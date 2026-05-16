import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../providers/change_phone_notifier.dart';

class ChangePhoneMobileLayout extends ConsumerStatefulWidget {
  const ChangePhoneMobileLayout({super.key});

  @override
  ConsumerState<ChangePhoneMobileLayout> createState() =>
      _ChangePhoneMobileLayoutState();
}

class _ChangePhoneMobileLayoutState
    extends ConsumerState<ChangePhoneMobileLayout> {
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePhoneProvider);

    ref.listen(changePhoneProvider, (_, next) {
      if (next is ChangePhoneSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Phone number updated successfully'),
          backgroundColor: AppColors.ok,
        ));
        context.pop();
      }
    });

    return switch (state) {
      ChangePhoneInitial() || ChangePhoneLoading() || ChangePhoneError() =>
        _Step1View(
          ctrl: _phoneCtrl,
          state: state,
          onSend: () => ref
              .read(changePhoneProvider.notifier)
              .sendOtp(_phoneCtrl.text.trim()),
        ),
      ChangePhoneOtpSent(:final phone) => _OtpSentView(
          phone: phone,
          onVerified: () =>
              ref.read(changePhoneProvider.notifier).markSuccess(),
        ),
      ChangePhoneSuccess() => const SizedBox.shrink(),
    };
  }
}

class _Step1View extends StatelessWidget {
  const _Step1View({
    required this.ctrl,
    required this.state,
    required this.onSend,
  });
  final TextEditingController ctrl;
  final ChangePhoneState state;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final isLoading = state is ChangePhoneLoading;
    final errorMsg =
        state is ChangePhoneError ? (state as ChangePhoneError).message : null;

    return Column(
      children: [
        const EmTopBar(title: 'Change Phone'),
        Expanded(
          child: EmScrollContent(
            padded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your new phone number',
                    style: AppTypography.h3),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'We\'ll send an OTP to verify it.',
                  style: AppTypography.bodyR
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusLg),
                    border: Border.all(
                        color: errorMsg != null
                            ? AppColors.err
                            : AppColors.rule),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md),
                        child: Text('+91',
                            style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: ctrl,
                          keyboardType: TextInputType.phone,
                          style: AppTypography.body,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                            hintText: 'Phone number',
                            hintStyle: AppTypography.bodyR
                                .copyWith(color: AppColors.textMuted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (errorMsg != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(errorMsg,
                      style:
                          AppTypography.small.copyWith(color: AppColors.err)),
                ],
                const SizedBox(height: AppSpacing.xl),
                EmButtonFull(
                  label: 'Send OTP',
                  loading: isLoading,
                  onPressed: isLoading ? null : onSend,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OtpSentView extends StatelessWidget {
  const _OtpSentView({required this.phone, required this.onVerified});
  final String phone;
  final VoidCallback onVerified;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EmTopBar(title: 'Verify Phone'),
        Expanded(
          child: EmScrollContent(
            padded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmCard(
                  variant: CardVariant.tint,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('OTP sent to', style: AppTypography.small),
                      const SizedBox(height: 2),
                      Text(phone, style: AppTypography.h3),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Enter the 6-digit OTP sent to your new number. Once verified, your phone number will be updated.',
                  style: AppTypography.bodyR
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                EmButtonFull(
                  label: 'Confirm Verification',
                  onPressed: onVerified,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
