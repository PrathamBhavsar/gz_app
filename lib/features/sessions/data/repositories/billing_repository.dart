import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/billing_service.dart';
import '../../../../models/api_responses.dart';

class BillingRepository {
  final BillingService _billingService;
  final NetworkChecker _networkChecker;

  BillingRepository(this._billingService, this._networkChecker);

  Future<PaginatedBillingResponse> fetchMyBilling(
    String storeId, {
    int? page,
    int? limit,
  }) async {
    await _networkChecker.assertConnection();
    return await _billingService.getMyBilling(
      storeId,
      page: page ?? 1,
      limit: limit ?? 50,
    );
  }
}

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  final service = ref.watch(billingServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return BillingRepository(service, network);
});
