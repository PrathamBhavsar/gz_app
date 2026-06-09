import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_loyalty.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../home/application/active_store_notifier.dart';
import '../../../application/booking_form_notifier.dart';
import '../../../application/booking_notifier.dart';
import '../../../application/booking_summary_ui_notifier.dart';
import '../../booking_presenters.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  ConsumerState<BookingSummaryScreen> createState() =>
      _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<BookingFormState>(bookingFormNotifierProvider, (previous, next) {
      if (next is BookingFormError) {
        showErrorSnackbar(context, next.error);
      }
      if (next is BookingFormSuccess) {
        context.pushReplacement(AppRoutes.bookSuccess);
      }
    });

    final bookingState = ref.watch(bookingNotifierProvider);
    final summaryUi = ref.watch(bookingSummaryUiNotifierProvider);
    final activeStoreState = ref.watch(activeStoreNotifierProvider);
    final bookingFormState = ref.watch(bookingFormNotifierProvider);
    final system = bookingState.selectedSystem;
    final slot = bookingState.selectedSlot;
    final start = parseSlotTime(slot?.startTime);
    final end = parseSlotTime(slot?.endTime);
    final store = activeStoreState.selectedStore;
    final durationMinutes = slotDurationMinutes(slot);
    final hourlyRate = system?.pricePerHour ?? 0;
    final subtotal = durationMinutes == null
        ? 0.0
        : hourlyRate * (durationMinutes / 60);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    if (system == null || slot == null || start == null || end == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const GzTopBar(title: 'Booking summary'),
        body: const PageErrorDisplay(
          error: AppPageError(
            title: 'Booking details missing',
            message:
                'Pick a slot and a system before reviewing the booking summary.',
            icon: 'alert_circle',
          ),
        ),
      );
    }

    final isSubmitting = bookingFormState is BookingFormLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Booking summary'),
      body: summaryUi.when(
        loading: () => const GzCard(
          child: SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        ),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(bookingSummaryUiNotifierProvider.notifier).refresh(),
        ),
        data: (summaryState) {
          final campaignDiscount = campaignDiscountEstimate(
            summaryState.selectedCampaign,
            subtotal,
          );
          final creditsDiscount = summaryState.creditsToRedeem.toDouble();
          final estimatedTotal = (subtotal - campaignDiscount - creditsDiscount)
              .clamp(0.0, double.infinity);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: Column(
                    children: [
                      _SystemInfoCard(
                        systemName: system.name ?? 'Unnamed system',
                        seatLabel: systemSeatLabel(system),
                        storeName: store?.name ?? 'Selected store',
                        system: system,
                      ),
                      const SizedBox(height: 12),
                      _SessionDetailsCard(
                        dateLabel: formatBookingDate(start),
                        timeLabel: formatTimeRange(start, end),
                        durationLabel: formatDurationLabel(
                          durationMinutes ?? 0,
                        ),
                        rateLabel: formatPricePerHour(system.pricePerHour),
                        systemTypeLabel:
                            bookingState.selectedSystemTypeName ??
                            'All systems',
                      ),
                      const SizedBox(height: 12),
                      _CampaignSelectionCard(
                        campaigns: summaryState.campaigns,
                        selectedCampaignId: summaryState.selectedCampaignId,
                        onSelected: (id) => ref
                            .read(bookingSummaryUiNotifierProvider.notifier)
                            .selectCampaign(id),
                      ),
                      const SizedBox(height: 12),
                      _CreditsCard(
                        creditBalance: summaryState.creditBalance,
                        creditsToRedeem: summaryState.creditsToRedeem,
                        onChanged: (value) => ref
                            .read(bookingSummaryUiNotifierProvider.notifier)
                            .setCreditsToRedeem(value),
                      ),
                      const SizedBox(height: 12),
                      _PaymentMethodCard(
                        selected: bookingState.selectedPaymentMethod,
                        onSelected: (method) => ref
                            .read(bookingNotifierProvider.notifier)
                            .setPaymentMethod(method),
                      ),
                      const SizedBox(height: 12),
                      _CostBreakdownCard(
                        subtotal: subtotal,
                        campaignDiscount: campaignDiscount,
                        creditsDiscount: creditsDiscount,
                        total: estimatedTotal,
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
                  label: 'Confirm booking',
                  loading: isSubmitting,
                  onPressed: isSubmitting
                      ? null
                      : () => ref
                            .read(bookingFormNotifierProvider.notifier)
                            .submit(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SystemInfoCard extends StatelessWidget {
  const _SystemInfoCard({
    required this.systemName,
    required this.seatLabel,
    required this.storeName,
    required this.system,
  });

  final String systemName;
  final String seatLabel;
  final String storeName;
  final SystemModel system;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.buttonBg,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            ),
            child: Center(
              child: HugeIcon(
                icon: platformIcon(system.platform),
                color: AppColors.buttonFg,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(systemName, style: AppTypography.h2),
                const SizedBox(height: 4),
                Text(
                  seatLabel,
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  storeName,
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionDetailsCard extends StatelessWidget {
  const _SessionDetailsCard({
    required this.dateLabel,
    required this.timeLabel,
    required this.durationLabel,
    required this.rateLabel,
    required this.systemTypeLabel,
  });

  final String dateLabel;
  final String timeLabel;
  final String durationLabel;
  final String rateLabel;
  final String systemTypeLabel;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Session details', style: AppTypography.h3),
          const SizedBox(height: 10),
          GzMetaRow(label: 'Date', value: dateLabel),
          GzMetaRow(label: 'Time', value: timeLabel),
          GzMetaRow(label: 'Duration', value: durationLabel),
          GzMetaRow(label: 'Rate', value: rateLabel),
          GzMetaRow(label: 'Type', value: systemTypeLabel),
        ],
      ),
    );
  }
}

class _CampaignSelectionCard extends StatelessWidget {
  const _CampaignSelectionCard({
    required this.campaigns,
    required this.selectedCampaignId,
    required this.onSelected,
  });

  final List<CampaignModel> campaigns;
  final String? selectedCampaignId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Campaign', style: AppTypography.h3),
          const SizedBox(height: 10),
          if (campaigns.isEmpty)
            Text(
              'No active campaigns for this system type.',
              style: AppTypography.bodyR,
            )
          else
            ...campaigns.map((campaign) {
              final selected = campaign.id == selectedCampaignId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => onSelected(selected ? null : campaign.id),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.surfaceTint
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusLg,
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
                                campaign.name ?? 'Campaign',
                                style: AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                campaignValueLabel(campaign),
                                style: AppTypography.bodyR,
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                            color: AppColors.ok,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _CreditsCard extends StatelessWidget {
  const _CreditsCard({
    required this.creditBalance,
    required this.creditsToRedeem,
    required this.onChanged,
  });

  final CreditBalanceModel? creditBalance;
  final int creditsToRedeem;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final maxCredits = (creditBalance?.availableBalance ?? 0).floor();

    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Credits', style: AppTypography.h3),
          const SizedBox(height: 10),
          GzMetaRow(
            label: 'Available balance',
            value: '${maxCredits.toString()} credits',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _CreditsStepperButton(
                icon: HugeIcons.strokeRoundedMinusSign,
                onTap: creditsToRedeem > 0
                    ? () => onChanged(creditsToRedeem - 1)
                    : null,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '$creditsToRedeem credits',
                    style: AppTypography.num.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              _CreditsStepperButton(
                icon: HugeIcons.strokeRoundedPlusSign,
                onTap: creditsToRedeem < maxCredits
                    ? () => onChanged(creditsToRedeem + 1)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Server pricing is authoritative. Credits are sent with the booking request and final discounts are confirmed by the backend.',
            style: AppTypography.small,
          ),
        ],
      ),
    );
  }
}

class _CreditsStepperButton extends StatelessWidget {
  const _CreditsStepperButton({required this.icon, this.onTap});

  final dynamic icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
            border: Border.all(color: AppColors.rule),
          ),
          child: Center(
            child: HugeIcon(icon: icon, color: AppColors.textPrimary, size: 18),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.selected, required this.onSelected});

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onSelected;

  static const _methods = [
    PaymentMethod.upi,
    PaymentMethod.card,
    PaymentMethod.cash,
    PaymentMethod.wallet,
    PaymentMethod.credits,
  ];

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment method', style: AppTypography.h3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _methods
                .map((method) {
                  final active = method == selected;
                  return GestureDetector(
                    onTap: () => onSelected(method),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: active ? AppColors.buttonBg : AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusChip,
                        ),
                        border: active
                            ? null
                            : Border.all(color: AppColors.rule),
                      ),
                      child: Text(
                        _labelFor(method),
                        style: AppTypography.small.copyWith(
                          color: active
                              ? AppColors.buttonFg
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  String _labelFor(PaymentMethod method) => switch (method) {
    PaymentMethod.upi => 'UPI',
    PaymentMethod.card => 'Card',
    PaymentMethod.cash => 'Cash',
    PaymentMethod.wallet => 'Wallet',
    PaymentMethod.credits => 'Credits',
  };
}

class _CostBreakdownCard extends StatelessWidget {
  const _CostBreakdownCard({
    required this.subtotal,
    required this.campaignDiscount,
    required this.creditsDiscount,
    required this.total,
  });

  final double subtotal;
  final double campaignDiscount;
  final double creditsDiscount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cost breakdown', style: AppTypography.h3),
          const SizedBox(height: 10),
          GzMetaRow(label: 'Session', value: formatCurrency(subtotal)),
          GzMetaRow(
            label: 'Campaign estimate',
            value: '-${formatCurrency(campaignDiscount)}',
          ),
          GzMetaRow(
            label: 'Credits requested',
            value: '-${formatCurrency(creditsDiscount)}',
          ),
          const GzMetaRow(label: 'Convenience fee', value: 'Rs 0'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: AppColors.rule),
          ),
          GzMetaRow(
            label: 'Estimated total',
            value: formatCurrency(total),
            valueBold: true,
            valueStyle: AppTypography.num.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
