import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../application/email_verification_notifier.dart';
import '../../../../../shared/widgets/gz_button.dart';

class EmailVerificationPendingScreen extends ConsumerStatefulWidget {
  const EmailVerificationPendingScreen({super.key, this.email});

  final String? email;

  @override
  ConsumerState<EmailVerificationPendingScreen> createState() =>
      _EmailVerificationPendingScreenState();
}

class _EmailVerificationPendingScreenState
    extends ConsumerState<EmailVerificationPendingScreen> {
  static const _resendDelaySeconds = 60;
  int _secondsRemaining = _resendDelaySeconds;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  Future<void> _startCountdown() async {
    while (mounted && _secondsRemaining > 0) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) {
        return;
      }
      setState(() => _secondsRemaining -= 1);
    }
  }

  void _showResendGuidance() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No resend endpoint exists yet. Check spam or register again to get a fresh verification email.',
        ),
      ),
    );
  }

  Future<void> _checkVerification() async {
    await ref
        .read(emailVerificationNotifierProvider.notifier)
        .checkCurrentUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    final address = widget.email ?? 'your email address';
    ref.listen<EmailVerificationState>(emailVerificationNotifierProvider, (
      previous,
      next,
    ) {
      if (!mounted) {
        return;
      }
      if (next is EmailVerificationSuccess) {
        context.go(AppRoutes.home);
      } else if (next is EmailVerificationError) {
        showErrorSnackbar(context, next.error);
      }
    });

    final verificationState = ref.watch(emailVerificationNotifierProvider);
    final isChecking = verificationState is EmailVerificationLoading;
    final canResend = _secondsRemaining == 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedMail01,
                  color: AppColors.textPrimary,
                  size: 64,
                ),
                const SizedBox(height: 20),
                Text('Check your inbox', style: AppTypography.h1),
                const SizedBox(height: 10),
                Text(
                  'We sent a verification link to $address',
                  style: AppTypography.bodyR,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GzButton(
                  label: canResend
                      ? 'Resend guidance'
                      : 'Resend in ${_secondsRemaining}s',
                  variant: GzButtonVariant.ghost,
                  onPressed: canResend ? _showResendGuidance : null,
                ),
                const SizedBox(height: 12),
                GzButton(
                  label: 'I\'ve verified',
                  onPressed: isChecking ? null : _checkVerification,
                  loading: isChecking,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go(AppRoutes.emailLogin),
                  child: Text(
                    'Wrong email? Go back',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
