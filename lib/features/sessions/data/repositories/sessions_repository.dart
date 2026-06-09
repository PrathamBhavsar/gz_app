import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_systems.dart';

class SessionsRepository {
  SessionsRepository(this._api, this._net, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  Future<List<SessionModel>> fetchMySessions() async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.sessionsMy));
    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['sessions', 'items'],
    );
    return payload
        .map((item) => SessionModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<SessionModel> fetchSessionDetail(String sessionId) async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.playerSessionDetail, id: sessionId));
    final response = SessionResponse.fromJson(_asMap(raw));
    final session = response.data;
    if (session == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing session in session detail response',
      );
    }
    return session;
  }

  Future<List<SessionLogModel>> fetchSessionLogs(String sessionId) async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.playerSessionLogs, id: sessionId));
    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['logs', 'items'],
    );
    return payload
        .map((item) => SessionLogModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  String _store(String template, {String? id}) {
    final storeId = _ref.read(activeStoreIdProvider);
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Select a store before viewing sessions');
    }

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
      message: 'Expected object response from sessions API',
    );
  }

  List<dynamic> _extractListPayload(
    Map<String, dynamic> raw, {
    required List<String> dataKeys,
  }) {
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

final sessionsRepositoryProvider = Provider<SessionsRepository>((ref) {
  return SessionsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref,
  );
});
