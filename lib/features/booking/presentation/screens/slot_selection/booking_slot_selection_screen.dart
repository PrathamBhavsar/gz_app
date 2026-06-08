import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../home/application/active_store_notifier.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_store_selector_pill.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/store_selector_sheet.dart';

class BookingSlotSelectionScreen extends ConsumerStatefulWidget {
  const BookingSlotSelectionScreen({super.key});

  @override
  ConsumerState<BookingSlotSelectionScreen> createState() =>
      _BookingSlotSelectionScreenState();
}

class _BookingSlotSelectionScreenState
    extends ConsumerState<BookingSlotSelectionScreen> {
  static const _filters = ['All', 'PC', 'PS5', 'Xbox', 'VR', 'Other'];

  static const _systems = <_SystemCardData>[
    _SystemCardData(
      title: 'PC Station 01',
      seat: 'Seat 1',
      status: 'Available',
      statusKind: GzTagKind.ok,
      icon: HugeIcons.strokeRoundedComputerDesk01,
      filter: 'PC',
    ),
    _SystemCardData(
      title: 'PC Station 02',
      seat: 'Seat 2',
      status: 'Booked',
      statusKind: GzTagKind.mute,
      icon: HugeIcons.strokeRoundedComputerDesk01,
      filter: 'PC',
    ),
    _SystemCardData(
      title: 'PS5 Console 01',
      seat: 'Seat 3',
      status: 'Available',
      statusKind: GzTagKind.ok,
      icon: HugeIcons.strokeRoundedGameController02,
      filter: 'PS5',
    ),
    _SystemCardData(
      title: 'Xbox Series X',
      seat: 'Seat 4',
      status: 'Booked',
      statusKind: GzTagKind.mute,
      icon: HugeIcons.strokeRoundedGameController01,
      filter: 'Xbox',
    ),
    _SystemCardData(
      title: 'VR Pod 01',
      seat: 'Seat 5',
      status: 'Available',
      statusKind: GzTagKind.ok,
      icon: HugeIcons.strokeRoundedVirtualRealityVr01,
      filter: 'VR',
    ),
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final activeStoreState = ref.watch(activeStoreNotifierProvider);
    final storeName =
        activeStoreState.selectedStore?.name ??
        (activeStoreState.isLoading ? 'Loading store...' : 'Select store');
    final visibleSystems = _selectedFilter == 'All'
        ? _systems
        : _systems.where((system) => system.filter == _selectedFilter).toList();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text('Book a System', style: AppTypography.h1),
                        ),
                        const SizedBox(width: 12),
                        GzStoreSelectorPill(
                          storeName: storeName,
                          onTap: () => showStoreSelectorSheet(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filters.map((filter) {
                          final isActive = filter == _selectedFilter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GzChip(
                              label: filter,
                              active: isActive,
                              onTap: () {
                                setState(() => _selectedFilter = filter);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.rule),
                    const SizedBox(height: 16),
                    ...visibleSystems.map(
                      (system) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SystemCard(system: system),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: GzButton(
                label: 'Check Availability',
                onPressed: () => context.push(AppRoutes.bookAvailability),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.system});

  final _SystemCardData system;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 14,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            ),
            child: Center(
              child: HugeIcon(
                icon: system.icon,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(system.title, style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(
                  system.seat,
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GzTag(kind: system.statusKind, label: system.status),
        ],
      ),
    );
  }
}

class _SystemCardData {
  const _SystemCardData({
    required this.title,
    required this.seat,
    required this.status,
    required this.statusKind,
    required this.icon,
    required this.filter,
  });

  final String title;
  final String seat;
  final String status;
  final GzTagKind statusKind;
  final dynamic icon;
  final String filter;
}
