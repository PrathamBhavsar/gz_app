import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses_admin.dart';

/// Thin wrapper around ApiClient for all admin analytics endpoints.
/// Every endpoint path comes from [ApiConstants] — no hardcoded strings.
class AdminAnalyticsService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AdminAnalyticsService(this._apiClient, this._tokenStorage);

  String _withStoreId(String template, String storeId) {
    return template.replaceAll('{storeId}', storeId);
  }

  // ─── Dashboard ──────────────────────────────────────────────────────

  /// GET /stores/:storeId/analytics/dashboard
  Future<AnalyticsDashboardResponse> getDashboard(
    String storeId, {
    String? dateFrom,
    String? dateTo,
  }) async {
    var endpoint = _withStoreId(ApiConstants.analyticsDashboard, storeId);
    final params = <String, String>[];
    if (dateFrom != null) params.add('dateFrom=$dateFrom');
    if (dateTo != null) params.add('dateTo=$dateTo');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';

    final data = await _apiClient.get(endpoint);
    return AnalyticsDashboardResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Revenue ────────────────────────────────────────────────────────

  /// GET /stores/:storeId/analytics/revenue
  Future<RevenueAnalyticsResponse> getRevenue(
    String storeId, {
    String? dateFrom,
    String? dateTo,
    String? groupBy,
  }) async {
    var endpoint = _withStoreId(ApiConstants.analyticsRevenue, storeId);
    final params = <String, String>[];
    if (dateFrom != null) params.add('dateFrom=$dateFrom');
    if (dateTo != null) params.add('dateTo=$dateTo');
    if (groupBy != null) params.add('groupBy=$groupBy');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';

    final data = await _apiClient.get(endpoint);
    return RevenueAnalyticsResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Utilization ────────────────────────────────────────────────────

  /// GET /stores/:storeId/analytics/utilization
  Future<UtilizationResponse> getUtilization(
    String storeId, {
    String? dateFrom,
    String? dateTo,
  }) async {
    var endpoint = _withStoreId(ApiConstants.analyticsUtilization, storeId);
    final params = <String, String>[];
    if (dateFrom != null) params.add('dateFrom=$dateFrom');
    if (dateTo != null) params.add('dateTo=$dateTo');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';

    final data = await _apiClient.get(endpoint);
    return UtilizationResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Session Stats ──────────────────────────────────────────────────

  /// GET /stores/:storeId/analytics/sessions/stats
  Future<SessionStatsResponse> getSessionStats(
    String storeId, {
    String? dateFrom,
    String? dateTo,
  }) async {
    var endpoint =
        _withStoreId(ApiConstants.analyticsSessionStats, storeId);
    final params = <String, String>[];
    if (dateFrom != null) params.add('dateFrom=$dateFrom');
    if (dateTo != null) params.add('dateTo=$dateTo');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';

    final data = await _apiClient.get(endpoint);
    return SessionStatsResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Players ────────────────────────────────────────────────────────

  /// GET /stores/:storeId/analytics/players
  Future<PlayerAnalyticsResponse> getPlayers(
    String storeId, {
    String? dateFrom,
    String? dateTo,
  }) async {
    var endpoint = _withStoreId(ApiConstants.analyticsPlayers, storeId);
    final params = <String, String>[];
    if (dateFrom != null) params.add('dateFrom=$dateFrom');
    if (dateTo != null) params.add('dateTo=$dateTo');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';

    final data = await _apiClient.get(endpoint);
    return PlayerAnalyticsResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── System Performance ─────────────────────────────────────────────

  /// GET /stores/:storeId/analytics/systems/performance
  Future<SystemPerformanceResponse> getSystemPerformance(
    String storeId, {
    String? dateFrom,
    String? dateTo,
  }) async {
    var endpoint =
        _withStoreId(ApiConstants.analyticsSystemPerformance, storeId);
    final params = <String, String>[];
    if (dateFrom != null) params.add('dateFrom=$dateFrom');
    if (dateTo != null) params.add('dateTo=$dateTo');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';

    final data = await _apiClient.get(endpoint);
    return SystemPerformanceResponse.fromJson(data as Map<String, dynamic>);
  }
}

final adminAnalyticsServiceProvider =
    Provider<AdminAnalyticsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AdminAnalyticsService(apiClient, tokenStorage);
});
