import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gz_app/core/navigation/routes.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../providers/booking_notifier.dart';
import '../providers/systems_notifier.dart';

class BookingSystemSelectionMobileLayout extends ConsumerWidget {
  const BookingSystemSelectionMobileLayout({super.key});

  static const _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatSlotLabel(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'No slot selected';
    final day = start.day;
    final month = _monthAbbr[start.month - 1];
    final startH = start.hour;
    final endH = end.hour;
    final period = endH >= 12 ? 'PM' : 'AM';
    final s12 = startH > 12 ? startH - 12 : (startH == 0 ? 12 : startH);
    final e12 = endH > 12 ? endH - 12 : (endH == 0 ? 12 : endH);
    return '$day $month · $s12–$e12 $period';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingNotifierProvider);
    final systemsAsync = ref.watch(systemsNotifierProvider);
    final slotLabel = _formatSlotLabel(
      bookingState.selectedSlotStart,
      bookingState.selectedSlotEnd,
    );

    return Column(
      children: [
        GzTopBar(title: 'Choose System'),

        // ── Selected slot chip ──
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                color: AppColors.textTertiary,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.xs),
              GzChip(keyLabel: 'WHEN', value: slotLabel),
            ],
          ),
        ),

        const Divider(height: 1, color: AppColors.divider),

        // ── System list ──
        Expanded(
          child: systemsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (e, _) => PageErrorDisplay(
              error: AppPageError.from(e),
              onRetry: () =>
                  ref.read(systemsNotifierProvider.notifier).refresh(),
            ),
            data: (systems) {
              final available = systems
                  .where((s) => s.status == SystemStatus.available)
                  .toList();
              if (available.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedComputerDesk01,
                          color: AppColors.textMuted,
                          size: 48,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text('No systems available', style: AppTypography.h2),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'All systems are booked for this slot',
                          style: AppTypography.bodyR,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                itemCount: available.length,
                itemBuilder: (_, i) => _SystemPickerRow(
                  system: available[i],
                  onSelect: () {
                    ref
                        .read(bookingNotifierProvider.notifier)
                        .selectSystem(available[i]);
                    context.push(AppRoutes.bookSummary);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SystemPickerRow extends StatelessWidget {
  const _SystemPickerRow({required this.system, required this.onSelect});
  final SystemModel system;
  final VoidCallback onSelect;

  List<List<dynamic>> get _icon => switch (system.platform) {
        SystemPlatform.pc => HugeIcons.strokeRoundedComputerDesk01,
        SystemPlatform.ps5 ||
        SystemPlatform.ps4 =>
          HugeIcons.strokeRoundedGameController02,
        SystemPlatform.xbox => HugeIcons.strokeRoundedGameController01,
        SystemPlatform.vr => HugeIcons.strokeRoundedVirtualRealityVr01,
        _ => HugeIcons.strokeRoundedGameController01,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm + AppSpacing.xs,
        AppSpacing.sm + AppSpacing.xs,
        AppSpacing.sm + AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
            ),
            child: Center(
              child: HugeIcon(
                icon: _icon,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(system.name ?? 'System', style: AppTypography.h3),
                if (system.stationNumber != null)
                  Text(
                    'Seat ${system.stationNumber}',
                    style: AppTypography.small,
                  ),
              ],
            ),
          ),
          GzButton(
            label: 'Select',
            small: true,
            onPressed: onSelect,
          ),
        ],
      ),
    );
  }
}
