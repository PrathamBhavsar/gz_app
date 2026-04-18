import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_auth_provider.dart';
import '../../providers/admin_operations_provider.dart';
import '../../providers/admin_permissions.dart';

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
  DateTime _selectedDate = DateTime.now();
  String _statusFilter = 'All';

  static const _statusOptions = ['All', 'unpaid', 'paid', 'checked_in', 'no_show', 'cancelled'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadBookings());
  }

  void _loadBookings() {
    final dateStr =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    ref
        .read(bookingsProvider.notifier)
        .loadBookings(date: dateStr, status: _statusFilter == 'All' ? null : _statusFilter);
  }

  @override
  Widget build(BuildContext context) {
    final perms = ref.watch(adminPermissionsProvider);
    final canCancel = perms.canCancelBooking;
    final bookingsState = ref.watch(bookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminDashboard),
        ),
        title: Text('Bookings', style: AppTypography.headingSmall),
      ),
      body: Column(
        children: [
          // Date strip
          _buildDateStrip(),
          const SizedBox(height: AppSpacing.md),
          // Status filter chips
          _buildStatusFilters(),
          const SizedBox(height: AppSpacing.md),
          // Bookings list
          Expanded(child: _buildBookingsList(bookingsState, canCancel)),
        ],
      ),
    );
  }

  // ─── Date Strip ─────────────────────────────────────────────────────

  Widget _buildDateStrip() {
    final dates = List.generate(
      7,
      (i) => DateTime.now().add(Duration(days: i - 3)),
    );

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isToday = _isSameDay(date, DateTime.now());
          final isSelected = _isSameDay(date, _selectedDate);
          final dayName = _getDayName(date);
          final dayNum = date.day.toString();

          return GestureDetector(
            onTap: () {
              setState(() => _selectedDate = date);
              _loadBookings();
            },
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
                    dayName,
                    style: AppTypography.caption.copyWith(
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dayNum,
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

  // ─── Status Filters ─────────────────────────────────────────────────

  Widget _buildStatusFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _statusOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final status = _statusOptions[index];
          final isSelected = status == _statusFilter;
          return GestureDetector(
            onTap: () {
              setState(() => _statusFilter = status);
              _loadBookings();
            },
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
                _formatStatusLabel(status),
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected
                      ? AppColors.background
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Bookings List ──────────────────────────────────────────────────

  Widget _buildBookingsList(BookingsState state, bool canCancel) {
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
            Text('Failed to load bookings',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: _loadBookings,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Retry', style: AppTypography.button),
            ),
          ],
        ),
      );
    }

    if (state is BookingsLoaded) {
      if (state.bookings.isEmpty) {
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
                onPressed: () => context.go(AppRoutes.adminWalkIn),
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
        onRefresh: () async => _loadBookings(),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: state.bookings.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final booking = state.bookings[index];
            return _buildBookingCard(booking, canCancel);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, bool canCancel) {
    final playerName = booking['userName']?.toString() ?? 'Unknown Player';
    final systemId = booking['systemId']?.toString() ?? '--';
    final systemName = booking['systemName']?.toString() ?? systemId;
    final startTime = booking['startTime']?.toString() ?? '--';
    final duration = booking['durationMinutes']?.toString() ?? '--';
    final status = booking['status']?.toString() ?? 'unknown';
    final bookingId = booking['id']?.toString() ?? booking['bookingId']?.toString() ?? '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: name + status pill
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
              _buildStatusPill(status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Details row
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
          // Action buttons
          if (status == 'unpaid' || status == 'paid') ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'paid')
                  TextButton(
                    onPressed: () => _handleCheckIn(bookingId),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                    ),
                    child: Text('Check-in', style: AppTypography.bodySmall),
                  ),
                if (canCancel && status != 'cancelled')
                  TextButton(
                    onPressed: () => _handleCancel(bookingId),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
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

  Widget _buildStatusPill(String status) {
    final (color, label) = switch (status) {
      'paid' => (AppColors.success, 'Paid'),
      'unpaid' => (const Color(0xFFFFC107), 'Unpaid'),
      'checked_in' => (const Color(0xFF2196F3), 'Checked In'),
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
        color: color.withOpacity(0.15),
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

  // ─── Actions ────────────────────────────────────────────────────────

  Future<void> _handleCheckIn(String bookingId) async {
    final success =
        await ref.read(bookingsProvider.notifier).checkInBooking(bookingId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Player checked in' : 'Check-in failed'),
          backgroundColor:
              success ? AppColors.success : AppColors.error,
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
        title: Text('Cancel Booking?',
            style: AppTypography.headingSmall
                .copyWith(color: AppColors.textPrimary)),
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
                  borderSide:
                      const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Go back',
                style: AppTypography.button
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Cancel Booking',
                style: AppTypography.button.copyWith(color: AppColors.error)),
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
            content:
                Text(success ? 'Booking cancelled' : 'Cancel failed'),
            backgroundColor:
                success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
    reasonController.dispose();
  }

  // ─── Helpers ────────────────────────────────────────────────────────

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _formatStatusLabel(String status) {
    return switch (status) {
      'All' => 'All',
      'unpaid' => 'Unpaid',
      'paid' => 'Paid',
      'checked_in' => 'Checked-in',
      'no_show' => 'No-show',
      'cancelled' => 'Cancelled',
      _ => status,
    };
  }
}
