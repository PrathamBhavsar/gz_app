import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses_admin.dart';

/// Thin wrapper around ApiClient for all admin management endpoints
/// (Pricing, Billing, Campaigns, Credits, Disputes).
/// Every endpoint path comes from [ApiConstants] — no hardcoded strings.
class AdminManagementService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AdminManagementService(this._apiClient, this._tokenStorage);

  String _withStoreId(String template, String storeId) {
    return template.replaceAll('{storeId}', storeId);
  }

  String _resolve(String template, String storeId, String id) {
    return template
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', id);
  }

  String _resolveUser(String template, String storeId, String userId) {
    return template
        .replaceAll('{storeId}', storeId)
        .replaceAll('{userId}', userId);
  }

  // ─── Pricing Rules ───────────────────────────────────────────────────

  /// GET /stores/:storeId/pricing/rules
  Future<dynamic> getPricingRules(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.pricingRules, storeId);
    return await _apiClient.get(endpoint);
  }

  /// POST /stores/:storeId/pricing/rules
  Future<dynamic> createPricingRule({
    required String storeId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint = _withStoreId(ApiConstants.pricingRules, storeId);
    return await _apiClient.post(endpoint, body: body);
  }

  /// PATCH /stores/:storeId/pricing/rules/:id
  Future<dynamic> updatePricingRule({
    required String storeId,
    required String ruleId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint =
        _resolve(ApiConstants.pricingRules, storeId, ruleId);
    // pricingRules is a collection endpoint — append /:id for individual
    final resolved = '${_withStoreId(ApiConstants.pricingRules, storeId)}/$ruleId';
    return await _apiClient.patch(resolved, body: body);
  }

  /// POST /stores/:storeId/pricing/calculate
  Future<PriceCalculationResponse> calculatePrice({
    required String storeId,
    required String systemType,
    required int durationMinutes,
    String? startTime,
  }) async {
    final endpoint = _withStoreId(ApiConstants.pricingCalculate, storeId);
    final data = await _apiClient.post(
      endpoint,
      body: {
        'systemType': systemType,
        'durationMinutes': durationMinutes,
        if (startTime != null) 'startTime': startTime,
      },
    );
    return PriceCalculationResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Billing ─────────────────────────────────────────────────────────

  /// GET /stores/:storeId/billing/ledger
  Future<dynamic> getBillingLedger(
    String storeId, {
    String? status,
    int? page,
    int? limit,
  }) async {
    var endpoint = _withStoreId(ApiConstants.billingLedger, storeId);
    final params = <String, String>[];
    if (status != null) params.add('status=$status');
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';
    return await _apiClient.get(endpoint);
  }

  /// POST /stores/:storeId/billing/:id/override { reason, amount }
  Future<dynamic> billingOverride({
    required String storeId,
    required String billingId,
    required String reason,
    required double amount,
  }) async {
    final endpoint =
        _resolve(ApiConstants.billingOverride, storeId, billingId);
    return await _apiClient.post(endpoint, body: {
      'reason': reason,
      'amount': amount,
    });
  }

  /// GET /stores/:storeId/billing/revenue/summary
  Future<RevenueSummaryResponse> getRevenueSummary(String storeId) async {
    final endpoint =
        _withStoreId(ApiConstants.billingRevenueSummary, storeId);
    final data = await _apiClient.get(endpoint);
    return RevenueSummaryResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Payments ────────────────────────────────────────────────────────

  /// GET /stores/:storeId/payments
  Future<dynamic> getPayments(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.paymentsList, storeId);
    return await _apiClient.get(endpoint);
  }

  /// GET /stores/:storeId/payments/reconciliation
  Future<ReconciliationResponse> getReconciliation(String storeId) async {
    final endpoint =
        _withStoreId(ApiConstants.paymentsReconciliation, storeId);
    final data = await _apiClient.get(endpoint);
    return ReconciliationResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /stores/:storeId/payments/:id/refund
  Future<dynamic> refundPayment({
    required String storeId,
    required String paymentId,
    String? reason,
  }) async {
    final endpoint =
        _resolve(ApiConstants.paymentRefund, storeId, paymentId);
    return await _apiClient.post(endpoint, body: {
      if (reason != null) 'reason': reason,
    });
  }

  // ─── Campaigns ───────────────────────────────────────────────────────

  /// GET /stores/:storeId/campaigns
  Future<dynamic> getCampaigns(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.campaignsAdminList, storeId);
    return await _apiClient.get(endpoint);
  }

  /// POST /stores/:storeId/campaigns
  Future<dynamic> createCampaign({
    required String storeId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint = _withStoreId(ApiConstants.campaignsAdminList, storeId);
    return await _apiClient.post(endpoint, body: body);
  }

  /// POST /stores/:storeId/campaigns/:id/pause
  Future<dynamic> pauseCampaign({
    required String storeId,
    required String campaignId,
  }) async {
    final endpoint =
        _resolve(ApiConstants.campaignPause, storeId, campaignId);
    return await _apiClient.post(endpoint);
  }

  /// POST /stores/:storeId/campaigns/:id/resume
  Future<dynamic> resumeCampaign({
    required String storeId,
    required String campaignId,
  }) async {
    final endpoint =
        _resolve(ApiConstants.campaignResume, storeId, campaignId);
    return await _apiClient.post(endpoint);
  }

  // ─── Credits ─────────────────────────────────────────────────────────

  /// GET /stores/:storeId/credits/balance/:userId
  Future<dynamic> getCreditBalance({
    required String storeId,
    required String userId,
  }) async {
    final endpoint = _resolveUser(
      ApiConstants.creditsUserBalance,
      storeId,
      userId,
    );
    return await _apiClient.get(endpoint);
  }

  /// GET /stores/:storeId/credits/transactions/:userId
  Future<dynamic> getCreditTransactions({
    required String storeId,
    required String userId,
  }) async {
    final endpoint = _resolveUser(
      ApiConstants.creditsUserTransactions,
      storeId,
      userId,
    );
    return await _apiClient.get(endpoint);
  }

  /// POST /stores/:storeId/credits/adjust { userId, amount, reason }
  Future<dynamic> adjustCredits({
    required String storeId,
    required String userId,
    required double amount,
    String? reason,
  }) async {
    final endpoint = _withStoreId(ApiConstants.creditsAdjust, storeId);
    return await _apiClient.post(endpoint, body: {
      'userId': userId,
      'amount': amount,
      if (reason != null) 'reason': reason,
    });
  }

  // ─── Disputes ────────────────────────────────────────────────────────

  /// GET /stores/:storeId/disputes
  Future<dynamic> getDisputes(
    String storeId, {
    String? status,
  }) async {
    var endpoint = _withStoreId(ApiConstants.disputesAdminList, storeId);
    if (status != null) endpoint += '?status=$status';
    return await _apiClient.get(endpoint);
  }

  /// POST /stores/:storeId/disputes/:id/review
  Future<dynamic> reviewDispute({
    required String storeId,
    required String disputeId,
  }) async {
    final endpoint =
        _resolve(ApiConstants.disputeReview, storeId, disputeId);
    return await _apiClient.post(endpoint);
  }

  /// POST /stores/:storeId/disputes/:id/resolve { resolution, notes }
  Future<dynamic> resolveDispute({
    required String storeId,
    required String disputeId,
    required String resolution,
    String? notes,
  }) async {
    final endpoint =
        _resolve(ApiConstants.disputeResolve, storeId, disputeId);
    return await _apiClient.post(endpoint, body: {
      'resolution': resolution,
      if (notes != null) 'notes': notes,
    });
  }
}

final adminManagementServiceProvider =
    Provider<AdminManagementService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AdminManagementService(apiClient, tokenStorage);
});
