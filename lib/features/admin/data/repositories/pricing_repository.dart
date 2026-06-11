import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/domain_billing.dart';
import 'admin_store_repository_support.dart';

class PricingRepository {
  PricingRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<PricingRuleModel>> fetchRules() async {
    await _net.assertConnection();

    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.pricingRules),
    );
    final map = adminStoreAsMap(raw, responseName: 'pricing rules');
    return adminStoreExtractList(
          map,
          dataKeys: const ['rules', 'pricingRules', 'items'],
        )
        .map((item) {
          return PricingRuleModel.fromJson(
            adminStoreAsMap(item, responseName: 'pricing rules'),
          );
        })
        .toList(growable: false);
  }

  Future<PricingRuleModel> createRule(Map<String, dynamic> body) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.pricingRules),
      body: body,
    );
    return _parseRuleMutation(raw);
  }

  Future<PricingRuleModel> updateRule(
    String id,
    Map<String, dynamic> body,
  ) async {
    await _net.assertConnection();

    final raw = await _api.patch(
      await adminStorePath(_storage, '${ApiConstants.pricingRules}/$id'),
      body: body,
    );
    return _parseRuleMutation(raw);
  }

  Future<void> deleteRule(String id) async {
    await _net.assertConnection();
    await _api.delete(
      await adminStorePath(_storage, '${ApiConstants.pricingRules}/$id'),
    );
  }

  PricingRuleModel _parseRuleMutation(dynamic raw) {
    final map = adminStoreAsMap(raw, responseName: 'pricing rule mutation');
    final data = map['data'];
    if (data is Map<String, dynamic>) {
      return PricingRuleModel.fromJson(data);
    }
    if (data is Map) {
      return PricingRuleModel.fromJson(
        data.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    throw const ApiException(
      statusCode: 500,
      message: 'Missing pricing rule payload in response',
    );
  }
}

final pricingRepositoryProvider = Provider<PricingRepository>((ref) {
  return PricingRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
