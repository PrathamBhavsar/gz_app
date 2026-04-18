import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses_admin.dart';

/// Thin wrapper around ApiClient for all admin operations endpoints.
/// Every endpoint path comes from [ApiConstants] — no hardcoded strings.
class AdminOperationsService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AdminOperationsService(this._apiClient, this._tokenStorage);

  // ─── Helper: inject storeId into endpoint templates ───────────────────

  String _resolveStoreId() {
    // storeId is read synchronously from the in-memory provider state;
    // the caller (provider) guarantees it's set before invoking service.
    throw UnimplementedError(
      'Use the storeId parameter overload or pass via provider.',
    );
  }

  String _withStoreId(String template, String storeId) {
    return template.replaceAll('{storeId}', storeId);
  }

  String _withStoreAndId(String template, String storeId, String id) {
    return template
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', id);
  }

  // ─── Live Systems (Floor Map) ────────────────────────────────────────

  /// GET /stores/:storeId/systems/live
  Future<LiveSystemsResponse> getLiveSystems(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.systemsLive, storeId);
    final data = await _apiClient.get(endpoint);
    return LiveSystemsResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:storeId/systems/available
  Future<dynamic> getAvailableSystems(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.systemsAvailable, storeId);
    return await _apiClient.get(endpoint);
  }

  // ─── Sessions ────────────────────────────────────────────────────────

  /// GET /stores/:storeId/sessions/active
  Future<dynamic> getActiveSessions(String storeId) async {
    final endpoint = _withStoreId(ApiConstants.sessionsActive, storeId);
    return await _apiClient.get(endpoint);
  }

  /// GET /stores/:storeId/sessions/:id
  Future<dynamic> getSessionDetail(String storeId, String sessionId) async {
    final endpoint = _withStoreAndId(
      ApiConstants.sessionDetail.replaceAll('{id}', sessionId),
      storeId,
      sessionId,
    );
    // sessionDetail already has {id} — handle both replacements
    final resolved = ApiConstants.sessionDetail
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', sessionId);
    return await _apiClient.get(resolved);
  }

  /// POST /stores/:storeId/sessions/:id/pause
  Future<dynamic> pauseSession(String storeId, String sessionId) async {
    final resolved = ApiConstants.sessionPause
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', sessionId);
    return await _apiClient.post(resolved);
  }

  /// POST /stores/:storeId/sessions/:id/resume
  Future<dynamic> resumeSession(String storeId, String sessionId) async {
    final resolved = ApiConstants.sessionResume
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', sessionId);
    return await _apiClient.post(resolved);
  }

  /// POST /stores/:storeId/sessions/:id/end
  Future<dynamic> endSession(String storeId, String sessionId) async {
    final resolved = ApiConstants.sessionEnd
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', sessionId);
    return await _apiClient.post(resolved);
  }

  /// POST /stores/:storeId/sessions/:id/extend  { extraMinutes }
  Future<dynamic> extendSession(
    String storeId,
    String sessionId,
    int extraMinutes,
  ) async {
    final resolved = ApiConstants.sessionExtend
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', sessionId);
    return await _apiClient.post(
      resolved,
      body: {'extraMinutes': extraMinutes},
    );
  }

  // ─── Walk-in Booking ─────────────────────────────────────────────────

  /// POST /stores/:storeId/bookings/walk-in
  Future<WalkInBookingResponseWrapper> createWalkIn({
    required String storeId,
    required String userId,
    required String systemId,
    required int durationMinutes,
    String? paymentMethod,
  }) async {
    final endpoint =
        _withStoreId(ApiConstants.bookingWalkIn, storeId);
    final data = await _apiClient.post(
      endpoint,
      body: {
        'userId': userId,
        'systemId': systemId,
        'durationMinutes': durationMinutes,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
      },
    );
    return WalkInBookingResponseWrapper.fromJson(
      data as Map<String, dynamic>,
    );
  }

  // ─── Bookings ────────────────────────────────────────────────────────

  /// GET /stores/:storeId/bookings  (with optional filters)
  Future<dynamic> getBookings(
    String storeId, {
    String? date,
    String? status,
  }) async {
    final endpoint = _withStoreId(ApiConstants.bookingsList, storeId);
    // Append query params if provided
    var url = endpoint;
    final queryParams = <String, String>[];
    if (date != null) queryParams.add('date=$date');
    if (status != null) queryParams.add('status=$status');
    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }
    return await _apiClient.get(url);
  }

  /// POST /stores/:storeId/bookings/:id/check-in
  Future<dynamic> checkInBooking(String storeId, String bookingId) async {
    final resolved = ApiConstants.bookingCheckIn
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', bookingId);
    return await _apiClient.post(resolved);
  }

  /// POST /stores/:storeId/bookings/:id/cancel  { reason }
  Future<dynamic> cancelBooking(
    String storeId,
    String bookingId, {
    String? reason,
  }) async {
    final resolved = ApiConstants.bookingCancel
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', bookingId);
    return await _apiClient.post(
      resolved,
      body: {if (reason != null) 'reason': reason},
    );
  }

  // ─── Pricing (used by Walk-in for price preview) ─────────────────────

  /// POST /stores/:storeId/pricing/calculate
  Future<PriceCalculationResponse> calculatePrice({
    required String storeId,
    required String systemType,
    required int durationMinutes,
    String? startTime,
  }) async {
    final endpoint =
        _withStoreId(ApiConstants.pricingCalculate, storeId);
    final data = await _apiClient.post(
      endpoint,
      body: {
        'systemType': systemType,
        'durationMinutes': durationMinutes,
        if (startTime != null) 'startTime': startTime,
      },
    );
    return PriceCalculationResponse.fromJson(
      data as Map<String, dynamic>,
    );
  }
}

final adminOperationsServiceProvider =
    Provider<AdminOperationsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AdminOperationsService(apiClient, tokenStorage);
});
