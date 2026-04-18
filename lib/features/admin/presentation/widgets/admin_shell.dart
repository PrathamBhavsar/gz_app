import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/routes.dart';

class AdminMobileLayout extends StatelessWidget {
  final Widget child;
  const AdminMobileLayout({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/admin/analytics')) return 1;
    if (location.startsWith('/admin/pricing') ||
        location.startsWith('/admin/billing') ||
        location.startsWith('/admin/campaigns') ||
        location.startsWith('/admin/credits') ||
        location.startsWith('/admin/disputes')) {
      return 2;
    }
    if (location.startsWith('/admin/systems') ||
        location.startsWith('/admin/staff') ||
        location.startsWith('/admin/config') ||
        location.startsWith('/admin/notifications')) {
      return 3;
    }
    // Default: Operations tab (dashboard, sessions, walk-in, bookings)
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.adminDashboard);
      case 1:
        context.go(AppRoutes.adminAnalytics);
      case 2:
        context.go(AppRoutes.adminPricing);
      case 3:
        context.go(AppRoutes.adminSystemsMgmt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onTap(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome01,
              color: AppColors.textSecondary,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome01,
              color: AppColors.primary,
            ),
            label: 'Operations',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedGameboy,
              color: AppColors.textSecondary,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedGameboy,
              color: AppColors.primary,
            ),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedWallet01,
              color: AppColors.textSecondary,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedWallet01,
              color: AppColors.primary,
            ),
            label: 'Management',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: AppColors.textSecondary,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: AppColors.primary,
            ),
            label: 'Store',
          ),
        ],
      ),
    );
  }
}
