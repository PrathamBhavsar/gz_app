import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/network/admin_live_service.dart';
import '../../providers/admin_auth_provider.dart';
import '../../providers/admin_auth_state.dart';
import '../../providers/admin_operations_provider.dart';
import '../../providers/admin_live_provider.dart';
import '../../../../../../models/domain_admin.dart';

final _dashboardFilterProvider =
    StateProvider.autoDispose<String>((ref) => 'All');

Color _systemStatusColor(String? status) => switch (status) {
      'available' => AppColors.ok,
      'in_use' => AppColors.info,
      'maintenance' => AppColors.warn,
      'offline' => AppColors.error,
      _ => AppColors.textSecondary,
    };

String _formatSessionDuration(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}

/// Admin Dashboard / Floor Map — Screen 42.
/// Real-time visualization of the gaming floor with system availability.
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  StreamSubscription<WsEvent>? _wsSubscription;

  static const _filterOptions = ['All', 'PC', 'Console', 'VR', 'Maintenance'];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(floorMapProvider.notifier).loadSystems(),
    );
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    super.dispose();
  }

  void _listenToWsEvents() {
    _wsSubscription?.cancel();
    _wsSubscription =
        ref.read(adminLiveServiceProvider).events.listen((event) {
      if (!mounted) return;
      switch (event.type) {
        case WsEventType.systemStatusChange:
        case WsEventType.sessionStarted:
        case WsEventType.sessionEnded:
        case WsEventType.agentHeartbeat:
          ref.read(floorMapProvider.notifier).loadSystems();
        case WsEventType.bookingNew:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New booking received'),
              backgroundColor: AppColors.surface,
              duration: Duration(seconds: 2),
            ),
          );
        case WsEventType.unknown:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminAuthNotifierProvider);
    final role = adminState is AdminAuthAuthenticated
        ? adminState.admin.role ?? ''
        : '';
    final floorState = ref.watch(floorMapProvider);
    final selectedFilter = ref.watch(_dashboardFilterProvider);

    final wsConnection = ref.watch(liveConnectionProvider);
    final isWsConnected = wsConnection.valueOrNull ?? false;

    _listenToWsEvents();
    ref.watch(wsAutoConnectProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gaming Zone', style: AppTypography.headingSmall),
            Row(
              children: [
                Text(
                  'Operations · ${_formatRole(role)}',
                  style: AppTypography.caption,
                ),
                const SizedBox(width: AppSpacing.sm),
                _LivePill(isConnected: isWsConnected),
              ],
            ),
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
      body: RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () => ref.read(floorMapProvider.notifier).loadSystems(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _KpiRibbon(floorState: floorState),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            SliverToBoxAdapter(
              child: _FilterChips(
                filterOptions: _filterOptions,
                selectedFilter: selectedFilter,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            _FloorGrid(
              floorState: floorState,
              selectedFilter: selectedFilter,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.adminWalkIn),
        backgroundColor: AppColors.rose,
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          color: AppColors.background,
          size: 24,
        ),
      ),
    );
  }

  String _formatRole(String role) => switch (role) {
        'super_admin' => 'Super Admin',
        'admin' => 'Admin',
        'staff' => 'Staff',
        _ => role,
      };
}

// ─── Live Pill ────────────────────────────────────────────────────────────────

class _LivePill extends StatelessWidget {
  const _LivePill({required this.isConnected});
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final color = isConnected ? AppColors.success : AppColors.error;
    final label = isConnected ? 'Live' : 'Offline';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── KPI Ribbon ───────────────────────────────────────────────────────────────

class _KpiRibbon extends StatelessWidget {
  const _KpiRibbon({required this.floorState});
  final FloorMapState floorState;

  @override
  Widget build(BuildContext context) {
    int totalSystems = 0;
    int inUseSystems = 0;
    int activeSessions = 0;

    if (floorState is FloorMapLoaded) {
      final loaded = floorState as FloorMapLoaded;
      totalSystems = loaded.systems.length;
      inUseSystems =
          loaded.systems.where((s) => s.status == 'in_use').length;
      activeSessions =
          loaded.systems.where((s) => s.currentSession != null).length;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _DashKpiCard(
            label: 'Occupancy',
            value: totalSystems > 0 ? '$inUseSystems/$totalSystems' : '--',
            icon: HugeIcons.strokeRoundedDashboardSpeed01,
            iconColor: AppColors.rose,
          ),
          const SizedBox(width: AppSpacing.sm),
          _DashKpiCard(
            label: 'Sessions',
            value: '$activeSessions',
            icon: HugeIcons.strokeRoundedTimer01,
            iconColor: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.sm),
          _DashKpiCard(
            label: 'Available',
            value: '${totalSystems - inUseSystems}',
            icon: HugeIcons.strokeRoundedGameboy,
            iconColor: AppColors.ok,
          ),
        ],
      ),
    );
  }
}

class _DashKpiCard extends StatelessWidget {
  const _DashKpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });
  final String label;
  final String value;
  final List<List<dynamic>> icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
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
            HugeIcon(icon: icon, color: iconColor, size: 18),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: AppTypography.headingSmall),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}

// ─── Filter Chips ─────────────────────────────────────────────────────────────

class _FilterChips extends ConsumerWidget {
  const _FilterChips({
    required this.filterOptions,
    required this.selectedFilter,
  });
  final List<String> filterOptions;
  final String selectedFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: filterOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final isSelected = filter == selectedFilter;
          return GestureDetector(
            onTap: () => ref
                .read(_dashboardFilterProvider.notifier)
                .state = filter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.rose : AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
                border: Border.all(
                  color: isSelected ? AppColors.rose : AppColors.border,
                ),
              ),
              child: Text(
                filter,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected
                      ? AppColors.background
                      : AppColors.textSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Floor Grid ───────────────────────────────────────────────────────────────

class _FloorGrid extends ConsumerWidget {
  const _FloorGrid({
    required this.floorState,
    required this.selectedFilter,
  });
  final FloorMapState floorState;
  final String selectedFilter;

  List<LiveSystemStatusModel> _filterSystems(
    List<LiveSystemStatusModel> systems,
    String filter,
  ) {
    if (filter == 'All') return systems;
    if (filter == 'Maintenance') {
      return systems.where((s) => s.status == 'maintenance').toList();
    }
    return systems
        .where(
            (s) => s.platform?.toLowerCase() == filter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (floorState is FloorMapLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.rose)),
      );
    }

    if (floorState is FloorMapError) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedAlert01,
                color: AppColors.error,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Failed to load floor data',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () =>
                    ref.read(floorMapProvider.notifier).loadSystems(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                  ),
                ),
                child: Text('Retry', style: AppTypography.button),
              ),
            ],
          ),
        ),
      );
    }

    if (floorState is FloorMapLoaded) {
      final filtered = _filterSystems(
        (floorState as FloorMapLoaded).systems,
        selectedFilter,
      );

      if (filtered.isEmpty) {
        return SliverFillRemaining(
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
                  'No systems found',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.75,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => _SystemTile(system: filtered[index]),
            childCount: filtered.length,
          ),
        ),
      );
    }

    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator(color: AppColors.rose)),
    );
  }
}

// ─── System Tile ──────────────────────────────────────────────────────────────

class _SystemTile extends StatelessWidget {
  const _SystemTile({required this.system});
  final LiveSystemStatusModel system;

  @override
  Widget build(BuildContext context) {
    final statusColor = _systemStatusColor(system.status);
    final isAvailable = system.status == 'available';
    final isInUse = system.status == 'in_use';
    final isMaintenance = system.status == 'maintenance';
    final isOffline = system.status == 'offline';

    String? elapsed;
    bool endingSoon = false;
    if (isInUse &&
        system.currentSession?.startedAt != null &&
        system.currentSession?.durationMinutes != null) {
      final elapsedDuration =
          DateTime.now().difference(system.currentSession!.startedAt!);
      elapsed = _formatSessionDuration(elapsedDuration);
      final remaining = (system.currentSession!.durationMinutes! * 60) -
          elapsedDuration.inSeconds;
      endingSoon = remaining < 600 && remaining > 0;
    }

    return GestureDetector(
      onTap: () => context.go(
        '${AppRoutes.adminSessions}?systemId=${system.systemId}',
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.6),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    system.name ?? 'Unknown',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isMaintenance || isOffline
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              system.systemTypeName ?? system.platform ?? '',
              style:
                  AppTypography.caption.copyWith(color: AppColors.textSecondary),
            ),
            const Spacer(),
            if (isAvailable)
              Text(
                'Available',
                style: AppTypography.bodySmall.copyWith(color: AppColors.ok),
              ),
            if (isInUse && system.currentSession != null) ...[
              Text(
                system.currentSession?.userName ?? 'Player',
                style:
                    AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
              if (elapsed != null)
                Text(
                  elapsed,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
              if (endingSoon)
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.xs),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.rose.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusSm),
                  ),
                  child: Text(
                    'Ending soon',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.rose,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
            if (isMaintenance)
              Row(
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedWrench01,
                    color: AppColors.textSecondary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Maintenance',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            if (isOffline)
              Text(
                'Offline',
                style:
                    AppTypography.caption.copyWith(color: AppColors.error),
              ),
          ],
        ),
      ),
    );
  }
}
