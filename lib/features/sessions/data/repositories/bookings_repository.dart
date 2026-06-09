import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';

class BookingsRepository {
  BookingsRepository(this._api, this._net, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  Future<List<BookingModel>> fetchMyBookings() async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.bookingsMyList));
    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['bookings', 'items'],
    );
    return payload
        .map((item) => BookingModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<BookingModel> fetchBookingDetail(String bookingId) async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.playerBookingDetail, id: bookingId));
    final response = BookingResponse.fromJson(_asMap(raw));
    final booking = response.data;
    if (booking == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing booking in booking detail response',
      );
    }
    return booking;
  }

  Future<PaymentModel> payBooking({
    required String bookingId,
    required PaymentMethod paymentMethod,
    required String idempotencyKey,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      _store(ApiConstants.bookingPayment, id: bookingId),
      body: {
        'paymentMethod': paymentMethod.name,
        'idempotencyKey': idempotencyKey,
      },
    );
    final response = PaymentResponse.fromJson(_asMap(raw));
    final payment = response.data;
    if (payment == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing payment in booking payment response',
      );
    }
    return payment;
  }

  Future<BookingModel> cancelBooking(String bookingId) async {
    await _net.assertConnection();

    final raw = await _api.post(_store(ApiConstants.bookingCancel, id: bookingId));
    final response = BookingResponse.fromJson(_asMap(raw));
    final booking = response.data;
    if (booking == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing booking in cancel booking response',
      );
    }
    return booking;
  }

  Future<BookingModel> checkInBooking(String bookingId) async {
    await _net.assertConnection();

    final raw = await _api.post(_store(ApiConstants.bookingCheckIn, id: bookingId));
    final response = BookingResponse.fromJson(_asMap(raw));
    final booking = response.data;
    if (booking == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing booking in check-in response',
      );
    }
    return booking;
  }

  String _store(String template, {String? id}) {
    final storeId = _ref.read(activeStoreIdProvider);
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Select a store before viewing bookings');
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
      message: 'Expected object response from bookings API',
    );
  }

  List<dynamic> _extractListPayload(
    Map<String, dynamic> raw, {
    required List<String> dataKeys,
  }) {
    final data = raw['data'];
    if (data is List) {
      return data;
    }

    if (data is Map) {
      final map = _asMap(data);
      for (final key in dataKeys) {
        final nested = map[key];
        if (nested is List) {
          return nested;
        }
      }
    }

    for (final key in dataKeys) {
      final nested = raw[key];
      if (nested is List) {
        return nested;
      }
    }

    return const [];
  }
}

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return BookingsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref,
  );
});
