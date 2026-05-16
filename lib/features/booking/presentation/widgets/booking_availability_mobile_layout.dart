import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/api_responses.dart';
import '../../../../../shared/widgets/em_button.dart';
import '../../../../../shared/widgets/em_tag.dart';
import '../../../../../shared/widgets/em_top_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../providers/availability_notifier.dart';
import '../providers/booking_notifier.dart';

class BookingAvailabilityMobileLayout extends ConsumerStatefulWidget {
  const BookingAvailabilityMobileLayout({super.key});

  @override
  ConsumerState<BookingAvailabilityMobileLayout> createState() =>
      _BookingAvailabilityMobileLayoutState();
}

class _BookingAvailabilityMobileLayoutState
    extends ConsumerState<BookingAvailabilityMobileLayout> {
  late DateTime _selectedDate;
  final _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = _today;
    Future.microtask(
      () => ref
          .read(availabilityNotifierProvider.notifier)
          .fetchForDate(_selectedDate),
    );
  }

  List<DateTime> get _next7Days => List.generate(
        7,
        (i) => _today.add(Duration(days: i)),
      );

  static const _dayAbbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _dayLabel(DateTime d) => _dayAbbr[d.weekday - 1];
  String _monthLabel(DateTime d) => _monthAbbr[d.month - 1];

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    ref.read(availabilityNotifierProvider.notifier).fetchForDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final availAsync = ref.watch(availabilityNotifierProvider);
    final selectedSlot = availAsync.valueOrNull?.selectedSlotStart;

    return Column(
      children: [
        EmTopBar(title: 'Pick a slot'),

        // ── Date strip ──
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
            itemCount: 7,
            itemBuilder: (_, i) {
              final date = _next7Days[i];
              final isSelected = date.day == _selectedDate.day &&
                  date.month == _selectedDate.month;
              return GestureDetector(
                onTap: () => _onDateSelected(date),
                child: Container(
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.buttonBg : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _dayLabel(date),
                        style: AppTypography.small.copyWith(
                          color: isSelected
                              ? AppColors.buttonFg.withValues(alpha: 0.7)
                              : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: AppTypography.h3.copyWith(
                          color: isSelected
                              ? AppColors.buttonFg
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _monthLabel(date),
                        style: AppTypography.small.copyWith(
                          fontSize: 10,
                          color: isSelected
                              ? AppColors.buttonFg.withValues(alpha: 0.7)
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.sm),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: AppSpacing.xs),

        // ── Slot list ──
        Expanded(
          child: availAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (e, _) => PageErrorDisplay(
              error: AppPageError.from(e),
              onRetry: () => ref
                  .read(availabilityNotifierProvider.notifier)
                  .fetchForDate(_selectedDate),
            ),
            data: (data) {
              if (data.slots.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedCalendar01,
                          color: AppColors.textMuted,
                          size: 48,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text('No slots available', style: AppTypography.h2),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Try a different date',
                          style: AppTypography.bodyR,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                itemCount: data.slots.length,
                itemBuilder: (_, i) => _SlotRow(
                  slot: data.slots[i],
                  isSelected: data.selectedSlotStart == data.slots[i].startTime,
                  onTap: () => ref
                      .read(availabilityNotifierProvider.notifier)
                      .selectSlot(
                        data.slots[i].startTime ?? '',
                        data.slots[i].endTime ?? '',
                      ),
                ),
              );
            },
          ),
        ),

        // ── Sticky bottom CTA ──
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: EmButtonFull(
              label: 'Select System',
              onPressed: selectedSlot == null
                  ? null
                  : () {
                      final avail =
                          ref.read(availabilityNotifierProvider).valueOrNull;
                      if (avail == null) return;
                      // Store selected slot in booking flow notifier
                      final start = DateTime.tryParse(avail.selectedSlotStart!);
                      final end = DateTime.tryParse(avail.selectedSlotEnd!);
                      if (start != null && end != null) {
                        ref
                            .read(bookingNotifierProvider.notifier)
                            .selectSlot(start, end);
                      }
                      context.push('/book/systems');
                    },
            ),
          ),
        ),
      ],
    );
  }
}

class _SlotRow extends StatelessWidget {
  const _SlotRow({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  final AvailabilitySlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  bool get _isBooked => slot.status == 'booked' || slot.status == 'unavailable';

  String _formatTime(String? isoTime) {
    if (isoTime == null) return '—';
    try {
      final dt = DateTime.parse(isoTime).toLocal();
      final h = dt.hour;
      final m = dt.minute.toString().padLeft(2, '0');
      final period = h >= 12 ? 'PM' : 'AM';
      final hour12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '$hour12:$m $period';
    } catch (_) {
      return isoTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isBooked ? 0.45 : 1.0,
      child: GestureDetector(
        onTap: _isBooked ? null : onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceTint : AppColors.surface,
            borderRadius:
                BorderRadius.circular(AppSpacing.borderRadiusLg),
            border: isSelected
                ? Border.all(color: AppColors.ok, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_formatTime(slot.startTime)} – ${_formatTime(slot.endTime)}',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (slot.systemCount != null && !_isBooked)
                Text(
                  '${slot.systemCount} systems',
                  style: AppTypography.small,
                ),
              const SizedBox(width: AppSpacing.sm),
              EmTag(
                kind: _isBooked ? EmTagKind.mute : EmTagKind.ok,
                label: _isBooked ? 'Full' : 'Open',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
