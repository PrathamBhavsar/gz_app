import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _showPassword = false;

  void _register() => context.push(AppRoutes.otpVerification);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create an account', style: AppTypography.h1),
                      const SizedBox(height: 28),
                      const _AuthField(
                        hint: 'Full Name',
                        focused: true,
                      ),
                      const SizedBox(height: 16),
                      const _AuthField(
                        hint: 'Phone Number',
                        suffixText: '(Optional)',
                      ),
                      const SizedBox(height: 16),
                      const _AuthField(
                        hint: 'Email Address',
                        suffixText: '(Optional)',
                      ),
                      const SizedBox(height: 16),
                      _AuthField(
                        hint: 'Password',
                        suffixText: '(Optional)',
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
                    ],
                  ),
                ),
              ),
              GzButton(label: 'Register', onPressed: _register),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.hint,
    this.suffixText,
    this.trailing,
    this.obscureText = false,
    this.focused = false,
  });

  final String hint;
  final String? suffixText;
  final Widget? trailing;
  final bool obscureText;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: focused
            ? Border.all(color: AppColors.textPrimary, width: 1.5)
            : null,
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
          suffixIconConstraints: const BoxConstraints(minHeight: 20),
          suffixIcon: trailing ??
              (suffixText == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          suffixText!,
                          style: AppTypography.small,
                        ),
                      ),
                    )),
        ),
      ),
    );
  }
}
