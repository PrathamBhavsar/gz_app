import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_analytics.dart';
import '../../data/services/admin_analytics_service.dart';
import '../../../../core/network/connectivity_service.dart';
import 'admin_auth_provider.dart';

// ============================================================
// Generic Analytics State — reused for all 6 analytics screens
// ============================================================

sealed class AnalyticsState<T> {
  const AnalyticsState();
}

class AnalyticsInitial<T> extends AnalyticsState<T> {
  const AnalyticsInitial();
}

class AnalyticsLoading<T> extends AnalyticsState<T> {
  const AnalyticsLoading();
}

class AnalyticsLoaded<T> extends AnalyticsState<T> {
  final T data;
  const AnalyticsLoaded(this.data);
}

class AnalyticsError<T> extends AnalyticsState<T> {
  final Object error;
  const AnalyticsError(this.error);
}

// ============================================================
// Dashboard Provider (Screen 46)
// ============================================================

class DashboardNotifier extends Notifier<AnalyticsState<AnalyticsDashboardModel>> {
  StreamSubscription<bool>? _connectivitySub;
  String? _dateFrom;
  String? _dateTo;

  @override
  AnalyticsState<AnalyticsDashboardModel> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is AnalyticsError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const AnalyticsInitial();
  }

  Future<void> load({String? dateFrom, String? dateTo}) async {
    _dateFrom = dateFrom;
    _dateTo = dateTo;
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const AnalyticsLoading();
    try {
      final response = await ref
          .read(adminAnalyticsServiceProvider)
          .getDashboard(storeId, dateFrom: dateFrom, dateTo: dateTo);
      if (response.data != null) {
        state = AnalyticsLoaded(response.data!);
      } else {
        state = const AnalyticsError('No data returned');
      }
    } catch (e) {
      state = AnalyticsError(e);
    }
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier,
    AnalyticsState<AnalyticsDashboardModel>>(DashboardNotifier.new);

// ============================================================
// Revenue Provider (Screen 47)
// ============================================================

class RevenueNotifier
    extends Notifier<AnalyticsState<RevenueAnalyticsModel>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  AnalyticsState<RevenueAnalyticsModel> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is AnalyticsError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const AnalyticsInitial();
  }

  Future<void> load({String? dateFrom, String? dateTo, String? groupBy}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const AnalyticsLoading();
    try {
      final response = await ref
          .read(adminAnalyticsServiceProvider)
          .getRevenue(storeId, dateFrom: dateFrom, dateTo: dateTo, groupBy: groupBy);
      if (response.data != null) {
        state = AnalyticsLoaded(response.data!);
      } else {
        state = const AnalyticsError('No data returned');
      }
    } catch (e) {
      state = AnalyticsError(e);
    }
  }
}

final revenueProvider = NotifierProvider<RevenueNotifier,
    AnalyticsState<RevenueAnalyticsModel>>(RevenueNotifier.new);

// ============================================================
// Utilization Provider (Screen 48)
// ============================================================

class UtilizationNotifier
    extends Notifier<AnalyticsState<UtilizationModel>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  AnalyticsState<UtilizationModel> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is AnalyticsError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const AnalyticsInitial();
  }

  Future<void> load({String? dateFrom, String? dateTo}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const AnalyticsLoading();
    try {
      final response = await ref
          .read(adminAnalyticsServiceProvider)
          .getUtilization(storeId, dateFrom: dateFrom, dateTo: dateTo);
      if (response.data != null) {
        state = AnalyticsLoaded(response.data!);
      } else {
        state = const AnalyticsError('No data returned');
      }
    } catch (e) {
      state = AnalyticsError(e);
    }
  }
}

final utilizationProvider = NotifierProvider<UtilizationNotifier,
    AnalyticsState<UtilizationModel>>(UtilizationNotifier.new);

// ============================================================
// Session Stats Provider (Screen 49)
// ============================================================

class SessionStatsNotifier
    extends Notifier<AnalyticsState<SessionStatsModel>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  AnalyticsState<SessionStatsModel> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is AnalyticsError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const AnalyticsInitial();
  }

  Future<void> load({String? dateFrom, String? dateTo}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const AnalyticsLoading();
    try {
      final response = await ref
          .read(adminAnalyticsServiceProvider)
          .getSessionStats(storeId, dateFrom: dateFrom, dateTo: dateTo);
      if (response.data != null) {
        state = AnalyticsLoaded(response.data!);
      } else {
        state = const AnalyticsError('No data returned');
      }
    } catch (e) {
      state = AnalyticsError(e);
    }
  }
}

final sessionStatsProvider = NotifierProvider<SessionStatsNotifier,
    AnalyticsState<SessionStatsModel>>(SessionStatsNotifier.new);

// ============================================================
// Players Provider (Screen 50)
// ============================================================

class PlayersNotifier
    extends Notifier<AnalyticsState<PlayerAnalyticsModel>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  AnalyticsState<PlayerAnalyticsModel> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is AnalyticsError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const AnalyticsInitial();
  }

  Future<void> load({String? dateFrom, String? dateTo}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const AnalyticsLoading();
    try {
      final response = await ref
          .read(adminAnalyticsServiceProvider)
          .getPlayers(storeId, dateFrom: dateFrom, dateTo: dateTo);
      if (response.data != null) {
        state = AnalyticsLoaded(response.data!);
      } else {
        state = const AnalyticsError('No data returned');
      }
    } catch (e) {
      state = AnalyticsError(e);
    }
  }
}

final playersProvider = NotifierProvider<PlayersNotifier,
    AnalyticsState<PlayerAnalyticsModel>>(PlayersNotifier.new);

// ============================================================
// System Performance Provider (Screen 51)
// ============================================================

class SystemPerformanceNotifier
    extends Notifier<AnalyticsState<SystemPerformanceModel>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  AnalyticsState<SystemPerformanceModel> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is AnalyticsError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const AnalyticsInitial();
  }

  Future<void> load({String? dateFrom, String? dateTo}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const AnalyticsLoading();
    try {
      final response = await ref
          .read(adminAnalyticsServiceProvider)
          .getSystemPerformance(storeId, dateFrom: dateFrom, dateTo: dateTo);
      if (response.data != null) {
        state = AnalyticsLoaded(response.data!);
      } else {
        state = const AnalyticsError('No data returned');
      }
    } catch (e) {
      state = AnalyticsError(e);
    }
  }
}

final systemPerformanceProvider = NotifierProvider<SystemPerformanceNotifier,
    AnalyticsState<SystemPerformanceModel>>(SystemPerformanceNotifier.new);
