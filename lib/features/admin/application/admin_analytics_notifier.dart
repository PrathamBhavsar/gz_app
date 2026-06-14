import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/domain_analytics.dart';
import '../data/repositories/analytics_repository.dart';
import 'admin_management_models.dart';

// ─── Dashboard ────────────────────────────────────────────────────────────────

class AdminAnalyticsDashboardNotifier
    extends AsyncNotifier<AdminAnalyticsDashboardData> {
  @override
  Future<AdminAnalyticsDashboardData> build() => _load('Today');

  Future<AdminAnalyticsDashboardData> _load(String period) async {
    final repo = ref.read(analyticsRepositoryProvider);
    final apiPeriod = period == '7 Days' ? '7d' : 'today';
    final dashFuture = repo.fetchDashboard(period: apiPeriod);
    final revFuture = repo.fetchRevenue(groupBy: 'daily', period: apiPeriod);
    final dashboard = await dashFuture;
    final revenue = await revFuture;
    return AdminAnalyticsDashboardData(
      dashboard: dashboard,
      revenueRows: revenue.data ?? const [],
      selectedPeriod: period,
      loadedAt: DateTime.now(),
    );
  }

  Future<void> selectFilter(String period) async {
    if (period == 'Custom') return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(period));
  }

  Future<void> refresh() async {
    final current = state.valueOrNull?.selectedPeriod ?? 'Today';
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(current));
  }
}

final adminAnalyticsDashboardNotifierProvider =
    AsyncNotifierProvider<AdminAnalyticsDashboardNotifier,
        AdminAnalyticsDashboardData>(AdminAnalyticsDashboardNotifier.new);

// ─── Revenue ──────────────────────────────────────────────────────────────────

class AdminRevenueAnalyticsNotifier
    extends AsyncNotifier<AdminRevenueData> {
  @override
  Future<AdminRevenueData> build() => _load('Daily');

  Future<AdminRevenueData> _load(String filter) async {
    final repo = ref.read(analyticsRepositoryProvider);
    final groupBy = switch (filter) {
      'Weekly' => 'weekly',
      'Monthly' => 'monthly',
      _ => 'daily',
    };
    final model = await repo.fetchRevenue(groupBy: groupBy, period: '30d');
    return AdminRevenueData(
      model: model,
      selectedFilter: filter,
      loadedAt: DateTime.now(),
    );
  }

  Future<void> selectFilter(String filter) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(filter));
  }

  Future<void> refresh() async {
    final current = state.valueOrNull?.selectedFilter ?? 'Daily';
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(current));
  }
}

final adminRevenueAnalyticsNotifierProvider =
    AsyncNotifierProvider<AdminRevenueAnalyticsNotifier, AdminRevenueData>(
      AdminRevenueAnalyticsNotifier.new,
    );

// ─── Utilization ──────────────────────────────────────────────────────────────

class AdminUtilizationNotifier extends AsyncNotifier<AdminUtilizationData> {
  @override
  Future<AdminUtilizationData> build() => _load('Day');

  Future<AdminUtilizationData> _load(String filter) async {
    final repo = ref.read(analyticsRepositoryProvider);
    final groupBy = filter == 'Week' ? 'week' : 'day';
    final model = await repo.fetchUtilization(groupBy: groupBy);
    return AdminUtilizationData(
      model: model,
      selectedFilter: filter,
      loadedAt: DateTime.now(),
    );
  }

  Future<void> selectFilter(String filter) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(filter));
  }

  Future<void> refresh() async {
    final current = state.valueOrNull?.selectedFilter ?? 'Day';
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(current));
  }
}

final adminUtilizationNotifierProvider =
    AsyncNotifierProvider<AdminUtilizationNotifier, AdminUtilizationData>(
      AdminUtilizationNotifier.new,
    );

// ─── Session Stats ────────────────────────────────────────────────────────────

class AdminSessionStatsNotifier extends AsyncNotifier<SessionStatsModel> {
  @override
  Future<SessionStatsModel> build() async {
    return ref.read(analyticsRepositoryProvider).fetchSessionStats();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(analyticsRepositoryProvider).fetchSessionStats(),
    );
  }
}

final adminSessionStatsNotifierProvider =
    AsyncNotifierProvider<AdminSessionStatsNotifier, SessionStatsModel>(
      AdminSessionStatsNotifier.new,
    );

// ─── Player Analytics ─────────────────────────────────────────────────────────

class AdminPlayerAnalyticsNotifier
    extends AsyncNotifier<PlayerAnalyticsModel> {
  @override
  Future<PlayerAnalyticsModel> build() async {
    return ref.read(analyticsRepositoryProvider).fetchPlayers();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(analyticsRepositoryProvider).fetchPlayers(),
    );
  }
}

final adminPlayerAnalyticsNotifierProvider =
    AsyncNotifierProvider<AdminPlayerAnalyticsNotifier, PlayerAnalyticsModel>(
      AdminPlayerAnalyticsNotifier.new,
    );

// ─── System Performance ───────────────────────────────────────────────────────

class AdminSystemPerformanceNotifier
    extends AsyncNotifier<SystemPerformanceModel> {
  @override
  Future<SystemPerformanceModel> build() async {
    return ref.read(analyticsRepositoryProvider).fetchSystemPerformance();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(analyticsRepositoryProvider).fetchSystemPerformance(),
    );
  }
}

final adminSystemPerformanceNotifierProvider =
    AsyncNotifierProvider<AdminSystemPerformanceNotifier,
        SystemPerformanceModel>(AdminSystemPerformanceNotifier.new);
