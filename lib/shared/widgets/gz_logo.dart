import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GzLogo extends StatelessWidget {
  const GzLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.buttonBg,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        'GZ',
        style: AppTypography.num.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.surfaceTintStrong,
          fontSize: 13,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
