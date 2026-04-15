import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/booking_notifier.dart';

class BookingSummaryTabletLayout extends ConsumerWidget {
  const BookingSummaryTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingNotifierProvider);
    final system = state.selectedSystemType;
    if (system == null) return const Center(child: Text('No system selected'));

    final totalAmount =
        (system.hourlyBaseRate ?? 0) * (state.selectedDurationMinutes / 60);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking Details', style: AppTypography.headingLarge),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(
                      height: AppSpacing.xl,
                      color: AppColors.border,
                    ),
                    _summaryRow('System', '${system.name}'),
                    const SizedBox(height: AppSpacing.md),
                    _summaryRow(
                      'Date',
                      '${state.selectedDate?.toString().split(' ')[0]}',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _summaryRow(
                      'Duration',
                      '${state.selectedDurationMinutes ~/ 60} Hours',
                    ),
                    const Divider(
                      height: AppSpacing.xxl,
                      color: AppColors.border,
                    ),
                    _summaryRow(
                      'Total Amount',
                      '\$ ${totalAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              if (state.error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  state.error!,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          final success = await ref
                              .read(bookingNotifierProvider.notifier)
                              .confirmBooking();
                          if (success && context.mounted) {
                            context.go('/book/success');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadius,
                      ),
                    ),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.background,
                          ),
                        )
                      : Text(
                          'Confirm & Pay',
                          style: AppTypography.headingSmall,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.headingLarge
              : AppTypography.headingSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTypography.headingLarge.copyWith(color: AppColors.primary)
              : AppTypography.headingSmall,
        ),
      ],
    );
  }
}
