import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/domain_global.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/domain_systems.dart';

class StoreRepository {
  StoreRepository(this._api, this._net);

  final ApiClient _api;
  final NetworkChecker _net;

  String _withQuery(String path, Map<String, String> query) {
    if (query.isEmpty) {
      return path;
    }
    return '$path?${Uri(queryParameters: query).query}';
  }

  Future<List<StoreModel>> fetchStores({
    String? search,
    String? platform,
    bool? isOpen,
    bool activeOnly = true,
    int page = 1,
    int limit = 20,
  }) async {
    await _net.assertConnection();

    final raw = await _api.get(
      _withQuery(ApiConstants.storesList, {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (platform != null && platform.isNotEmpty) 'platform': platform,
        if (isOpen != null) 'isOpen': '$isOpen',
        if (activeOnly) 'isActive': 'true',
        'page': '$page',
        'limit': '$limit',
      }),
    );

    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['stores', 'items'],
    );
    return payload
        .map((item) => StoreModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<StoreModel> fetchStoreBySlug(String slug) async {
    await _net.assertConnection();

    final raw = await _api.get(
      ApiConstants.storeBySlug.replaceAll('{slug}', slug),
    );
    final payload = _extractObjectPayload(
      _asMap(raw),
      dataKeys: const ['store'],
    );
    return StoreModel.fromJson(payload);
  }

  Future<List<CampaignModel>> fetchActiveCampaigns(String storeId) async {
    await _net.assertConnection();

    final raw = await _api.get(
      ApiConstants.playerCampaignsActive.replaceAll('{storeId}', storeId),
    );
    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['campaigns', 'items'],
    );
    return payload
        .map((item) => CampaignModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<List<SystemModel>> fetchAvailableSystems(String storeId) async {
    await _net.assertConnection();

    final raw = await _api.get(
      ApiConstants.systemsAvailable.replaceAll('{storeId}', storeId),
    );
    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['systems', 'items'],
    );
    return payload
        .map((item) => SystemModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<StoreModel?> findStoreById(String storeId) async {
    final stores = await fetchStores(limit: 50);
    for (final store in stores) {
      if (store.id == storeId) {
        return store;
      }
    }
    return null;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (key, mapValue) => MapEntry(key.toString(), mapValue),
      );
    }
    throw const ApiException(
      statusCode: 500,
      message: 'Expected object response from store API',
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

  Map<String, dynamic> _extractObjectPayload(
    Map<String, dynamic> raw, {
    required List<String> dataKeys,
  }) {
    final data = raw['data'];
    if (data is Map) {
      final map = _asMap(data);
      for (final key in dataKeys) {
        final nested = map[key];
        if (nested is Map) {
          return _asMap(nested);
        }
      }
      return map;
    }

    for (final key in dataKeys) {
      final nested = raw[key];
      if (nested is Map) {
        return _asMap(nested);
      }
    }

    return raw;
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
  );
});
