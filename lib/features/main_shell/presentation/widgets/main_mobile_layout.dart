import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/navigation/routes.dart';

class MainMobileLayout extends StatelessWidget {
  final Widget child;
  const MainMobileLayout({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith('/book')) return 1;
    if (location.startsWith('/sessions')) return 2;
    if (location.startsWith('/wallet')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go('/book');
        break;
      case 2:
        context.go('/sessions');
        break;
      case 3:
        context.go('/wallet');
        break;
      case 4:
        context.go('/profile');
        break;
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
            icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01, color: AppColors.textSecondary),
            activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedHome01, color: AppColors.primary),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: AppColors.textSecondary),
            activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: AppColors.primary),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedGameboy, color: AppColors.textSecondary),
            activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedGameboy, color: AppColors.primary),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedWallet01, color: AppColors.textSecondary),
            activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedWallet01, color: AppColors.primary),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedUser, color: AppColors.textSecondary),
            activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
