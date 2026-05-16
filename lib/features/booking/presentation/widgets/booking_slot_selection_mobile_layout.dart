import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/auth/token_storage.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/connectivity_banner.dart';
import '../../../../../shared/widgets/em_button.dart';
import '../../../../../shared/widgets/em_store_selector_pill.dart';
import '../../../../../shared/widgets/em_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import 'package:gz_app/shared/widgets/store_selector_sheet.dart';
import '../providers/systems_notifier.dart';
import '../providers/booking_notifier.dart';

class BookingSlotSelectionMobileLayout extends ConsumerWidget {
  const BookingSlotSelectionMobileLayout({super.key});

  static const _filters = [
    ('all', 'All'),
    ('pc', 'PC'),
    ('ps5', 'PS5'),
    ('xbox', 'Xbox'),
    ('vr', 'VR'),
    ('other', 'Other'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeId = ref.watch(activeStoreIdProvider);
    final systemsAsync = ref.watch(systemsNotifierProvider);
    final selectedFilter = ref.watch(systemsFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Book a System', style: AppTypography.h1),
                ),
                EmStoreSelectorPill(
                  storeName: storeId != null ? 'Current Store' : 'Select Store',
                  onTap: () => showStoreSelectorSheet(context),
                ),
              ],
            ),
          ),
        ),

        // ── Type filter chips ──
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
            itemBuilder: (_, i) {
              final (key, label) = _filters[i];
              final isSelected = selectedFilter == key;
              return GestureDetector(
                onTap: () {
                  ref.read(systemsFilterProvider.notifier).state = key;
                  ref.read(bookingNotifierProvider.notifier).setTypeFilter(key);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.buttonBg
                        : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusChip),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: AppTypography.body.copyWith(
                      color:
                          isSelected ? AppColors.buttonFg : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.sm),
        const ConnectivityBanner(),
        const Divider(height: 1, color: AppColors.divider),

        // ── Systems list ──
        Expanded(
          child: storeId == null
              ? _NoStoreMessage(onTap: () => showStoreSelectorSheet(context))
              : systemsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (e, _) => PageErrorDisplay(
                    error: AppPageError.from(e),
                    onRetry: () =>
                        ref.read(systemsNotifierProvider.notifier).refresh(),
                  ),
                  data: (systems) {
                    final filtered = _applyFilter(systems, selectedFilter);
                    if (filtered.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            'No systems available',
                            style: AppTypography.bodyR,
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () =>
                          ref.read(systemsNotifierProvider.notifier).refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.sm,
                          AppSpacing.md,
                          AppSpacing.md,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) =>
                            _SystemCard(system: filtered[i]),
                      ),
                    );
                  },
                ),
        ),

        // ── Sticky bottom CTA ──
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: EmButtonFull(
              label: 'Check Availability',
              onPressed: storeId == null
                  ? null
                  : () => context.push('/book/availability'),
            ),
          ),
        ),
      ],
    );
  }

  List<SystemModel> _applyFilter(List<SystemModel> systems, String filter) {
    if (filter == 'all') return systems;
    return systems.where((s) {
      final p = s.platform;
      if (p == null) return filter == 'other';
      return switch (filter) {
        'pc' => p == SystemPlatform.pc,
        'ps5' => p == SystemPlatform.ps5 || p == SystemPlatform.ps4,
        'xbox' => p == SystemPlatform.xbox,
        'vr' => p == SystemPlatform.vr,
        'other' => p == SystemPlatform.other,
        _ => true,
      };
    }).toList();
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.system});
  final SystemModel system;

  @override
  Widget build(BuildContext context) {
    final isAvailable = system.status == SystemStatus.available;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Row(
        children: [
          _PlatformAvatar(platform: system.platform),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(system.name ?? 'System', style: AppTypography.h3),
                if (system.stationNumber != null)
                  Text(
                    'Seat ${system.stationNumber}',
                    style: AppTypography.small,
                  ),
              ],
            ),
          ),
          EmTag(
            kind: isAvailable ? EmTagKind.ok : EmTagKind.mute,
            label: isAvailable ? 'Available' : 'Booked',
          ),
        ],
      ),
    );
  }
}

class _PlatformAvatar extends StatelessWidget {
  const _PlatformAvatar({required this.platform});
  final SystemPlatform? platform;

  List<List<dynamic>> get _icon => switch (platform) {
        SystemPlatform.pc => HugeIcons.strokeRoundedComputerDesk01,
        SystemPlatform.ps5 ||
        SystemPlatform.ps4 =>
          HugeIcons.strokeRoundedGameController02,
        SystemPlatform.xbox => HugeIcons.strokeRoundedGameController01,
        SystemPlatform.vr => HugeIcons.strokeRoundedVirtualRealityVr01,
        _ => HugeIcons.strokeRoundedGameController01,
      };

  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.pillBg,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
        ),
        child: Center(
          child: HugeIcon(icon: _icon, color: AppColors.textSecondary, size: 20),
        ),
      );
}

class _NoStoreMessage extends StatelessWidget {
  const _NoStoreMessage({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedStore01,
                color: AppColors.textMuted,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('No store selected', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Pick a store to see available systems',
                style: AppTypography.bodyR,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              EmButton(label: 'Select a store', onPressed: onTap),
            ],
          ),
        ),
      );
}
