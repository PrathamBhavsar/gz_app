import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/domain_systems.dart';
import 'admin_store_repository_support.dart';

class StoreAdminsRepository {
  StoreAdminsRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<StoreAdminModel>> fetchAdmins() async {
    await _net.assertConnection();

    final raw = await _api.get(await adminStorePath(_storage, ApiConstants.storeAdminsList));
    final map = adminStoreAsMap(raw, responseName: 'store admins');
    return adminStoreExtractList(
      map,
      dataKeys: const ['admins', 'items'],
    ).map((item) => StoreAdminModel.fromJson(adminStoreAsMap(item, responseName: 'store admins'))).toList(growable: false);
  }

  Future<StoreAdminModel> createAdmin({
    required String name,
    required String email,
    required String role,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.storeAdminsCreate),
      body: {'name': name, 'email': email, 'role': role},
    );
    return _parseMutation(raw);
  }

  Future<StoreAdminModel> updateAdmin({
    required String id,
    required String role,
    String? name,
  }) async {
    await _net.assertConnection();

    final raw = await _api.patch(
      await adminStorePath(_storage, ApiConstants.storeAdminsUpdate, id: id),
      body: {
        'role': role,
        if (name != null && name.isNotEmpty) 'name': name,
      },
    );
    return _parseMutation(raw);
  }

  Future<void> deactivateAdmin(String id) async {
    await _net.assertConnection();
    await _api.delete(
      await adminStorePath(_storage, ApiConstants.storeAdminsDeactivate, id: id),
    );
  }

  StoreAdminModel _parseMutation(dynamic raw) {
    final map = adminStoreAsMap(raw, responseName: 'store admin mutation');
    final data = map['data'];
    if (data is Map<String, dynamic>) {
      return StoreAdminModel.fromJson(data);
    }
    if (data is Map) {
      return StoreAdminModel.fromJson(
        data.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    throw const ApiException(
      statusCode: 500,
      message: 'Missing store admin payload in response',
    );
  }
}

final storeAdminsRepositoryProvider = Provider<StoreAdminsRepository>((ref) {
  return StoreAdminsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
