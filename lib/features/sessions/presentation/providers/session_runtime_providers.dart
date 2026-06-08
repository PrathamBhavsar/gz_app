import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_runtime_providers.g.dart';

enum SessionUiStatus { confirmed, unpaid, checkedIn, active, completed }

class SessionHubActiveState {
  const SessionHubActiveState({
    required this.sessionId,
    required this.systemName,
    required this.remainingLabel,
  });

  final String sessionId;
  final String systemName;
  final String remainingLabel;

  SessionHubActiveState copyWith({
    String? sessionId,
    String? systemName,
    String? remainingLabel,
  }) {
    return SessionHubActiveState(
      sessionId: sessionId ?? this.sessionId,
      systemName: systemName ?? this.systemName,
      remainingLabel: remainingLabel ?? this.remainingLabel,
    );
  }
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

  UpcomingBookingState copyWith({
    String? id,
    String? system,
    String? date,
    String? time,
    SessionUiStatus? status,
  }) {
    return UpcomingBookingState(
      id: id ?? this.id,
      system: system ?? this.system,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
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

  SessionsHubState copyWith({
    SessionHubActiveState? activeSession,
    bool clearActiveSession = false,
    List<UpcomingBookingState>? upcoming,
    List<PastSessionState>? past,
    DateTime? lastUpdatedAt,
  }) {
    return SessionsHubState(
      activeSession: clearActiveSession
          ? null
          : (activeSession ?? this.activeSession),
      upcoming: upcoming ?? this.upcoming,
      past: past ?? this.past,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
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
  Duration get elapsed => totalDuration - remaining;
  double get elapsedProgress {
    final totalSeconds = totalDuration.inSeconds;
    if (totalSeconds <= 0) {
      return 0;
    }
    final elapsedSeconds = elapsed.inSeconds.clamp(0, totalSeconds);
    return elapsedSeconds / totalSeconds;
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

@Riverpod(keepAlive: true)
class SessionsHub extends _$SessionsHub {
  @override
  SessionsHubState build() {
    return const SessionsHubState(
      activeSession: SessionHubActiveState(
        sessionId: 'sess-001',
        systemName: 'PC Station 03',
        remainingLabel: '1:22:38 remaining',
      ),
      upcoming: [
        UpcomingBookingState(
          id: 'GZ-2406-4891',
          system: 'PC Station 01',
          date: 'Wed 4 Jun',
          time: '6:00 PM',
          status: SessionUiStatus.confirmed,
        ),
        UpcomingBookingState(
          id: 'GZ-2406-4892',
          system: 'PS5 Console',
          date: 'Thu 5 Jun',
          time: '4:00 PM',
          status: SessionUiStatus.unpaid,
        ),
      ],
      past: [
        PastSessionState(
          id: 'GZ-2406-4891',
          store: 'GameZone Koramangala',
          system: 'PC Station 03',
          date: '4 Jun',
          duration: '2h 07m',
          amount: '₹1,740',
        ),
        PastSessionState(
          id: 'GZ-2405-3210',
          store: 'GameZone Indiranagar',
          system: 'PS5 Console',
          date: '28 May',
          duration: '1h 30m',
          amount: '₹1,200',
        ),
        PastSessionState(
          id: 'GZ-2405-2100',
          store: 'GameZone Koramangala',
          system: 'Xbox Series X',
          date: '20 May',
          duration: '3h 00m',
          amount: '₹2,400',
        ),
      ],
    );
  }

  void handleSessionStarted(Map<String, dynamic> payload) {
    final sessionId =
        payload['sessionId']?.toString() ??
        payload['id']?.toString() ??
        state.activeSession?.sessionId ??
        'sess-001';
    final systemName =
        payload['systemName']?.toString() ??
        payload['system']?.toString() ??
        state.activeSession?.systemName ??
        'PC Station 03';
    final remainingLabel = _remainingLabelFromPayload(payload) ?? '2:00:00 remaining';

    state = state.copyWith(
      activeSession: SessionHubActiveState(
        sessionId: sessionId,
        systemName: systemName,
        remainingLabel: remainingLabel,
      ),
      lastUpdatedAt: DateTime.now(),
    );
  }

  void handleSessionEnded(Map<String, dynamic> payload) {
    final sessionId =
        payload['sessionId']?.toString() ?? payload['id']?.toString();
    if (sessionId != null && state.activeSession?.sessionId != sessionId) {
      return;
    }

    state = state.copyWith(
      clearActiveSession: true,
      lastUpdatedAt: DateTime.now(),
    );
  }

  void handleBookingCheckedIn(Map<String, dynamic> payload) {
    final bookingId =
        payload['bookingId']?.toString() ??
        payload['id']?.toString() ??
        payload['referenceId']?.toString();
    if (bookingId == null) {
      return;
    }

    state = state.copyWith(
      upcoming: [
        for (final booking in state.upcoming)
          if (booking.id == bookingId)
            booking.copyWith(status: SessionUiStatus.checkedIn)
          else
            booking,
      ],
      lastUpdatedAt: DateTime.now(),
    );
  }
}

@Riverpod(keepAlive: true)
class BookingDetailStateNotifier extends _$BookingDetailStateNotifier {
  @override
  BookingDetailState build(String id) {
    final bookingId = id.isEmpty ? 'GZ-2406-4891' : id;
    final isPaid = bookingId == 'GZ-2406-4891';
    return BookingDetailState(
      id: bookingId,
      status: SessionUiStatus.confirmed,
      system: isPaid ? 'PC Station 01' : 'PS5 Console',
      seat: isPaid ? 'Seat 3' : 'Bay 2',
      store: 'GameZone Koramangala',
      date: isPaid ? 'Wed, 4 Jun' : 'Thu, 5 Jun',
      time: isPaid ? '6:00 PM – 8:00 PM' : '4:00 PM – 6:00 PM',
      duration: '2 hours',
      total: isPaid ? '₹160' : '₹220',
      paymentStatus: isPaid ? 'Paid' : 'Unpaid',
      primaryActionLabel: isPaid ? 'Check in' : 'Pay now',
    );
  }

  void handleBookingCheckedIn(Map<String, dynamic> payload) {
    final bookingId =
        payload['bookingId']?.toString() ??
        payload['id']?.toString() ??
        payload['referenceId']?.toString();
    if (bookingId == null || bookingId != state.id) {
      return;
    }

    state = state.copyWith(
      status: SessionUiStatus.checkedIn,
      paymentStatus: 'Checked in',
      primaryActionLabel: 'Checked in',
    );
  }
}

@Riverpod(keepAlive: true)
class ActiveSessionDetailStateNotifier
    extends _$ActiveSessionDetailStateNotifier {
  @override
  ActiveSessionDetailState build(String id) {
    final sessionId = id.isEmpty ? 'sess-001' : id;
    final startedAt = DateTime.now().subtract(const Duration(minutes: 37, seconds: 22));
    final endTime = DateTime.now().add(const Duration(hours: 1, minutes: 22, seconds: 38));

    return ActiveSessionDetailState(
      id: sessionId,
      storeName: 'GameZone Koramangala',
      systemName: 'PC Station 03',
      startedAt: startedAt,
      endTime: endTime,
      sessionCode: 'a3f9b2c1',
      events: const [
        SessionEventLogEntry(time: '09:41', event: 'Session started', category: 'Activity'),
        SessionEventLogEntry(time: '09:41', event: 'System online', category: 'System'),
        SessionEventLogEntry(time: '09:45', event: 'Player connected', category: 'Activity'),
      ],
    );
  }

  void extendTimer(DateTime newEndTime) {
    state = state.copyWith(
      endTime: newEndTime,
      events: [
        SessionEventLogEntry(
          time: _formatTime(DateTime.now()),
          event: 'Session extended',
          category: 'Alerts',
        ),
        ...state.events,
      ],
    );
  }
}

String? _remainingLabelFromPayload(Map<String, dynamic> payload) {
  final endTime = _parseDateTime(payload['endTime'] ?? payload['newEndTime']);
  if (endTime == null) {
    return null;
  }

  final remaining = endTime.difference(DateTime.now());
  return '${_formatDuration(remaining)} remaining';
}

DateTime? parseSessionEndTime(Map<String, dynamic> payload) {
  return _parseDateTime(payload['endTime'] ?? payload['newEndTime']);
}

DateTime? _parseDateTime(Object? raw) {
  if (raw == null) {
    return null;
  }
  return DateTime.tryParse(raw.toString());
}

String formatRemaining(Duration duration) => _formatDuration(duration);

String formatElapsed(Duration duration) => _formatDuration(duration);

String _formatDuration(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours.toString().padLeft(2, '0');
  final minutes = (safe.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (safe.inSeconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}

String _formatTime(DateTime timestamp) {
  final hour = timestamp.hour.toString().padLeft(2, '0');
  final minute = timestamp.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
