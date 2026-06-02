import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Reset password'),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            children: [
              _PasswordField(
                hint: 'New password',
                obscureText: !_showNewPassword,
                onToggle: () {
                  setState(() => _showNewPassword = !_showNewPassword);
                },
                isVisible: _showNewPassword,
              ),
              const SizedBox(height: 16),
              _PasswordField(
                hint: 'Confirm password',
                obscureText: !_showConfirmPassword,
                onToggle: () {
                  setState(
                    () => _showConfirmPassword = !_showConfirmPassword,
                  );
                },
                isVisible: _showConfirmPassword,
              ),
              const Spacer(),
              const GzButton(label: 'Set new password'),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.hint,
    required this.obscureText,
    required this.onToggle,
    required this.isVisible,
  });

  final String hint;
  final bool obscureText;
  final VoidCallback onToggle;
  final bool isVisible;

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
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: HugeIcon(
              icon: isVisible
                  ? HugeIcons.strokeRoundedView
                  : HugeIcons.strokeRoundedViewOffSlash,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
