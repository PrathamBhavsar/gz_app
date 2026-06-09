import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';

class BookingRepository {
  BookingRepository(this._api, this._net, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  Future<List<AvailabilitySlot>> fetchAvailability({
    required DateTime date,
    int? durationMinutes,
    String? systemTypeId,
  }) async {
    await _net.assertConnection();

    final raw = await _api.get(
      _withQuery(_store(ApiConstants.bookingsAvailability), {
        'date': _formatIsoDate(date),
        if (durationMinutes != null) 'duration': '$durationMinutes',
        if (systemTypeId != null && systemTypeId.isNotEmpty)
          'systemTypeId': systemTypeId,
      }),
    );
    final response = AvailabilityResponse.fromJson(_asMap(raw));
    return response.data ?? const [];
  }

  Future<BookingModel> createBooking({
    required String systemId,
    required DateTime startTime,
    required DateTime endTime,
    required PaymentMethod paymentMethod,
    String? systemTypeId,
    String? campaignId,
    int? creditsToRedeem,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      _store(ApiConstants.bookingsList),
      body: {
        'systemId': systemId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'paymentMethod': paymentMethod.name,
        if (systemTypeId != null && systemTypeId.isNotEmpty)
          'systemTypeId': systemTypeId,
        if (campaignId != null && campaignId.isNotEmpty)
          'campaignId': campaignId,
        if (creditsToRedeem != null && creditsToRedeem > 0)
          'creditsToRedeem': creditsToRedeem,
      },
    );
    final response = BookingResponse.fromJson(_asMap(raw));
    final booking = response.data;
    if (booking == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing booking in create booking response',
      );
    }
    return booking;
  }

  Future<List<CampaignModel>> fetchActiveCampaigns({
    String? systemTypeId,
  }) async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.playerCampaignsActive));
    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['campaigns', 'items'],
    );
    final campaigns = payload
        .map((item) => CampaignModel.fromJson(_asMap(item)))
        .toList(growable: false);
    if (systemTypeId == null || systemTypeId.isEmpty) {
      return campaigns;
    }
    return campaigns
        .where((campaign) {
          final applicable = campaign.applicableSystemTypes;
          return applicable == null ||
              applicable.isEmpty ||
              applicable.contains(systemTypeId);
        })
        .toList(growable: false);
  }

  Future<CreditBalanceModel?> fetchCreditBalance() async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.playerCreditsBalance));
    final response = CreditBalanceResponse.fromJson(_asMap(raw));
    return response.data;
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

    final raw = await _api.post(
      _store(ApiConstants.bookingCancel, id: bookingId),
    );
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

    final raw = await _api.post(
      _store(ApiConstants.bookingCheckIn, id: bookingId),
    );
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
      throw const ValidationException('Select a store before booking');
    }

    var path = template.replaceAll('{storeId}', storeId);
    if (id != null) {
      path = path.replaceAll('{id}', id);
    }
    return path;
  }

  String _withQuery(String path, Map<String, String> query) {
    if (query.isEmpty) {
      return path;
    }
    return '$path?${Uri(queryParameters: query).query}';
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
      message: 'Expected object response from booking API',
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

  String _formatIsoDate(DateTime value) {
    final normalized = DateTime(value.year, value.month, value.day);
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}-$month-$day';
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref,
  );
});
