import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Key–value info chip. Pass [keyLabel] for the dimmed key part.
/// Set [filled] to invert colours (dark background).
class GzChip extends StatelessWidget {
  const GzChip({
    super.key,
    required this.value,
    this.keyLabel,
    this.filled = false,
    this.onTap,
  });

  final String value;
  final String? keyLabel;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.buttonBg : AppColors.surface;
    final fg = filled ? AppColors.buttonFg : AppColors.textPrimary;
    final keyFg = filled
        ? AppColors.buttonFg.withValues(alpha: 0.55)
        : AppColors.textTertiary;

    final chip = Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (keyLabel != null) ...[
            Text(keyLabel!, style: AppTypography.num.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: keyFg)),
            const SizedBox(width: 4),
          ],
          Text(value, style: AppTypography.num.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: fg)),
        ],
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}
