import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class GzAdminChip extends StatelessWidget {
  const GzAdminChip({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: active ? AppColors.buttonBg : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
        border: active ? null : Border.all(color: AppColors.rule),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTypography.num.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: active ? AppColors.buttonFg : AppColors.textPrimary,
        ),
      ),
    );

    if (onTap == null) return child;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
