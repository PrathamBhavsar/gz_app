import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_systems.dart';
import 'admin_store_repository_support.dart';

class SystemTypesRepository {
  SystemTypesRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<SystemTypeModel>> fetchSystemTypes() async {
    await _net.assertConnection();

    final raw = await _api.get(await adminStorePath(_storage, ApiConstants.systemTypes));
    final map = adminStoreAsMap(raw, responseName: 'system types');
    final paginated = PaginatedSystemTypesResponse.fromJson(map).data;
    if (paginated != null && paginated.isNotEmpty) {
      return paginated;
    }

    return adminStoreExtractList(
      map,
      dataKeys: const ['systemTypes', 'types', 'items'],
    ).map((item) => SystemTypeModel.fromJson(adminStoreAsMap(item, responseName: 'system types'))).toList(growable: false);
  }

  Future<SystemTypeModel> createSystemType({
    required String name,
    String? description,
    double? hourlyBaseRate,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.systemTypes),
      body: {
        'name': name,
        if (description?.isNotEmpty ?? false) 'description': description,
        if (hourlyBaseRate != null) 'hourly_base_rate': hourlyBaseRate,
      },
    );
    return _parseTypeMutation(raw);
  }

  Future<SystemTypeModel> updateSystemType({
    required String id,
    required String name,
    String? description,
    double? hourlyBaseRate,
  }) async {
    await _net.assertConnection();

    final raw = await _api.patch(
      await adminStorePath(_storage, ApiConstants.systemTypeDetail, id: id),
      body: {
        'name': name,
        if (description != null) 'description': description,
        if (hourlyBaseRate != null) 'hourly_base_rate': hourlyBaseRate,
      },
    );
    return _parseTypeMutation(raw);
  }

  Future<void> deleteSystemType(String id) async {
    await _net.assertConnection();
    await _api.delete(
      await adminStorePath(_storage, ApiConstants.systemTypeDetail, id: id),
    );
  }

  SystemTypeModel _parseTypeMutation(dynamic raw) {
    final map = adminStoreAsMap(raw, responseName: 'system type mutation');
    final data = map['data'];
    if (data is Map<String, dynamic>) {
      return SystemTypeModel.fromJson(data);
    }
    if (data is Map) {
      return SystemTypeModel.fromJson(
        data.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    throw const ApiException(
      statusCode: 500,
      message: 'Missing system type payload in response',
    );
  }
}

final systemTypesRepositoryProvider = Provider<SystemTypesRepository>((ref) {
  return SystemTypesRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
