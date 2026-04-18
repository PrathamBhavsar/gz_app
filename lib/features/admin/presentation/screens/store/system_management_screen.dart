import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_store_provider.dart';
import '../../providers/admin_auth_provider.dart';

/// System Management — Screen 57.
/// Inventory management: system types tab + systems list, add system modal.
class SystemManagementScreen extends ConsumerStatefulWidget {
  const SystemManagementScreen({super.key});

  @override
  ConsumerState<SystemManagementScreen> createState() =>
      _SystemManagementScreenState();
}

class _SystemManagementScreenState
    extends ConsumerState<SystemManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _platformFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canEdit =
        ref.watch(adminRoleProvider) == 'super_admin' ||
        ref.watch(adminRoleProvider) == 'admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminSystemsMgmt),
        ),
        title: Text('Systems', style: AppTypography.headingSmall),
        actions: [
          if (canEdit)
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedAdd01,
                color: AppColors.textPrimary,
              ),
              onPressed: () => _showAddSystemSheet(context),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.rose,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.bodyMedium,
          tabs: const [
            Tab(text: 'Systems'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSystemsTab(canEdit),
          _buildCategoriesTab(canEdit),
        ],
      ),
    );
  }

  // ─── Systems Tab ─────────────────────────────────────────────────────

  Widget _buildSystemsTab(bool canEdit) {
    final state = ref.watch(systemsProvider);

    return RefreshIndicator(
      color: AppColors.rose,
      backgroundColor: AppColors.surface,
      onRefresh: () => ref.read(systemsProvider.notifier).load(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // Platform filter chips
            _buildPlatformFilters(),
            const SizedBox(height: AppSpacing.lg),
            _buildSystemsList(state),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformFilters() {
    final platforms = [null, 'pc', 'ps5', 'console', 'vr'];
    final labels = ['All', 'PC', 'PS5', 'Console', 'VR'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(platforms.length, (i) {
          final isActive = _platformFilter == platforms[i];
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => setState(() => _platformFilter = platforms[i]),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.rose : AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                ),
                child: Text(
                  labels[i],
                  style: AppTypography.bodySmall.copyWith(
                    color: isActive
                        ? AppColors.background
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSystemsList(ManagementState<List<dynamic>> state) {
    if (state is ManagementLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }
    if (state is ManagementError) {
      return _buildError(state.error, () => ref.read(systemsProvider.notifier).load());
    }
    if (state is ManagementLoaded) {
      var systems = state.data;
      if (_platformFilter != null) {
        systems = systems
            .where((s) =>
                (s as Map<String, dynamic>)['platform']?.toString().toLowerCase() ==
                _platformFilter)
            .toList();
      }
      if (systems.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text('No systems found',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ),
        );
      }
      return Column(
        children: systems
            .map((s) => _buildSystemCard(s as Map<String, dynamic>))
            .toList(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSystemCard(Map<String, dynamic> system) {
    final name = system['name']?.toString() ?? 'Unknown';
    final station = system['station_number']?.toString() ?? '--';
    final platform = system['platform']?.toString() ?? '--';
    final status = system['status']?.toString() ?? 'unknown';
    final isActive = system['is_active'] as bool? ?? true;

    final statusColor = switch (status.toLowerCase()) {
      'available' => const Color(0xFF4CAF50),
      'in_use' => const Color(0xFF2196F3),
      'maintenance' => AppColors.gold,
      'offline' => AppColors.error,
      _ => AppColors.textSecondary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Station $station · ${platform.toUpperCase()}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          if (!isActive)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
              child: Text('INACTIVE',
                  style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
              child: Text(
                status.toUpperCase(),
                style: AppTypography.bodySmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Categories Tab ──────────────────────────────────────────────────

  Widget _buildCategoriesTab(bool canEdit) {
    final state = ref.watch(systemTypesProvider);

    return RefreshIndicator(
      color: AppColors.rose,
      backgroundColor: AppColors.surface,
      onRefresh: () => ref.read(systemTypesProvider.notifier).load(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            if (state is ManagementLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: CircularProgressIndicator(color: AppColors.rose),
                ),
              )
            else if (state is ManagementError)
              _buildError(state.error,
                  () => ref.read(systemTypesProvider.notifier).load())
            else if (state is ManagementLoaded)
              ...state.data.map((t) =>
                  _buildTypeCard(t as Map<String, dynamic>)),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(Map<String, dynamic> type) {
    final name = type['name']?.toString() ?? 'Unnamed';
    final rate = type['hourly_base_rate']?.toString() ?? '0';
    final isActive = type['is_active'] as bool? ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text('Base rate: ₹$rate/hr',
                    style: AppTypography.caption),
              ],
            ),
          ),
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            color: isActive ? const Color(0xFF4CAF50) : AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  // ─── Shared ──────────────────────────────────────────────────────────

  Widget _buildError(Object error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onRetry,
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

  void _showAddSystemSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final stationCtrl = TextEditingController();
    String platform = 'pc';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add System', style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: nameCtrl,
                style: AppTypography.bodyMedium,
                decoration: _inputDecor('System Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: stationCtrl,
                style: AppTypography.bodyMedium,
                keyboardType: TextInputType.number,
                decoration: _inputDecor('Station Number'),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Platform', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                children: ['pc', 'ps5', 'console', 'vr'].map((p) {
                  final isActive = platform == p;
                  return GestureDetector(
                    onTap: () => setSheetState(() => platform = p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.rose : AppColors.background,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusSm),
                        border: Border.all(
                            color: isActive ? AppColors.rose : AppColors.border),
                      ),
                      child: Text(
                        p.toUpperCase(),
                        style: AppTypography.bodySmall.copyWith(
                          color: isActive
                              ? AppColors.background
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.trim().isEmpty) return;
                    Navigator.pop(ctx);
                    final storeId = ref.read(adminStoreIdProvider);
                    if (storeId == null) return;
                    await ref.read(adminStoreServiceProvider).createSystem(
                          storeId: storeId,
                          body: {
                            'name': nameCtrl.text.trim(),
                            'station_number':
                                int.tryParse(stationCtrl.text) ?? 1,
                            'platform': platform,
                          },
                        );
                    ref.read(systemsProvider.notifier).load();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rose,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadius),
                    ),
                  ),
                  child: Text('Add System', style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecor(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.caption,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
