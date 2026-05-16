import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_operations_provider.dart';
import '../../providers/admin_permissions.dart';

final _bookingDateProvider =
    StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
final _bookingStatusFilterProvider =
    StateProvider.autoDispose<String>((ref) => 'All');

/// Booking Management — Screen 45.
/// Centralized view of all scheduled reservations.
class BookingManagementScreen extends ConsumerStatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  ConsumerState<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState
    extends ConsumerState<BookingManagementScreen> {
  static const _statusOptions = [
    'All',
    'unpaid',
    'paid',
    'checked_in',
    'no_show',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadBookings());
  }

  void _loadBookings([DateTime? overrideDate, String? overrideStatus]) {
    final DateTime date = overrideDate ?? ref.read(_bookingDateProvider);
    final status = overrideStatus ?? ref.read(_bookingStatusFilterProvider);
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    ref
        .read(bookingsProvider.notifier)
        .loadBookings(date: dateStr, status: status == 'All' ? null : status);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(_bookingDateProvider);
    final statusFilter = ref.watch(_bookingStatusFilterProvider);
    final perms = ref.watch(adminPermissionsProvider);
    final canCancel = perms.canCancelBooking;
    final bookingsState = ref.watch(bookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.go(AppRoutes.adminDashboard),
        ),
        title: Text('Bookings', style: AppTypography.headingSmall),
      ),
      body: Column(
        children: [
          _DateStrip(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              ref.read(_bookingDateProvider.notifier).state = date;
              _loadBookings(date);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _StatusFilters(
            statusFilter: statusFilter,
            statusOptions: _statusOptions,
            onStatusSelected: (status) {
              ref.read(_bookingStatusFilterProvider.notifier).state = status;
              _loadBookings(null, status);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: _BookingsList(
              state: bookingsState,
              canCancel: canCancel,
              onRetry: _loadBookings,
              onRefresh: () async => _loadBookings(),
              onStartWalkIn: () => context.go(AppRoutes.adminWalkIn),
              onCheckIn: _handleCheckIn,
              onCancel: _handleCancel,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckIn(String bookingId) async {
    final success =
        await ref.read(bookingsProvider.notifier).checkInBooking(bookingId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Player checked in' : 'Check-in failed'),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleCancel(String bookingId) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Cancel Booking?',
          style: AppTypography.headingSmall
              .copyWith(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please provide a reason for cancellation:',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: reasonController,
              style: AppTypography.bodyLarge,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Reason (optional)',
                hintStyle: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: Text(
              'Go back',
              style:
                  AppTypography.button.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: Text(
              'Cancel Booking',
              style: AppTypography.button.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref
          .read(bookingsProvider.notifier)
          .cancelBooking(bookingId, reason: reasonController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Booking cancelled' : 'Cancel failed'),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
    reasonController.dispose();
  }
}

// ─── Date Strip ───────────────────────────────────────────────────────────────

class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.selectedDate,
    required this.onDateSelected,
  });
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i - 3)));

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isToday = _isSameDay(date, DateTime.now());
          final isSelected = _isSameDay(date, selectedDate);

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.rose : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayName(date),
                    style: AppTypography.caption.copyWith(
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date.day.toString(),
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isToday && !isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.rose,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Status Filters ───────────────────────────────────────────────────────────

class _StatusFilters extends StatelessWidget {
  const _StatusFilters({
    required this.statusFilter,
    required this.statusOptions,
    required this.onStatusSelected,
  });
  final String statusFilter;
  final List<String> statusOptions;
  final void Function(String) onStatusSelected;

  static String _formatLabel(String status) => switch (status) {
        'All' => 'All',
        'unpaid' => 'Unpaid',
        'paid' => 'Paid',
        'checked_in' => 'Checked-in',
        'no_show' => 'No-show',
        'cancelled' => 'Cancelled',
        _ => status,
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: statusOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final status = statusOptions[index];
          final isSelected = status == statusFilter;
          return GestureDetector(
            onTap: () => onStatusSelected(status),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.rose : AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
                border: Border.all(
                  color: isSelected ? AppColors.rose : AppColors.border,
                ),
              ),
              child: Text(
                _formatLabel(status),
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected
                      ? AppColors.background
                      : AppColors.textSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Bookings List ────────────────────────────────────────────────────────────

class _BookingsList extends StatelessWidget {
  const _BookingsList({
    required this.state,
    required this.canCancel,
    required this.onRetry,
    required this.onRefresh,
    required this.onStartWalkIn,
    required this.onCheckIn,
    required this.onCancel,
  });
  final BookingsState state;
  final bool canCancel;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final VoidCallback onStartWalkIn;
  final Future<void> Function(String) onCheckIn;
  final Future<void> Function(String) onCancel;

  @override
  Widget build(BuildContext context) {
    if (state is BookingsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.rose),
      );
    }

    if (state is BookingsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load bookings',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Retry', style: AppTypography.button),
            ),
          ],
        ),
      );
    }

    if (state is BookingsLoaded) {
      final bookings = (state as BookingsLoaded).bookings;

      if (bookings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedCalendar03,
                color: AppColors.textSecondary,
                size: 64,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No bookings for this date',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onStartWalkIn,
                child: Text(
                  'Start a walk-in?',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.rose),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: onRefresh,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: bookings.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _BookingCard(
              booking: booking,
              canCancel: canCancel,
              onCheckIn: onCheckIn,
              onCancel: onCancel,
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ─── Booking Card ─────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.canCancel,
    required this.onCheckIn,
    required this.onCancel,
  });
  final Map<String, dynamic> booking;
  final bool canCancel;
  final Future<void> Function(String) onCheckIn;
  final Future<void> Function(String) onCancel;

  @override
  Widget build(BuildContext context) {
    final playerName = booking['userName']?.toString() ?? 'Unknown Player';
    final systemId = booking['systemId']?.toString() ?? '--';
    final systemName = booking['systemName']?.toString() ?? systemId;
    final startTime = booking['startTime']?.toString() ?? '--';
    final duration = booking['durationMinutes']?.toString() ?? '--';
    final status = booking['status']?.toString() ?? 'unknown';
    final bookingId = booking['id']?.toString() ??
        booking['bookingId']?.toString() ??
        '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  playerName,
                  style: AppTypography.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusPill(status: status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedGameboy,
                color: AppColors.textSecondary,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                systemName,
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                color: AppColors.textSecondary,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '$startTime · ${duration}m',
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          if (status == 'unpaid' || status == 'paid') ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'paid')
                  TextButton(
                    onPressed: () => onCheckIn(bookingId),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm),
                    ),
                    child: Text('Check-in', style: AppTypography.bodySmall),
                  ),
                if (canCancel && status != 'cancelled')
                  TextButton(
                    onPressed: () => onCancel(bookingId),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm),
                    ),
                    child: Text('Cancel', style: AppTypography.bodySmall),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Status Pill ──────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      'paid' => (AppColors.success, 'Paid'),
      'unpaid' => (AppColors.warn, 'Unpaid'),
      'checked_in' => (AppColors.info, 'Checked In'),
      'no_show' => (AppColors.error, 'No Show'),
      'cancelled' => (AppColors.textSecondary, 'Cancelled'),
      _ => (AppColors.textSecondary, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
