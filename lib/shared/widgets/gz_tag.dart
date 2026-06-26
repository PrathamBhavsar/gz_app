import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum GzTagKind { ok, warn, err, info, mute, purple }

class GzTag extends StatelessWidget {
  const GzTag({super.key, required this.kind, required this.label});

  final GzTagKind kind;
  final String label;

  Color get _bg => switch (kind) {
    GzTagKind.ok => AppColors.okBg,
    GzTagKind.warn => AppColors.warnBg,
    GzTagKind.err => AppColors.errBg,
    GzTagKind.info => AppColors.infoBg,
    GzTagKind.mute => AppColors.pillBg,
    GzTagKind.purple => AppColors.purpleBg,
  };

  Color get _fg => switch (kind) {
    GzTagKind.ok => AppColors.ok,
    GzTagKind.warn => AppColors.warn,
    GzTagKind.err => AppColors.err,
    GzTagKind.info => AppColors.info,
    GzTagKind.mute => AppColors.textSecondary,
    GzTagKind.purple => AppColors.purple,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTypography.small.copyWith(
          color: _fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
