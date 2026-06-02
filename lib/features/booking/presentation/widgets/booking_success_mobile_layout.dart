import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../providers/booking_form_notifier.dart';
import '../providers/booking_notifier.dart';

class BookingSuccessMobileLayout extends ConsumerWidget {
  const BookingSuccessMobileLayout({super.key});

  static const _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(bookingFormNotifierProvider);
    final booking = formState is BookingFormSuccess ? formState.booking : null;
    final bookingState = ref.watch(bookingNotifierProvider);

    final systemName = bookingState.selectedSystem?.name ?? 'Gaming System';
    final slotStart = bookingState.selectedSlotStart;
    final slotEnd = bookingState.selectedSlotEnd;

    String dateTimeLabel = 'Scheduled session';
    if (slotStart != null) {
      dateTimeLabel =
          '${slotStart.day} ${_monthAbbr[slotStart.month - 1]} · ${_fmt12h(slotStart)}–${_fmt12h(slotEnd!)}';
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),

            // ── Success icon ──
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.okBg,
                shape: BoxShape.circle,
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                color: AppColors.ok,
                size: 40,
              ),
            )
                .animate()
                .scale(begin: const Offset(0, 0), duration: 400.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 200.ms),

            const SizedBox(height: AppSpacing.lg),

            Text('Booking Confirmed!', style: AppTypography.title)
                .animate(delay: 200.ms)
                .fadeIn()
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppSpacing.xs),

            Text(
              'Your slot is locked in.',
              style: AppTypography.bodyR,
            ).animate(delay: 300.ms).fadeIn(),

            const SizedBox(height: AppSpacing.lg),

            // ── Booking ref ──
            if (booking?.id != null)
              GzChip(
                keyLabel: 'REF',
                value: booking!.id!.substring(0, 8).toUpperCase(),
              ).animate(delay: 350.ms).fadeIn(),

            const SizedBox(height: AppSpacing.md),

            // ── Booking summary card ──
            GzCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedComputerDesk01,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(systemName, style: AppTypography.h3),
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.sm),
                  Text(dateTimeLabel, style: AppTypography.bodyR),
                ],
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppSpacing.sm),

            // ── Payment status ──
            GzTag(
              kind: booking?.isPaid == true ? GzTagKind.ok : GzTagKind.warn,
              label: booking?.isPaid == true ? 'Payment confirmed' : 'Pay at store',
            ).animate(delay: 450.ms).fadeIn(),

            const Spacer(),

            // ── CTAs ──
            GzButton(
              label: 'View Booking',
              onPressed: () => context.go(AppRoutes.sessions),
            ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppSpacing.sm),

            GzButton(
              label: 'Back to Home',
              variant: GzButtonVariant.ghost,
              onPressed: () => context.go(AppRoutes.home),
            ).animate(delay: 550.ms).fadeIn(),

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  static String _fmt12h(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$h12:$m $period';
  }
}
