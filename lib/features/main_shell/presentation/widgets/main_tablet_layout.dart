import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/navigation/routes.dart';

class MainTabletLayout extends StatelessWidget {
  final Widget child;
  const MainTabletLayout({super.key, required this.child});

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
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _calculateSelectedIndex(context),
          onDestinationSelected: (index) => _onTap(context, index),
          backgroundColor: AppColors.surface,
          selectedIconTheme: const IconThemeData(color: AppColors.primary),
          unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary),
          labelType: NavigationRailLabelType.all,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Icon(Icons.gamepad, color: AppColors.rose, size: 32),
          ),
          destinations: const [
            NavigationRailDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01, color: AppColors.textSecondary),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedHome01, color: AppColors.primary),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: AppColors.textSecondary),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: AppColors.primary),
              label: Text('Book'),
            ),
            NavigationRailDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedGameboy, color: AppColors.textSecondary),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedGameboy, color: AppColors.primary),
              label: Text('Sessions'),
            ),
            NavigationRailDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedWallet01, color: AppColors.textSecondary),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedWallet01, color: AppColors.primary),
              label: Text('Wallet'),
            ),
            NavigationRailDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedUser, color: AppColors.textSecondary),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser, color: AppColors.primary),
              label: Text('Profile'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1, color: AppColors.border),
        Expanded(child: child),
      ],
    );
  }
}
