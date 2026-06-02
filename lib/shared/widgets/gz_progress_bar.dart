import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class GzProgressBar extends StatelessWidget {
  const GzProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.trackColor,
    this.fillColor,
  });

  final double value;
  final double height;
  final Color? trackColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final pct = value.clamp(0.0, 1.0);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: trackColor ?? AppColors.rule,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: pct,
          child: Container(
            decoration: BoxDecoration(
              color: fillColor ?? AppColors.textPrimary,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}
