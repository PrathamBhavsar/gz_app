import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_chip.dart';
import '../../../../shared/widgets/em_meta_row.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/session_detail_notifier.dart';

class SessionHistoryDetailMobileLayout extends ConsumerWidget {
  final String id;
  const SessionHistoryDetailMobileLayout({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSession = ref.watch(sessionDetailNotifierProvider(id));

    return asyncSession.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const EmTopBar(title: 'Session'),
            Expanded(
              child: PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(sessionDetailNotifierProvider(id).notifier)
                    .refresh(id),
              ),
            ),
          ],
        ),
      ),
      data: (session) => _SessionHistoryBody(session: session),
    );
  }
}

class _SessionHistoryBody extends StatelessWidget {
  final SessionModel session;
  const _SessionHistoryBody({required this.session});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '—';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  EmTagKind _statusKind(SessionStatus? status) => switch (status) {
    SessionStatus.completed => EmTagKind.ok,
    SessionStatus.inProgress => EmTagKind.info,
    SessionStatus.cancelled => EmTagKind.err,
    SessionStatus.disputed => EmTagKind.warn,
    null => EmTagKind.mute,
  };

  String _statusLabel(SessionStatus? status) => switch (status) {
    SessionStatus.completed => 'Completed',
    SessionStatus.inProgress => 'In progress',
    SessionStatus.cancelled => 'Cancelled',
    SessionStatus.disputed => 'Disputed',
    null => 'Unknown',
  };

  @override
  Widget build(BuildContext context) {
    final dur = session.durationMinutes;

    return SafeArea(
      child: Column(
        children: [
          const EmTopBar(title: 'Session'),
          Expanded(
            child: EmScrollContent(
              padded: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── System/store card ──
                  EmCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.pillBg,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusChip,
                                ),
                              ),
                              child: const Center(
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedComputerDesk01,
                                  color: AppColors.textPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: AppSpacing.sm + AppSpacing.xs,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.storeId ?? '—',
                                    style: AppTypography.small.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                  Text(
                                    session.systemId ?? '—',
                                    style: AppTypography.h3,
                                  ),
                                ],
                              ),
                            ),
                            EmTag(
                              kind: _statusKind(session.status),
                              label: _statusLabel(session.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 6,
                          children: [
                            EmChip(
                              keyLabel: 'DATE',
                              value: _formatDate(session.startedAt),
                            ),
                            if (session.id != null)
                              EmChip(
                                keyLabel: 'ID',
                                value: session.id!.length > 8
                                    ? session.id!.substring(0, 8)
                                    : session.id!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // ── Time details ──
                  EmCard(
                    child: Column(
                      children: [
                        EmMetaRow(
                          label: 'Started',
                          value: _formatTime(session.startedAt),
                        ),
                        EmMetaRow(
                          label: 'Ended',
                          value: _formatTime(session.endedAt),
                        ),
                        EmMetaRow(
                          label: 'Duration',
                          value: dur != null ? '${dur}m' : '—',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // ── Billing ──
                  EmCard(
                    child: Column(
                      children: const [
                        EmMetaRow(label: 'Billing', value: '—'),
                        EmMetaRow(label: 'Status', value: '—'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),

          // ── Sticky bottom ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            child: EmButtonFull(
              label: 'File a Dispute',
              variant: EmButtonVariant.ghost,
              onPressed: () => context.push(AppRoutes.disputeCreate),
            ),
          ),
        ],
      ),
    );
  }
}
