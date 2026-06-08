import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../application/otp_notifier.dart';
import '../../widgets/auth_input_field.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, this.phone, this.email});

  final String? phone;
  final String? email;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();
    await ref
        .read(otpNotifierProvider.notifier)
        .verify(
          code: _codeController.text.trim(),
          phone: widget.phone,
          email: widget.email,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OtpState>(otpNotifierProvider, (previous, next) {
      if (!mounted) return;
      if (next is OtpSuccess) {
        context.go(AppRoutes.home);
      } else if (next is OtpError) {
        showErrorSnackbar(context, next.error);
      }
    });

    final otpState = ref.watch(otpNotifierProvider);
    final isLoading = otpState is OtpLoading;
    final destination = widget.phone ?? widget.email ?? 'your account';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: ''),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verify your number', style: AppTypography.h1),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit code to $destination',
                style: AppTypography.bodyR,
              ),
              const SizedBox(height: 28),
              AuthInputField(
                controller: _codeController,
                hint: 'Enter 6-digit code',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!isLoading) {
                    _verify();
                  }
                },
                enabled: !isLoading,
                maxLength: 6,
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Resend in 0:42',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              GzButton(
                label: 'Verify',
                onPressed: isLoading ? null : _verify,
                loading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
