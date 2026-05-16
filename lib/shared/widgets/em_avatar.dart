import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

// Walle palette — 7 muted tones matching components.jsx AVATAR_COLORS
const _walleColors = [
  (bg: Color(0xFFEAD5C8), fg: Color(0xFF5C4A40)),
  (bg: Color(0xFFD4E4D8), fg: Color(0xFF3D5A45)),
  (bg: Color(0xFFDFD4E8), fg: Color(0xFF534968)),
  (bg: Color(0xFFE8D4D4), fg: Color(0xFF685454)),
  (bg: Color(0xFFD4E0E8), fg: Color(0xFF40536B)),
  (bg: Color(0xFFE8E4D4), fg: Color(0xFF6B6340)),
  (bg: Color(0xFFE4D8D4), fg: Color(0xFF6B5954)),
];

enum AvatarSize { sm, md, lg, xl }

class EmAvatar extends StatelessWidget {
  const EmAvatar({
    super.key,
    this.icon,
    this.children,
    this.size = AvatarSize.md,
    this.index,
  });

  final Widget? icon;
  final String? children;
  final AvatarSize size;

  /// Override palette index (0–6). Defaults to first char of [children].
  final int? index;

  double get _dimension => switch (size) {
        AvatarSize.sm => 32,
        AvatarSize.md => 34,
        AvatarSize.lg => 40,
        AvatarSize.xl => 56,
      };

  double get _fontSize => switch (size) {
        AvatarSize.sm => 12,
        AvatarSize.md => 13,
        AvatarSize.lg => 15,
        AvatarSize.xl => 20,
      };

  ({Color bg, Color fg}) get _palette {
    final i = index ??
        (children != null && children!.isNotEmpty
            ? children!.codeUnitAt(0) % _walleColors.length
            : 0);
    return _walleColors[i % _walleColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final d = _dimension;
    final palette = _palette;

    Widget content;
    if (icon != null) {
      content = icon!;
    } else if (children != null && children!.isNotEmpty) {
      content = Text(
        children![0].toUpperCase(),
        style: AppTypography.body.copyWith(
          color: palette.fg,
          fontSize: _fontSize,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      content = const SizedBox.shrink();
    }

    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: palette.bg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
