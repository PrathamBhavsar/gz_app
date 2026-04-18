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

/// Admin Dashboard / Floor Map — Screen 42.
/// Real-time visualization of the gaming floor with system availability.
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  String _selectedFilter = 'All';
  StreamSubscription<WsEvent>? _wsSubscription;
  bool _isWsConnected = false;

  static const _filterOptions = ['All', 'PC', 'Console', 'VR', 'Maintenance'];

  @override
  void initState() {
    super.initState();
    // Trigger initial load
    Future.microtask(
      () => ref.read(floorMapProvider.notifier).loadSystems(),
    );
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    super.dispose();
  }

  /// Listen to WebSocket events and refresh floor data on relevant events.
  void _listenToWsEvents() {
    _wsSubscription?.cancel();
    _wsSubscription = ref.read(adminLiveServiceProvider).events.listen((event) {
      if (!mounted) return;
      switch (event.type) {
        case WsEventType.systemStatusChange:
        case WsEventType.sessionStarted:
        case WsEventType.sessionEnded:
        case WsEventType.agentHeartbeat:
          // Refresh the floor map with latest data from server
          ref.read(floorMapProvider.notifier).loadSystems();
        case WsEventType.bookingNew:
          // Could show a toast notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New booking received'),
              backgroundColor: AppColors.surface,
              duration: const Duration(seconds: 2),
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
    final adminName = adminState is AdminAuthAuthenticated
        ? adminState.admin.name ?? 'Admin'
        : 'Admin';
    final role = adminState is AdminAuthAuthenticated
        ? adminState.admin.role ?? ''
        : '';
    final floorState = ref.watch(floorMapProvider);

    // Watch WS connection state
    final wsConnection = ref.watch(liveConnectionProvider);
    _isWsConnected = wsConnection.valueOrNull ?? false;

    // Subscribe to live events
    _listenToWsEvents();

    // Ensure WS is connected when this screen is active
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
                _buildLivePill(),
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
        onRefresh: () =>
            ref.read(floorMapProvider.notifier).loadSystems(),
        child: CustomScrollView(
          slivers: [
            // KPI Ribbon
            SliverToBoxAdapter(child: _buildKpiRibbon(floorState)),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.md),
            ),
            // Filter Chips
            SliverToBoxAdapter(child: _buildFilterChips()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.md),
            ),
            // Floor Map Grid
            _buildFloorGrid(floorState),
            // Bottom padding for FAB
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xxl),
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

  // ─── Live Pill ──────────────────────────────────────────────────────

  Widget _buildLivePill() {
    final color = _isWsConnected ? AppColors.success : AppColors.error;
    final label = _isWsConnected ? 'Live' : 'Offline';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
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

  // ─── KPI Ribbon ─────────────────────────────────────────────────────

  Widget _buildKpiRibbon(FloorMapState state) {
    int totalSystems = 0;
    int inUseSystems = 0;
    int activeSessions = 0;

    if (state is FloorMapLoaded) {
      totalSystems = state.systems.length;
      inUseSystems = state.systems
          .where((s) => s.status == 'in_use')
          .length;
      activeSessions = state.systems
          .where((s) => s.currentSession != null)
          .length;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildKpiCard(
            'Occupancy',
            totalSystems > 0 ? '$inUseSystems/$totalSystems' : '--',
            HugeIcons.strokeRoundedDashboard,
            AppColors.rose,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildKpiCard(
            'Sessions',
            '$activeSessions',
            HugeIcons.strokeRoundedTimer01,
            AppColors.success,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildKpiCard(
            'Available',
            '${totalSystems - inUseSystems}',
            HugeIcons.strokeRoundedGameboy,
            const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
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

  // ─── Filter Chips ───────────────────────────────────────────────────

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _filterOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = filter == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.rose : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                border: Border.all(
                  color: isSelected ? AppColors.rose : AppColors.border,
                ),
              ),
              child: Text(
                filter,
                style: AppTypography.bodySmall.copyWith(
                  color:
                      isSelected ? AppColors.background : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Floor Grid ─────────────────────────────────────────────────────

  Widget _buildFloorGrid(FloorMapState state) {
    if (state is FloorMapLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }

    if (state is FloorMapError) {
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
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
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

    if (state is FloorMapLoaded) {
      final filtered = _filterSystems(state.systems);
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
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.75,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildSystemTile(filtered[index]),
            childCount: filtered.length,
          ),
        ),
      );
    }

    // Initial state
    return const SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(color: AppColors.rose),
      ),
    );
  }

  List<LiveSystemStatusModel> _filterSystems(
    List<LiveSystemStatusModel> systems,
  ) {
    if (_selectedFilter == 'All') return systems;
    if (_selectedFilter == 'Maintenance') {
      return systems
          .where((s) => s.status == 'maintenance')
          .toList();
    }
    return systems
        .where((s) => s.platform?.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  // ─── System Tile ────────────────────────────────────────────────────

  Widget _buildSystemTile(LiveSystemStatusModel system) {
    final statusColor = _getStatusColor(system.status);
    final isAvailable = system.status == 'available';
    final isInUse = system.status == 'in_use';
    final isMaintenance = system.status == 'maintenance';
    final isOffline = system.status == 'offline';

    // Calculate elapsed time for in-use sessions
    String? elapsed;
    bool endingSoon = false;
    if (isInUse && system.currentSession?.startedAt != null && system.currentSession?.durationMinutes != null) {
      final elapsedDuration = DateTime.now().difference(system.currentSession!.startedAt!);
      elapsed = _formatDuration(elapsedDuration);
      final remaining = (system.currentSession!.durationMinutes! * 60) -
          elapsedDuration.inSeconds;
      endingSoon = remaining < 600 && remaining > 0; // < 10 min
    }

    return GestureDetector(
      onTap: () {
        // Navigate to session management with systemId
        context.go(
          '${AppRoutes.adminSessions}?systemId=${system.systemId}',
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          border: Border.all(
            color: statusColor.withOpacity(0.6),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: name + status dot
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
            // Type badge
            Text(
              system.systemTypeName ?? system.platform ?? '',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            // Status-specific content
            if (isAvailable)
              Text(
                'Available',
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xFF4CAF50),
                ),
              ),
            if (isInUse && system.currentSession != null) ...[
              Text(
                system.currentSession?.userName ?? 'Player',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (elapsed != null)
                Text(
                  elapsed,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              if (endingSoon)
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.xs),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.rose.withOpacity(0.15),
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
                    icon: HugeIcons.strokeRoundedWrench,
                    color: AppColors.textSecondary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Maintenance',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            if (isOffline)
              Text(
                'Offline',
                style: AppTypography.caption.copyWith(
                  color: AppColors.error,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    return switch (status) {
      'available' => const Color(0xFF4CAF50),
      'in_use' => const Color(0xFF2196F3),
      'maintenance' => const Color(0xFFFFC107),
      'offline' => AppColors.error,
      _ => AppColors.textSecondary,
    };
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatRole(String role) {
    return switch (role) {
      'super_admin' => 'Super Admin',
      'admin' => 'Admin',
      'staff' => 'Staff',
      _ => role,
    };
  }
}
