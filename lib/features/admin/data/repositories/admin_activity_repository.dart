import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/domain_activity.dart';

class AdminActivityRepository {
  AdminActivityRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<AdminActivityItem>> fetchFeed({
    required String scope,
    String? systemId,
    String? bucket,
  }) async {
    await _net.assertConnection();

    final raw = await _api.get(
      await _withQuery(await _store(ApiConstants.sessionsFeed), {
        'scope': scope,
        if (systemId != null && systemId.isNotEmpty) 'systemId': systemId,
        if (bucket != null && bucket.isNotEmpty) 'bucket': bucket,
      }),
    );
    final map = _asMap(raw);
    final data = map['data'];
    if (data is! List) {
      return const [];
    }
    return data
        .map((item) => AdminActivityItem.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<String> _adminStoreId() async {
    final storeId = await _storage.getAdminStoreId();
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Missing admin store context');
    }
    return storeId;
  }

  Future<String> _store(String template) async {
    final storeId = await _adminStoreId();
    return template.replaceAll('{storeId}', storeId);
  }

  Future<String> _withQuery(String path, Map<String, String> query) async {
    if (query.isEmpty) {
      return path;
    }
    return '$path?${Uri(queryParameters: query).query}';
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
      message: 'Expected object response from admin activity feed API',
    );
  }
}

final adminActivityRepositoryProvider = Provider<AdminActivityRepository>((
  ref,
) {
  return AdminActivityRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
