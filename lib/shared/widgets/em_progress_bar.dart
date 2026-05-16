import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EmProgressBar extends StatelessWidget {
  const EmProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.trackColor,
    this.fillColor,
  });

  /// 0.0 – 1.0
  final double value;
  final double height;
  final Color? trackColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final track = trackColor ?? AppColors.rule;
        final fill = fillColor ?? AppColors.textPrimary;
        final pct = value.clamp(0.0, 1.0);

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: track,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: pct,
              child: Container(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
