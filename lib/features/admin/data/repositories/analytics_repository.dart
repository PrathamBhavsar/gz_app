import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses_admin.dart';
import '../../../../models/domain_analytics.dart';
import 'admin_store_repository_support.dart';

class AnalyticsRepository {
  AnalyticsRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<AnalyticsDashboardModel> fetchDashboard({
    String period = 'today',
  }) async {
    await _net.assertConnection();
    final base = await adminStorePath(
      _storage,
      ApiConstants.analyticsDashboard,
    );
    final raw = await _api.get('$base?period=$period');
    final map = adminStoreAsMap(raw, responseName: 'analytics dashboard');
    final result = AnalyticsDashboardResponse.fromJson(map).data;
    if (result == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing analytics dashboard data',
      );
    }
    return result;
  }

  Future<RevenueAnalyticsModel> fetchRevenue({
    String groupBy = 'daily',
    String period = '7d',
  }) async {
    await _net.assertConnection();
    final base = await adminStorePath(_storage, ApiConstants.analyticsRevenue);
    final raw = await _api.get('$base?group_by=$groupBy&period=$period');
    final map = adminStoreAsMap(raw, responseName: 'analytics revenue');
    final result = RevenueAnalyticsResponse.fromJson(map).data;
    if (result == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing revenue analytics data',
      );
    }
    return result;
  }

  Future<UtilizationModel> fetchUtilization({String groupBy = 'day'}) async {
    await _net.assertConnection();
    final base = await adminStorePath(
      _storage,
      ApiConstants.analyticsUtilization,
    );
    final raw = await _api.get('$base?group_by=$groupBy');
    final map = adminStoreAsMap(raw, responseName: 'analytics utilization');
    final result = UtilizationResponse.fromJson(map).data;
    if (result == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing utilization data',
      );
    }
    return result;
  }

  Future<SessionStatsModel> fetchSessionStats({String period = 'today'}) async {
    await _net.assertConnection();
    final base = await adminStorePath(
      _storage,
      ApiConstants.analyticsSessionStats,
    );
    final raw = await _api.get('$base?period=$period');
    final map = adminStoreAsMap(raw, responseName: 'session stats');
    final result = SessionStatsResponse.fromJson(map).data;
    if (result == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing session stats data',
      );
    }
    return result;
  }

  Future<PlayerAnalyticsModel> fetchPlayers({String period = 'today'}) async {
    await _net.assertConnection();
    final base = await adminStorePath(
      _storage,
      ApiConstants.analyticsPlayers,
    );
    final raw = await _api.get('$base?period=$period');
    final map = adminStoreAsMap(raw, responseName: 'player analytics');
    final result = PlayerAnalyticsResponse.fromJson(map).data;
    if (result == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing player analytics data',
      );
    }
    return result;
  }

  Future<SystemPerformanceModel> fetchSystemPerformance({
    String period = 'today',
  }) async {
    await _net.assertConnection();
    final base = await adminStorePath(
      _storage,
      ApiConstants.analyticsSystemPerformance,
    );
    final raw = await _api.get('$base?period=$period');
    final map = adminStoreAsMap(raw, responseName: 'system performance');
    final result = SystemPerformanceResponse.fromJson(map).data;
    if (result == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing system performance data',
      );
    }
    return result;
  }
}

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
