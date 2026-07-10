import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/domain_systems.dart';

class BookingRepository {
  BookingRepository(this._api, this._net, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  Future<BookingModel> createBooking({
    required String systemId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
  }) async {
    await _net.assertConnection();

    // Backend `POST /bookings` only accepts systemId/scheduledStart/scheduledEnd/notes.
    // Payment happens separately via payBooking(); campaigns/credits are redeemed
    // against the session/billing record after the session completes, not here.
    final raw = await _api.post(
      _store(ApiConstants.bookingsList),
      body: {
        'systemId': systemId,
        'scheduledStart': scheduledStart.toUtc().toIso8601String(),
        'scheduledEnd': scheduledEnd.toUtc().toIso8601String(),
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

  Future<BookingModel> payBooking({required String bookingId}) async {
    await _net.assertConnection();

    // Backend `POST /bookings/:id/pay` takes no body — it just flips the
    // booking to paid/confirmed and returns the updated booking, not a payment record.
    final raw = await _api.post(_store(ApiConstants.bookingPayment, id: bookingId));
    final response = BookingResponse.fromJson(_asMap(raw));
    final booking = response.data;
    if (booking == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing booking in booking payment response',
      );
    }
    return booking;
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

}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref,
  );
});
