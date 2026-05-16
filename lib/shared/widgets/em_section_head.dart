import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class EmSectionHead extends StatelessWidget {
  const EmSectionHead(
    this.title, {
    super.key,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: 12),
      child: Row(
        children: [
          Text(title, style: AppTypography.h2),
          if (subtitle != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(
              subtitle!,
              style: AppTypography.small.copyWith(color: AppColors.textTertiary),
            ),
          ],
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
