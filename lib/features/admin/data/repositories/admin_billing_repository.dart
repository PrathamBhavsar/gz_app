import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses_admin.dart';
import '../../../../models/domain_admin.dart';
import '../../../../models/domain_billing.dart';
import 'admin_store_repository_support.dart';

class AdminBillingRepository {
  AdminBillingRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<BillingLedgerModel>> fetchLedger() async {
    await _net.assertConnection();

    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.billingLedger),
    );
    final map = adminStoreAsMap(raw, responseName: 'billing ledger');
    return adminStoreExtractList(
          map,
          dataKeys: const ['ledger', 'billing', 'items'],
        )
        .map((item) {
          return BillingLedgerModel.fromJson(
            adminStoreAsMap(item, responseName: 'billing ledger'),
          );
        })
        .toList(growable: false);
  }

  Future<RevenueSummaryModel?> fetchRevenueSummary() async {
    await _net.assertConnection();

    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.billingRevenueSummary),
    );
    final map = adminStoreAsMap(raw, responseName: 'billing revenue summary');
    return RevenueSummaryResponse.fromJson(map).data;
  }

  Future<String> overrideBilling({
    required String billingId,
    required double amount,
    required String reason,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await adminStorePath(
        _storage,
        ApiConstants.billingOverride,
        id: billingId,
      ),
      body: {
        'override_type': 'price',
        'override_value': amount,
        'reason': reason,
      },
    );
    final map = adminStoreAsMap(raw, responseName: 'billing override');
    return map['message']?.toString() ?? 'Billing overridden';
  }
}

final adminBillingRepositoryProvider = Provider<AdminBillingRepository>((ref) {
  return AdminBillingRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
