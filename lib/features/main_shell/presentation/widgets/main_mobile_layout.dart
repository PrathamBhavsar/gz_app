import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/routes.dart';

class MainMobileLayout extends StatelessWidget {
  final Widget child;
  const MainMobileLayout({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith(AppRoutes.home)) return 0;
    if (loc.startsWith('/book')) return 1;
    if (loc.startsWith('/sessions')) return 2;
    if (loc.startsWith('/wallet')) return 3;
    if (loc.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go(AppRoutes.home);
      case 1: context.go('/book');
      case 2: context.go('/sessions');
      case 3: context.go('/wallet');
      case 4: context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _selectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: _GzBottomNav(
        active: active,
        onTap: (i) => _onTap(context, i),
      ),
    );
  }
}

// Custom bottom nav matching the design exactly:
// - White surface background
// - Rounded top 28px
// - 5 icon-only tabs
// - Active: textPrimary, Inactive: textMuted
// - Padding: 14px top, 22px bottom
class _GzBottomNav extends StatelessWidget {
  const _GzBottomNav({required this.active, required this.onTap});
  final int active;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
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
              _NavBtn(icon: _NavIcon.home,   active: active == 0, onTap: () => onTap(0)),
              _NavBtn(icon: _NavIcon.book,   active: active == 1, onTap: () => onTap(1)),
              _NavBtn(icon: _NavIcon.games,  active: active == 2, onTap: () => onTap(2)),
              _NavBtn(icon: _NavIcon.wallet, active: active == 3, onTap: () => onTap(3)),
              _NavBtn(icon: _NavIcon.user,   active: active == 4, onTap: () => onTap(4)),
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
          painter: _GzIconPainter(icon: icon, color: color),
        ),
      ),
    );
  }
}

enum _NavIcon { home, book, games, wallet, user }

// Paints the exact icon paths from components.jsx:
// home, book, games, wallet, user
class _GzIconPainter extends CustomPainter {
  const _GzIconPainter({required this.icon, required this.color});
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
        // <path d="M4 11l8-7 8 7v9a1 1 0 01-1 1h-4v-6h-6v6H5a1 1 0 01-1-1v-9z"/>
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
        // <path d="M5 4h11l3 3v13H5z"/>
        // <path d="M9 9h7M9 13h7M9 17h4"/>
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
        // <rect x="3" y="7" width="18" height="11" rx="3.5"/>
        // <path d="M8 12h3M9.5 10.5v3M15 11.5v.5M17 13v.5"/>
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
        // <rect x="3" y="6" width="18" height="13" rx="2.5"/>
        // <path d="M3 10h18M16.5 14h2"/>
        final rrect = RRect.fromRectAndRadius(
          const Rect.fromLTWH(3, 6, 18, 13),
          const Radius.circular(2.5),
        );
        canvas.drawRRect(rrect, paint);
        canvas.drawLine(const Offset(3, 10), const Offset(21, 10), paint);
        canvas.drawLine(const Offset(16.5, 14), const Offset(18.5, 14), paint);

      case _NavIcon.user:
        // <circle cx="12" cy="8.5" r="3.5"/>
        // <path d="M5 20c1.2-4 4-6 7-6s5.8 2 7 6"/>
        canvas.drawCircle(const Offset(12, 8.5), 3.5, paint);
        final p = Path();
        p.moveTo(5, 20);
        p.cubicTo(6.2, 16, 8, 14, 12, 14);
        p.cubicTo(16, 14, 17.8, 16, 19, 20);
        canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(_GzIconPainter old) => old.icon != icon || old.color != color;
}
