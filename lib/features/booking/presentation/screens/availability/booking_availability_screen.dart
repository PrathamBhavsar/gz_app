import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class BookingAvailabilityScreen extends StatefulWidget {
  const BookingAvailabilityScreen({super.key});

  @override
  State<BookingAvailabilityScreen> createState() =>
      _BookingAvailabilityScreenState();
}

class _BookingAvailabilityScreenState extends State<BookingAvailabilityScreen> {
  static const _days = <_DayOption>[
    _DayOption(label: 'Mon', date: '2'),
    _DayOption(label: 'Tue', date: '3'),
    _DayOption(label: 'Wed', date: '4'),
    _DayOption(label: 'Thu', date: '5'),
    _DayOption(label: 'Fri', date: '6'),
    _DayOption(label: 'Sat', date: '7'),
    _DayOption(label: 'Sun', date: '8'),
  ];

  static const _slots = <_TimeSlot>[
    _TimeSlot('10:00 AM'),
    _TimeSlot('10:30 AM'),
    _TimeSlot('11:00 AM', booked: true),
    _TimeSlot('11:30 AM'),
    _TimeSlot('12:00 PM'),
    _TimeSlot('12:30 PM', booked: true),
    _TimeSlot('1:00 PM'),
    _TimeSlot('1:30 PM'),
    _TimeSlot('2:00 PM', booked: true),
    _TimeSlot('2:30 PM'),
    _TimeSlot('3:00 PM'),
    _TimeSlot('3:30 PM', booked: true),
    _TimeSlot('4:00 PM'),
    _TimeSlot('4:30 PM'),
    _TimeSlot('5:00 PM'),
    _TimeSlot('5:30 PM'),
    _TimeSlot('6:00 PM'),
    _TimeSlot('6:30 PM', booked: true),
    _TimeSlot('7:00 PM'),
    _TimeSlot('7:30 PM'),
    _TimeSlot('8:00 PM'),
    _TimeSlot('8:30 PM', booked: true),
    _TimeSlot('9:00 PM'),
    _TimeSlot('9:30 PM'),
    _TimeSlot('10:00 PM'),
    _TimeSlot('10:30 PM'),
    _TimeSlot('11:00 PM', booked: true),
  ];

  String _selectedDay = 'Wed 4';
  String _selectedSlot = '6:00 PM';

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(
        title: 'Pick a time',
        subtitle: 'RTX 4090 · Seat 3',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 64,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _days.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final day = _days[index];
                        final key = '${day.label} ${day.date}';
                        final isActive = key == _selectedDay;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = key),
                          child: Container(
                            width: 72,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.buttonBg
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusLg,
                              ),
                              border: isActive
                                  ? null
                                  : Border.all(color: AppColors.rule),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  day.label,
                                  style: AppTypography.small.copyWith(
                                    color: isActive
                                        ? AppColors.buttonFg
                                        : AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  day.date,
                                  style: AppTypography.h3.copyWith(
                                    color: isActive
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
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedCalendar01,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text('Choose a 30-minute slot', style: AppTypography.h3),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _slots.map((slot) {
                      final isSelected = slot.label == _selectedSlot;
                      final isBooked = slot.booked;
                      return GestureDetector(
                        onTap: isBooked
                            ? null
                            : () => setState(() => _selectedSlot = slot.label),
                        child: Container(
                          width: 102,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.buttonBg
                                : isBooked
                                ? AppColors.pillBg
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusChip,
                            ),
                            border: isSelected || isBooked
                                ? null
                                : Border.all(color: AppColors.rule),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            slot.label,
                            style: AppTypography.num.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.buttonFg
                                  : isBooked
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
              label: 'Select system →',
              trailing: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.buttonFg,
                size: 18,
              ),
              onPressed: () => context.push(AppRoutes.bookSystems),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayOption {
  const _DayOption({required this.label, required this.date});

  final String label;
  final String date;
}

class _TimeSlot {
  const _TimeSlot(this.label, {this.booked = false});

  final String label;
  final bool booked;
}
