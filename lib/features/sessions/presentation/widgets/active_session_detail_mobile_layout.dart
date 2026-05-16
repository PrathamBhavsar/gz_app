import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_systems.dart';
import '../../../../shared/widgets/em_live_dot.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/active_session_notifier.dart';

final _sessionDetailElapsedProvider =
    StateProvider.autoDispose<int>((ref) => 0);
final _sessionDetailShowEventsProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class ActiveSessionDetailMobileLayout extends ConsumerWidget {
  final String id;
  const ActiveSessionDetailMobileLayout({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSession = ref.watch(activeSessionNotifierProvider(id));

    return asyncSession.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const EmTopBar(title: 'Live session'),
            Expanded(
              child: PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(activeSessionNotifierProvider(id).notifier)
                    .refresh(id),
              ),
            ),
          ],
        ),
      ),
      data: (session) => _ActiveSessionBody(session: session, sessionId: id),
    );
  }
}

/// StatefulWidget is justified here: owns Timer lifecycle for countdown display.
class _ActiveSessionBody extends ConsumerStatefulWidget {
  final SessionModel session;
  final String sessionId;
  const _ActiveSessionBody({required this.session, required this.sessionId});

  @override
  ConsumerState<_ActiveSessionBody> createState() => _ActiveSessionBodyState();
}

class _ActiveSessionBodyState extends ConsumerState<_ActiveSessionBody> {
  late int _totalSecs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initTimerFromSession(widget.session);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (ref.read(_sessionDetailElapsedProvider) < _totalSecs) {
        ref.read(_sessionDetailElapsedProvider.notifier).state++;
      }
    });
  }

  void _initTimerFromSession(SessionModel session) {
    final durationMin = session.durationMinutes ?? 120;
    _totalSecs = durationMin * 60;
    final initial = session.startedAt != null
        ? DateTime.now().difference(session.startedAt!).inSeconds.clamp(0, _totalSecs)
        : 0;
    ref.read(_sessionDetailElapsedProvider.notifier).state = initial;
  }

  @override
  void didUpdateWidget(_ActiveSessionBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session != widget.session) {
      _initTimerFromSession(widget.session);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final elapsed = ref.watch(_sessionDetailElapsedProvider);
    final showEvents = ref.watch(_sessionDetailShowEventsProvider);
    final session = widget.session;
    final remain = (_totalSecs - elapsed).clamp(0, _totalSecs);
    final pct = _totalSecs > 0 ? elapsed / _totalSecs : 0.0;

    final hh = remain ~/ 3600;
    final mm = (remain % 3600) ~/ 60;
    final ss = remain % 60;
    final remainStr = '${_pad(hh)}:${_pad(mm)}:${_pad(ss)}';

    final em = elapsed ~/ 60;
    final es = elapsed % 60;

    return SafeArea(
      child: Column(
        children: [
          EmTopBar(
            title: 'Live session',
            subtitle: session.storeId ?? '',
            disableBack: false,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              children: [
                // ── Hero timer card ──
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceTint,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'TIME REMAINING',
                        style: AppTypography.meta.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(remainStr, style: AppTypography.hero.copyWith(fontSize: 56)),
                      const SizedBox(height: 6),
                      Text(
                        '${_pad(em)}:${_pad(es)} elapsed',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: pct.toDouble(),
                          backgroundColor: Colors.black12,
                          color: AppColors.buttonBg,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(pct * 100).toStringAsFixed(0)}% elapsed',
                            style: AppTypography.small.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'ID: ${session.id?.substring(0, 8) ?? '—'}',
                            style: AppTypography.small,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

                // ── Session details ──
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.buttonBg,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusChip,
                              ),
                            ),
                            child: const Center(
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedComputerDesk01,
                                color: AppColors.buttonFg,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.systemId ?? '—',
                                  style: AppTypography.h3,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  session.storeId ?? '—',
                                  style: AppTypography.small,
                                ),
                              ],
                            ),
                          ),
                          const EmTag(kind: EmTagKind.ok, label: 'Active'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

                // ── Events log ──
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => ref
                            .read(_sessionDetailShowEventsProvider.notifier)
                            .state = !showEvents,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedListView,
                                color: AppColors.textPrimary,
                                size: 18,
                              ),
                              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                              Text(
                                'Session events',
                                style: AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              AnimatedRotation(
                                turns: showEvents ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowDown01,
                                  color: AppColors.textTertiary,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (showEvents)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            0,
                            AppSpacing.md,
                            AppSpacing.md,
                          ),
                          child: Column(
                            children: [
                              if (session.startedAt != null)
                                _EventRow(
                                  time: _formatTime(session.startedAt!),
                                  label: 'Session started',
                                  first: true,
                                ),
                              const _EventRow(
                                time: '—',
                                label: 'Live session in progress',
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

                // ── Live indicator ──
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: Row(
                    children: [
                      const EmLiveDot(),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Session is live',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.ok,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.time, required this.label, this.first = false});

  final String time;
  final String label;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        border: first
            ? null
            : Border(top: BorderSide(color: AppColors.rule)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(time, style: AppTypography.num.copyWith(fontSize: 12)),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(
            child: Text(label, style: AppTypography.body.copyWith(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
