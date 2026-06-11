import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_bookings_notifier.dart';

class BookingManagementScreen extends ConsumerWidget {
  const BookingManagementScreen({super.key});

  static const _statuses = [
    'All',
    'Pending',
    'Confirmed',
    'Checked In',
    'No Show',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(adminBookingsNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Bookings',
        onBack: () => context.go(AppRoutes.adminDashboard),
      ),
      body: bookings.when(
        loading: () => const GzLoadingView(message: 'Loading bookings'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminBookingsNotifierProvider.notifier).refresh(),
        ),
        data: (data) {
          final dateOptions = List<DateTime>.generate(
            5,
            (index) => DateTime.now().add(Duration(days: index - 2)),
          );
          return SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 4),
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final value = dateOptions[index];
                      final active = _isSameDate(value, data.selectedDate);
                      return GzChip(
                        label: _dateChipLabel(value),
                        active: active,
                        onTap: () => ref
                            .read(adminBookingsNotifierProvider.notifier)
                            .selectDate(value),
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemCount: dateOptions.length,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final status = _statuses[index];
                      return GzChip(
                        label: status,
                        active: status == data.selectedStatus,
                        onTap: () => ref
                            .read(adminBookingsNotifierProvider.notifier)
                            .selectStatus(status),
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemCount: _statuses.length,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.rule),
                Expanded(
                  child: data.bookings.isEmpty
                      ? const PageErrorDisplay(error: AppPageError.empty)
                      : RefreshIndicator(
                          onRefresh: () => ref
                              .read(adminBookingsNotifierProvider.notifier)
                              .refresh(),
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemBuilder: (context, index) {
                              final booking = data.bookings[index];
                              return _BookingCard(data: booking);
                            },
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemCount: data.bookings.length,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.data});

  final BookingModel data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.adminBookingDetailPath(data.id ?? '')),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.userName ??
                              data.userId ??
                              data.walkInPhone ??
                              'Player',
                          style: AppTypography.h3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GzTag(
                        kind: _bookingStatusKind(data.status?.name),
                        label: _bookingStatusLabel(data.status?.name),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${data.systemName ?? data.systemId ?? 'System'} · ${_timeRange(data.scheduledStart, data.scheduledEnd)}',
                    style: AppTypography.small,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _amountLabel(data.amount, data.isPaid),
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _dateChipLabel(DateTime value) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${days[value.weekday - 1]} ${value.day}';
}

String _timeRange(DateTime? start, DateTime? end) {
  if (start == null || end == null) {
    return 'Time unavailable';
  }
  String fmt(DateTime value) {
    final hour = value.hour > 12
        ? value.hour - 12
        : (value.hour == 0 ? 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  return '${fmt(start)} - ${fmt(end)}';
}

String _amountLabel(double? amount, bool? isPaid) {
  if (amount == null) {
    return isPaid == true ? 'Paid' : 'Pending payment';
  }
  return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)} · ${isPaid == true ? 'Paid' : 'Unpaid'}';
}

GzTagKind _bookingStatusKind(String? status) {
  switch (status) {
    case 'checkedIn':
      return GzTagKind.ok;
    case 'cancelled':
      return GzTagKind.err;
    case 'noShow':
      return GzTagKind.warn;
    case 'pending':
      return GzTagKind.warn;
    default:
      return GzTagKind.mute;
  }
}

String _bookingStatusLabel(String? status) {
  switch (status) {
    case 'checkedIn':
      return 'Checked In';
    case 'noShow':
      return 'No Show';
    case 'confirmed':
      return 'Confirmed';
    case 'cancelled':
      return 'Cancelled';
    case 'pending':
      return 'Pending';
    default:
      return 'Booked';
  }
}
