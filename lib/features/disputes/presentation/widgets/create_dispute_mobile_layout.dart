import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../models/domain_billing.dart';
import '../providers/create_dispute_notifier.dart';

class CreateDisputeMobileLayout extends ConsumerStatefulWidget {
  const CreateDisputeMobileLayout({super.key});

  @override
  ConsumerState<CreateDisputeMobileLayout> createState() =>
      _CreateDisputeMobileLayoutState();
}

class _CreateDisputeMobileLayoutState
    extends ConsumerState<CreateDisputeMobileLayout> {
  final _sessionCtrl = TextEditingController();
  final _reasonCtrl  = TextEditingController();
  final _amountCtrl  = TextEditingController();

  bool get _canSubmit =>
      _sessionCtrl.text.trim().isNotEmpty &&
      _reasonCtrl.text.trim().length >= 20;

  @override
  void dispose() {
    _sessionCtrl.dispose();
    _reasonCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final amt = double.tryParse(_amountCtrl.text.trim());
    ref.read(createDisputeProvider.notifier).submit(
      sessionId: _sessionCtrl.text.trim(),
      reason: _reasonCtrl.text.trim(),
      disputedAmount: amt,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createDisputeProvider);
    return switch (state) {
      CreateDisputeSuccess(:final dispute) => _SuccessView(dispute: dispute),
      _ => _FormView(
          sessionCtrl: _sessionCtrl,
          reasonCtrl:  _reasonCtrl,
          amountCtrl:  _amountCtrl,
          isLoading:   state is CreateDisputeLoading,
          errorMsg:    state is CreateDisputeError
              ? (state as CreateDisputeError).message
              : null,
          canSubmit: _canSubmit,
          onSubmit:  _submit,
        ),
    };
  }
}

// ── Form view ─────────────────────────────────────────────────────────────────

class _FormView extends StatefulWidget {
  const _FormView({
    required this.sessionCtrl,
    required this.reasonCtrl,
    required this.amountCtrl,
    required this.isLoading,
    required this.canSubmit,
    required this.onSubmit,
    this.errorMsg,
  });
  final TextEditingController sessionCtrl;
  final TextEditingController reasonCtrl;
  final TextEditingController amountCtrl;
  final bool isLoading;
  final bool canSubmit;
  final VoidCallback onSubmit;
  final String? errorMsg;

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {
  @override
  void initState() {
    super.initState();
    widget.sessionCtrl.addListener(_rebuild);
    widget.reasonCtrl.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    widget.sessionCtrl.removeListener(_rebuild);
    widget.reasonCtrl.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reasonLen = widget.reasonCtrl.text.length;

    return Column(
      children: [
        const EmTopBar(title: 'File a Dispute', subtitle: "We've got you"),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.md),
            children: [
              // Explainer banner
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusCard),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedInformationCircle,
                        color: AppColors.info,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Reviewed in 2–3 business days',
                          style:
                              AppTypography.h3.copyWith(color: AppColors.info)),
                      const SizedBox(height: 4),
                      Text(
                        'Provide the session ID and describe the billing issue. Logs are pulled automatically.',
                        style: AppTypography.bodyR.copyWith(
                            color: AppColors.info, fontSize: 13, height: 1.4),
                      ),
                    ]),
                  ),
                ]),
              ),

              // Session ID field
              _FormField(
                label: 'SESSION ID',
                isRequired: true,
                child: _InputBox(
                  controller: widget.sessionCtrl,
                  hint: 'e.g. sess_abc123',
                  keyboardType: TextInputType.text,
                ),
              ),

              // Reason field
              _FormField(
                label: 'WHAT HAPPENED?',
                isRequired: true,
                trailing: Text(
                  '$reasonLen / 500',
                  style: AppTypography.num.copyWith(
                    fontSize: 12,
                    color: reasonLen >= 20
                        ? AppColors.ok
                        : (reasonLen > 0 ? AppColors.warn : AppColors.textTertiary),
                  ),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: (reasonLen > 0 && reasonLen < 20)
                          ? Border.all(color: AppColors.warn, width: 1.5)
                          : null,
                    ),
                    child: TextField(
                      controller: widget.reasonCtrl,
                      maxLength: 500,
                      maxLines: 5,
                      style: AppTypography.body,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                        hintText:
                            'Describe what happened — include time, system, and what went wrong',
                        hintStyle: AppTypography.bodyR
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                  if (reasonLen > 0 && reasonLen < 20)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'At least 20 characters — help us understand what happened',
                        style:
                            AppTypography.small.copyWith(color: AppColors.warn),
                      ),
                    ),
                ]),
              ),

              // Amount field (optional)
              _FormField(
                label: 'AMOUNT DISPUTED',
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text('₹',
                          style: AppTypography.h2.copyWith(
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.amountCtrl,
                        keyboardType: TextInputType.number,
                        style: AppTypography.num
                            .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm, vertical: 14),
                          hintText: '0',
                        ),
                      ),
                    ),
                  ]),
                ),
              ),

              // Error
              if (widget.errorMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errBg,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: Row(children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedAlert01,
                      color: AppColors.err,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(widget.errorMsg!,
                          style: AppTypography.small
                              .copyWith(color: AppColors.err)),
                    ),
                  ]),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),

        // Sticky submit
        Container(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.sm + AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
          color: AppColors.background,
          child: Column(children: [
            EmButtonFull(
              label: 'Submit Dispute',
              loading: widget.isLoading,
              onPressed: (widget.canSubmit && !widget.isLoading)
                  ? widget.onSubmit
                  : null,
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
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
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
  const _SuccessView({required this.dispute});
  final BillingDisputeModel dispute;

  @override
  Widget build(BuildContext context) {
    final id = dispute.id ?? '';
    final refNum =
        '#${id.length > 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase()}';

    return Column(children: [
      const EmTopBar(title: 'Submitted'),
      Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                    color: AppColors.surfaceTint, shape: BoxShape.circle),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                    color: AppColors.ok,
                    size: 36,
                  ),
                ),
              ).animate().scale(
                  begin: const Offset(0.6, 0.6),
                  duration: 300.ms,
                  curve: Curves.easeOutBack),
              const SizedBox(height: AppSpacing.lg),
              Text('Dispute filed', style: AppTypography.title),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTypography.bodyR.copyWith(height: 1.5),
                  children: [
                    const TextSpan(text: "We've assigned dispute "),
                    TextSpan(
                        text: refNum,
                        style: AppTypography.num.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600)),
                    const TextSpan(
                        text: '. You\'ll hear back in 2–3 business days.'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              EmButtonFull(
                label: 'View Dispute',
                onPressed: id.isNotEmpty
                    ? () => context.pushReplacement('/profile/disputes/$id')
                    : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              EmButtonFull(
                label: 'Back to Disputes',
                variant: EmButtonVariant.ghost,
                onPressed: () => context.go(AppRoutes.disputesList),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.child,
    this.isRequired = false,
    this.trailing,
  });
  final String label;
  final bool isRequired;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, AppSpacing.sm),
            child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Text(label, style: AppTypography.meta),
                if (isRequired)
                  Text(' *',
                      style: AppTypography.meta.copyWith(color: AppColors.err)),
              ]),
              if (trailing != null) trailing!,
            ]),
          ),
          child,
        ]),
      );
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hint,
    this.keyboardType,
  });
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTypography.body,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            hintText: hint,
            hintStyle:
                AppTypography.bodyR.copyWith(color: AppColors.textTertiary),
          ),
        ),
      );
}
