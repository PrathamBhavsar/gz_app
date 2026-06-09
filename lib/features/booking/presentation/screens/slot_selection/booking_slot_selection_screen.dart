import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_store_selector_pill.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../../shared/widgets/store_selector_sheet.dart';
import '../../../../home/application/active_store_notifier.dart';
import '../../../application/booking_notifier.dart';
import '../../../application/system_types_notifier.dart';
import '../../../application/systems_notifier.dart';
import '../../booking_presenters.dart';

class BookingSlotSelectionScreen extends ConsumerWidget {
  const BookingSlotSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStoreState = ref.watch(activeStoreNotifierProvider);
    final bookingState = ref.watch(bookingNotifierProvider);
    final systems = ref.watch(filteredSystemsProvider);
    final systemTypes = ref.watch(systemTypesNotifierProvider);
    final canProceed = activeStoreState.selectedStore != null;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final storeName =
        activeStoreState.selectedStore?.name ??
        (activeStoreState.isLoading ? 'Loading store...' : 'Select store');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                    const SizedBox(height: 8),
                    Text(
                      'Live systems refresh every 30 seconds.',
                      style: AppTypography.bodyR,
                    ),
                    const SizedBox(height: 20),
                    systemTypes.when(
                      loading: () => const SizedBox(
                        height: 40,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (types) => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GzChip(
                                label: 'All',
                                active:
                                    bookingState.selectedSystemTypeId == null,
                                onTap: () => ref
                                    .read(bookingNotifierProvider.notifier)
                                    .setSystemType(
                                      systemTypeId: null,
                                      systemTypeName: null,
                                    ),
                              ),
                            ),
                            ...types.map((type) {
                              final typeId = type.id;
                              final active =
                                  typeId != null &&
                                  bookingState.selectedSystemTypeId == typeId;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GzChip(
                                  label: type.name ?? 'Type',
                                  active: active,
                                  onTap: () => ref
                                      .read(bookingNotifierProvider.notifier)
                                      .setSystemType(
                                        systemTypeId: typeId,
                                        systemTypeName: type.name,
                                      ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.rule),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _SystemsBody(
                        activeStoreState: activeStoreState,
                        systems: systems,
                        onRefresh: () async {
                          await ref
                              .read(systemTypesNotifierProvider.notifier)
                              .refresh();
                          await ref
                              .read(systemsNotifierProvider.notifier)
                              .refresh();
                        },
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
                onPressed: canProceed
                    ? () => context.push(AppRoutes.bookAvailability)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemsBody extends StatelessWidget {
  const _SystemsBody({
    required this.activeStoreState,
    required this.systems,
    required this.onRefresh,
  });

  final ActiveStoreState activeStoreState;
  final AsyncValue<List<SystemModel>> systems;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (activeStoreState.isLoading) {
      return const GzLoadingView(message: 'Loading your active store...');
    }

    if (activeStoreState.selectedStore == null) {
      return const PageErrorDisplay(
        error: AppPageError(
          title: 'Select a store',
          message:
              'Choose a store first so the booking flow knows where to load systems from.',
          icon: 'alert_circle',
        ),
      );
    }

    return systems.when(
      loading: () =>
          const GzLoadingView(message: 'Loading available systems...'),
      error: (error, _) =>
          PageErrorDisplay(error: AppPageError.from(error), onRetry: onRefresh),
      data: (items) {
        if (items.isEmpty) {
          return const PageErrorDisplay(
            error: AppPageError(
              title: 'No systems available',
              message:
                  'Try a different system type or check back after the next refresh.',
              icon: 'inbox',
              kind: AppPageErrorKind.empty,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _SystemCard(system: items[index]),
          ),
        );
      },
    );
  }
}

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.system});

  final SystemModel system;

  @override
  Widget build(BuildContext context) {
    final status = system.status == SystemStatus.available
        ? 'Available'
        : 'Busy';
    final tagKind = system.status == SystemStatus.available
        ? GzTagKind.ok
        : GzTagKind.mute;

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
                icon: platformIcon(system.platform),
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
                Text(system.name ?? 'Unnamed system', style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(systemSeatLabel(system), style: AppTypography.small),
                const SizedBox(height: 4),
                Text(systemSpecsLabel(system), style: AppTypography.bodyR),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GzTag(kind: tagKind, label: status),
              const SizedBox(height: 8),
              Text(
                formatPricePerHour(system.pricePerHour),
                style: AppTypography.num.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
