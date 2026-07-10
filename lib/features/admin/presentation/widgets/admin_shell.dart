import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/gz_admin_bottom_nav.dart';

class AdminShell extends StatefulWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  DateTime? _lastBackPress;

  void _onPop(bool didPop, Object? result) {
    if (didPop) return;
    if (_selectedTab(context) != GzAdminTab.dashboard) {
      context.go(AppRoutes.adminDashboard);
      return;
    }
    final now = DateTime.now();
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }

  bool _showsBottomNav(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return location == AppRoutes.adminDashboard ||
        location == AppRoutes.adminSessions ||
        location == AppRoutes.adminWalkIn ||
        location == AppRoutes.adminBookings ||
        location == AppRoutes.adminAnalytics ||
        location == AppRoutes.adminManagement ||
        location == AppRoutes.adminSystemsMgmt;
  }

  GzAdminTab _selectedTab(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/admin/analytics')) return GzAdminTab.sessions;
    if (location.startsWith('/admin/sessions') ||
        location.startsWith('/admin/walk-in') ||
        location.startsWith('/admin/bookings')) {
      return GzAdminTab.sessions;
    }
    if (location.startsWith('/admin/management') ||
        location.startsWith('/admin/pricing') ||
        location.startsWith('/admin/billing') ||
        location.startsWith('/admin/campaigns') ||
        location.startsWith('/admin/credits') ||
        location.startsWith('/admin/disputes')) {
      return GzAdminTab.management;
    }
    if (location.startsWith('/admin/systems') ||
        location.startsWith('/admin/staff') ||
        location.startsWith('/admin/config') ||
        location.startsWith('/admin/notifications')) {
      return GzAdminTab.store;
    }
    return GzAdminTab.dashboard;
  }

  void _onTap(BuildContext context, GzAdminTab tab) {
    switch (tab) {
      case GzAdminTab.dashboard:
        context.go(AppRoutes.adminDashboard);
        return;
      case GzAdminTab.sessions:
        context.go(AppRoutes.adminSessions);
        return;
      case GzAdminTab.management:
        context.go(AppRoutes.adminManagement);
        return;
      case GzAdminTab.store:
        context.go(AppRoutes.adminSystemsMgmt);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPop,
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: _showsBottomNav(context)
            ? GzAdminBottomNav(
                currentTab: _selectedTab(context),
                onTap: (tab) => _onTap(context, tab),
              )
            : null,
      ),
    );
  }
}
