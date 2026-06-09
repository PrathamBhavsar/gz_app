import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../../models/domain_systems.dart';
import '../../../application/booking_notifier.dart';
import '../../../application/systems_notifier.dart';
import '../../booking_presenters.dart';

class BookingSystemSelectionScreen extends ConsumerWidget {
  const BookingSystemSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingNotifierProvider);
    final systems = ref.watch(filteredSystemsProvider);
    final selectedSystemId = bookingState.selectedSystem?.id;
    final slot = bookingState.selectedSlot;
    final start = parseSlotTime(slot?.startTime);
    final end = parseSlotTime(slot?.endTime);
    final subtitle = start != null && end != null
        ? '${formatBookingDate(start)} · ${formatTimeRange(start, end)}'
        : 'Pick a slot first';
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Pick your system', subtitle: subtitle),
      body: Column(
        children: [
          Expanded(
            child: systems.when(
              loading: () => const GzLoadingView(message: 'Loading systems...'),
              error: (error, _) => PageErrorDisplay(
                error: AppPageError.from(error),
                onRetry: () =>
                    ref.read(systemsNotifierProvider.notifier).refresh(),
              ),
              data: (items) {
                if (slot == null || start == null || end == null) {
                  return const PageErrorDisplay(
                    error: AppPageError(
                      title: 'Pick a slot first',
                      message:
                          'Go back and choose an available time before selecting a system.',
                      icon: 'alert_circle',
                    ),
                  );
                }

                if (items.isEmpty) {
                  return const PageErrorDisplay(error: AppPageError.empty);
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(systemsNotifierProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final system = items[index];
                      return _SystemOptionCard(
                        system: system,
                        selected: selectedSystemId == system.id,
                        onTap: () => ref
                            .read(bookingNotifierProvider.notifier)
                            .setSelectedSystem(system),
                      );
                    },
                  ),
                );
              },
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
              onPressed: bookingState.selectedSystem != null
                  ? () => context.push(AppRoutes.bookSummary)
                  : null,
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

  final SystemModel system;
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
                child: Center(
                  child: HugeIcon(
                    icon: platformIcon(system.platform),
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
                    Text(
                      system.name ?? 'Unnamed system',
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: 4),
                    Text(systemSeatLabel(system), style: AppTypography.small),
                    const SizedBox(height: 4),
                    Text(systemSpecsLabel(system), style: AppTypography.bodyR),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          formatPricePerHour(system.pricePerHour),
                          style: AppTypography.num.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        GzButton(
                          label: selected ? 'Selected' : 'Select',
                          small: true,
                          onPressed: onTap,
                        ),
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
