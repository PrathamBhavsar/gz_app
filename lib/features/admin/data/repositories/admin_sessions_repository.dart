import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_systems.dart';

class AdminSessionsRepository {
  AdminSessionsRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<SessionModel>> fetchSessions({String? systemId}) async {
    await _net.assertConnection();

    final raw = await _api.get(
      await _withQuery(await _store(ApiConstants.sessionsList), {
        if (systemId != null && systemId.isNotEmpty) 'systemId': systemId,
      }),
    );
    final payload = _extractListPayload(_asMap(raw), const [
      'sessions',
      'items',
    ]);
    return payload
        .map((item) => SessionModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<List<SessionModel>> fetchActiveSessions() async {
    await _net.assertConnection();

    final raw = await _api.get(await _store(ApiConstants.sessionsActive));
    final payload = _extractListPayload(_asMap(raw), const [
      'sessions',
      'activeSessions',
      'items',
    ]);
    return payload
        .map((item) => SessionModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<SessionModel> fetchSessionDetail(String id) async {
    await _net.assertConnection();

    final raw = await _api.get(
      await _store(ApiConstants.sessionDetail, id: id),
    );
    final response = SessionResponse.fromJson(_asMap(raw));
    final session = response.data;
    if (session == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing session in admin session detail response',
      );
    }
    return session;
  }

  Future<List<SessionLogModel>> fetchSessionLogs(String id) async {
    await _net.assertConnection();

    final raw = await _api.get(await _store(ApiConstants.sessionLogs, id: id));
    final payload = _extractListPayload(_asMap(raw), const ['logs', 'items']);
    return payload
        .map((item) => SessionLogModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<String> pauseSession(String id) async {
    return _postMessage(ApiConstants.sessionPause, id: id);
  }

  Future<String> resumeSession(String id) async {
    return _postMessage(ApiConstants.sessionResume, id: id);
  }

  Future<String> endSession(String id) async {
    return _postMessage(ApiConstants.sessionEnd, id: id);
  }

  Future<String> extendSession(String id, {required int extraMinutes}) async {
    return _postMessage(
      ApiConstants.sessionExtend,
      id: id,
      body: {'extraMinutes': extraMinutes},
    );
  }

  Future<String> _postMessage(
    String template, {
    required String id,
    Map<String, dynamic>? body,
  }) async {
    await _net.assertConnection();
    final raw = await _api.post(await _store(template, id: id), body: body);
    final map = _asMap(raw);
    return map['message']?.toString() ?? 'Action completed';
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
      message: 'Expected object response from admin sessions API',
    );
  }

  List<dynamic> _extractListPayload(
    Map<String, dynamic> raw,
    List<String> dataKeys,
  ) {
    final data = raw['data'];
    if (data is List) {
      return data;
    }
    if (data is Map) {
      final map = _asMap(data);
      for (final key in dataKeys) {
        final nested = map[key];
        if (nested is List) {
          return nested;
        }
      }
    }
    for (final key in dataKeys) {
      final nested = raw[key];
      if (nested is List) {
        return nested;
      }
    }
    return const [];
  }
}

final adminSessionsRepositoryProvider = Provider<AdminSessionsRepository>((
  ref,
) {
  return AdminSessionsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
