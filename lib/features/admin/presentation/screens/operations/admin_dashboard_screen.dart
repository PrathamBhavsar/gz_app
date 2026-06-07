import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/auth/token_storage.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_live_dot.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  static const _filters = ['All', 'PC', 'Console', 'VR', 'Maintenance'];

  static const _systems = [
    _SystemTileData(
      name: 'PC Station 01',
      type: 'PC',
      status: _SystemStatus.available,
    ),
    _SystemTileData(
      name: 'PC Station 02',
      type: 'PC',
      status: _SystemStatus.inUse,
      user: 'Rahul M.',
      time: '1h 22m',
      endingSoon: true,
    ),
    _SystemTileData(
      name: 'PC Station 03',
      type: 'PC',
      status: _SystemStatus.inUse,
      user: 'Priya S.',
      time: '0h 45m',
    ),
    _SystemTileData(
      name: 'PC Station 04',
      type: 'PC',
      status: _SystemStatus.inUse,
      user: 'Amit K.',
      time: '2h 10m',
    ),
    _SystemTileData(
      name: 'PS5 Console 01',
      type: 'Console',
      status: _SystemStatus.available,
    ),
    _SystemTileData(
      name: 'PS5 Console 02',
      type: 'Console',
      status: _SystemStatus.inUse,
      user: 'Neha R.',
      time: '1h 05m',
    ),
    _SystemTileData(
      name: 'Xbox 01',
      type: 'Xbox',
      status: _SystemStatus.offline,
    ),
    _SystemTileData(
      name: 'Xbox Station 02',
      type: 'Console',
      status: _SystemStatus.maintenance,
    ),
    _SystemTileData(
      name: 'VR Pod 01',
      type: 'VR',
      status: _SystemStatus.available,
    ),
    _SystemTileData(
      name: 'VR Pod 02',
      type: 'VR',
      status: _SystemStatus.maintenance,
    ),
    _SystemTileData(
      name: 'PC Station 05',
      type: 'PC',
      status: _SystemStatus.available,
    ),
    _SystemTileData(
      name: 'PC Station 06',
      type: 'PC',
      status: _SystemStatus.inUse,
      user: 'Kiran P.',
      time: '1h 50m',
    ),
  ];

  String _activeFilter = 'All';

  List<_SystemTileData> get _visibleSystems {
    switch (_activeFilter) {
      case 'PC':
        return _systems.where((tile) => tile.type == 'PC').toList();
      case 'Console':
        return _systems
            .where((tile) => tile.type == 'Console' || tile.type == 'Xbox')
            .toList();
      case 'VR':
        return _systems.where((tile) => tile.type == 'VR').toList();
      case 'Maintenance':
        return _systems
            .where((tile) => tile.status == _SystemStatus.maintenance)
            .toList();
      default:
        return _systems;
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Sign out', style: AppTypography.h2),
        content: Text('Sign out of admin portal?', style: AppTypography.bodyR),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Sign out', style: AppTypography.body.copyWith(color: AppColors.err)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(tokenStorageProvider).clearAll();
    if (mounted) context.go(AppRoutes.adminLogin);
  }

  @override
  Widget build(BuildContext context) {
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
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.adminWalkIn),
        backgroundColor: AppColors.rose,
        shape: const CircleBorder(),
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          color: AppColors.surface,
          size: 24,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 104),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      icon: HugeIcons.strokeRoundedDashboardSpeed01,
                      accent: AppColors.rose,
                      value: '8/12',
                      label: 'Occupancy',
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _KpiCard(
                      icon: HugeIcons.strokeRoundedTimer01,
                      accent: AppColors.ok,
                      value: '8',
                      label: 'Sessions',
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _KpiCard(
                      icon: HugeIcons.strokeRoundedGameboy,
                      accent: AppColors.textTertiary,
                      value: '4',
                      label: 'Available',
                    ),
                  ),
                ],
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
                            onTap: () => setState(() => _activeFilter = filter),
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
                itemCount: _visibleSystems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 122,
                ),
                itemBuilder: (context, index) {
                  final system = _visibleSystems[index];
                  return _SystemTile(
                    data: system,
                    onTap: () => context.go(
                      '${AppRoutes.adminSessions}?systemId=${Uri.encodeComponent(system.name)}',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
          GzLiveDot(size: 6),
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
          HugeIcon(icon: icon, color: accent, size: 20),
          const SizedBox(height: 14),
          Text(
            value,
            style: AppTypography.h2.copyWith(
              fontFamily: 'GeistMono',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.small),
        ],
      ),
    );
  }
}

class _SystemTile extends StatelessWidget {
  const _SystemTile({required this.data, required this.onTap});

  final _SystemTileData data;
  final VoidCallback onTap;

  Color get _borderColor => switch (data.status) {
    _SystemStatus.available => AppColors.ok,
    _SystemStatus.inUse => AppColors.info,
    _SystemStatus.maintenance => AppColors.warn,
    _SystemStatus.offline => AppColors.err,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      data.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: _borderColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(data.type, style: AppTypography.small),
              const Spacer(),
              switch (data.status) {
                _SystemStatus.available => Text(
                  'Available',
                  style: AppTypography.small.copyWith(color: AppColors.ok),
                ),
                _SystemStatus.inUse => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.user!,
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(data.time!, style: AppTypography.small),
                    if (data.endingSoon) ...[
                      const SizedBox(height: 4),
                      const GzTag(kind: GzTagKind.err, label: 'Ending soon'),
                    ],
                  ],
                ),
                _SystemStatus.maintenance => Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedWrench01,
                      color: AppColors.warn,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Maintenance',
                      style: AppTypography.small.copyWith(
                        color: AppColors.warn,
                      ),
                    ),
                  ],
                ),
                _SystemStatus.offline => Text(
                  'Offline',
                  style: AppTypography.small.copyWith(color: AppColors.err),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

enum _SystemStatus { available, inUse, maintenance, offline }

class _SystemTileData {
  const _SystemTileData({
    required this.name,
    required this.type,
    required this.status,
    this.user,
    this.time,
    this.endingSoon = false,
  });

  final String name;
  final String type;
  final _SystemStatus status;
  final String? user;
  final String? time;
  final bool endingSoon;
}
