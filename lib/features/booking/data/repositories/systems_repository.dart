import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/api_responses.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/domain_systems.dart';

class SystemsRepository {
  SystemsRepository(this._api, this._net, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  Future<List<SystemModel>> fetchAvailableSystems({
    DateTime? startTime,
    DateTime? endTime,
    String? systemTypeId,
  }) async {
    await _net.assertConnection();

    final raw = await _api.get(
      _withQuery(_store(ApiConstants.systemsAvailable), {
        if (startTime != null)
          'startTime': startTime.toUtc().toIso8601String(),
        if (endTime != null) 'endTime': endTime.toUtc().toIso8601String(),
        if (systemTypeId != null && systemTypeId.isNotEmpty)
          'systemTypeId': systemTypeId,
      }),
    );

    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['systems', 'items'],
    );
    return payload
        .map((item) => SystemModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  String _store(String template) {
    final storeId = _ref.read(activeStoreIdProvider);
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Select a store before booking');
    }
    return template.replaceAll('{storeId}', storeId);
  }

  String _withQuery(String path, Map<String, String> query) {
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
      message: 'Expected object response from systems API',
    );
  }

  Future<List<SystemTypeModel>> fetchSystemTypes() async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.systemTypes));
    final map = _asMap(raw);
    final response = PaginatedSystemTypesResponse.fromJson(map);
    final direct = response.data;
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }

    final payload = _extractListPayload(
      map,
      dataKeys: const ['systemTypes', 'types', 'items'],
    );
    return payload
        .map((item) => SystemTypeModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  List<dynamic> _extractListPayload(
    Map<String, dynamic> raw, {
    required List<String> dataKeys,
  }) {
    if (raw['systems'] is List) {
      return raw['systems'] as List<dynamic>;
    }

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

    return const [];
  }
}

final systemsRepositoryProvider = Provider<SystemsRepository>((ref) {
  return SystemsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref,
  );
});
