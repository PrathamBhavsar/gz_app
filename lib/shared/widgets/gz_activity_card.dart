import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/domain_activity.dart';
import 'gz_card.dart';
import 'gz_tag.dart';

/// Common list row for a session or booking entry in the unified activity feed.
/// Reused by SystemSessionsScreen (incoming/past) and SessionManagementScreen
/// (all/current/incoming/past tabs).
class GzActivityCard extends StatelessWidget {
  const GzActivityCard({super.key, required this.item, this.onTap});

  final AdminActivityItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GzCard(
          padding: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.systemName ?? 'System',
                      style: AppTypography.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GzTag(kind: _tagKind(item), label: _tagLabel(item)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _playerLabel(item),
                style: AppTypography.bodyR.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.userPhone != null || item.walkInPhone != null) ...[
                const SizedBox(height: 2),
                Text(
                  item.userPhone ?? item.walkInPhone ?? '',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_timeLabel(item), style: AppTypography.small),
                  Text(
                    _paymentLabel(item),
                    style: AppTypography.small.copyWith(
                      color: _paymentColor(item),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _playerLabel(AdminActivityItem item) {
  if (item.userName != null && item.userName!.isNotEmpty) {
    return item.userName!;
  }
  if (item.walkInPhone != null && item.walkInPhone!.isNotEmpty) {
    return 'Walk-in · ${item.walkInPhone}';
  }
  return 'Walk-in player';
}

String _timeLabel(AdminActivityItem item) {
  final at = item.bucket == ActivityBucket.incoming
      ? item.startAt
      : (item.startAt ?? item.bookedAt);
  if (at == null) return 'Unavailable';
  final local = at.toLocal();
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final hour = local.hour > 12
      ? local.hour - 12
      : (local.hour == 0 ? 12 : local.hour);
  final minute = local.minute.toString().padLeft(2, '0');
  final suffix = local.hour >= 12 ? 'PM' : 'AM';
  return '${months[local.month - 1]} ${local.day} · $hour:$minute $suffix';
}

String _paymentLabel(AdminActivityItem item) {
  if (item.kind == ActivityKind.session && (item.isBilled ?? false)) {
    final amount = item.billedAmount;
    return amount == null ? 'Billed' : 'Billed ₹${_money(amount)}';
  }
  final amount = item.amount;
  if (item.isPaid == true) {
    return amount == null ? 'Paid' : 'Paid ₹${_money(amount)}';
  }
  return amount == null ? 'Pending' : 'Pending ₹${_money(amount)}';
}

Color _paymentColor(AdminActivityItem item) {
  final settled =
      (item.kind == ActivityKind.session && (item.isBilled ?? false)) ||
      item.isPaid == true;
  return settled ? AppColors.ok : AppColors.warn;
}

String _money(double amount) {
  return amount.truncateToDouble() == amount
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
}

GzTagKind _tagKind(AdminActivityItem item) {
  switch (item.bucket) {
    case ActivityBucket.current:
      return GzTagKind.ok;
    case ActivityBucket.incoming:
      return GzTagKind.info;
    case ActivityBucket.past:
      switch (item.rawStatus) {
        case 'cancelled':
        case 'no_show':
          return GzTagKind.err;
        default:
          return GzTagKind.mute;
      }
    case null:
      return GzTagKind.mute;
  }
}

String _tagLabel(AdminActivityItem item) {
  switch (item.bucket) {
    case ActivityBucket.current:
      return 'Live';
    case ActivityBucket.incoming:
      return item.rawStatus == 'pending' ? 'Booked' : 'Confirmed';
    case ActivityBucket.past:
      switch (item.rawStatus) {
        case 'cancelled':
          return 'Cancelled';
        case 'disputed':
          return 'Disputed';
        case 'no_show':
          return 'No-show';
        default:
          return 'Ended';
      }
    case null:
      return 'Unknown';
  }
}
