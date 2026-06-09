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
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../../models/api_responses.dart';
import '../../../application/availability_notifier.dart';
import '../../../application/booking_notifier.dart';
import '../../booking_presenters.dart';

class BookingAvailabilityScreen extends ConsumerWidget {
  const BookingAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingNotifierProvider);
    final availability = ref.watch(availabilityNotifierProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final selectedSlot = bookingState.selectedSlot;

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
                  icon: HugeIcons.strokeRoundedCalendar01,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text('Choose a slot', style: AppTypography.h3),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: availability.when(
              loading: () => const GzLoadingView(message: 'Loading slots...'),
              error: (error, _) => PageErrorDisplay(
                error: AppPageError.from(error),
                onRetry: () =>
                    ref.read(availabilityNotifierProvider.notifier).refresh(),
              ),
              data: (data) {
                if (data.slots.isEmpty) {
                  return const PageErrorDisplay(error: AppPageError.empty);
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(availabilityNotifierProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: data.slots.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final slot = data.slots[index];
                      final selected =
                          identical(selectedSlot, slot) ||
                          (selectedSlot?.startTime == slot.startTime &&
                              selectedSlot?.endTime == slot.endTime);
                      final enabled = isBookableSlot(slot);
                      return GestureDetector(
                        onTap: enabled
                            ? () => ref
                                  .read(bookingNotifierProvider.notifier)
                                  .setSelectedSlot(slot)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.surfaceTint
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusCard,
                            ),
                            border: Border.all(
                              color: selected
                                  ? AppColors.textPrimary
                                  : AppColors.rule,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formatSlotRange(slot),
                                      style: AppTypography.h3,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${slot.systemCount ?? 0} systems available',
                                      style: AppTypography.bodyR,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              _SlotStatusPill(slot: slot),
                            ],
                          ),
                        ),
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
              label: 'Select system',
              trailing: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.buttonFg,
                size: 18,
              ),
              onPressed: selectedSlot != null
                  ? () => context.push(AppRoutes.bookSystems)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotStatusPill extends StatelessWidget {
  const _SlotStatusPill({required this.slot});

  final AvailabilitySlot slot;

  @override
  Widget build(BuildContext context) {
    final selected = availabilityStatusLabel(slot.status);
    final kind = availabilityTagKind(slot.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: switch (kind) {
          GzTagKind.ok => AppColors.okBg,
          GzTagKind.warn => AppColors.warnBg,
          GzTagKind.err => AppColors.errBg,
          GzTagKind.info => AppColors.infoBg,
          GzTagKind.mute => AppColors.pillBg,
          GzTagKind.purple => AppColors.purpleBg,
        },
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
      ),
      child: Text(
        selected,
        style: AppTypography.small.copyWith(
          color: switch (kind) {
            GzTagKind.ok => AppColors.ok,
            GzTagKind.warn => AppColors.warn,
            GzTagKind.err => AppColors.err,
            GzTagKind.info => AppColors.info,
            GzTagKind.mute => AppColors.textSecondary,
            GzTagKind.purple => AppColors.purple,
          },
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
