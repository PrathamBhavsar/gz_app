import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  static const _dates = ['Mon 2', 'Tue 3', 'Wed 4', 'Thu 5', 'Fri 6'];
  static const _statuses = [
    'All',
    'Unpaid',
    'Paid',
    'Checked In',
    'No Show',
    'Cancelled',
  ];

  static const _bookings = [
    _BookingData(
      name: 'Rahul M.',
      time: '09:00–11:00',
      system: 'PC Station 01',
      status: GzTagKind.ok,
      statusLabel: 'Paid',
      showAction: true,
    ),
    _BookingData(
      name: 'Priya S.',
      time: '10:00–12:00',
      system: 'PS5 Console',
      status: GzTagKind.warn,
      statusLabel: 'Unpaid',
      showAction: true,
    ),
    _BookingData(
      name: 'Amit K.',
      time: '11:00–13:00',
      system: 'Xbox Series X',
      status: GzTagKind.mute,
      statusLabel: 'Checked In',
    ),
    _BookingData(
      name: 'Neha R.',
      time: '14:00–16:00',
      system: 'VR Pod 01',
      status: GzTagKind.err,
      statusLabel: 'No Show',
    ),
  ];

  String _selectedDate = 'Wed 4';
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Bookings',
        onBack: () => context.go(AppRoutes.adminDashboard),
      ),
      body: SafeArea(
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
                  final date = _dates[index];
                  final active = date == _selectedDate;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: active ? AppColors.rose : AppColors.pillBg,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusPill,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        date,
                        style: AppTypography.num.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? AppColors.surface
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemCount: _dates.length,
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
                    active: status == _selectedStatus,
                    onTap: () => setState(() => _selectedStatus = status),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemCount: _statuses.length,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.rule),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemBuilder: (context, index) {
                  final booking = _bookings[index];
                  return _BookingCard(data: booking);
                },
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemCount: _bookings.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.data});

  final _BookingData data;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Flexible(child: Text(data.name, style: AppTypography.h3)),
                    const SizedBox(width: 8),
                    GzTag(kind: data.status, label: data.statusLabel),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${data.time} · ${data.system}',
                  style: AppTypography.small,
                ),
              ],
            ),
          ),
          if (data.showAction) ...[
            const SizedBox(width: 12),
            SizedBox(
              width: 92,
              child: GzButton(
                label: 'Check In',
                variant: GzButtonVariant.ghost,
                small: true,
                onPressed: () {},
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BookingData {
  const _BookingData({
    required this.name,
    required this.time,
    required this.system,
    required this.status,
    required this.statusLabel,
    this.showAction = false,
  });

  final String name;
  final String time;
  final String system;
  final GzTagKind status;
  final String statusLabel;
  final bool showAction;
}
