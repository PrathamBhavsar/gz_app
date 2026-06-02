import 'package:flutter/material.dart';
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
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: GzAdminBottomNav(
        currentTab: _selectedTab(context),
        onTap: (tab) => _onTap(context, tab),
      ),
    );
  }
}
