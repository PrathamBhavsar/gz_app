import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/network/admin_live_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_admin.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../auth/application/admin_auth_notifier.dart';
import '../../../application/admin_dashboard_notifier.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  static const _filters = ['All', 'PC', 'Console', 'VR', 'Maintenance'];
  String _activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    ref.listen(adminLiveEventsProvider, (_, next) {
      next.whenData((_) {
        ref.read(adminDashboardNotifierProvider.notifier).refresh();
      });
    });

    final dashboard = ref.watch(adminDashboardNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Gaming Zone',
        subtitle: 'Operations · Admin',
        disableBack: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _LivePill(),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: _logout,
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedLogout01,
                color: AppColors.textTertiary,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.adminWalkIn),
        backgroundColor: AppColors.rose,
        shape: const CircleBorder(),
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          color: AppColors.surface,
          size: 24,
        ),
      ),
      body: dashboard.when(
        loading: () => const GzLoadingView(message: 'Loading floor status'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminDashboardNotifierProvider.notifier).refresh(),
        ),
        data: (data) {
          if (data.liveSystems.isEmpty) {
            return const PageErrorDisplay(error: AppPageError.empty);
          }
          final visibleSystems = _filteredSystems(data.liveSystems);
          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 104),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _KpiCard(
                          icon: HugeIcons.strokeRoundedDashboardSpeed01,
                          accent: AppColors.rose,
                          value: _occupancyLabel(data.liveSystems),
                          label: 'Occupancy',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _KpiCard(
                          icon: HugeIcons.strokeRoundedTimer01,
                          accent: AppColors.ok,
                          value: '${data.dashboard.totalSessions ?? 0}',
                          label: 'Sessions',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _KpiCard(
                          icon: HugeIcons.strokeRoundedGameboy,
                          accent: AppColors.textTertiary,
                          value: '${_availableCount(data.liveSystems)}',
                          label: 'Available',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SummaryRow(
                    revenue: _currencyLabel(data.dashboard.totalRevenue),
                    players: '${data.dashboard.uniquePlayers ?? 0} players',
                    refreshedAt: _formatClock(data.loadedAt),
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters
                          .map(
                            (filter) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GzChip(
                                label: filter,
                                active: _activeFilter == filter,
                                onTap: () =>
                                    setState(() => _activeFilter = filter),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleSystems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 130,
                        ),
                    itemBuilder: (context, index) {
                      final system = visibleSystems[index];
                      return _SystemTile(
                        data: system,
                        onTap: system.systemId == null
                            ? null
                            : () => context.push(
                                AppRoutes.adminSystemSessionsPath(
                                  system.systemId!,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<LiveSystemStatusModel> _filteredSystems(
    List<LiveSystemStatusModel> systems,
  ) {
    switch (_activeFilter) {
      case 'PC':
        return systems
            .where((item) => (item.platform ?? '').toLowerCase() == 'pc')
            .toList();
      case 'Console':
        return systems.where((item) {
          final platform = (item.platform ?? '').toLowerCase();
          return platform.contains('ps') ||
              platform.contains('xbox') ||
              platform.contains('console');
        }).toList();
      case 'VR':
        return systems
            .where((item) => (item.platform ?? '').toLowerCase() == 'vr')
            .toList();
      case 'Maintenance':
        return systems.where((item) => item.status == 'maintenance').toList();
      default:
        return systems;
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Sign out', style: AppTypography.h2),
        content: const Text(
          'Sign out of admin portal?',
          style: AppTypography.bodyR,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(adminAuthNotifierProvider.notifier).logout();
    }
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.revenue,
    required this.players,
    required this.refreshedAt,
  });

  final String revenue;
  final String players;
  final String refreshedAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Revenue $revenue',
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Text(
          players,
          style: AppTypography.small.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Text(
          refreshedAt,
          style: AppTypography.small.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

class _LivePill extends StatelessWidget {
  const _LivePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.okBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: AppColors.ok),
          SizedBox(width: 4),
          Text(
            'Live',
            style: TextStyle(
              fontFamily: 'Geist',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.ok,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.accent,
    required this.value,
    required this.label,
  });

  final dynamic icon;
  final Color accent;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(icon: icon, color: accent, size: 18),
          const SizedBox(height: 12),
          Text(value, style: AppTypography.h2),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.small),
        ],
      ),
    );
  }
}

class _SystemTile extends StatelessWidget {
  const _SystemTile({required this.data, required this.onTap});

  final LiveSystemStatusModel data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final current = data.currentSession;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.name ?? 'System',
                    style: AppTypography.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GzTag(
                  kind: _statusKind(data.status),
                  label: _statusLabel(data.status),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              data.platform?.toUpperCase() ?? data.systemTypeName ?? 'System',
              style: AppTypography.small,
            ),
            const Spacer(),
            if (current != null) ...[
              Text(
                current.userName ?? current.userId ?? 'Current player',
                style: AppTypography.small.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                _sessionAge(current.startedAt),
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ] else
              Text(
                'Tap for session control',
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _occupancyLabel(List<LiveSystemStatusModel> systems) {
  final inUse = systems.where((item) => item.status == 'in_use').length;
  return '$inUse/${systems.length}';
}

int _availableCount(List<LiveSystemStatusModel> systems) {
  return systems.where((item) => item.status == 'available').length;
}

String _currencyLabel(String? value) {
  if (value == null || value.isEmpty) {
    return '₹0';
  }
  return value.startsWith('₹') ? value : '₹$value';
}

String _formatClock(DateTime value) {
  final hour = value.hour > 12
      ? value.hour - 12
      : (value.hour == 0 ? 12 : value.hour);
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

String _sessionAge(DateTime? startedAt) {
  if (startedAt == null) {
    return 'Live now';
  }
  final diff = DateTime.now().difference(startedAt);
  final hours = diff.inHours;
  final minutes = diff.inMinutes.remainder(60);
  if (hours > 0) {
    return '${hours}h ${minutes}m live';
  }
  return '${minutes}m live';
}

GzTagKind _statusKind(String? status) {
  switch (status) {
    case 'in_use':
      return GzTagKind.ok;
    case 'maintenance':
      return GzTagKind.warn;
    case 'offline':
      return GzTagKind.err;
    default:
      return GzTagKind.mute;
  }
}

String _statusLabel(String? status) {
  switch (status) {
    case 'in_use':
      return 'In use';
    case 'maintenance':
      return 'Maintenance';
    case 'offline':
      return 'Offline';
    default:
      return 'Available';
  }
}
