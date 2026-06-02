import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/gz_bottom_nav.dart';

class MainMobileLayout extends StatelessWidget {
  final Widget child;
  const MainMobileLayout({super.key, required this.child});

  GzTab _selectedTab(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith(AppRoutes.home)) return GzTab.home;
    if (loc.startsWith('/book')) return GzTab.book;
    if (loc.startsWith('/sessions')) return GzTab.sessions;
    if (loc.startsWith('/wallet')) return GzTab.wallet;
    if (loc.startsWith('/profile')) return GzTab.profile;
    return GzTab.home;
  }

  void _onTap(BuildContext context, GzTab tab) {
    switch (tab) {
      case GzTab.home:
        context.go(AppRoutes.home);
      case GzTab.book:
        context.go(AppRoutes.book);
      case GzTab.sessions:
        context.go(AppRoutes.sessions);
      case GzTab.wallet:
        context.go(AppRoutes.wallet);
      case GzTab.profile:
        context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _selectedTab(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: GzBottomNav(
        currentTab: active,
        onTap: (tab) => _onTap(context, tab),
      ),
    );
  }
}
