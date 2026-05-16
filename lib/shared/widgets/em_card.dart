import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum CardVariant { base, tint, inset }

class EmCard extends StatelessWidget {
  const EmCard({
    super.key,
    required this.child,
    this.variant = CardVariant.base,
    this.padding,
  });

  final Widget child;
  final CardVariant variant;

  /// Uniform padding in dp. Defaults to AppSpacing.md (16).
  final double? padding;

  @override
  Widget build(BuildContext context) {
    final p = padding ?? AppSpacing.md;
    final (bg, radius) = switch (variant) {
      CardVariant.base => (AppColors.surface, AppSpacing.borderRadiusCard),
      CardVariant.tint => (AppColors.surfaceTint, AppSpacing.borderRadiusCard),
      CardVariant.inset => (AppColors.pillBg, AppSpacing.borderRadiusLg),
    };

    return Container(
      padding: EdgeInsets.all(p),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
