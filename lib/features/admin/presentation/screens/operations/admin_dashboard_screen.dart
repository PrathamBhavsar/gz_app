import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_auth_provider.dart';
import '../../providers/admin_auth_state.dart';

/// Admin Dashboard — Screen 42.
/// Placeholder screen. Full implementation in Phase 4.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminAuthNotifierProvider);
    final adminName = adminState is AdminAuthAuthenticated
        ? adminState.admin.name ?? 'Admin'
        : 'Admin';
    final role = adminState is AdminAuthAuthenticated
        ? adminState.admin.role ?? ''
        : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gaming Zone', style: AppTypography.headingSmall),
            Text('Operations • $role', style: AppTypography.caption),
          ],
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedLogout01,
              color: AppColors.textSecondary,
            ),
            onPressed: () async {
              await ref.read(adminAuthNotifierProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.authLanding);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text('Welcome, $adminName', style: AppTypography.headingMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Live floor view will appear here.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // KPI placeholder cards
            Row(
              children: [
                _buildKpiCard('Occupancy', '--', Icons.monitor_heart_outlined),
                const SizedBox(width: AppSpacing.sm),
                _buildKpiCard('Sessions', '--', Icons.timer_outlined),
                const SizedBox(width: AppSpacing.sm),
                _buildKpiCard('Revenue', '--', Icons.currency_rupee),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // Floor map placeholder
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedGameboy,
                      color: AppColors.textSecondary,
                      size: 64,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Floor Map',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.adminWalkIn),
        backgroundColor: AppColors.rose,
        child: const Icon(Icons.add, color: AppColors.background),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 18),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: AppTypography.headingSmall),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}
