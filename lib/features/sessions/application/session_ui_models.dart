import '../../../../models/api_responses.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';

enum SessionUiStatus { confirmed, unpaid, checkedIn, active, completed }

class SessionHubActiveState {
  const SessionHubActiveState({
    required this.sessionId,
    required this.systemName,
    required this.remainingLabel,
    required this.elapsedProgress,
  });

  final String sessionId;
  final String systemName;
  final String remainingLabel;
  final double elapsedProgress;
}

class UpcomingBookingState {
  const UpcomingBookingState({
    required this.id,
    required this.system,
    required this.date,
    required this.time,
    required this.status,
  });

  final String id;
  final String system;
  final String date;
  final String time;
  final SessionUiStatus status;
}

class PastSessionState {
  const PastSessionState({
    required this.id,
    required this.store,
    required this.system,
    required this.date,
    required this.duration,
    required this.amount,
  });

  final String id;
  final String store;
  final String system;
  final String date;
  final String duration;
  final String amount;
}

class SessionsHubState {
  const SessionsHubState({
    required this.activeSession,
    required this.upcoming,
    required this.past,
    this.lastUpdatedAt,
  });

  final SessionHubActiveState? activeSession;
  final List<UpcomingBookingState> upcoming;
  final List<PastSessionState> past;
  final DateTime? lastUpdatedAt;
}

class BookingDetailState {
  const BookingDetailState({
    required this.id,
    required this.status,
    required this.system,
    required this.seat,
    required this.store,
    required this.date,
    required this.time,
    required this.duration,
    required this.total,
    required this.paymentStatus,
    required this.primaryActionLabel,
    required this.isCancelled,
  });

  final String id;
  final SessionUiStatus status;
  final String system;
  final String seat;
  final String store;
  final String date;
  final String time;
  final String duration;
  final String total;
  final String paymentStatus;
  final String primaryActionLabel;
  final bool isCancelled;

  BookingDetailState copyWith({
    String? id,
    SessionUiStatus? status,
    String? system,
    String? seat,
    String? store,
    String? date,
    String? time,
    String? duration,
    String? total,
    String? paymentStatus,
    String? primaryActionLabel,
    bool? isCancelled,
  }) {
    return BookingDetailState(
      id: id ?? this.id,
      status: status ?? this.status,
      system: system ?? this.system,
      seat: seat ?? this.seat,
      store: store ?? this.store,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      total: total ?? this.total,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      primaryActionLabel: primaryActionLabel ?? this.primaryActionLabel,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}

class SessionEventLogEntry {
  const SessionEventLogEntry({
    required this.time,
    required this.event,
    this.category = 'Activity',
  });

  final String time;
  final String event;
  final String category;
}

class ActiveSessionDetailState {
  const ActiveSessionDetailState({
    required this.id,
    required this.storeName,
    required this.systemName,
    required this.startedAt,
    required this.endTime,
    required this.sessionCode,
    required this.events,
  });

  final String id;
  final String storeName;
  final String systemName;
  final DateTime startedAt;
  final DateTime endTime;
  final String sessionCode;
  final List<SessionEventLogEntry> events;

  Duration get totalDuration => endTime.difference(startedAt);
  Duration get remaining => endTime.difference(DateTime.now());
  Duration get elapsed {
    final value = DateTime.now().difference(startedAt);
    if (value.isNegative) {
      return Duration.zero;
    }
    return value > totalDuration ? totalDuration : value;
  }

  double get elapsedProgress {
    final totalSeconds = totalDuration.inSeconds;
    if (totalSeconds <= 0) {
      return 0;
    }
    return elapsed.inSeconds.clamp(0, totalSeconds) / totalSeconds;
  }

  ActiveSessionDetailState copyWith({
    String? id,
    String? storeName,
    String? systemName,
    DateTime? startedAt,
    DateTime? endTime,
    String? sessionCode,
    List<SessionEventLogEntry>? events,
  }) {
    return ActiveSessionDetailState(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      systemName: systemName ?? this.systemName,
      startedAt: startedAt ?? this.startedAt,
      endTime: endTime ?? this.endTime,
      sessionCode: sessionCode ?? this.sessionCode,
      events: events ?? this.events,
    );
  }
}

class SessionHistoryDetailState {
  const SessionHistoryDetailState({
    required this.id,
    required this.systemName,
    required this.storeName,
    required this.startedLabel,
    required this.endedLabel,
    required this.durationLabel,
    required this.rateLabel,
    required this.totalLabel,
    required this.methodLabel,
    required this.statusLabel,
    required this.events,
  });

  final String id;
  final String systemName;
  final String storeName;
  final String startedLabel;
  final String endedLabel;
  final String durationLabel;
  final String rateLabel;
  final String totalLabel;
  final String methodLabel;
  final String statusLabel;
  final List<SessionEventLogEntry> events;
}

BookingDetailState mapBookingDetail(BookingModel booking) {
  final status = sessionUiStatusFromBooking(booking);
  final paymentStatus = booking.isPaid == true ? 'Paid' : 'Unpaid';
  return BookingDetailState(
    id: booking.id ?? '',
    status: status,
    system: bookingSystemName(booking),
    seat: booking.metadata?['seatName']?.toString() ?? 'Seat assigned at check-in',
    store: booking.metadata?['storeName']?.toString() ?? 'Gaming Zone',
    date: formatReadableDateLong(booking.scheduledStart),
    time: formatReadableTimeRange(booking.scheduledStart, booking.scheduledEnd),
    duration: _bookingDurationLabel(booking),
    total: formatCurrency(booking.amount ?? 0),
    paymentStatus: paymentStatus,
    primaryActionLabel: paymentStatus == 'Unpaid' ? 'Pay now' : 'Check in',
    isCancelled: booking.status == BookingStatus.cancelled,
  );
}

ActiveSessionDetailState mapActiveSessionDetail(
  SessionModel session,
  List<SessionLogModel> logs,
) {
  final storeName = session.metadata?['storeName']?.toString() ?? 'Gaming Zone';
  final systemName = sessionSystemName(session);
  final startedAt = session.startedAt ?? DateTime.now();
  final endTime = _sessionEndTime(session) ?? startedAt.add(const Duration(hours: 2));
  return ActiveSessionDetailState(
    id: session.id ?? '',
    storeName: storeName,
    systemName: systemName,
    startedAt: startedAt,
    endTime: endTime,
    sessionCode: (session.id ?? '').replaceAll('-', '').substring(
      0,
      (session.id ?? '').replaceAll('-', '').length.clamp(0, 8),
    ),
    events: logs.map(mapLogEntry).toList(growable: false),
  );
}

SessionHistoryDetailState mapSessionHistoryDetail(
  SessionModel session,
  BillingRow? billing,
  List<SessionLogModel> logs,
) {
  final startedAt = session.startedAt;
  final endedAt = session.endedAt ?? _sessionEndTime(session);
  final duration = endedAt != null && startedAt != null
      ? endedAt.difference(startedAt)
      : Duration(minutes: session.durationMinutes ?? billing?.durationMinutes ?? 0);
  final amount = billing?.amount ?? 0;

  return SessionHistoryDetailState(
    id: session.id ?? '',
    systemName: billing == null ? sessionSystemName(session) : billingSystemName(billing),
    storeName: billing == null ? 'Gaming Zone' : billingStoreName(billing),
    startedLabel: formatReadableTime(startedAt) ?? 'Unknown',
    endedLabel: formatReadableTime(endedAt) ?? 'Unknown',
    durationLabel: formatShortDuration(duration),
    rateLabel: _rateLabel(amount, duration),
    totalLabel: formatCurrency(amount),
    methodLabel: billing?.method?.toUpperCase() ?? 'Unknown',
    statusLabel: formatBillingStatus(billing?.status),
    events: logs.map(mapLogEntry).toList(growable: false),
  );
}

SessionEventLogEntry mapLogEntry(SessionLogModel log) {
  final category = _logCategory(log);
  return SessionEventLogEntry(
    time: formatReadableTime(log.eventAt ?? log.localTime) ?? '--:--',
    event: _logEventLabel(log),
    category: category,
  );
}

DateTime? sessionEndTime(SessionModel session) => _sessionEndTime(session);

DateTime? parseSessionEndTime(Map<String, dynamic> payload) {
  final rawEnd = payload['endTime'] ?? payload['newEndTime'];
  if (rawEnd == null) {
    return null;
  }
  return DateTime.tryParse(rawEnd.toString());
}

DateTime? _sessionEndTime(SessionModel session) {
  final metadata = session.metadata;
  final rawEnd =
      metadata?['endTime'] ?? metadata?['scheduledEnd'] ?? metadata?['scheduled_end'];
  if (rawEnd != null) {
    return DateTime.tryParse(rawEnd.toString());
  }
  if (session.endedAt != null) {
    return session.endedAt;
  }
  if (session.startedAt != null && session.durationMinutes != null) {
    return session.startedAt!.add(Duration(minutes: session.durationMinutes!));
  }
  return null;
}

String _bookingDurationLabel(BookingModel booking) {
  if (booking.scheduledStart != null && booking.scheduledEnd != null) {
    return formatShortDuration(booking.scheduledEnd!.difference(booking.scheduledStart!));
  }
  return 'Duration unavailable';
}

String _rateLabel(double amount, Duration duration) {
  final hours = duration.inMinutes / 60;
  if (hours <= 0) {
    return 'N/A';
  }
  return '${formatCurrency(amount / hours)}/hr';
}

String _logCategory(SessionLogModel log) {
  final source = log.source?.toLowerCase();
  final type = log.eventType?.toLowerCase() ?? '';
  if (source == 'system' || type.contains('system')) {
    return 'System';
  }
  if (type.contains('alert') || type.contains('warning') || type.contains('extend')) {
    return 'Alerts';
  }
  return 'Activity';
}

String _logEventLabel(SessionLogModel log) {
  final metadataMessage = log.metadata?['message']?.toString();
  if (metadataMessage != null && metadataMessage.isNotEmpty) {
    return metadataMessage;
  }

  final eventType = log.eventType?.replaceAll('.', ' ').replaceAll('_', ' ');
  if (eventType == null || eventType.isEmpty) {
    return 'Session updated';
  }

  return eventType
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String formatRemaining(Duration duration) => formatClockDuration(duration);

String formatElapsed(Duration duration) => formatClockDuration(duration);

String formatClockDuration(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours.toString().padLeft(2, '0');
  final minutes = (safe.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (safe.inSeconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}

String formatShortDuration(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours;
  final minutes = safe.inMinutes % 60;
  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }
  return '${safe.inMinutes}m';
}

String formatCurrency(num amount) {
  if (amount == amount.roundToDouble()) {
    return '₹${amount.toInt()}';
  }
  return '₹${amount.toStringAsFixed(2)}';
}

String formatReadableDate(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Unknown date';
  }

  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
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
  final local = dateTime.toLocal();
  return '${weekdays[local.weekday - 1]} ${local.day} ${months[local.month - 1]}';
}

String formatReadableDateLong(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Unknown date';
  }

  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = [
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
  final local = dateTime.toLocal();
  return '${weekdays[local.weekday - 1]}, ${local.day} ${months[local.month - 1]}';
}

String formatReadableTimeRange(DateTime? start, DateTime? end) {
  final startLabel = formatReadableTime(start);
  final endLabel = formatReadableTime(end);
  if (startLabel == null && endLabel == null) {
    return 'Time unavailable';
  }
  if (startLabel != null && endLabel != null) {
    return '$startLabel – $endLabel';
  }
  return startLabel ?? endLabel!;
}

String? formatReadableTime(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }

  final local = dateTime.toLocal();
  final hour = local.hour == 0
      ? 12
      : local.hour > 12
      ? local.hour - 12
      : local.hour;
  final minute = local.minute.toString().padLeft(2, '0');
  final suffix = local.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

String formatBillingStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'paid':
    case 'completed':
      return 'Paid';
    case 'pending':
    case 'unpaid':
      return 'Unpaid';
    case 'overdue':
      return 'Overdue';
    case 'failed':
      return 'Failed';
    case 'refunded':
      return 'Refunded';
    default:
      return 'Unknown';
  }
}

SessionUiStatus sessionUiStatusFromBooking(BookingModel booking) {
  if (booking.status == BookingStatus.checkedIn) {
    return SessionUiStatus.checkedIn;
  }
  if (booking.isPaid == false || booking.status == BookingStatus.pending) {
    return SessionUiStatus.unpaid;
  }
  return SessionUiStatus.confirmed;
}

String sessionSystemName(SessionModel session) {
  final metadata = session.metadata;
  final systemName = metadata?['systemName']?.toString();
  if (systemName != null && systemName.isNotEmpty) {
    return systemName;
  }
  return session.systemId == null || session.systemId!.isEmpty
      ? 'System'
      : 'System ${session.systemId}';
}

String bookingSystemName(BookingModel booking) {
  final metadata = booking.metadata;
  final systemName = metadata?['systemName']?.toString();
  if (systemName != null && systemName.isNotEmpty) {
    return systemName;
  }
  return booking.systemId == null || booking.systemId!.isEmpty
      ? 'System'
      : 'System ${booking.systemId}';
}

String billingSystemName(BillingRow row) {
  if (row.systemName != null && row.systemName!.isNotEmpty) {
    return row.systemName!;
  }
  return 'Session';
}

String billingStoreName(BillingRow row) {
  if (row.storeName != null && row.storeName!.isNotEmpty) {
    return row.storeName!;
  }
  return 'Gaming Zone';
}
