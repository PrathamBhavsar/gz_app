import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';

const _walleColors = [
  (bg: Color(0xFFEAD5C8), fg: Color(0xFF5C4A40)),
  (bg: Color(0xFFD4E4D8), fg: Color(0xFF3D5A45)),
  (bg: Color(0xFFDFD4E8), fg: Color(0xFF534968)),
  (bg: Color(0xFFE8D4D4), fg: Color(0xFF685454)),
  (bg: Color(0xFFD4E0E8), fg: Color(0xFF40536B)),
  (bg: Color(0xFFE8E4D4), fg: Color(0xFF6B6340)),
  (bg: Color(0xFFE4D8D4), fg: Color(0xFF6B5954)),
];

enum GzAvatarSize { sm, md, lg, xl }

class GzAvatar extends StatelessWidget {
  const GzAvatar({
    super.key,
    this.letter,
    this.icon,
    this.size = GzAvatarSize.md,
    this.index,
    this.children,
  });

  final String? letter;
  final Widget? icon;
  final GzAvatarSize size;
  final int? index;
  final String? children;

  double get _dimension => switch (size) {
    GzAvatarSize.sm => 32,
    GzAvatarSize.md => 34,
    GzAvatarSize.lg => 40,
    GzAvatarSize.xl => 56,
  };

  double get _fontSize => switch (size) {
    GzAvatarSize.sm => 12,
    GzAvatarSize.md => 13,
    GzAvatarSize.lg => 15,
    GzAvatarSize.xl => 20,
  };

  @override
  Widget build(BuildContext context) {
    final value = letter ?? children;
    final paletteIndex = index ??
        (value != null && value.isNotEmpty
            ? value.codeUnitAt(0) % _walleColors.length
            : 0);
    final palette = _walleColors[paletteIndex % _walleColors.length];

    return Container(
      width: _dimension,
      height: _dimension,
      decoration: BoxDecoration(color: palette.bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: icon ??
          (value != null && value.isNotEmpty
              ? Text(
                  value[0].toUpperCase(),
                  style: AppTypography.body.copyWith(
                    color: palette.fg,
                    fontSize: _fontSize,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : const SizedBox.shrink()),
    );
  }
}
