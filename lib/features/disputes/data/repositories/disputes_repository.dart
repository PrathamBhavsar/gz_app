import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_billing.dart';

class CreateDisputeInput {
  const CreateDisputeInput({
    required this.sessionId,
    required this.reason,
    this.disputedAmount,
    this.notes,
  });

  final String sessionId;
  final String reason;
  final double? disputedAmount;
  final String? notes;
}

class DisputesRepository {
  DisputesRepository(this._api, this._net, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  Future<List<BillingDisputeModel>> fetchMyDisputes() async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.playerDisputesMy));
    final response = DisputeListResponse.fromJson(_asMap(raw));
    return response.data ?? const <BillingDisputeModel>[];
  }

  Future<BillingDisputeModel> fetchDisputeById(String id) async {
    await _net.assertConnection();

    final raw = await _api.get(
      _store(ApiConstants.playerDisputeDetail, id: id),
    );
    final response = DisputeResponse.fromJson(_asMap(raw));
    final dispute = response.data;
    if (dispute == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing dispute detail in API response',
      );
    }
    return dispute;
  }

  Future<BillingDisputeModel> createDispute(CreateDisputeInput input) async {
    await _net.assertConnection();

    final body = <String, dynamic>{
      'sessionId': input.sessionId,
      'reason': input.reason,
      if (input.disputedAmount != null) 'disputedAmount': input.disputedAmount,
      if (input.notes != null && input.notes!.trim().isNotEmpty)
        'metadata': {'notes': input.notes!.trim()},
    };

    final raw = await _api.post(
      _store(ApiConstants.playerDisputeCreate),
      body: body,
    );
    final response = DisputeResponse.fromJson(_asMap(raw));
    final dispute = response.data;
    if (dispute == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing dispute in create dispute response',
      );
    }
    return dispute;
  }

  Future<String> withdrawDispute(String id) async {
    await _net.assertConnection();

    final raw = await _api.post(
      _store(ApiConstants.playerDisputeWithdraw, id: id),
    );
    final map = _asMap(raw);
    return map['message']?.toString() ?? 'Dispute withdrawn successfully';
  }

  String _store(String template, {String? id}) {
    final storeId = _ref.read(activeStoreIdProvider);
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Select a store before viewing disputes');
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
      message: 'Expected object response from disputes API',
    );
  }
}

final disputesRepositoryProvider = Provider<DisputesRepository>((ref) {
  return DisputesRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref,
  );
});
