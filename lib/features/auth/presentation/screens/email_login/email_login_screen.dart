import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';


import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  bool _showPassword = false;

  void _signIn() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Email login'),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FilledField(hint: 'Email address'),
              const SizedBox(height: 16),
              _FilledField(
                hint: 'Password',
                obscureText: !_showPassword,
                trailing: IconButton(
                  onPressed: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                  icon: HugeIcon(
                    icon: _showPassword
                        ? HugeIcons.strokeRoundedView
                        : HugeIcons.strokeRoundedViewOffSlash,
                    color: AppColors.textTertiary,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  child: Text(
                    'Forgot password?',
                    style: AppTypography.small.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GzButton(label: 'Sign in', onPressed: _signIn),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.pushReplacement(AppRoutes.register),
                  child: Text(
                    'Don\'t have an account? Register →',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilledField extends StatelessWidget {
  const _FilledField({
    required this.hint,
    this.trailing,
    this.obscureText = false,
  });

  final String hint;
  final Widget? trailing;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: TextField(
        readOnly: true,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.body.copyWith(color: AppColors.textPrimary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: trailing,
        ),
      ),
    );
  }
}
