import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/session_runtime_providers.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod _selected = PaymentMethod.cash;

  @override
  Widget build(BuildContext context) {
    ref.listen<PaymentFlowState>(
      paymentNotifierProvider(widget.id),
      (previous, next) {
        if (next is PaymentSuccess && next != previous) {
          showSuccessSnackbar(context, 'Payment completed');
          ref.read(paymentNotifierProvider(widget.id).notifier).reset();
          context.pop();
        } else if (next is PaymentError && next != previous) {
          showErrorSnackbar(context, next.error);
          ref.read(paymentNotifierProvider(widget.id).notifier).reset();
        }
      },
    );

    final booking = ref.watch(bookingDetailStateNotifierProvider(widget.id));
    final paymentState = ref.watch(paymentNotifierProvider(widget.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Complete payment'),
      body: SafeArea(
        top: false,
        child: booking.when(
          loading: () => const GzLoadingView(message: 'Loading payment...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref
                .read(bookingDetailStateNotifierProvider(widget.id).notifier)
                .refresh(),
          ),
          data: (bookingData) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusCard),
                ),
                child: Column(
                  children: [
                    Text(
                      bookingData.total,
                      style: AppTypography.h1.copyWith(
                        fontSize: 40,
                        fontFamily: 'GeistMono',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bookingData.time,
                      style: AppTypography.small
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Payment method', style: AppTypography.h2),
              const SizedBox(height: 12),
              _PaymentMethodTile(
                icon: HugeIcons.strokeRoundedMoney02,
                label: 'Cash',
                selected: _selected == PaymentMethod.cash,
                onTap: () => setState(() => _selected = PaymentMethod.cash),
              ),
              const SizedBox(height: 10),
              _PaymentMethodTile(
                icon: HugeIcons.strokeRoundedSmartPhone01,
                label: 'UPI',
                selected: _selected == PaymentMethod.upi,
                onTap: () => setState(() => _selected = PaymentMethod.upi),
              ),
              const SizedBox(height: 10),
              _PaymentMethodTile(
                icon: HugeIcons.strokeRoundedCreditCard,
                label: 'Card',
                selected: _selected == PaymentMethod.card,
                onTap: () => setState(() => _selected = PaymentMethod.card),
              ),
              const SizedBox(height: 28),
              GzButton(
                label: 'Pay ${bookingData.total}',
                loading: paymentState is PaymentLoading,
                onPressed: () => ref
                    .read(paymentNotifierProvider(widget.id).notifier)
                    .submit(_selected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final List<List<dynamic>> icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          border: Border.all(
            color: selected ? AppColors.textPrimary : AppColors.rule,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTypography.h3)),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 13),
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.rule, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
