import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/dispute_service.dart';
import '../../../../models/api_responses.dart';

class DisputeRepository {
  final DisputeService _disputeService;
  final NetworkChecker _networkChecker;

  DisputeRepository(this._disputeService, this._networkChecker);

  Future<DisputeListResponse> fetchMyDisputes(String storeId) async {
    await _networkChecker.assertConnection();
    return await _disputeService.getMyDisputes(storeId);
  }

  Future<DisputeResponse> fetchDispute(String storeId, String disputeId) async {
    await _networkChecker.assertConnection();
    return await _disputeService.getDispute(storeId, disputeId);
  }

  Future<DisputeResponse> fileDispute(
    String storeId, {
    required String sessionId,
    required String reason,
    double? disputedAmount,
  }) async {
    await _networkChecker.assertConnection();
    return await _disputeService.createDispute(
      storeId,
      sessionId: sessionId,
      reason: reason,
      disputedAmount: disputedAmount,
    );
  }

  Future<DisputeResponse> withdrawDispute(
    String storeId,
    String disputeId,
  ) async {
    await _networkChecker.assertConnection();
    return await _disputeService.withdrawDispute(storeId, disputeId);
  }
}

final disputeRepositoryProvider = Provider<DisputeRepository>((ref) {
  final service = ref.watch(disputeServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return DisputeRepository(service, network);
});
