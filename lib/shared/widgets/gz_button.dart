import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum GzButtonVariant { primary, ghost, dangerOutline }

class GzButton extends StatelessWidget {
  const GzButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GzButtonVariant.primary,
    this.small = false,
    this.icon,
    this.leading,
    this.trailing,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final GzButtonVariant variant;
  final bool small;
  final Widget? icon;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final height = small ? 38.0 : 56.0;
    final foreground = switch (variant) {
      GzButtonVariant.primary => AppColors.buttonFg,
      GzButtonVariant.ghost => AppColors.textPrimary,
      GzButtonVariant.dangerOutline => AppColors.err,
    };
    final background = switch (variant) {
      GzButtonVariant.primary => AppColors.buttonBg,
      GzButtonVariant.ghost => AppColors.pillBg,
      GzButtonVariant.dangerOutline => Colors.transparent,
    };
    final border = switch (variant) {
      GzButtonVariant.primary => null,
      GzButtonVariant.ghost => Border.all(color: AppColors.rule, width: 1.5),
      GzButtonVariant.dangerOutline =>
        Border.all(color: AppColors.err, width: 1.5),
    };
    final lead = icon ?? leading;

    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            padding: EdgeInsets.symmetric(horizontal: small ? 14 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              side: border is Border ? border.top : BorderSide.none,
            ),
          ).copyWith(
            side: WidgetStatePropertyAll(
              border is Border ? border.top : BorderSide.none,
            ),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
          child: loading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (lead != null) ...[lead, const SizedBox(width: 8)],
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: (small ? AppTypography.small : AppTypography.button)
                            .copyWith(
                              color: foreground,
                              fontSize: small ? 13 : null,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      trailing!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
