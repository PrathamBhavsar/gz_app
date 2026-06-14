import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_billing.dart';
import 'admin_store_repository_support.dart';

class AdminDisputesRepository {
  AdminDisputesRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<BillingDisputeModel>> fetchDisputes({String? status}) async {
    await _net.assertConnection();
    var path = await adminStorePath(_storage, ApiConstants.disputesAdminList);
    if (status != null && status.isNotEmpty) {
      path = '$path?status=$status';
    }
    final raw = await _api.get(path);
    final map = adminStoreAsMap(raw, responseName: 'disputes');
    return DisputeListResponse.fromJson(map).data ?? const [];
  }

  Future<BillingDisputeModel> fetchDisputeDetail(String id) async {
    await _net.assertConnection();
    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.disputeDetail, id: id),
    );
    final map = adminStoreAsMap(raw, responseName: 'dispute detail');
    final dispute = DisputeResponse.fromJson(map).data;
    if (dispute == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing dispute in response',
      );
    }
    return dispute;
  }

  Future<String> reviewDispute(String id, {String? notes}) async {
    await _net.assertConnection();
    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.disputeReview, id: id),
      body: {
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    final map = adminStoreAsMap(raw, responseName: 'dispute review');
    return map['message']?.toString() ?? 'Dispute marked as under review';
  }

  Future<String> resolveDispute(
    String id, {
    required String resolution,
    String? notes,
    double? resolutionAmount,
  }) async {
    await _net.assertConnection();
    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.disputeResolve, id: id),
      body: {
        'resolution': resolution,
        if (notes != null && notes.isNotEmpty) 'resolution_notes': notes,
        'resolution_amount': resolutionAmount,
      },
    );
    final map = adminStoreAsMap(raw, responseName: 'dispute resolve');
    return map['message']?.toString() ?? 'Dispute resolved';
  }
}

final adminDisputesRepositoryProvider =
    Provider<AdminDisputesRepository>((ref) {
  return AdminDisputesRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
