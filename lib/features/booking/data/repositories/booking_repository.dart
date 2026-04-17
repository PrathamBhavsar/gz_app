import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/booking_service.dart';
import '../../../../models/api_responses.dart';

class BookingRepository {
  final BookingService _bookingService;
  final NetworkChecker _networkChecker;

  BookingRepository(this._bookingService, this._networkChecker);

  Future<AvailabilityResponse> fetchAvailability(
    String storeId, {
    required String date,
    String? systemTypeId,
    int? duration,
  }) async {
    await _networkChecker.assertConnection();
    return await _bookingService.getAvailability(
      storeId,
      date: date,
      systemTypeId: systemTypeId,
      duration: duration,
    );
  }

  Future<PaginatedBookingsResponse> fetchMyBookings(
    String storeId, {
    String? status,
    int? page,
    int? limit,
  }) async {
    await _networkChecker.assertConnection();
    return await _bookingService.getMyBookings(
      storeId,
      status: status,
      page: page ?? 1,
      limit: limit ?? 20,
    );
  }

  Future<BookingResponse> fetchBooking(String storeId, String bookingId) async {
    await _networkChecker.assertConnection();
    return await _bookingService.getBooking(storeId, bookingId);
  }

  Future<BookingResponse> placeBooking(
    String storeId, {
    required String systemId,
    required String startTime,
    required String endTime,
    required String systemTypeId,
    String? campaignId,
    int? creditsToRedeem,
    String? paymentMethod,
  }) async {
    await _networkChecker.assertConnection();
    return await _bookingService.createBooking(
      storeId,
      systemId: systemId,
      startTime: startTime,
      endTime: endTime,
      systemTypeId: systemTypeId,
      campaignId: campaignId,
      creditsToRedeem: creditsToRedeem,
      paymentMethod: paymentMethod,
    );
  }

  Future<PaymentResponse> payForBooking(
    String storeId,
    String bookingId, {
    required String paymentMethod,
    required String idempotencyKey,
  }) async {
    await _networkChecker.assertConnection();
    return await _bookingService.payBooking(
      storeId,
      bookingId,
      paymentMethod: paymentMethod,
      idempotencyKey: idempotencyKey,
    );
  }

  Future<BookingResponse> cancelBooking(
    String storeId,
    String bookingId,
  ) async {
    await _networkChecker.assertConnection();
    return await _bookingService.cancelBooking(storeId, bookingId);
  }

  Future<Map<String, dynamic>> checkIn(String storeId, String bookingId) async {
    await _networkChecker.assertConnection();
    return await _bookingService.checkIn(storeId, bookingId);
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final service = ref.watch(bookingServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return BookingRepository(service, network);
});
