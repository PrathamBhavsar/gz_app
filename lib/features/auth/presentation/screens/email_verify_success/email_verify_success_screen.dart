import 'dart:async';

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

class EmailVerifySuccessScreen extends ConsumerStatefulWidget {
  const EmailVerifySuccessScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<EmailVerifySuccessScreen> createState() =>
      _EmailVerifySuccessScreenState();
}

class _EmailVerifySuccessScreenState
    extends ConsumerState<EmailVerifySuccessScreen> {
  int _countdown = 4;
  Timer? _timer;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.token != null && widget.token!.isNotEmpty) {
      _submitted = true;
      Future.microtask(() {
        ref
            .read(emailVerificationNotifierProvider.notifier)
            .verifyToken(widget.token!);
      });
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown == 0) {
        timer.cancel();
        _continueToSignIn();
        return;
      }
      setState(() => _countdown -= 1);
    });
  }

  void _continueToSignIn() {
    if (mounted) context.go(AppRoutes.emailLogin);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EmailVerificationState>(emailVerificationNotifierProvider, (
      previous,
      next,
    ) {
      if (!mounted) {
        return;
      }
      if (next is EmailVerificationError) {
        showErrorSnackbar(context, next.error);
        context.go(AppRoutes.authLanding);
      }
    });

    final verificationState = ref.watch(emailVerificationNotifierProvider);
    final isLoading =
        verificationState is EmailVerificationLoading && _submitted;

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
                  icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                  color: AppColors.ok,
                  size: 72,
                ),
                const SizedBox(height: 20),
                Text('Email verified!', style: AppTypography.h1),
                const SizedBox(height: 10),
                Text(
                  isLoading
                      ? 'Verifying your email link...'
                      : 'Redirecting you in $_countdown…',
                  style: AppTypography.bodyR,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GzButton(
                  label: 'Continue to sign in',
                  onPressed: isLoading ? null : _continueToSignIn,
                  loading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
