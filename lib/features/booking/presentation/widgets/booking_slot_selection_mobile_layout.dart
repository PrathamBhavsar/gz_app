import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/booking_notifier.dart';

class BookingSlotSelectionMobileLayout extends ConsumerWidget {
  const BookingSlotSelectionMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingNotifierProvider);
    final notifier = ref.read(bookingNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Date & Time', style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.md),
          _buildDatePickerCard(context, state.selectedDate ?? DateTime.now(), notifier),
          const SizedBox(height: AppSpacing.xl),
          Text('Duration', style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSelector(state.selectedDurationMinutes, notifier),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/book/systems');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
              ),
              child: Text('Find Available Systems', style: AppTypography.button),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildDatePickerCard(BuildContext context, DateTime selectedDate, BookingNotifier notifier) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date != null) notifier.updateDate(date);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}', style: AppTypography.bodyLarge),
            const Icon(Icons.calendar_today, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector(int duration, BookingNotifier notifier) {
    return Row(
      children: [
        _durationChip('1 HR', 60, duration, notifier),
        const SizedBox(width: AppSpacing.sm),
        _durationChip('2 HRS', 120, duration, notifier),
        const SizedBox(width: AppSpacing.sm),
        _durationChip('3 HRS', 180, duration, notifier),
      ],
    );
  }

  Widget _durationChip(String label, int value, int current, BookingNotifier notifier) {
    final isSelected = value == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.updateDuration(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.button.copyWith(color: isSelected ? AppColors.background : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
