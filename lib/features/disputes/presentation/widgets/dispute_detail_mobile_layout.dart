import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../providers/dispute_detail_notifier.dart';

class DisputeDetailMobileLayout extends ConsumerWidget {
  const DisputeDetailMobileLayout({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(disputeDetailProvider);
    final n = ref.read(disputeDetailProvider.notifier);

    return Stack(
      children: [
        Column(
          children: [
            GzTopBar(
              title: 'Dispute',
              subtitle: '#DIS-0042',
              trailing: const HugeIcon(
                icon: HugeIcons.strokeRoundedInformationCircle,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),

            // ── Status demo toggle ──
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm + AppSpacing.xs),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.pillBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: DisputeStatus.values.map((ds) {
                    final active = s.status == ds;
                    final label = switch (ds) {
                      DisputeStatus.open      => 'Open',
                      DisputeStatus.review    => 'Review',
                      DisputeStatus.resolved  => 'Resolved',
                      DisputeStatus.withdrawn => 'Withdrawn',
                    };
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => ref.read(disputeDetailProvider.notifier).setStatus(ds),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 28,
                          decoration: BoxDecoration(
                            color: active ? AppColors.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Text(label,
                                style: AppTypography.meta.copyWith(
                                    fontSize: 11,
                                    color: active ? AppColors.textPrimary : AppColors.textTertiary)),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── Scrollable body ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
                children: [
                  // Status banner
                  _StatusBanner(status: s.status),
                  const SizedBox(height: 14),

                  // Session reference
                  _Card(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('DISPUTED SESSION', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.pillBg,
                            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
                          ),
                          child: const Center(
                            child: HugeIcon(icon: HugeIcons.strokeRoundedComputerDesk01, color: AppColors.textPrimary, size: 18),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('RTX 4090 — Seat 3',
                              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('GameZone Koramangala', style: AppTypography.small),
                        ]),
                      ]),
                      const SizedBox(height: 14),
                      Wrap(spacing: 6, runSpacing: 6, children: const [
                        GzChip(keyLabel: 'WHEN', value: '18 Apr · 2h'),
                        GzChip(keyLabel: 'PAID', value: '₹160'),
                        GzChip(keyLabel: 'VIA',  value: 'UPI'),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Amount in dispute
                  _Card(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('AMOUNT IN DISPUTE', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      const GzMetaRow(label: 'Original charge', value: '₹160'),
                      const SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Amount disputed', style: AppTypography.bodyR),
                        Text('₹80', style: AppTypography.num.copyWith(
                            fontWeight: FontWeight.w600, color: AppColors.err)),
                      ]),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Divider(color: AppColors.rule, height: 1),
                      ),
                      RichText(
                        text: TextSpan(
                          style: AppTypography.bodyR.copyWith(fontSize: 13),
                          children: [
                            const TextSpan(text: 'Reason: '),
                            TextSpan(
                              text: 'Session ended 45 minutes early, full amount charged.',
                              style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Player quote
                  _Card(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('YOUR DESCRIPTION', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: AppColors.pillBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            left: BorderSide(color: AppColors.textPrimary, width: 3),
                          ),
                        ),
                        child: Text(
                          '"The system crashed at 5:23 PM and staff could not restart it. I was asked to leave. Full 2-hour charge was still applied."',
                          style: AppTypography.bodyR.copyWith(
                              fontSize: 13.5, height: 1.45, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Resolution card
                  _ResolutionCard(status: s.status),
                  const SizedBox(height: 12),

                  // Timeline
                  _Card(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('TIMELINE', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 14),
                      _TimelineStep(
                        n: 1,
                        stepState: _StepState.done,
                        title: 'Dispute filed',
                        date: '18 Apr · 6:42 PM',
                      ),
                      _TimelineStep(
                        n: 2,
                        stepState: _step2State(s.status),
                        title: 'Under review',
                        date: s.status == DisputeStatus.open ? 'Pending' : '19 Apr · 9:00 AM',
                      ),
                      _TimelineStep(
                        n: 3,
                        stepState: _step3State(s.status),
                        title: 'Resolution',
                        date: s.status == DisputeStatus.resolved
                            ? '21 Apr · 2:10 PM'
                            : s.status == DisputeStatus.withdrawn
                                ? 'Cancelled'
                                : 'Pending',
                        last: true,
                      ),
                    ]),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Withdraw button
                  if (s.status != DisputeStatus.withdrawn && s.status != DisputeStatus.resolved)
                    Center(
                      child: GestureDetector(
                        onTap: n.openConfirm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.err, width: 1.5),
                            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                          ),
                          child: Text('Withdraw dispute',
                              style: AppTypography.body.copyWith(
                                  color: AppColors.err, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),

                  // Withdrawn confirmation banner
                  if (s.withdrawnBannerVisible)
                    Container(
                      margin: const EdgeInsets.only(top: AppSpacing.sm + AppSpacing.xs),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + AppSpacing.xs, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.okBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('Dispute withdrawn successfully',
                            style: AppTypography.small.copyWith(
                                color: AppColors.ok, fontWeight: FontWeight.w600)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        // ── Confirm dialog overlay ──
        if (s.confirmOpen)
          GestureDetector(
            onTap: n.closeConfirm,
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(color: AppColors.errBg, shape: BoxShape.circle),
                      child: const Center(
                        child: HugeIcon(icon: HugeIcons.strokeRoundedAlert01, color: AppColors.err, size: 20),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('Withdraw this dispute?', style: AppTypography.h1),
                    const SizedBox(height: 6),
                    Text(
                      "This action can't be undone. The original ₹160 charge will stand.",
                      style: AppTypography.bodyR.copyWith(height: 1.45),
                    ),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: n.closeConfirm,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              border: Border.all(color: AppColors.rule),
                              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                            ),
                            child: Center(child: Text('Keep dispute',
                                style: AppTypography.body.copyWith(fontWeight: FontWeight.w600))),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: GestureDetector(
                          onTap: n.withdraw,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.err,
                              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                            ),
                            child: Center(child: Text('Withdraw',
                                style: AppTypography.body.copyWith(
                                    color: Colors.white, fontWeight: FontWeight.w600))),
                          ),
                        ),
                      ),
                    ]),
                  ]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  static _StepState _step2State(DisputeStatus status) => switch (status) {
    DisputeStatus.open      => _StepState.pending,
    DisputeStatus.withdrawn => _StepState.cancelled,
    _                       => _StepState.done,
  };

  static _StepState _step3State(DisputeStatus status) => switch (status) {
    DisputeStatus.resolved  => _StepState.done,
    DisputeStatus.withdrawn => _StepState.cancelled,
    _                       => _StepState.pending,
  };
}

// ── Card wrapper ──────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
    ),
    child: child,
  );
}

// ── Status banner ─────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});
  final DisputeStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon, label) = switch (status) {
      DisputeStatus.open      => (AppColors.warnBg, AppColors.warn,          HugeIcons.strokeRoundedClock01,               'Open'),
      DisputeStatus.review    => (AppColors.infoBg, AppColors.info,          HugeIcons.strokeRoundedLegal01,                 'Under review'),
      DisputeStatus.resolved  => (AppColors.okBg,   AppColors.ok,            HugeIcons.strokeRoundedCheckmarkCircle01,     'Resolved'),
      DisputeStatus.withdrawn => (AppColors.pillBg,  AppColors.textSecondary, HugeIcons.strokeRoundedMultiplicationSign,   'Withdrawn'),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: const BoxDecoration(
            color: Color(0x80FFFFFF),
            shape: BoxShape.circle,
          ),
          child: Center(child: HugeIcon(icon: icon, color: fg, size: 20)),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('STATUS',
              style: AppTypography.meta.copyWith(color: fg, letterSpacing: 0.7)),
          const SizedBox(height: 3),
          Text(label, style: AppTypography.h2.copyWith(color: fg)),
        ]),
      ]),
    );
  }
}

// ── Resolution card ───────────────────────────────────────────────────────────

class _ResolutionCard extends StatelessWidget {
  const _ResolutionCard({required this.status});
  final DisputeStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon, text) = switch (status) {
      DisputeStatus.open      => (AppColors.warnBg, AppColors.warn,          HugeIcons.strokeRoundedClock01,               'Awaiting first review — typically picked up within 24 hours.'),
      DisputeStatus.review    => (AppColors.infoBg, AppColors.info,          HugeIcons.strokeRoundedLegal01,                 'Resolution pending — typically 2–3 business days.'),
      DisputeStatus.resolved  => (AppColors.okBg,   AppColors.ok,            HugeIcons.strokeRoundedCheckmarkCircle01,     'Full refund of ₹80 issued. May take 2–3 days to reflect.'),
      DisputeStatus.withdrawn => (AppColors.pillBg,  AppColors.textSecondary, HugeIcons.strokeRoundedMultiplicationSign,   'You withdrew this dispute. The original charge stands.'),
    };

    return _Card(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip)),
          child: Center(child: HugeIcon(icon: icon, color: fg, size: 18)),
        ),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Resolution', style: AppTypography.h3),
            const SizedBox(height: 4),
            Text(text, style: AppTypography.bodyR.copyWith(fontSize: 13, height: 1.45)),
          ]),
        ),
      ]),
    );
  }
}

// ── Timeline ──────────────────────────────────────────────────────────────────

enum _StepState { done, pending, cancelled }

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.n,
    required this.stepState,
    required this.title,
    required this.date,
    this.last = false,
  });

  final int n;
  final _StepState stepState;
  final String title;
  final String date;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final (dotBg, dotFg, dotBorder, lineColor) = switch (stepState) {
      _StepState.done      => (AppColors.textPrimary, Colors.white,             AppColors.textPrimary, AppColors.textPrimary),
      _StepState.pending   => (AppColors.surface,     AppColors.textTertiary,   AppColors.rule,        AppColors.rule),
      _StepState.cancelled => (AppColors.pillBg,      AppColors.textMuted,      AppColors.rule,        AppColors.rule),
    };

    final label = switch (stepState) {
      _StepState.done      => '✓',
      _StepState.cancelled => '×',
      _StepState.pending   => '$n',
    };

    return SizedBox(
      height: last ? null : 56,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: 24,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: dotBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotBorder, width: 2),
                ),
                child: Center(
                  child: Text(label,
                      style: TextStyle(
                          color: dotFg, fontSize: 11,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'GeistMono')),
                ),
              ),
              if (!last)
                Positioned(
                  top: 28, left: 11, bottom: -6,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 2,
                    color: lineColor,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: stepState == _StepState.cancelled
                          ? AppColors.textTertiary
                          : AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(date,
                  style: AppTypography.num.copyWith(
                      fontSize: 12,
                      decoration: stepState == _StepState.cancelled
                          ? TextDecoration.lineThrough
                          : null,
                      color: AppColors.textTertiary)),
            ]),
          ),
        ),
      ]),
    );
  }
}
