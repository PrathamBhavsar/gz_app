import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_chip.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/enums.dart';
import '../providers/dispute_detail_notifier.dart';

class DisputeDetailMobileLayout extends ConsumerWidget {
  const DisputeDetailMobileLayout({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(disputeDetailProvider(id));

    return switch (state) {
      DisputeDetailLoading() => Column(children: [
          const EmTopBar(title: 'Dispute'),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ]),
      DisputeDetailError(:final error) => Column(children: [
          const EmTopBar(title: 'Dispute'),
          Expanded(
            child: PageErrorDisplay(
              error: AppPageError.from(error),
              onRetry: () =>
                  ref.read(disputeDetailProvider(id).notifier).refresh(id),
            ),
          ),
        ]),
      DisputeDetailData(:final dispute, :final confirmOpen) => Stack(
          children: [
            Column(
              children: [
                EmTopBar(
                  title: 'Dispute',
                  subtitle:
                      '#${(dispute.id ?? '').length > 8 ? dispute.id!.substring(0, 8).toUpperCase() : (dispute.id ?? '').toUpperCase()}',
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
                    children: [
                      _StatusBanner(status: dispute.status),
                      const SizedBox(height: 14),

                      // Session reference
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DISPUTED SESSION',
                                style: AppTypography.meta
                                    .copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                if (dispute.sessionId != null)
                                  EmChip(
                                    keyLabel: 'SESSION',
                                    value: dispute.sessionId!.length > 8
                                        ? dispute.sessionId!
                                            .substring(0, 8)
                                            .toUpperCase()
                                        : dispute.sessionId!.toUpperCase(),
                                  ),
                                if (dispute.createdAt != null)
                                  EmChip(
                                    keyLabel: 'FILED',
                                    value: _fmtDate(dispute.createdAt!),
                                  ),
                                if (dispute.disputeAmount != null)
                                  EmChip(
                                    keyLabel: 'DISPUTED',
                                    value:
                                        '₹${dispute.disputeAmount!.toStringAsFixed(0)}',
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Amount in dispute
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AMOUNT IN DISPUTE',
                                style: AppTypography.meta
                                    .copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 12),
                            if (dispute.disputeAmount != null)
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Amount disputed',
                                        style: AppTypography.bodyR),
                                    Text(
                                        '₹${dispute.disputeAmount!.toStringAsFixed(0)}',
                                        style: AppTypography.num.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.err)),
                                  ]),
                            if (dispute.reason != null) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm),
                                child: Divider(
                                    color: AppColors.rule, height: 1),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: AppTypography.bodyR
                                      .copyWith(fontSize: 13),
                                  children: [
                                    const TextSpan(text: 'Reason: '),
                                    TextSpan(
                                      text: dispute.reason,
                                      style: AppTypography.body.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Resolution card
                      _ResolutionCard(dispute: dispute),
                      const SizedBox(height: 12),

                      // Timeline
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TIMELINE',
                                style: AppTypography.meta
                                    .copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 14),
                            _TimelineStep(
                              n: 1,
                              stepState: _StepState.done,
                              title: 'Dispute filed',
                              date: dispute.createdAt != null
                                  ? _fmtDate(dispute.createdAt!)
                                  : '—',
                            ),
                            _TimelineStep(
                              n: 2,
                              stepState: _step2State(dispute.status),
                              title: 'Under review',
                              date: dispute.status == DisputeStatus.open
                                  ? 'Pending'
                                  : '—',
                            ),
                            _TimelineStep(
                              n: 3,
                              stepState: _step3State(dispute.status),
                              title: 'Resolution',
                              date: dispute.status == DisputeStatus.resolved
                                  ? (dispute.resolvedAt != null
                                      ? _fmtDate(dispute.resolvedAt!)
                                      : '—')
                                  : dispute.status == DisputeStatus.withdrawn
                                      ? 'Withdrawn'
                                      : 'Pending',
                              last: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Withdraw button
                      if (dispute.status != DisputeStatus.withdrawn &&
                          dispute.status != DisputeStatus.resolved)
                        Center(
                          child: GestureDetector(
                            onTap: () => ref
                                .read(disputeDetailProvider(id).notifier)
                                .openConfirm(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.err, width: 1.5),
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.borderRadiusLg),
                              ),
                              child: Text('Withdraw dispute',
                                  style: AppTypography.body.copyWith(
                                      color: AppColors.err,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Confirm dialog overlay
            if (confirmOpen)
              GestureDetector(
                onTap: () => ref
                    .read(disputeDetailProvider(id).notifier)
                    .closeConfirm(),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: AppColors.errBg,
                                shape: BoxShape.circle),
                            child: const Center(
                              child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedAlert01,
                                  color: AppColors.err,
                                  size: 20),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text('Withdraw this dispute?',
                              style: AppTypography.h1),
                          const SizedBox(height: 6),
                          Text(
                            "This action can't be undone. The original charge will stand.",
                            style: AppTypography.bodyR.copyWith(height: 1.45),
                          ),
                          const SizedBox(height: 18),
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => ref
                                    .read(disputeDetailProvider(id).notifier)
                                    .closeConfirm(),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    border:
                                        Border.all(color: AppColors.rule),
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.borderRadiusLg),
                                  ),
                                  child: Center(
                                    child: Text('Keep dispute',
                                        style: AppTypography.body.copyWith(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => ref
                                    .read(disputeDetailProvider(id).notifier)
                                    .withdraw(id),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.err,
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.borderRadiusLg),
                                  ),
                                  child: Center(
                                    child: Text('Withdraw',
                                        style: AppTypography.body.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
    };
  }

  static _StepState _step2State(DisputeStatus? status) => switch (status) {
    DisputeStatus.open      => _StepState.pending,
    DisputeStatus.withdrawn => _StepState.cancelled,
    _                       => _StepState.done,
  };

  static _StepState _step3State(DisputeStatus? status) => switch (status) {
    DisputeStatus.resolved  => _StepState.done,
    DisputeStatus.withdrawn => _StepState.cancelled,
    _                       => _StepState.pending,
  };

  static String _fmtDate(DateTime d) =>
      '${d.day} ${_months[d.month]} ${d.year}';

  static const _months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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
      borderRadius:
          BorderRadius.circular(AppSpacing.borderRadiusCard),
    ),
    child: child,
  );
}

// ── Status banner ─────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});
  final DisputeStatus? status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon, label) = switch (status) {
      DisputeStatus.open =>
        (AppColors.warnBg, AppColors.warn,
         HugeIcons.strokeRoundedClock01, 'Open'),
      DisputeStatus.underReview =>
        (AppColors.infoBg, AppColors.info,
         HugeIcons.strokeRoundedLegal01, 'Under Review'),
      DisputeStatus.resolved =>
        (AppColors.okBg, AppColors.ok,
         HugeIcons.strokeRoundedCheckmarkCircle01, 'Resolved'),
      DisputeStatus.withdrawn =>
        (AppColors.pillBg, AppColors.textSecondary,
         HugeIcons.strokeRoundedMultiplicationSign, 'Withdrawn'),
      null =>
        (AppColors.pillBg, AppColors.textSecondary,
         HugeIcons.strokeRoundedClock01, 'Unknown'),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0x80FFFFFF),
            shape: BoxShape.circle,
          ),
          child: Center(child: HugeIcon(icon: icon, color: fg, size: 20)),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('STATUS',
              style: AppTypography.meta
                  .copyWith(color: fg, letterSpacing: 0.7)),
          const SizedBox(height: 3),
          Text(label, style: AppTypography.h2.copyWith(color: fg)),
        ]),
      ]),
    );
  }
}

// ── Resolution card ───────────────────────────────────────────────────────────

class _ResolutionCard extends StatelessWidget {
  const _ResolutionCard({required this.dispute});
  final BillingDisputeModel dispute;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon, text) = switch (dispute.status) {
      DisputeStatus.open =>
        (AppColors.warnBg, AppColors.warn,
         HugeIcons.strokeRoundedClock01,
         'Awaiting first review — typically picked up within 24 hours.'),
      DisputeStatus.underReview =>
        (AppColors.infoBg, AppColors.info,
         HugeIcons.strokeRoundedLegal01,
         'Resolution pending — typically 2–3 business days.'),
      DisputeStatus.resolved =>
        (AppColors.okBg, AppColors.ok,
         HugeIcons.strokeRoundedCheckmarkCircle01,
         dispute.resolutionNotes ?? 'Dispute resolved.'),
      DisputeStatus.withdrawn =>
        (AppColors.pillBg, AppColors.textSecondary,
         HugeIcons.strokeRoundedMultiplicationSign,
         'You withdrew this dispute. The original charge stands.'),
      null =>
        (AppColors.pillBg, AppColors.textSecondary,
         HugeIcons.strokeRoundedClock01, 'Status unknown.'),
    };

    return _Card(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            borderRadius:
                BorderRadius.circular(AppSpacing.borderRadiusChip),
          ),
          child: Center(child: HugeIcon(icon: icon, color: fg, size: 18)),
        ),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resolution', style: AppTypography.h3),
              const SizedBox(height: 4),
              Text(text,
                  style: AppTypography.bodyR
                      .copyWith(fontSize: 13, height: 1.45)),
            ],
          ),
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
      _StepState.done =>
        (AppColors.textPrimary, Colors.white, AppColors.textPrimary,
         AppColors.textPrimary),
      _StepState.pending =>
        (AppColors.surface, AppColors.textTertiary, AppColors.rule,
         AppColors.rule),
      _StepState.cancelled =>
        (AppColors.pillBg, AppColors.textMuted, AppColors.rule, AppColors.rule),
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
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: dotBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotBorder, width: 2),
                ),
                child: Center(
                  child: Text(label,
                      style: TextStyle(
                          color: dotFg,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'GeistMono')),
                ),
              ),
              if (!last)
                Positioned(
                  top: 28,
                  left: 11,
                  bottom: -6,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
