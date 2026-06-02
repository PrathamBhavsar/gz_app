import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/gz_admin_bottom_nav.dart';

class AdminMobileLayout extends StatelessWidget {
  final Widget child;
  const AdminMobileLayout({super.key, required this.child});

  GzAdminTab _selectedTab(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/admin/analytics')) return GzAdminTab.sessions;
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
      case GzAdminTab.sessions:
        context.go(AppRoutes.adminAnalytics);
      case GzAdminTab.management:
        context.go(AppRoutes.adminManagement);
      case GzAdminTab.store:
        context.go(AppRoutes.adminSystemsMgmt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: GzAdminBottomNav(
        currentTab: _selectedTab(context),
        onTap: (tab) => _onTap(context, tab),
      ),
    );
  }
}
