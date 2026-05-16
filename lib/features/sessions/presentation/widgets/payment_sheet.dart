import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_section_head.dart';
import '../providers/payment_notifier.dart';

final _paymentMethodProvider =
    StateProvider.autoDispose<String>((ref) => 'cash');

/// Shows the payment bottom sheet for a given booking.
void showPaymentSheet(BuildContext context, WidgetRef ref, String bookingId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _PaymentSheet(bookingId: bookingId),
  );
}

class _PaymentSheet extends ConsumerStatefulWidget {
  final String bookingId;
  const _PaymentSheet({required this.bookingId});

  @override
  ConsumerState<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<_PaymentSheet> {
  static const _methods = [
    (id: 'cash', label: 'Cash', sub: 'Pay at counter'),
    (id: 'upi', label: 'UPI', sub: 'Google Pay, PhonePe, etc.'),
    (id: 'card', label: 'Card', sub: 'Credit or debit card'),
    (id: 'credits', label: 'Credits', sub: 'Use your store credits'),
  ];

  @override
  Widget build(BuildContext context) {
    ref.listen<PaymentState>(paymentNotifierProvider, (_, next) {
      if (next is PaymentSuccess) {
        context.pop();
      }
    });

    final selectedMethod = ref.watch(_paymentMethodProvider);
    final payState = ref.watch(paymentNotifierProvider);
    final isLoading = payState is PaymentLoading;
    final errorMsg = payState is PaymentError ? payState.message : null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.rule,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const EmSectionHead('Payment'),

                // ── Booking summary card ──
                EmCard(
                  variant: CardVariant.inset,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Booking #${widget.bookingId.length > 8 ? widget.bookingId.substring(0, 8) : widget.bookingId}',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Pay now',
                        style: AppTypography.small,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Payment methods ──
                EmCard(
                  child: Column(
                    children: _methods.map((m) {
                      final selected = selectedMethod == m.id;
                      return GestureDetector(
                        onTap: () => ref
                            .read(_paymentMethodProvider.notifier)
                            .state = m.id,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.buttonBg
                                        : AppColors.rule,
                                    width: selected ? 6 : 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.label,
                                      style: AppTypography.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(m.sub, style: AppTypography.small),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (errorMsg != null) ...[
                  Text(
                    errorMsg,
                    style: AppTypography.small.copyWith(color: AppColors.err),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                EmButtonFull(
                  label: 'Confirm Payment',
                  loading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () => ref
                          .read(paymentNotifierProvider.notifier)
                          .pay(widget.bookingId, selectedMethod),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
