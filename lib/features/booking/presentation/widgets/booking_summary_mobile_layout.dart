import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/booking_notifier.dart';

class BookingSummaryMobileLayout extends ConsumerWidget {
  const BookingSummaryMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingNotifierProvider);
    final system = state.selectedSystemType;
    if (system == null) return const Center(child: Text('No system selected'));

    final totalAmount = (system.hourlyBaseRate ?? 0) * (state.selectedDurationMinutes / 60);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Details', style: AppTypography.headingSmall),
                const Divider(height: AppSpacing.xl, color: AppColors.border),
                _summaryRow('System', '${system.name}'),
                const SizedBox(height: AppSpacing.sm),
                _summaryRow('Date', '${state.selectedDate?.toString().split(' ')[0]}'),
                const SizedBox(height: AppSpacing.sm),
                _summaryRow('Duration', '${state.selectedDurationMinutes ~/ 60} Hours'),
                const Divider(height: AppSpacing.xl, color: AppColors.border),
                _summaryRow('Total', '\$ ${totalAmount.toStringAsFixed(2)}', isTotal: true),
              ],
            ),
          ),
          if (state.error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(state.error!, style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : () async {
                final success = await ref.read(bookingNotifierProvider.notifier).confirmBooking();
                if (success) {
                  context.go('/book/success');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
              ),
              child: state.isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.background))
                  : Text('Confirm & Pay', style: AppTypography.button),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTypography.headingMedium : AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
        Text(value, style: isTotal ? AppTypography.headingMedium.copyWith(color: AppColors.primary) : AppTypography.bodyLarge),
      ],
    );
  }
}
