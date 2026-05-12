import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

enum GzButtonVariant { primary, ghost, dangerOutline }

class GzButton extends StatelessWidget {
  const GzButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GzButtonVariant.primary,
    this.small = false,
    this.leading,
    this.trailing,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final GzButtonVariant variant;
  final bool small;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final height = small ? 38.0 : 56.0;
    final fontSize = small ? 13.0 : 15.0;
    final radius = small ? AppSpacing.borderRadiusChip : AppSpacing.borderRadiusLg;

    Color bg;
    Color fg;
    BoxBorder? border;

    switch (variant) {
      case GzButtonVariant.primary:
        bg = AppColors.buttonBg;
        fg = AppColors.buttonFg;
        border = null;
      case GzButtonVariant.ghost:
        bg = AppColors.surface;
        fg = AppColors.textPrimary;
        border = Border.all(color: AppColors.rule);
      case GzButtonVariant.dangerOutline:
        bg = Colors.transparent;
        fg = AppColors.err;
        border = Border.all(color: AppColors.err.withValues(alpha: 0.3));
    }

    return Opacity(
      opacity: disabled ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : onPressed,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: small ? 14 : 22),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius), border: border),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                )
              else ...[
                if (leading != null) ...[leading!, const SizedBox(width: 8)],
                Text(label, style: AppTypography.button.copyWith(color: fg, fontSize: fontSize)),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width wrapper for GzButton.
class GzButtonFull extends StatelessWidget {
  const GzButtonFull({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GzButtonVariant.primary,
    this.small = false,
    this.leading,
    this.trailing,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final GzButtonVariant variant;
  final bool small;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GzButton(
        label: label,
        onPressed: onPressed,
        variant: variant,
        small: small,
        leading: leading,
        trailing: trailing,
        loading: loading,
      ),
    );
  }
}
