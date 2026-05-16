import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum EmTagKind { ok, warn, err, info, purple, mute }

class EmTag extends StatelessWidget {
  const EmTag({super.key, required this.kind, required this.label});

  final EmTagKind kind;
  final String label;

  Color get _bg => switch (kind) {
        EmTagKind.ok => AppColors.okBg,
        EmTagKind.warn => AppColors.warnBg,
        EmTagKind.err => AppColors.errBg,
        EmTagKind.info => AppColors.infoBg,
        EmTagKind.purple => AppColors.purpleBg,
        EmTagKind.mute => AppColors.pillBg,
      };

  Color get _fg => switch (kind) {
        EmTagKind.ok => AppColors.ok,
        EmTagKind.warn => AppColors.warn,
        EmTagKind.err => AppColors.err,
        EmTagKind.info => AppColors.info,
        EmTagKind.purple => AppColors.purple,
        EmTagKind.mute => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
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
