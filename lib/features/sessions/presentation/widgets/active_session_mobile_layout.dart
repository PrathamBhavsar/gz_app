import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_chip.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_live_dot.dart';
import '../../../../shared/widgets/em_progress_bar.dart';

// StatefulWidget allowed here: owns Timer lifecycle (= AnimationController equivalent)
class ActiveSessionMobileLayout extends ConsumerStatefulWidget {
  const ActiveSessionMobileLayout({super.key});

  @override
  ConsumerState<ActiveSessionMobileLayout> createState() =>
      _ActiveSessionMobileLayoutState();
}

class _ActiveSessionMobileLayoutState
    extends ConsumerState<ActiveSessionMobileLayout> {
  static const _totalSecs  = 2 * 60 * 60; // 2h
  static const _startElapsed = 23 * 60 + 56; // 23m 56s

  int _elapsed = _startElapsed;
  bool _showEvents = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_elapsed < _totalSecs) setState(() => _elapsed++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final remain = (_totalSecs - _elapsed).clamp(0, _totalSecs);
    final pct    = _elapsed / _totalSecs;
    final cost   = (_elapsed / 3600) * 80;

    final hh = remain ~/ 3600;
    final mm = (remain % 3600) ~/ 60;
    final ss = remain % 60;
    final remainStr = '${_pad(hh)}:${_pad(mm)}:${_pad(ss)}';

    final em = _elapsed ~/ 60;
    final es = _elapsed % 60;
    final elapsedStr = '${_pad(em)}:${_pad(es)}';

    return SafeArea(
      child: Column(
        children: [
          EmTopBar(
            title: 'Live session',
            subtitle: 'GameZone · Koramangala',
            disableBack: true,
            trailing: const HugeIcon(
              icon: HugeIcons.strokeRoundedNotification01,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
              children: [
                // ── Hero timer card ──
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceTint,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text('TIME REMAINING', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 14),
                    Text(remainStr, style: AppTypography.hero.copyWith(fontSize: 64)),
                    const SizedBox(height: 6),
                    Text('$elapsedStr elapsed of 2:00:00',
                        style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 18),
                    EmProgressBar(
                      value: pct,
                      trackColor: Colors.black12,
                      fillColor: AppColors.buttonBg,
                    ),
                    const SizedBox(height: 14),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Started 4:00 PM', style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
                      Text('${(pct * 100).toStringAsFixed(0)}%',
                          style: AppTypography.num.copyWith(fontWeight: FontWeight.w700)),
                      Text('Ends 6:00 PM', style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
                    ]),
                  ]),
                ),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

                // ── Session details ──
                _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(color: AppColors.buttonBg, borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip)),
                      child: const Center(child: HugeIcon(icon: HugeIcons.strokeRoundedComputerDesk01, color: AppColors.buttonFg, size: 20)),
                    ),
                    const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('RTX 4090 Gaming PC', style: AppTypography.h3),
                      const SizedBox(height: 3),
                      Text('GameZone Koramangala', style: AppTypography.small),
                    ])),
                    const EmTag(kind: EmTagKind.ok, label: 'Active'),
                  ]),
                  const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                  Wrap(spacing: 6, children: const [
                    EmChip(keyLabel: 'SEAT', value: '3'),
                    EmChip(keyLabel: 'PLAT', value: 'PC'),
                    EmChip(keyLabel: 'ID',   value: 'SES-20948'),
                  ]),
                ])),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

                // ── Running cost ──
                _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('RUNNING TOTAL', style: AppTypography.meta),
                    Row(children: [
                      const EmLiveDot(size: 6),
                      const SizedBox(width: 6),
                      Text('live', style: AppTypography.small.copyWith(color: AppColors.ok, fontWeight: FontWeight.w600)),
                    ]),
                  ]),
                  const SizedBox(height: 4),
                  Text('₹${cost.toStringAsFixed(2)}', style: AppTypography.heroMd),
                  const SizedBox(height: 4),
                  Text('₹80/hr · ${em}m ${es}s elapsed', style: AppTypography.small),
                  const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                    decoration: BoxDecoration(color: AppColors.pillBg, borderRadius: BorderRadius.circular(10)),
                    child: Text('Final bill is calculated by the system at session end.',
                        style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 12)),
                  ),
                ])),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

                // ── Events log ──
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: Column(children: [
                    GestureDetector(
                      onTap: () => setState(() => _showEvents = !_showEvents),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(children: [
                          const HugeIcon(icon: HugeIcons.strokeRoundedListView, color: AppColors.textPrimary, size: 18),
                          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                          Text('4 events logged', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                          const Spacer(),
                          AnimatedRotation(
                            turns: _showEvents ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, color: AppColors.textTertiary, size: 18),
                          ),
                        ]),
                      ),
                    ),
                    if (_showEvents)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                        child: Column(children: const [
                          _EventRow(time: '04:00 PM', label: 'Session started · Seat 3',         first: true),
                          _EventRow(time: '04:08 PM', label: 'System activity detected'),
                          _EventRow(time: '04:18 PM', label: 'Steam launch · CS2'),
                          _EventRow(time: '04:23 PM', label: '5-min warning sent · ignore if continuing'),
                        ]),
                      ),
                  ]),
                ),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

                // ── Need more time card ──
                _Card(child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.warnBg, shape: BoxShape.circle),
                    child: const Center(child: HugeIcon(icon: HugeIcons.strokeRoundedUserGroup, color: AppColors.warn, size: 18)),
                  ),
                  const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Need more time?', style: AppTypography.h3),
                    const SizedBox(height: 4),
                    Text('Walk up to the counter — staff will extend your session in person.',
                        style: AppTypography.bodyR.copyWith(fontSize: 13)),
                  ])),
                ])),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

                // ── Support actions ──
                Row(children: [
                  Expanded(child: _ActionBtn(
                    icon: HugeIcons.strokeRoundedMessage01,
                    label: 'Chat support',
                    onTap: () {},
                  )),
                  const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                  _ActionBtn(
                    icon: HugeIcons.strokeRoundedAlert01,
                    label: 'SOS',
                    danger: true,
                    onTap: () {},
                    width: 110,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
    ),
    child: child,
  );
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.time, required this.label, this.first = false});
  final String time;
  final String label;
  final bool first;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    decoration: BoxDecoration(
      border: first ? null : Border(top: BorderSide(color: AppColors.rule)),
    ),
    child: Row(children: [
      SizedBox(width: 64, child: Text(time, style: AppTypography.num.copyWith(fontSize: 12))),
      const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
      Expanded(child: Text(label, style: AppTypography.body.copyWith(fontSize: 13))),
    ]),
  );
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon, required this.label, required this.onTap,
    this.danger = false, this.width,
  });
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final fg = danger ? AppColors.err : AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: danger ? AppColors.err.withValues(alpha: 0.3) : AppColors.rule),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          HugeIcon(icon: icon, color: fg, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.body.copyWith(color: fg, fontWeight: FontWeight.w600, fontSize: 14)),
        ]),
      ),
    );
  }
}
