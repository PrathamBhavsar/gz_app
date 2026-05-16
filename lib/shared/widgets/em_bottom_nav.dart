import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EmBottomNav extends StatelessWidget {
  const EmBottomNav({
    super.key,
    required this.active,
    required this.onTap,
  });

  final int active;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSubtle,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, bottomPadding > 0 ? 0 : 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBtn(icon: _NavIcon.home, active: active == 0, onTap: () => onTap(0)),
              _NavBtn(icon: _NavIcon.book, active: active == 1, onTap: () => onTap(1)),
              _NavBtn(icon: _NavIcon.games, active: active == 2, onTap: () => onTap(2)),
              _NavBtn(icon: _NavIcon.wallet, active: active == 3, onTap: () => onTap(3)),
              _NavBtn(icon: _NavIcon.user, active: active == 4, onTap: () => onTap(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({required this.icon, required this.active, required this.onTap});
  final _NavIcon icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.textPrimary : AppColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CustomPaint(
          size: const Size(22, 22),
          painter: _NavIconPainter(icon: icon, color: color),
        ),
      ),
    );
  }
}

enum _NavIcon { home, book, games, wallet, user }

class _NavIconPainter extends CustomPainter {
  const _NavIconPainter({required this.icon, required this.color});
  final _NavIcon icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.7 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.scale(s, s);

    switch (icon) {
      case _NavIcon.home:
        final p = Path();
        p.moveTo(4, 11);
        p.lineTo(12, 4);
        p.lineTo(20, 11);
        p.lineTo(20, 20);
        p.arcToPoint(const Offset(19, 21), radius: const Radius.circular(1));
        p.lineTo(15, 21);
        p.lineTo(15, 15);
        p.lineTo(9, 15);
        p.lineTo(9, 21);
        p.lineTo(5, 21);
        p.arcToPoint(const Offset(4, 20), radius: const Radius.circular(1));
        p.close();
        canvas.drawPath(p, paint..style = PaintingStyle.stroke);

      case _NavIcon.book:
        final p1 = Path();
        p1.moveTo(5, 4);
        p1.lineTo(16, 4);
        p1.lineTo(19, 7);
        p1.lineTo(19, 20);
        p1.lineTo(5, 20);
        p1.close();
        canvas.drawPath(p1, paint);
        canvas.drawLine(const Offset(9, 9), const Offset(16, 9), paint);
        canvas.drawLine(const Offset(9, 13), const Offset(16, 13), paint);
        canvas.drawLine(const Offset(9, 17), const Offset(13, 17), paint);

      case _NavIcon.games:
        final rrect = RRect.fromRectAndRadius(
          const Rect.fromLTWH(3, 7, 18, 11),
          const Radius.circular(3.5),
        );
        canvas.drawRRect(rrect, paint);
        canvas.drawLine(const Offset(8, 12), const Offset(11, 12), paint);
        canvas.drawLine(const Offset(9.5, 10.5), const Offset(9.5, 13.5), paint);
        canvas.drawLine(const Offset(15, 11.5), const Offset(15, 12), paint);
        canvas.drawLine(const Offset(17, 13), const Offset(17, 13.5), paint);

      case _NavIcon.wallet:
        final rrect = RRect.fromRectAndRadius(
          const Rect.fromLTWH(3, 6, 18, 13),
          const Radius.circular(2.5),
        );
        canvas.drawRRect(rrect, paint);
        canvas.drawLine(const Offset(3, 10), const Offset(21, 10), paint);
        canvas.drawLine(const Offset(16.5, 14), const Offset(18.5, 14), paint);

      case _NavIcon.user:
        canvas.drawCircle(const Offset(12, 8.5), 3.5, paint);
        final p = Path();
        p.moveTo(5, 20);
        p.cubicTo(6.2, 16, 8, 14, 12, 14);
        p.cubicTo(16, 14, 17.8, 16, 19, 20);
        canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(_NavIconPainter old) => old.icon != icon || old.color != color;
}
