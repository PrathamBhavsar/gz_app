import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses_admin.dart';
import '../../../../models/domain_admin.dart';
import '../../../../models/domain_analytics.dart';

class AdminDashboardRepository {
  AdminDashboardRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<AnalyticsDashboardModel> fetchDashboard() async {
    await _net.assertConnection();

    final raw = await _api.get(await _store(ApiConstants.analyticsDashboard));
    final response = AnalyticsDashboardResponse.fromJson(_asMap(raw));
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing dashboard data in analytics response',
      );
    }
    return data;
  }

  Future<List<LiveSystemStatusModel>> fetchLiveSystems() async {
    await _net.assertConnection();

    final raw = await _api.get(await _store(ApiConstants.systemsLive));
    final response = LiveSystemsResponse.fromJson(_asMap(raw));
    return response.data ?? const [];
  }

  Future<String> adminStoreId() async {
    final storeId = await _storage.getAdminStoreId();
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Missing admin store context');
    }
    return storeId;
  }

  Future<String> _store(String template, {String? id}) async {
    final storeId = await adminStoreId();
    var path = template.replaceAll('{storeId}', storeId);
    if (id != null) {
      path = path.replaceAll('{id}', id);
    }
    return path;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }
    throw const ApiException(
      statusCode: 500,
      message: 'Expected object response from admin dashboard API',
    );
  }
}

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  return AdminDashboardRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
