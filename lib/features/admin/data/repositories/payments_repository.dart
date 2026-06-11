import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses_admin.dart';
import '../../../../models/domain_admin.dart';
import '../../../../models/domain_billing.dart';
import 'admin_store_repository_support.dart';

class PaymentsRepository {
  PaymentsRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<PaymentModel>> fetchPayments() async {
    await _net.assertConnection();

    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.paymentsList),
    );
    final map = adminStoreAsMap(raw, responseName: 'payments');
    return adminStoreExtractList(map, dataKeys: const ['payments', 'items'])
        .map((item) {
          return PaymentModel.fromJson(
            adminStoreAsMap(item, responseName: 'payments'),
          );
        })
        .toList(growable: false);
  }

  Future<ReconciliationModel?> fetchReconciliation() async {
    await _net.assertConnection();

    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.paymentsReconciliation),
    );
    final map = adminStoreAsMap(raw, responseName: 'payments reconciliation');
    return ReconciliationResponse.fromJson(map).data;
  }

  Future<String> refundPayment({
    required String paymentId,
    String? reason,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.paymentRefund, id: paymentId),
      body: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );
    final map = adminStoreAsMap(raw, responseName: 'payment refund');
    return map['message']?.toString() ?? 'Payment refunded';
  }
}

final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  return PaymentsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
