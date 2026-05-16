import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../../../../shared/widgets/otp_input_sheet.dart';
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
  bool _otpSheetShown = false;

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
      if (next is ChangePhoneOtpSent && !_otpSheetShown) {
        _otpSheetShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showOtpInputSheet(
            context,
            phone: next.phone,
            onVerify: (otp) async {
              await ref.read(changePhoneProvider.notifier).verifyOtp(otp);
              ref.read(changePhoneProvider.notifier).markSuccess();
            },
            onResend: () => ref
                .read(changePhoneProvider.notifier)
                .sendOtp(_phoneCtrl.text.trim()),
          );
        });
      }
      if (next is ChangePhoneInitial || next is ChangePhoneError) {
        _otpSheetShown = false;
      }
    });

    final isLoading = state is ChangePhoneLoading;
    final errorMsg =
        state is ChangePhoneError ? state.message : null;

    return Column(
      children: [
        const EmTopBar(title: 'Change Phone'),
        Expanded(
          child: EmScrollContent(
            padded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your new phone number', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "We'll send an OTP to verify it.",
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
                      color:
                          errorMsg != null ? AppColors.err : AppColors.rule,
                    ),
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
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          style: AppTypography.body,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.all(AppSpacing.md),
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
                  onPressed: isLoading
                      ? null
                      : () => ref
                          .read(changePhoneProvider.notifier)
                          .sendOtp(_phoneCtrl.text.trim()),
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
