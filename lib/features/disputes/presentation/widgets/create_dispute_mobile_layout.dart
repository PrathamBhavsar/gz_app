import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_meta_row.dart';
import '../providers/create_dispute_notifier.dart';

class CreateDisputeMobileLayout extends ConsumerWidget {
  const CreateDisputeMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(createDisputeProvider);

    return switch (s) {
      CreateDisputeEditing() => _EditingView(state: s),
      CreateDisputeSubmitted(:final refNum) => _SuccessView(refNum: refNum),
    };
  }
}

// ── Editing view ────────────────────────────────────────────────────────────

class _EditingView extends ConsumerWidget {
  const _EditingView({required this.state});
  final CreateDisputeEditing state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(createDisputeProvider.notifier);

    return Column(
      children: [
        const EmTopBar(title: 'File a dispute', subtitle: 'We\'ve got you'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.md),
            children: [
              // ── Explainer ──
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: HugeIcon(icon: HugeIcons.strokeRoundedInformationCircle, color: AppColors.info, size: 18)),
                  ),
                  const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Reviewed in 2–3 business days',
                        style: AppTypography.h3.copyWith(color: AppColors.info)),
                    const SizedBox(height: 4),
                    Text('Attach the session that was billed incorrectly. Receipts and logs are pulled automatically.',
                        style: AppTypography.bodyR.copyWith(color: AppColors.info, fontSize: 13, height: 1.4)),
                  ])),
                ]),
              ),

              // ── Session picker ──
              _FormField(label: 'DISPUTED SESSION', required: true, child: Column(children: [
                GestureDetector(
                  onTap: n.togglePicker,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(state.session.label,
                            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text('₹${state.session.amt} charged', style: AppTypography.small),
                      ])),
                      AnimatedRotation(
                        turns: state.pickerOpen ? 0.5 : 0,
                        duration: 150.ms,
                        child: const HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, color: AppColors.textTertiary, size: 18),
                      ),
                    ]),
                  ),
                ),
                if (state.pickerOpen)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: kDisputeSessions.map((sess) => GestureDetector(
                        onTap: () => n.pickSession(sess.id),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                          margin: const EdgeInsets.only(bottom: 2),
                          decoration: BoxDecoration(
                            color: sess.id == state.sessionId ? AppColors.pillBg : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Expanded(child: Text(sess.label,
                                style: AppTypography.body.copyWith(
                                    fontWeight: sess.id == state.sessionId ? FontWeight.w600 : FontWeight.w500),
                                overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: AppSpacing.sm),
                            Text('₹${sess.amt}', style: AppTypography.small),
                          ]),
                        ),
                      )).toList(),
                    ),
                  ),
              ])),

              // ── Reason ──
              _FormField(
                label: 'WHAT HAPPENED?',
                required: true,
                trailing: Text(
                  '${state.reason.length} / 500',
                  style: AppTypography.num.copyWith(
                    fontSize: 12,
                    color: state.reason.length >= 20
                        ? AppColors.ok
                        : (state.reason.isNotEmpty ? AppColors.warn : AppColors.textTertiary),
                  ),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: (state.reason.isNotEmpty && state.reason.length < 20)
                          ? Border.all(color: AppColors.warn, width: 1.5)
                          : null,
                    ),
                    child: TextField(
                      maxLength: 500,
                      maxLines: 5,
                      style: AppTypography.body,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                        hintText: 'Describe what happened — include time, system, and what went wrong',
                        hintStyle: AppTypography.bodyR.copyWith(color: AppColors.textTertiary),
                      ),
                      onChanged: n.setReason,
                    ),
                  ),
                  if (state.reason.isNotEmpty && state.reason.length < 20)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('At least 20 characters — help us understand what happened',
                          style: AppTypography.small.copyWith(color: AppColors.warn)),
                    ),
                ]),
              ),

              // ── Amount ──
              _FormField(
                label: 'AMOUNT DISPUTED',
                trailing: Text('max ₹${state.session.amt}', style: AppTypography.small),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text('₹', style: AppTypography.h2.copyWith(color: AppColors.textTertiary, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: AppTypography.num.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 14),
                        ),
                        controller: TextEditingController(text: '${state.amount}'),
                        onChanged: (v) => n.setAmount(int.tryParse(v) ?? 0),
                      ),
                    ),
                    GestureDetector(
                      onTap: n.setFullAmount,
                      child: Container(
                        margin: const EdgeInsets.all(AppSpacing.sm),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.pillBg,
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                        ),
                        child: Text('Full', style: AppTypography.small.copyWith(fontWeight: FontWeight.w600, fontSize: 11)),
                      ),
                    ),
                  ]),
                ),
              ),

              // ── Additional notes ──
              _FormField(
                label: 'ADDITIONAL NOTES',
                child: Container(
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                  child: TextField(
                    style: AppTypography.body,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(14),
                      hintText: 'Any extra context for the reviewer',
                      hintStyle: AppTypography.bodyR.copyWith(color: AppColors.textTertiary),
                    ),
                    onChanged: (v) {},
                  ),
                ),
              ),

              // ── Summary preview ──
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('SUMMARY PREVIEW', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 10),
                  EmMetaRow(label: 'Session', value: state.session.label.split(' · ').first),
                  EmMetaRow(label: 'Store',   value: state.session.label.split(' · ').elementAtOrNull(1) ?? '—'),
                  EmMetaRow(label: 'System',  value: state.session.label.split(' · ').elementAtOrNull(2) ?? '—'),
                  EmMetaRow(label: 'Disputing', value: '₹${state.amount} of ₹${state.session.amt}'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('REASON', style: AppTypography.meta.copyWith(color: AppColors.textTertiary)),
                      const SizedBox(height: 4),
                      Text(
                        state.reason.trim().isNotEmpty
                            ? (state.reason.length > 80 ? '${state.reason.substring(0, 80)}…' : state.reason)
                            : 'Add a reason above',
                        style: AppTypography.body.copyWith(
                            fontSize: 12, height: 1.4,
                            color: state.reason.trim().isNotEmpty ? AppColors.textPrimary : AppColors.textTertiary),
                      ),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),

        // ── Sticky submit ──
        Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm + AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
          color: AppColors.background,
          child: Column(children: [
            Opacity(
              opacity: state.valid ? 1 : 0.4,
              child: GestureDetector(
                onTap: state.valid ? n.submit : null,
                child: Container(
                  width: double.infinity, height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.buttonBg,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: Center(child: Text('Submit dispute', style: AppTypography.button)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTypography.small,
                children: [
                  const TextSpan(text: 'Need help first?  '),
                  TextSpan(
                    text: 'Contact support',
                    style: AppTypography.small.copyWith(
                        color: AppColors.textPrimary, fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.refNum});
  final String refNum;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const EmTopBar(title: 'Submitted'),
      Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(color: AppColors.surfaceTint, shape: BoxShape.circle),
                child: const Center(
                  child: HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle01, color: AppColors.ok, size: 36),
                ),
              ).animate().scale(begin: const Offset(0.6, 0.6), duration: 300.ms, curve: Curves.easeOutBack),
              const SizedBox(height: AppSpacing.lg),
              Text('Dispute filed', style: AppTypography.title),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTypography.bodyR.copyWith(height: 1.5),
                  children: [
                    const TextSpan(text: "We've assigned dispute "),
                    TextSpan(text: refNum, style: AppTypography.num.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    const TextSpan(text: '. You\'ll hear back in 2–3 business days.'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 240, height: 56,
                decoration: BoxDecoration(color: AppColors.buttonBg, borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg)),
                child: Center(child: Text('View dispute', style: AppTypography.button)),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 240, height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.rule),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: Center(child: Text('Back to wallet',
                      style: AppTypography.body.copyWith(fontWeight: FontWeight.w600))),
                ),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Form field ────────────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({required this.label, required this.child, this.required = false, this.trailing});
  final String label;
  final bool required;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, AppSpacing.sm),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Text(label, style: AppTypography.meta),
            if (required)
              Text(' *', style: AppTypography.meta.copyWith(color: AppColors.err)),
          ]),
          if (trailing != null) trailing!,
        ]),
      ),
      child,
    ]),
  );
}
