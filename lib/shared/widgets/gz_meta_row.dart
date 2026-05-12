import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Label + value row used in cards.
class GzMetaRow extends StatelessWidget {
  const GzMetaRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(label, style: AppTypography.bodyR.copyWith(color: AppColors.textSecondary)),
          Text(value, style: valueStyle ?? AppTypography.num.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
