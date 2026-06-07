import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class BookingSystemSelectionScreen extends StatefulWidget {
  const BookingSystemSelectionScreen({super.key});

  @override
  State<BookingSystemSelectionScreen> createState() =>
      _BookingSystemSelectionScreenState();
}

class _BookingSystemSelectionScreenState
    extends State<BookingSystemSelectionScreen> {
  static const _sortOptions = [
    'Recommended',
    'Price ↑',
    'Price ↓',
    'Availability',
  ];

  static const _systems = <_SelectableSystem>[
    _SelectableSystem(
      name: 'RTX 4090 Gaming PC',
      seat: 'Seat 3',
      details: 'RTX 4090 · 32GB · 240Hz · 4K',
      price: '₹80/hr',
      tagLabel: 'Available',
      tagKind: GzTagKind.ok,
      recommended: true,
    ),
    _SelectableSystem(
      name: 'RTX 3080 Gaming PC',
      seat: 'Seat 7',
      details: 'RTX 3080 · 16GB · 165Hz',
      price: '₹70/hr',
      tagLabel: 'Available',
      tagKind: GzTagKind.ok,
    ),
    _SelectableSystem(
      name: 'RTX 3070 Gaming PC',
      seat: 'Seat 1',
      details: 'RTX 3070 · 16GB · 144Hz',
      price: '₹65/hr',
      tagLabel: 'In use · free 5:30 PM',
      tagKind: GzTagKind.info,
    ),
    _SelectableSystem(
      name: 'RTX 3060 Gaming PC',
      seat: 'Seat 9',
      details: 'RTX 3060 · 16GB · 144Hz',
      price: '₹55/hr',
      tagLabel: 'Available',
      tagKind: GzTagKind.ok,
    ),
    _SelectableSystem(
      name: 'i9 High Perf PC',
      seat: 'Seat 2',
      details: 'Core i9 · 64GB · Creator setup',
      price: '₹90/hr',
      tagLabel: 'Unavailable',
      tagKind: GzTagKind.mute,
    ),
  ];

  String _selectedSort = 'Recommended';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(
        title: 'Pick your system',
        subtitle: 'Wed 4 · 6:00 PM – 8:00 PM',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _sortOptions.map((option) {
                        final isActive = option == _selectedSort;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GzChip(
                            label: option,
                            active: isActive,
                            onTap: () => setState(() => _selectedSort = option),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...List.generate(_systems.length, (index) {
                    final system = _systems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SystemOptionCard(
                        system: system,
                        selected: _selectedIndex == index,
                        onTap: () => setState(() => _selectedIndex = index),
                      ),
                    );
                  }),
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
              label: 'Continue to summary',
              onPressed: () => context.push(AppRoutes.bookSummary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemOptionCard extends StatelessWidget {
  const _SystemOptionCard({
    required this.system,
    required this.selected,
    required this.onTap,
  });

  final _SelectableSystem system;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          border: Border.all(
            color: selected ? AppColors.textPrimary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: GzCard(
          variant: selected ? CardVariant.tint : CardVariant.base,
          padding: 14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.surfaceTintStrong
                      : AppColors.pillBg,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusLg,
                  ),
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedComputerDesk01,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(system.name, style: AppTypography.h3),
                        ),
                        if (system.recommended)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceTintStrong,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusPill,
                              ),
                            ),
                            child: Text(
                              'Recommended',
                              style: AppTypography.small.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      system.seat,
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(system.details, style: AppTypography.small),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(system.price, style: AppTypography.h3),
                        const Spacer(),
                        GzTag(kind: system.tagKind, label: system.tagLabel),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectableSystem {
  const _SelectableSystem({
    required this.name,
    required this.seat,
    required this.details,
    required this.price,
    required this.tagLabel,
    required this.tagKind,
    this.recommended = false,
  });

  final String name;
  final String seat;
  final String details;
  final String price;
  final String tagLabel;
  final GzTagKind tagKind;
  final bool recommended;
}
