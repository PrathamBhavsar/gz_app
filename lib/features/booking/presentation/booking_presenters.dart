import 'package:hugeicons/hugeicons.dart';

import '../../../models/api_responses.dart';
import '../../../models/domain_loyalty.dart';
import '../../../models/domain_systems.dart';
import '../../../models/enums.dart';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatBookingDate(DateTime value) {
  final weekday = _weekdays[value.weekday - 1];
  final month = _months[value.month - 1];
  return '$weekday, ${value.day} $month';
}

String formatDateChipLabel(DateTime value) => _weekdays[value.weekday - 1];

String formatMonthDay(DateTime value) =>
    '${value.day} ${_months[value.month - 1]}';

String formatTimeLabel(DateTime value) {
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

String formatTimeRange(DateTime start, DateTime end) {
  return '${formatTimeLabel(start)} - ${formatTimeLabel(end)}';
}

String formatSlotRange(AvailabilitySlot slot) {
  final start = parseSlotTime(slot.startTime);
  final end = parseSlotTime(slot.endTime);
  if (start == null || end == null) {
    return 'Time unavailable';
  }
  return formatTimeRange(start, end);
}

String formatPricePerHour(double? value) {
  if (value == null) {
    return 'Rate unavailable';
  }
  final whole = value % 1 == 0;
  return whole
      ? 'Rs ${value.toStringAsFixed(0)}/hr'
      : 'Rs ${value.toStringAsFixed(2)}/hr';
}

String formatCurrency(double? value) {
  final amount = value ?? 0;
  final whole = amount % 1 == 0;
  return whole
      ? 'Rs ${amount.toStringAsFixed(0)}'
      : 'Rs ${amount.toStringAsFixed(2)}';
}

double campaignDiscountEstimate(CampaignModel? campaign, double subtotal) {
  if (campaign == null) {
    return 0;
  }
  final value = campaign.value ?? 0;
  return switch (campaign.campaignType) {
    CampaignType.percentageOff => subtotal * (value / 100),
    CampaignType.fixedOff => value,
    _ => 0,
  };
}

String campaignValueLabel(CampaignModel campaign) {
  final value = campaign.value ?? 0;
  final whole = value % 1 == 0;
  final numeric = whole ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  return switch (campaign.campaignType) {
    CampaignType.percentageOff => '$numeric% off',
    CampaignType.fixedOff => '${formatCurrency(value)} off',
    CampaignType.bonusMinutes => '$numeric bonus min',
    CampaignType.bonusCredits => '$numeric bonus credits',
    CampaignType.happyHour => 'Happy hour',
    CampaignType.firstVisit => 'First visit',
    null => 'Offer',
  };
}

int? slotDurationMinutes(AvailabilitySlot? slot) {
  final start = parseSlotTime(slot?.startTime);
  final end = parseSlotTime(slot?.endTime);
  if (start == null || end == null) {
    return null;
  }
  return end.difference(start).inMinutes;
}

String formatDurationLabel(int minutes) {
  if (minutes % 60 == 0) {
    final hours = minutes ~/ 60;
    return hours == 1 ? '1 hour' : '$hours hours';
  }
  return '$minutes min';
}

DateTime? parseSlotTime(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return DateTime.tryParse(value);
}

String systemSeatLabel(SystemModel system) {
  final stationNumber = system.stationNumber;
  if (stationNumber != null) {
    return 'Seat $stationNumber';
  }
  return 'Seat unassigned';
}

String systemSpecsLabel(SystemModel system) {
  final parts = <String>[];
  final platform = systemPlatformLabel(system.platform);
  if (platform != 'All') {
    parts.add(platform);
  }
  final specs = system.specs;
  if (specs != null) {
    final gpu = specs['gpu']?.toString();
    final ram = specs['ram']?.toString();
    final display = specs['display']?.toString();
    if (gpu != null && gpu.isNotEmpty) {
      parts.add(gpu);
    }
    if (ram != null && ram.isNotEmpty) {
      parts.add(ram);
    }
    if (display != null && display.isNotEmpty) {
      parts.add(display);
    }
  }
  if (parts.isEmpty) {
    return 'Specs unavailable';
  }
  return parts.join(' · ');
}

const bookingSlotDurationMinutes = 60;
const bookingWindowStartHour = 10;
const bookingWindowEndHour = 23;

/// Hourly booking start times for [date], each [bookingSlotDurationMinutes]
/// long, bounded by the store's assumed [bookingWindowStartHour]-
/// [bookingWindowEndHour] window. Past start times are excluded when [date]
/// is today.
List<DateTime> generateBookingSlotStarts(DateTime date) {
  final now = DateTime.now();
  final isToday =
      date.year == now.year && date.month == now.month && date.day == now.day;
  final starts = <DateTime>[];
  for (var hour = bookingWindowStartHour; hour < bookingWindowEndHour; hour++) {
    final start = DateTime(date.year, date.month, date.day, hour);
    if (isToday && !start.isAfter(now)) {
      continue;
    }
    starts.add(start);
  }
  return starts;
}

dynamic platformIcon(SystemPlatform? platform) => switch (platform) {
  SystemPlatform.pc => HugeIcons.strokeRoundedComputerDesk01,
  SystemPlatform.ps4 ||
  SystemPlatform.ps5 => HugeIcons.strokeRoundedGameController02,
  SystemPlatform.xbox => HugeIcons.strokeRoundedGameController01,
  SystemPlatform.vr => HugeIcons.strokeRoundedVirtualRealityVr01,
  SystemPlatform.other || null => HugeIcons.strokeRoundedComputerDesk01,
};

String systemPlatformLabel(SystemPlatform? platform) => switch (platform) {
  null => 'All',
  SystemPlatform.pc => 'PC',
  SystemPlatform.ps5 => 'PS5',
  SystemPlatform.ps4 => 'PS4',
  SystemPlatform.xbox => 'Xbox',
  SystemPlatform.vr => 'VR',
  SystemPlatform.other => 'Other',
};
