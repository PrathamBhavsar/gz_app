import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class BookingService {
  final ApiClient _apiClient;

  BookingService(this._apiClient);

  /// GET /stores/:storeId/bookings/availability — Bearer
  Future<AvailabilityResponse> getAvailability(
    String storeId, {
    required String date,
    String? systemTypeId,
    int? duration,
  }) async {
    final queryParams = <String, String>{
      'date': date,
      if (systemTypeId != null) 'systemTypeId': systemTypeId,
      if (duration != null) 'duration': duration.toString(),
    };
    final qs = _encodeQuery(queryParams);
    final data = await _apiClient.get(
      '/stores/$storeId/bookings/availability?$qs',
    );
    return AvailabilityResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:storeId/bookings/my — Bearer
  Future<PaginatedBookingsResponse> getMyBookings(
    String storeId, {
    String? status,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{
      if (status != null) 'status': status,
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
    };
    final qs = queryParams.isNotEmpty ? '?${_encodeQuery(queryParams)}' : '';
    final data = await _apiClient.get('/stores/$storeId/bookings/my$qs');
    return PaginatedBookingsResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:storeId/bookings/:id — Bearer
  Future<BookingResponse> getBooking(String storeId, String bookingId) async {
    final data = await _apiClient.get('/stores/$storeId/bookings/$bookingId');
    return BookingResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /stores/:storeId/bookings — Bearer
  Future<BookingResponse> createBooking(
    String storeId, {
    required String systemId,
    required String startTime,
    required String endTime,
    required String systemTypeId,
    String? campaignId,
    int? creditsToRedeem,
    String? paymentMethod,
  }) async {
    final body = <String, dynamic>{
      'systemId': systemId,
      'startTime': startTime,
      'endTime': endTime,
      'systemTypeId': systemTypeId,
      if (campaignId != null) 'campaignId': campaignId,
      if (creditsToRedeem != null) 'creditsToRedeem': creditsToRedeem,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
    };
    final data = await _apiClient.post('/stores/$storeId/bookings', body: body);
    return BookingResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /stores/:storeId/bookings/:id/pay — Bearer
  Future<PaymentResponse> payBooking(
    String storeId,
    String bookingId, {
    required String paymentMethod,
    required String idempotencyKey,
  }) async {
    final data = await _apiClient.post(
      '/stores/$storeId/bookings/$bookingId/pay',
      body: {'paymentMethod': paymentMethod, 'idempotencyKey': idempotencyKey},
    );
    return PaymentResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /stores/:storeId/bookings/:id/cancel — Bearer
  Future<BookingResponse> cancelBooking(
    String storeId,
    String bookingId,
  ) async {
    final data = await _apiClient.post(
      '/stores/$storeId/bookings/$bookingId/cancel',
    );
    return BookingResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /stores/:storeId/bookings/:id/check-in — Bearer
  Future<Map<String, dynamic>> checkIn(String storeId, String bookingId) async {
    return await _apiClient.post(
          '/stores/$storeId/bookings/$bookingId/check-in',
        )
        as Map<String, dynamic>;
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}

final bookingServiceProvider = Provider<BookingService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BookingService(apiClient);
});
