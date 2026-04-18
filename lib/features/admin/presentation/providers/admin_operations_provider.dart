import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_admin.dart';
import '../../data/services/admin_operations_service.dart';
import '../../../../core/network/connectivity_service.dart';
import 'admin_auth_provider.dart';

// ============================================================
// Floor Map State
// ============================================================

sealed class FloorMapState {
  const FloorMapState();
}

class FloorMapInitial extends FloorMapState {
  const FloorMapInitial();
}

class FloorMapLoading extends FloorMapState {
  const FloorMapLoading();
}

class FloorMapLoaded extends FloorMapState {
  final List<LiveSystemStatusModel> systems;
  const FloorMapLoaded(this.systems);
}

class FloorMapError extends FloorMapState {
  final Object error;
  const FloorMapError(this.error);
}

// ============================================================
// Floor Map Notifier
// ============================================================

class FloorMapNotifier extends Notifier<FloorMapState> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  FloorMapState build() {
    final service = ref.watch(adminOperationsServiceProvider);
    final storeId = ref.watch(adminStoreIdProvider);

    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is FloorMapError) {
        loadSystems();
      }
    });

    ref.onDispose(() => _connectivitySub?.cancel());

    // Auto-load if storeId is available
    if (storeId != null) {
      Future.microtask(() => loadSystems());
    }

    return const FloorMapInitial();
  }

  Future<void> loadSystems() async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const FloorMapLoading();
    try {
      final response =
          await ref.read(adminOperationsServiceProvider).getLiveSystems(storeId);
      state = FloorMapLoaded(response.data ?? []);
    } catch (e) {
      state = FloorMapError(e);
    }
  }
}

final floorMapProvider =
    NotifierProvider<FloorMapNotifier, FloorMapState>(FloorMapNotifier.new);

// ============================================================
// Session Detail State
// ============================================================

sealed class SessionDetailState {
  const SessionDetailState();
}

class SessionDetailInitial extends SessionDetailState {
  const SessionDetailInitial();
}

class SessionDetailLoading extends SessionDetailState {
  const SessionDetailLoading();
}

class SessionDetailLoaded extends SessionDetailState {
  final Map<String, dynamic> sessionData;
  const SessionDetailLoaded(this.sessionData);
}

class SessionDetailError extends SessionDetailState {
  final Object error;
  const SessionDetailError(this.error);
}

// ============================================================
// Session Detail Notifier
// ============================================================

class SessionDetailNotifier extends FamilyNotifier<SessionDetailState, String> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  SessionDetailState build(String sessionId) {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is SessionDetailError) {
        loadSession(sessionId);
      }
    });

    ref.onDispose(() => _connectivitySub?.cancel());
    return const SessionDetailInitial();
  }

  Future<void> loadSession(String sessionId) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const SessionDetailLoading();
    try {
      final data = await ref
          .read(adminOperationsServiceProvider)
          .getSessionDetail(storeId, sessionId);
      state = SessionDetailLoaded(data as Map<String, dynamic>);
    } catch (e) {
      state = SessionDetailError(e);
    }
  }

  Future<void> pauseSession(String sessionId) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;
    try {
      await ref
          .read(adminOperationsServiceProvider)
          .pauseSession(storeId, sessionId);
      await loadSession(sessionId);
    } catch (_) {
      // Error handled by UI via state
    }
  }

  Future<void> resumeSession(String sessionId) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;
    try {
      await ref
          .read(adminOperationsServiceProvider)
          .resumeSession(storeId, sessionId);
      await loadSession(sessionId);
    } catch (_) {}
  }

  Future<void> endSession(String sessionId) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;
    try {
      await ref
          .read(adminOperationsServiceProvider)
          .endSession(storeId, sessionId);
      state = const SessionDetailInitial();
    } catch (_) {}
  }

  Future<void> extendSession(String sessionId, int extraMinutes) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;
    try {
      await ref
          .read(adminOperationsServiceProvider)
          .extendSession(storeId, sessionId, extraMinutes);
      await loadSession(sessionId);
    } catch (_) {}
  }
}

final sessionDetailProvider = FamilyNotifierProvider<SessionDetailNotifier,
    SessionDetailState, String>(SessionDetailNotifier.new);

// ============================================================
// Bookings State
// ============================================================

sealed class BookingsState {
  const BookingsState();
}

class BookingsInitial extends BookingsState {
  const BookingsInitial();
}

class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

class BookingsLoaded extends BookingsState {
  final List<Map<String, dynamic>> bookings;
  const BookingsLoaded(this.bookings);
}

class BookingsError extends BookingsState {
  final Object error;
  const BookingsError(this.error);
}

// ============================================================
// Bookings Notifier
// ============================================================

class BookingsNotifier extends Notifier<BookingsState> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  BookingsState build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is BookingsError) {
        loadBookings();
      }
    });

    ref.onDispose(() => _connectivitySub?.cancel());

    // Auto-load
    Future.microtask(() => loadBookings());
    return const BookingsInitial();
  }

  Future<void> loadBookings({String? date, String? status}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const BookingsLoading();
    try {
      final data = await ref
          .read(adminOperationsServiceProvider)
          .getBookings(storeId, date: date, status: status);
      final list = data is List
          ? data.cast<Map<String, dynamic>>()
          : <Map<String, dynamic>>[];
      state = BookingsLoaded(list);
    } catch (e) {
      state = BookingsError(e);
    }
  }

  Future<bool> checkInBooking(String bookingId) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref
          .read(adminOperationsServiceProvider)
          .checkInBooking(storeId, bookingId);
      await loadBookings();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cancelBooking(String bookingId, {String? reason}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref
          .read(adminOperationsServiceProvider)
          .cancelBooking(storeId, bookingId, reason: reason);
      await loadBookings();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final bookingsProvider =
    NotifierProvider<BookingsNotifier, BookingsState>(BookingsNotifier.new);

// ============================================================
// Walk-in State
// ============================================================

sealed class WalkInState {
  const WalkInState();
}

class WalkInIdle extends WalkInState {
  const WalkInIdle();
}

class WalkInLoading extends WalkInState {
  const WalkInLoading();
}

class WalkInSuccess extends WalkInState {
  final WalkInBookingResponse response;
  const WalkInSuccess(this.response);
}

class WalkInError extends WalkInState {
  final Object error;
  const WalkInError(this.error);
}

// ============================================================
// Walk-in Notifier
// ============================================================

class WalkInNotifier extends Notifier<WalkInState> {
  @override
  WalkInState build() => const WalkInIdle();

  Future<void> createWalkIn({
    required String userId,
    required String systemId,
    required int durationMinutes,
    String? paymentMethod,
  }) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const WalkInLoading();
    try {
      final response = await ref
          .read(adminOperationsServiceProvider)
          .createWalkIn(
            storeId: storeId,
            userId: userId,
            systemId: systemId,
            durationMinutes: durationMinutes,
            paymentMethod: paymentMethod,
          );
      if (response.data != null) {
        state = WalkInSuccess(response.data!);
      } else {
        state = const WalkInError('No data returned');
      }
    } catch (e) {
      state = WalkInError(e);
    }
  }

  void reset() => state = const WalkInIdle();
}

final walkInProvider =
    NotifierProvider<WalkInNotifier, WalkInState>(WalkInNotifier.new);
