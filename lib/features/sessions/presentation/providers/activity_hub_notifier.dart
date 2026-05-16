import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../features/booking/data/repositories/booking_repository.dart';
import '../../../../features/sessions/data/repositories/sessions_repository.dart';
import '../../../../models/domain_systems.dart';

/// Aggregated data for the Activity Hub (My Games screen).
class ActivityHubData {
  final List<BookingModel> upcomingBookings; // status: confirmed, pending
  final BookingModel? activeBooking;          // status: checked_in
  final SessionModel? activeSession;          // in_progress
  final List<SessionModel> history;           // completed, cancelled

  const ActivityHubData({
    this.upcomingBookings = const [],
    this.activeBooking,
    this.activeSession,
    this.history = const [],
  });
}

/// UI-only state for the Activity Hub tab/expand/pay-sheet layer.
class ActivityHubUiState {
  const ActivityHubUiState({
    this.tab = 'upcoming',
    this.expandedHistId,
    this.showPaySheet = false,
  });

  final String tab;
  final String? expandedHistId;
  final bool showPaySheet;

  ActivityHubUiState copyWith({
    String? tab,
    Object? expandedHistId = _sentinel,
    bool? showPaySheet,
  }) {
    return ActivityHubUiState(
      tab: tab ?? this.tab,
      expandedHistId:
          expandedHistId == _sentinel ? this.expandedHistId : expandedHistId as String?,
      showPaySheet: showPaySheet ?? this.showPaySheet,
    );
  }

  static const Object _sentinel = Object();
}

/// Combined state exposed to the UI.
class ActivityHubState {
  const ActivityHubState({
    this.data = const AsyncLoading(),
    this.ui = const ActivityHubUiState(),
  });

  final AsyncValue<ActivityHubData> data;
  final ActivityHubUiState ui;

  ActivityHubState copyWith({
    AsyncValue<ActivityHubData>? data,
    ActivityHubUiState? ui,
  }) {
    return ActivityHubState(
      data: data ?? this.data,
      ui: ui ?? this.ui,
    );
  }

  // ── Convenience passthrough getters ──
  String get tab => ui.tab;
  String? get expandedHistId => ui.expandedHistId;
  bool get showPaySheet => ui.showPaySheet;
}

class ActivityHubNotifier extends Notifier<ActivityHubState> {
  @override
  ActivityHubState build() {
    _fetch();
    return const ActivityHubState();
  }

  Future<void> _fetch() async {
    state = state.copyWith(data: const AsyncLoading());
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final bookingRepo = ref.read(bookingRepositoryProvider);
      final sessionRepo = ref.read(sessionsRepositoryProvider);

      // Run booking fetches in parallel
      final bookingResults = await Future.wait([
        bookingRepo.fetchMyBookings(storeId, status: 'confirmed'),
        bookingRepo.fetchMyBookings(storeId, status: 'pending'),
        bookingRepo.fetchMyBookings(storeId, status: 'checked_in'),
      ]);

      // Run session fetches in parallel
      final sessionResults = await Future.wait([
        sessionRepo.fetchSessions(storeId, status: 'in_progress'),
        sessionRepo.fetchSessions(storeId, status: 'completed'),
        sessionRepo.fetchSessions(storeId, status: 'cancelled'),
      ]);

      final confirmedBookings = bookingResults[0].data ?? [];
      final pendingBookings = bookingResults[1].data ?? [];
      final checkedInBookings = bookingResults[2].data ?? [];
      final inProgressSessions = sessionResults[0].data ?? [];
      final completedSessions = sessionResults[1].data ?? [];
      final cancelledSessions = sessionResults[2].data ?? [];

      final upcoming = [...confirmedBookings, ...pendingBookings];
      final activeBooking =
          checkedInBookings.isNotEmpty ? checkedInBookings.first as BookingModel? : null;
      final activeSession =
          inProgressSessions.isNotEmpty ? inProgressSessions.first as SessionModel? : null;
      final history = [...completedSessions, ...cancelledSessions];

      state = state.copyWith(
        data: AsyncData(
          ActivityHubData(
            upcomingBookings: upcoming,
            activeBooking: activeBooking,
            activeSession: activeSession,
            history: history,
          ),
        ),
      );
    } catch (e, st) {
      state = state.copyWith(data: AsyncError(e, st));
    }
  }

  Future<void> refresh() => _fetch();

  // ── UI mutations ──
  void setTab(String t) =>
      state = state.copyWith(ui: state.ui.copyWith(tab: t, showPaySheet: false));

  void toggleHist(String id) {
    final next = state.expandedHistId == id ? null : id;
    state = state.copyWith(ui: state.ui.copyWith(expandedHistId: next));
  }

  void showPay() =>
      state = state.copyWith(ui: state.ui.copyWith(showPaySheet: true));
  void closePay() =>
      state = state.copyWith(ui: state.ui.copyWith(showPaySheet: false));
}

final activityHubProvider =
    NotifierProvider<ActivityHubNotifier, ActivityHubState>(
  () => ActivityHubNotifier(),
);
