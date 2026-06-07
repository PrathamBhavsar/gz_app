import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';

class EmailVerifySuccessScreen extends StatefulWidget {
  const EmailVerifySuccessScreen({super.key});

  @override
  State<EmailVerifySuccessScreen> createState() =>
      _EmailVerifySuccessScreenState();
}

class _EmailVerifySuccessScreenState extends State<EmailVerifySuccessScreen> {
  int _countdown = 4;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown == 0) {
        timer.cancel();
        _continueToApp();
        return;
      }
      setState(() => _countdown -= 1);
    });
  }

  void _continueToApp() {
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Redirecting you in $_countdown…',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: 24),
                GzButton(
                  label: 'Continue to app',
                  onPressed: _continueToApp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
