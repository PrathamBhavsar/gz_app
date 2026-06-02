import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GzChip extends StatelessWidget {
  const GzChip({
    super.key,
    this.label,
    this.keyPrefix,
    this.active = false,
    this.onTap,
    this.value,
    this.keyLabel,
    this.filled,
  });

  final String? label;
  final String? keyPrefix;
  final bool active;
  final VoidCallback? onTap;

  final String? value;
  final String? keyLabel;
  final bool? filled;

  @override
  Widget build(BuildContext context) {
    final displayValue = label ?? value ?? '';
    final displayKey = keyPrefix ?? keyLabel;
    final isFilled = filled ?? active;
    final bg = isFilled ? AppColors.buttonBg : AppColors.surface;
    final fg = isFilled ? AppColors.buttonFg : AppColors.textPrimary;
    final keyFg = isFilled
        ? AppColors.buttonFg.withValues(alpha: 0.55)
        : AppColors.textTertiary;

    final chip = Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: isFilled ? null : Border.all(color: AppColors.rule),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (displayKey != null) ...[
            Text(
              displayKey,
              style: AppTypography.num.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: keyFg,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            displayValue,
            style: AppTypography.num.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}
