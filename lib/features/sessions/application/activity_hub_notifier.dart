import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_systems.dart';
import '../data/repositories/billing_repository.dart';
import '../data/repositories/bookings_repository.dart';
import '../data/repositories/sessions_repository.dart';
import 'session_ui_models.dart';

class ActivityHubNotifier extends AsyncNotifier<SessionsHubState> {
  @override
  Future<SessionsHubState> build() async {
    ref.watch(activeStoreIdProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<SessionsHubState> _load() async {
    final sessionsRepo = ref.read(sessionsRepositoryProvider);
    final bookingsRepo = ref.read(bookingsRepositoryProvider);
    final billingRepo = ref.read(billingRepositoryProvider);

    final results = await Future.wait<dynamic>([
      sessionsRepo.fetchMySessions(),
      bookingsRepo.fetchMyBookings(),
      billingRepo.fetchBillingHistory(),
    ]);

    final sessions = results[0] as List<SessionModel>;
    final bookings = results[1] as List<BookingModel>;
    final billingRows = results[2] as List<BillingRow>;

    final activeSessionModel = sessions.where(_isActiveSession).isEmpty
        ? null
        : sessions.firstWhere(_isActiveSession);
    final activeSession = activeSessionModel == null
        ? null
        : SessionHubActiveState(
            sessionId: activeSessionModel.id ?? '',
            systemName: sessionSystemName(activeSessionModel),
            remainingLabel: _remainingLabel(activeSessionModel),
            elapsedProgress: _elapsedProgress(activeSessionModel),
          );

    final upcoming = bookings
        .where(_isUpcomingBooking)
        .map(_mapUpcomingBooking)
        .toList(growable: false);

    final billingBySession = <String, BillingRow>{
      for (final row in billingRows)
        if (row.sessionId != null && row.sessionId!.isNotEmpty) row.sessionId!: row,
    };

    final past = sessions
        .where(_isPastSession)
        .map((session) => _mapPastSession(session, billingBySession[session.id]))
        .toList(growable: false);

    return SessionsHubState(
      activeSession: activeSession,
      upcoming: upcoming,
      past: past,
      lastUpdatedAt: DateTime.now(),
    );
  }

  void handleSessionStarted(Map<String, dynamic> payload) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final sessionId = payload['sessionId']?.toString() ?? payload['id']?.toString() ?? '';
    final systemName = payload['systemName']?.toString() ?? payload['system']?.toString() ?? 'System';
    final endTime = parseSessionEndTime(payload);
    final remaining = endTime == null
        ? 'Live now'
        : '${formatClockDuration(endTime.difference(DateTime.now()))} remaining';
    state = AsyncData(
      SessionsHubState(
        activeSession: SessionHubActiveState(
          sessionId: sessionId,
          systemName: systemName,
          remainingLabel: remaining,
          elapsedProgress: _elapsedProgressFromPayload(payload),
        ),
        upcoming: current.upcoming,
        past: current.past,
        lastUpdatedAt: DateTime.now(),
      ),
    );
  }

  void handleSessionEnded(Map<String, dynamic> payload) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final sessionId = payload['sessionId']?.toString() ?? payload['id']?.toString();
    if (sessionId != null && current.activeSession?.sessionId != sessionId) {
      return;
    }
    state = AsyncData(
      SessionsHubState(
        activeSession: null,
        upcoming: current.upcoming,
        past: current.past,
        lastUpdatedAt: DateTime.now(),
      ),
    );
  }

  void handleBookingCheckedIn(Map<String, dynamic> payload) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final bookingId =
        payload['bookingId']?.toString() ??
        payload['id']?.toString() ??
        payload['referenceId']?.toString();
    if (bookingId == null) {
      return;
    }
    state = AsyncData(
      SessionsHubState(
        activeSession: current.activeSession,
        upcoming: [
          for (final booking in current.upcoming)
            if (booking.id == bookingId)
              UpcomingBookingState(
                id: booking.id,
                system: booking.system,
                date: booking.date,
                time: booking.time,
                status: SessionUiStatus.checkedIn,
              )
            else
              booking,
        ],
        past: current.past,
        lastUpdatedAt: DateTime.now(),
      ),
    );
  }

  bool _isActiveSession(SessionModel session) {
    return session.status != null && session.status!.name == 'inProgress';
  }

  bool _isPastSession(SessionModel session) {
    return session.status != null &&
        const {'completed', 'cancelled', 'disputed'}.contains(session.status!.name);
  }

  bool _isUpcomingBooking(BookingModel booking) {
    return booking.status != null &&
        const {'pending', 'confirmed', 'checkedIn'}.contains(booking.status!.name);
  }

  UpcomingBookingState _mapUpcomingBooking(BookingModel booking) {
    return UpcomingBookingState(
      id: booking.id ?? '',
      system: bookingSystemName(booking),
      date: formatReadableDate(booking.scheduledStart),
      time: formatReadableTimeRange(booking.scheduledStart, booking.scheduledEnd),
      status: sessionUiStatusFromBooking(booking),
    );
  }

  PastSessionState _mapPastSession(SessionModel session, BillingRow? billing) {
    final duration = _sessionDuration(session, billing);
    return PastSessionState(
      id: session.id ?? '',
      store: billing == null ? 'Gaming Zone' : billingStoreName(billing),
      system: billing == null ? sessionSystemName(session) : billingSystemName(billing),
      date: formatReadableDate(session.startedAt ?? billing?.date),
      duration: formatShortDuration(duration),
      amount: billing == null ? 'Pending' : formatCurrency(billing.amount),
    );
  }

  Duration _sessionDuration(SessionModel session, BillingRow? billing) {
    if (billing?.durationMinutes != null) {
      return Duration(minutes: billing!.durationMinutes!);
    }
    if (session.durationMinutes != null) {
      return Duration(minutes: session.durationMinutes!);
    }
    if (session.startedAt != null && session.endedAt != null) {
      return session.endedAt!.difference(session.startedAt!);
    }
    return Duration.zero;
  }

  String _remainingLabel(SessionModel session) {
    final remaining = _remainingDuration(session);
    return '${formatClockDuration(remaining)} remaining';
  }

  Duration _remainingDuration(SessionModel session) {
    final end = _sessionEnd(session);
    if (end == null) {
      return Duration.zero;
    }
    return end.difference(DateTime.now());
  }

  double _elapsedProgress(SessionModel session) {
    final startedAt = session.startedAt;
    final end = _sessionEnd(session);
    if (startedAt == null || end == null) {
      return 0;
    }

    final total = end.difference(startedAt).inSeconds;
    if (total <= 0) {
      return 0;
    }

    final elapsed = DateTime.now().difference(startedAt).inSeconds;
    return elapsed.clamp(0, total) / total;
  }

  double _elapsedProgressFromPayload(Map<String, dynamic> payload) {
    final startRaw =
        payload['startedAt'] ?? payload['startTime'] ?? payload['started_at'];
    final end = parseSessionEndTime(payload);
    final startedAt = startRaw == null ? null : DateTime.tryParse(startRaw.toString());
    if (startedAt == null || end == null) {
      return 0;
    }
    final total = end.difference(startedAt).inSeconds;
    if (total <= 0) {
      return 0;
    }
    final elapsed = DateTime.now().difference(startedAt).inSeconds;
    return elapsed.clamp(0, total) / total;
  }

  DateTime? _sessionEnd(SessionModel session) {
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
}

final activityHubNotifierProvider =
    AsyncNotifierProvider<ActivityHubNotifier, SessionsHubState>(
      ActivityHubNotifier.new,
    );
