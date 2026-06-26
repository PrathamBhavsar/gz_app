import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/api_responses_admin.dart';
import '../../../../models/domain_admin.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';

class AdminBookingsRepository {
  AdminBookingsRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<BookingModel>> fetchBookings({
    DateTime? date,
    String? status,
  }) async {
    await _net.assertConnection();

    final raw = await _api.get(
      await _withQuery(await _store(ApiConstants.bookingsList), {
        if (date != null) 'date': _formatIsoDate(date),
        if (status != null && status.isNotEmpty && status != 'All')
          'status': _statusQuery(status),
      }),
    );
    final payload = _extractListPayload(_asMap(raw), const [
      'bookings',
      'items',
    ]);
    return payload
        .map((item) => BookingModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<BookingModel> fetchBookingDetail(String id) async {
    await _net.assertConnection();

    final raw = await _api.get(
      await _store(ApiConstants.adminBookingDetail, id: id),
    );
    final response = BookingResponse.fromJson(_asMap(raw));
    final booking = response.data;
    if (booking == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing booking in admin booking detail response',
      );
    }
    return booking;
  }

  Future<String> cancelBooking(String id, {String? reason}) async {
    await _net.assertConnection();
    final raw = await _api.post(
      await _store(ApiConstants.bookingCancel, id: id),
      body: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );
    final map = _asMap(raw);
    return map['message']?.toString() ?? 'Booking cancelled';
  }

  Future<String> checkInBooking(String id) async {
    await _net.assertConnection();
    final raw = await _api.post(
      await _store(ApiConstants.bookingCheckIn, id: id),
    );
    final map = _asMap(raw);
    return map['message']?.toString() ?? 'Booking checked in';
  }

  Future<WalkInBookingResponse> createWalkInBooking({
    required String systemId,
    required int durationMinutes,
    String? userId,
    String? userName,
    String? phone,
    PaymentMethod? paymentMethod,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await _store(ApiConstants.bookingWalkIn),
      body: {
        if (userId != null && userId.isNotEmpty) 'userId': userId,
        if (userName != null && userName.isNotEmpty) 'userName': userName,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (phone != null && phone.isNotEmpty) 'walkInPhone': phone,
        'systemId': systemId,
        'duration': durationMinutes,
        if (paymentMethod != null) 'paymentMethod': paymentMethod.name,
      },
    );
    final response = WalkInBookingResponseWrapper.fromJson(_asMap(raw));
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing walk-in booking response payload',
      );
    }
    return data;
  }

  Future<String> adminStoreId() async {
    final storeId = await _storage.getAdminStoreId();
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Missing admin store context');
    }
    return storeId;
  }

  Future<String> _store(String template, {String? id}) async {
    final storeId = await adminStoreId();
    var path = template.replaceAll('{storeId}', storeId);
    if (id != null) {
      path = path.replaceAll('{id}', id);
    }
    return path;
  }

  Future<String> _withQuery(String path, Map<String, String> query) async {
    if (query.isEmpty) {
      return path;
    }
    return '$path?${Uri(queryParameters: query).query}';
  }

  String _formatIsoDate(DateTime value) {
    final normalized = DateTime(value.year, value.month, value.day);
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}-$month-$day';
  }

  String _statusQuery(String label) {
    return switch (label) {
      'Checked In' => 'checked_in',
      'No Show' => 'no_show',
      _ => label.toLowerCase().replaceAll(' ', '_'),
    };
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
      message: 'Expected object response from admin bookings API',
    );
  }

  List<dynamic> _extractListPayload(
    Map<String, dynamic> raw,
    List<String> dataKeys,
  ) {
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

final adminBookingsRepositoryProvider = Provider<AdminBookingsRepository>((
  ref,
) {
  return AdminBookingsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
