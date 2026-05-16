import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/em_bottom_nav.dart';

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
      case 1: context.go(AppRoutes.book);
      case 2: context.go(AppRoutes.sessions);
      case 3: context.go(AppRoutes.wallet);
      case 4: context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _selectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: EmBottomNav(
        active: active,
        onTap: (i) => _onTap(context, i),
      ),
    );
  }
}
