import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';

class BillingRepository {
  BillingRepository(this._api, this._net, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  Future<List<BillingRow>> fetchBillingHistory({
    int page = 1,
    int limit = 50,
  }) async {
    await _net.assertConnection();

    final raw = await _api.get(
      _withQuery(_store(ApiConstants.billingMy), {
        'page': '$page',
        'limit': '$limit',
      }),
    );
    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['billing', 'items'],
    );
    return payload
        .map((item) => BillingRow.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  String _store(String template) {
    final storeId = _ref.read(activeStoreIdProvider);
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Select a store before viewing billing');
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
      message: 'Expected object response from billing API',
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

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref,
  );
});
