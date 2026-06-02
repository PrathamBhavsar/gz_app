import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Check in'),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowSubtle,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusCard),
                  child: CustomPaint(
                    painter: _QrPatternPainter(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Show this to staff',
                style: AppTypography.bodyR
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusCard),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PC Station 01  ·  6:00 PM  ·  2 hours',
                      style: AppTypography.bodyR,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GzButton(
                label: 'Scan to check in',
                onPressed: null,
              ),
              const SizedBox(height: 12),
              GzButton(
                label: 'Manual check in',
                variant: GzButtonVariant.ghost,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.textPrimary;
    const cols = 10;
    const rows = 10;
    const pattern = [
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 0],
      [1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 1, 0],
      [0, 1, 0, 1, 0, 1, 1, 0, 1, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 0, 1],
    ];
    const padding = 16.0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (pattern[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              padding + c * (size.width - padding * 2) / cols,
              padding + r * (size.height - padding * 2) / rows,
              (size.width - padding * 2) / cols - 2,
              (size.height - padding * 2) / rows - 2,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_QrPatternPainter old) => false;
}
