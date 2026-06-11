import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/otp_input_sheet.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/change_phone_notifier.dart';
import '../../application/profile_notifier.dart';

class ChangePhoneScreen extends ConsumerStatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  ConsumerState<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends ConsumerState<ChangePhoneScreen> {
  late final TextEditingController _phoneController;
  static const _phonePattern = r'^\+[1-9]\d{6,14}$';
  static const _countries = <_CountryOption>[
    _CountryOption(name: 'India', dialCode: '+91', flag: 'IN'),
    _CountryOption(name: 'United States', dialCode: '+1', flag: 'US'),
    _CountryOption(name: 'United Arab Emirates', dialCode: '+971', flag: 'AE'),
    _CountryOption(name: 'United Kingdom', dialCode: '+44', flag: 'GB'),
  ];
  _CountryOption _selectedCountry = _countries.first;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChangePhoneState>(changePhoneNotifierProvider, (previous, next) {
      if (next is ChangePhoneError) {
        showErrorSnackbar(context, next.error);
      }
      if (next is ChangePhoneOtpSent && previous is! ChangePhoneOtpSent) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          showOtpInputSheet(
            context,
            phone: next.phone,
            onVerify: (otp) =>
                ref.read(changePhoneNotifierProvider.notifier).verifyOtp(otp),
            onResend: () {
              ref.read(changePhoneNotifierProvider.notifier).resendOtp();
            },
          );
        });
      }
      if (next is ChangePhoneSuccess) {
        showSuccessSnackbar(context, next.message);
        _phoneController.clear();
      }
    });

    final profileState = ref.watch(profileNotifierProvider);
    final changeState = ref.watch(changePhoneNotifierProvider);
    final isSubmitting = changeState is ChangePhoneLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Change phone'),
      body: SafeArea(
        top: false,
        child: profileState.when(
          loading: () => const GzLoadingView(message: 'Loading profile'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
          ),
          data: (user) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current number: ${_currentPhone(user.phone)}',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'We will send an OTP to verify your new number before it is applied to the account.',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('New phone number', style: AppTypography.meta),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadiusLg,
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _pickCountry,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadius,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pillBg,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadius,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_selectedCountry.flag} ${_selectedCountry.dialCode}',
                                style: AppTypography.body,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowDown01,
                                color: AppColors.textTertiary,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '98765 43210',
                            border: InputBorder.none,
                          ),
                          style: AppTypography.body,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GzButton(
                  label: 'Send OTP',
                  onPressed: isSubmitting ? null : _submit,
                  loading: isSubmitting,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _currentPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Not set';
    }
    return phone.trim();
  }

  Future<void> _submit() async {
    final localDigits = _phoneController.text.trim().replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    if (localDigits.isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Enter the new phone number first.'),
      );
      return;
    }
    final currentPhone = ref
        .read(profileNotifierProvider)
        .valueOrNull
        ?.phone
        ?.trim();
    final normalized = '${_selectedCountry.dialCode}$localDigits';
    final phoneRegex = RegExp(_phonePattern);
    if (!phoneRegex.hasMatch(normalized)) {
      showErrorSnackbar(
        context,
        const ValidationException(
          'Enter a valid phone number in E.164 format.',
        ),
      );
      return;
    }
    if (currentPhone == normalized) {
      showErrorSnackbar(
        context,
        const ValidationException(
          'Enter a different phone number from your current one.',
        ),
      );
      return;
    }

    await ref.read(changePhoneNotifierProvider.notifier).submit(normalized);
  }

  Future<void> _pickCountry() async {
    final selected = await showModalBottomSheet<_CountryOption>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusCard),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemBuilder: (context, index) {
              final option = _countries[index];
              return ListTile(
                title: Text(
                  '${option.flag} ${option.name}',
                  style: AppTypography.body,
                ),
                trailing: Text(
                  option.dialCode,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(option),
              );
            },
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: AppColors.divider),
            itemCount: _countries.length,
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedCountry = selected;
      });
    }
  }
}

class _CountryOption {
  const _CountryOption({
    required this.name,
    required this.dialCode,
    required this.flag,
  });

  final String name;
  final String dialCode;
  final String flag;
}
