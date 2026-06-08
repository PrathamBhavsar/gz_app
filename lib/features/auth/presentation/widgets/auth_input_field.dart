import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.trailing,
    this.obscureText = false,
    this.focused = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.suffixText,
    this.enabled = true,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hint;
  final Widget? trailing;
  final bool obscureText;
  final bool focused;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? suffixText;
  final bool enabled;
  final int? maxLength;

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
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: '',
          hintText: hint,
          hintStyle: AppTypography.body.copyWith(color: AppColors.textPrimary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIconConstraints: const BoxConstraints(minHeight: 20),
          suffixIcon:
              trailing ??
              (suffixText == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Center(
                        widthFactor: 1,
                        child: Text(suffixText!, style: AppTypography.small),
                      ),
                    )),
        ),
      ),
    );
  }
}
