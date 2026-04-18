import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses_admin.dart';

/// Thin wrapper around ApiClient for all admin store endpoints
/// (Systems, System Types, Staff, Store Config, Notifications).
class AdminStoreService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AdminStoreService(this._apiClient, this._tokenStorage);

  String _withStoreId(String template, String storeId) =>
      template.replaceAll('{storeId}', storeId);

  String _resolve(String template, String storeId, String id) =>
      template.replaceAll('{storeId}', storeId).replaceAll('{id}', id);

  // ─── Systems ─────────────────────────────────────────────────────────

  /// GET /stores/:storeId/systems
  Future<dynamic> getSystems(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.systemsList, storeId);
    return await _apiClient.get(endpoint);
  }

  /// POST /stores/:storeId/systems
  Future<dynamic> createSystem({
    required String storeId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint = _withStoreId(ApiConstants.systemsList, storeId);
    return await _apiClient.post(endpoint, body: body);
  }

  /// PATCH /stores/:storeId/systems/:id
  Future<dynamic> updateSystem({
    required String storeId,
    required String systemId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint = _resolve(ApiConstants.systemDetail, storeId, systemId);
    return await _apiClient.patch(endpoint, body: body);
  }

  // ─── System Types ────────────────────────────────────────────────────

  /// GET /stores/:storeId/system-types
  Future<dynamic> getSystemTypes(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.systemTypes, storeId);
    return await _apiClient.get(endpoint);
  }

  /// POST /stores/:storeId/system-types
  Future<dynamic> createSystemType({
    required String storeId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint = _withStoreId(ApiConstants.systemTypes, storeId);
    return await _apiClient.post(endpoint, body: body);
  }

  // ─── Staff ───────────────────────────────────────────────────────────

  /// GET /stores/:storeId/admins
  Future<dynamic> getStaff(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.storeAdminsList, storeId);
    return await _apiClient.get(endpoint);
  }

  /// POST /stores/:storeId/admins
  Future<dynamic> addStaff({
    required String storeId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint = _withStoreId(ApiConstants.storeAdminsCreate, storeId);
    return await _apiClient.post(endpoint, body: body);
  }

  /// DELETE /stores/:storeId/admins/:id
  Future<dynamic> deactivateStaff({
    required String storeId,
    required String adminId,
  }) async {
    final endpoint = _resolve(ApiConstants.storeAdminsDeactivate, storeId, adminId);
    return await _apiClient.delete(endpoint);
  }

  // ─── Store Config ────────────────────────────────────────────────────

  /// GET /stores/:id/config
  Future<StoreConfigResponse> getConfig(String storeId) async {
    final endpoint = ApiConstants.storeConfig.replaceAll('{id}', storeId);
    final data = await _apiClient.get(endpoint);
    return StoreConfigResponse.fromJson(data as Map<String, dynamic>);
  }

  /// PATCH /stores/:id/config
  Future<StoreConfigResponse> updateConfig({
    required String storeId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint = ApiConstants.storeConfig.replaceAll('{id}', storeId);
    final data = await _apiClient.patch(endpoint, body: body);
    return StoreConfigResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Notifications ───────────────────────────────────────────────────

  /// POST /notifications/admin/send
  Future<dynamic> sendNotification(Map<String, dynamic> body) async {
    return await _apiClient.post(ApiConstants.notificationsAdminSend, body: body);
  }

  /// POST /notifications/admin/send/topic
  Future<dynamic> sendTopicNotification(Map<String, dynamic> body) async {
    return await _apiClient.post(
      ApiConstants.notificationsAdminSendTopic,
      body: body,
    );
  }
}

final adminStoreServiceProvider = Provider<AdminStoreService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AdminStoreService(apiClient, tokenStorage);
});
