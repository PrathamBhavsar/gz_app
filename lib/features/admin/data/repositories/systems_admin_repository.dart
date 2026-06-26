import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/api_responses_admin.dart';
import '../../../../models/domain_admin.dart';
import '../../../../models/domain_systems.dart';
import 'admin_store_repository_support.dart';

class SystemsAdminRepository {
  SystemsAdminRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<SystemModel>> fetchSystems() async {
    await _net.assertConnection();

    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.systemsList),
    );
    final map = adminStoreAsMap(raw, responseName: 'systems');
    final paginated = PaginatedSystemsResponse.fromJson(map).data;
    if (paginated != null && paginated.isNotEmpty) {
      return paginated;
    }

    return adminStoreExtractList(map, dataKeys: const ['systems', 'items'])
        .map(
          (item) => SystemModel.fromJson(
            adminStoreAsMap(item, responseName: 'systems'),
          ),
        )
        .toList(growable: false);
  }

  Future<List<LiveSystemStatusModel>> fetchLiveSystems() async {
    await _net.assertConnection();

    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.systemsLive),
    );
    final response = LiveSystemsResponse.fromJson(
      adminStoreAsMap(raw, responseName: 'live systems'),
    );
    return response.data ?? const [];
  }

  Future<SystemModel> fetchSystemDetail(String id) async {
    await _net.assertConnection();

    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.systemDetail, id: id),
    );
    return _parseSystemPayload(
      raw,
      responseName: 'system detail',
      missingMessage: 'Missing system detail payload',
    );
  }

  Future<SystemModel> createSystem({
    required String name,
    required String systemTypeId,
    required int stationNumber,
    required String platform,
    Map<String, dynamic>? specs,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.systemsList),
      body: {
        'name': name,
        'systemTypeId': systemTypeId,
        'stationNumber': stationNumber,
        'platform': platform,
        if (specs != null && specs.isNotEmpty) 'specs': specs,
      },
    );
    return _parseSystemMutation(raw);
  }

  Future<SystemModel> updateSystem({
    required String id,
    required String name,
    required String systemTypeId,
    required int stationNumber,
    required String platform,
    required String status,
    Map<String, dynamic>? specs,
  }) async {
    await _net.assertConnection();

    final raw = await _api.patch(
      await adminStorePath(_storage, ApiConstants.systemDetail, id: id),
      body: {
        'name': name,
        'systemTypeId': systemTypeId,
        'stationNumber': stationNumber,
        'platform': platform,
        'status': status,
        if (specs != null && specs.isNotEmpty) 'specs': specs,
      },
    );
    return _parseSystemMutation(raw);
  }

  Future<SystemApiKeyModel> regenerateKey(String id) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.systemRegenerateKey, id: id),
    );
    final map = adminStoreAsMap(raw, responseName: 'system key regeneration');
    final data = adminStoreAsMap(
      map['data'],
      responseName: 'system key regeneration payload',
    );
    return SystemApiKeyModel.fromJson(data);
  }

  Future<void> deleteSystem(String id) async {
    await _net.assertConnection();
    await _api.delete(
      await adminStorePath(_storage, ApiConstants.systemDetail, id: id),
    );
  }

  SystemModel _parseSystemMutation(dynamic raw) {
    return _parseSystemPayload(
      raw,
      responseName: 'system mutation',
      missingMessage: 'Missing system payload in response',
    );
  }

  SystemModel _parseSystemPayload(
    dynamic raw, {
    required String responseName,
    required String missingMessage,
  }) {
    final map = adminStoreAsMap(raw, responseName: responseName);
    final data = adminStoreAsMap(
      map['data'],
      responseName: '$responseName payload',
    );
    final system = data['system'] ?? data;
    if (system is! Map) {
      throw ApiException(statusCode: 500, message: missingMessage);
    }
    return SystemModel.fromJson(
      adminStoreAsMap(system, responseName: responseName),
    );
  }
}

final systemsAdminRepositoryProvider = Provider<SystemsAdminRepository>((ref) {
  return SystemsAdminRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
