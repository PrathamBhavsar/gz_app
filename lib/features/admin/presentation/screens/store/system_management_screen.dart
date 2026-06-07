import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_tag.dart';

enum SystemStatus { available, inUse, maintenance }

extension SystemStatusX on SystemStatus {
  GzTagKind get tagKind => switch (this) {
        SystemStatus.available => GzTagKind.ok,
        SystemStatus.inUse => GzTagKind.info,
        SystemStatus.maintenance => GzTagKind.warn,
      };

  String get label => switch (this) {
        SystemStatus.available => 'Available',
        SystemStatus.inUse => 'In Use',
        SystemStatus.maintenance => 'Maintenance',
      };
}

class _SystemData {
  const _SystemData({
    required this.id,
    required this.name,
    required this.type,
    required this.seatNumber,
    required this.specs,
    required this.status,
  });

  final String id;
  final String name;
  final String type;
  final String seatNumber;
  final String specs;
  final SystemStatus status;
}

class SystemManagementScreen extends StatefulWidget {
  const SystemManagementScreen({super.key});

  @override
  State<SystemManagementScreen> createState() => _SystemManagementScreenState();
}

class _SystemManagementScreenState extends State<SystemManagementScreen> {
  String _selectedType = 'All';

  static const _types = ['All', 'PC', 'PS5', 'Xbox', 'VR'];

  static const _systems = [
    _SystemData(
      id: 'SYS-001',
      name: 'PC Station 01',
      type: 'PC',
      seatNumber: '01',
      specs: 'RTX 4090 · 32GB · 240Hz',
      status: SystemStatus.available,
    ),
    _SystemData(
      id: 'SYS-002',
      name: 'PC Station 02',
      type: 'PC',
      seatNumber: '02',
      specs: 'RTX 4080 · 16GB · 165Hz',
      status: SystemStatus.inUse,
    ),
    _SystemData(
      id: 'SYS-003',
      name: 'PC Station 03',
      type: 'PC',
      seatNumber: '03',
      specs: 'RTX 4090 · 32GB · 240Hz',
      status: SystemStatus.inUse,
    ),
    _SystemData(
      id: 'SYS-004',
      name: 'PS5 Console 01',
      type: 'PS5',
      seatNumber: '01',
      specs: 'PlayStation 5 · 4K',
      status: SystemStatus.available,
    ),
    _SystemData(
      id: 'SYS-005',
      name: 'Xbox Series X',
      type: 'Xbox',
      seatNumber: '01',
      specs: 'Xbox Series X · 4K',
      status: SystemStatus.maintenance,
    ),
    _SystemData(
      id: 'SYS-006',
      name: 'VR Pod 01',
      type: 'VR',
      seatNumber: '01',
      specs: 'Meta Quest 3 · 120Hz',
      status: SystemStatus.available,
    ),
  ];

  List<_SystemData> get _filtered => _selectedType == 'All'
      ? _systems
      : _systems.where((s) => s.type == _selectedType).toList();

  List<List<dynamic>> _iconForType(String type) => switch (type) {
        'PC' => HugeIcons.strokeRoundedComputerDesk01,
        'PS5' => HugeIcons.strokeRoundedGameController01,
        'Xbox' => HugeIcons.strokeRoundedGameController01,
        'VR' => HugeIcons.strokeRoundedVirtualRealityVr01,
        _ => HugeIcons.strokeRoundedComputerDesk01,
      };

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final totalCount = _systems.length;
    final inUseCount = _systems.where((s) => s.status == SystemStatus.inUse).length;
    final maintenanceCount =
        _systems.where((s) => s.status == SystemStatus.maintenance).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Systems',
        trailing: GestureDetector(
          onTap: () => context.push('/admin/systems/add'),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Row(
                children: List.generate(_types.length, (i) {
                  final type = _types[i];
                  final isActive = _selectedType == type;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: i == _types.length - 1 ? 0 : 8,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.buttonBg : AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.borderRadiusChip),
                          border: isActive
                              ? null
                              : Border.all(color: AppColors.rule),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          type,
                          style: AppTypography.small.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.buttonFg
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Stats row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: GzCard(
                      variant: CardVariant.inset,
                      padding: 12,
                      child: Column(
                        children: [
                          Text('$totalCount',
                              style: AppTypography.h2),
                          Text('Total', style: AppTypography.small),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GzCard(
                      variant: CardVariant.inset,
                      padding: 12,
                      child: Column(
                        children: [
                          Text('$inUseCount',
                              style: AppTypography.h2.copyWith(
                                  color: AppColors.info)),
                          Text('In Use', style: AppTypography.small),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GzCard(
                      variant: CardVariant.inset,
                      padding: 12,
                      child: Column(
                        children: [
                          Text('$maintenanceCount',
                              style: AppTypography.h2.copyWith(
                                  color: AppColors.warn)),
                          Text('Maint.', style: AppTypography.small),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // System list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: filtered.length,
                separatorBuilder: (context, i) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final system = filtered[index];
                  return GestureDetector(
                    onTap: () =>
                        context.push('/admin/systems/${system.id}'),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusCard),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.pillBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: HugeIcon(
                              icon: _iconForType(system.type),
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(system.name, style: AppTypography.h3),
                                Text(system.specs, style: AppTypography.small),
                              ],
                            ),
                          ),
                          GzTag(
                            kind: system.status.tagKind,
                            label: system.status.label,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
