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
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/booking_notifier.dart';
import '../../../application/systems_notifier.dart';
import '../../booking_presenters.dart';

class BookingAvailabilityScreen extends ConsumerWidget {
  const BookingAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingNotifierProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final selectedSlot = bookingState.selectedSlot;
    final selectedSystemId = bookingState.selectedSystem?.id;
    final slotStarts = generateBookingSlotStarts(bookingState.selectedDate);

    if (selectedSlot == null && slotStarts.isNotEmpty) {
      final defaultStart = slotStarts.first;
      final defaultEnd = defaultStart.add(
        const Duration(minutes: bookingSlotDurationMinutes),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(bookingNotifierProvider.notifier)
            .setSelectedTimeSlot(defaultStart, defaultEnd);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'Pick a time',
        subtitle: formatBookingDate(bookingState.selectedDate),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final normalized = DateTime(date.year, date.month, date.day);
                  final selected =
                      DateTime(
                        bookingState.selectedDate.year,
                        bookingState.selectedDate.month,
                        bookingState.selectedDate.day,
                      ) ==
                      normalized;
                  return GestureDetector(
                    onTap: () => ref
                        .read(bookingNotifierProvider.notifier)
                        .setSelectedDate(normalized),
                    child: Container(
                      width: 72,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.buttonBg
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusLg,
                        ),
                        border: selected
                            ? null
                            : Border.all(color: AppColors.rule),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatDateChipLabel(normalized),
                            style: AppTypography.small.copyWith(
                              color: selected
                                  ? AppColors.buttonFg
                                  : AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${normalized.day}',
                            style: AppTypography.h3.copyWith(
                              color: selected
                                  ? AppColors.buttonFg
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedClock01,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text('Choose a time', style: AppTypography.h3),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (slotStarts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PageErrorDisplay(
                error: AppPageError(
                  title: 'No times left today',
                  message: 'Pick a different date to see booking times.',
                  icon: 'alert_circle',
                  kind: AppPageErrorKind.empty,
                ),
              ),
            )
          else
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: slotStarts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final start = slotStarts[index];
                  final end = start.add(
                    const Duration(minutes: bookingSlotDurationMinutes),
                  );
                  final selected =
                      selectedSlot != null &&
                      parseSlotTime(selectedSlot.startTime) == start;
                  return GestureDetector(
                    onTap: () => ref
                        .read(bookingNotifierProvider.notifier)
                        .setSelectedTimeSlot(start, end),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.buttonBg
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusPill,
                        ),
                        border: selected
                            ? null
                            : Border.all(color: AppColors.rule),
                      ),
                      child: Text(
                        formatTimeLabel(start),
                        style: AppTypography.bodyR.copyWith(
                          color: selected
                              ? AppColors.buttonFg
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedComputerDesk01,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text('Available systems', style: AppTypography.h3),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: selectedSlot == null
                ? const PageErrorDisplay(
                    error: AppPageError(
                      title: 'Pick a time first',
                      message:
                          'Choose a time above to see which systems are free.',
                      icon: 'alert_circle',
                      kind: AppPageErrorKind.empty,
                    ),
                  )
                : Consumer(
                    builder: (context, ref, _) {
                      final systems = ref.watch(filteredSystemsProvider);
                      return systems.when(
                        loading: () =>
                            const GzLoadingView(message: 'Checking systems...'),
                        error: (error, _) => PageErrorDisplay(
                          error: AppPageError.from(error),
                          onRetry: () => ref
                              .read(systemsNotifierProvider.notifier)
                              .refresh(),
                        ),
                        data: (items) {
                          if (items.isEmpty) {
                            return const PageErrorDisplay(
                              error: AppPageError(
                                title: 'Nothing free at this time',
                                message:
                                    'Try a different time slot or system type.',
                                icon: 'inbox',
                                kind: AppPageErrorKind.empty,
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () => ref
                                .read(systemsNotifierProvider.notifier)
                                .refresh(),
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                24,
                              ),
                              itemCount: items.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 10),
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
              trailing: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.buttonFg,
                size: 18,
              ),
              onPressed: selectedSlot != null && bookingState.selectedSystem != null
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
                        SizedBox(
                          width: 92,
                          child: GzButton(
                            label: selected ? 'Selected' : 'Select',
                            small: true,
                            onPressed: onTap,
                          ),
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
