import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gz_bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.child});

  final Widget child;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GzTab _currentTab = GzTab.home;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentTab = _tabForLocation(GoRouterState.of(context).matchedLocation);
  }

  GzTab _tabForLocation(String location) {
    if (location.startsWith('/book')) return GzTab.book;
    if (location.startsWith('/sessions')) return GzTab.sessions;
    if (location.startsWith('/wallet')) return GzTab.wallet;
    if (location.startsWith('/profile')) return GzTab.profile;
    return GzTab.home;
  }

  void _onTap(GzTab tab) {
    if (tab == _currentTab) return;
    setState(() => _currentTab = tab);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      bottomNavigationBar: GzBottomNav(currentTab: _currentTab, onTap: _onTap),
    );
  }
}
