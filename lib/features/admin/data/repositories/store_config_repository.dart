import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses_admin.dart';
import '../../../../models/domain_admin.dart';
import 'admin_store_repository_support.dart';

class StoreConfigRepository {
  StoreConfigRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<StoreConfigModel> fetchConfig() async {
    await _net.assertConnection();

    final raw = await _api.get(await adminStorePath(_storage, ApiConstants.storeConfig));
    final response = StoreConfigResponse.fromJson(
      adminStoreAsMap(raw, responseName: 'store config'),
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing store config payload',
      );
    }
    return data;
  }

  Future<StoreConfigModel> updateConfig({
    required int bookingWindowMinutes,
    required int paymentWindowMinutes,
    required int noShowGraceMinutes,
    required int maxBookingDurationMinutes,
    required String operatingHoursStart,
    required String operatingHoursEnd,
    required bool allowWalkIns,
    required bool autoStartSessionOnCheckIn,
  }) async {
    await _net.assertConnection();

    final raw = await _api.patch(
      await adminStorePath(_storage, ApiConstants.storeConfig),
      body: {
        'booking_window_minutes': bookingWindowMinutes,
        'payment_window_minutes': paymentWindowMinutes,
        'no_show_grace_minutes': noShowGraceMinutes,
        'max_booking_duration_minutes': maxBookingDurationMinutes,
        'operating_hours_start': operatingHoursStart,
        'operating_hours_end': operatingHoursEnd,
        'allow_walk_ins': allowWalkIns,
        'auto_start_session_on_check_in': autoStartSessionOnCheckIn,
      },
    );

    final response = StoreConfigResponse.fromJson(
      adminStoreAsMap(raw, responseName: 'store config update'),
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing updated store config payload',
      );
    }
    return data;
  }
}

final storeConfigRepositoryProvider = Provider<StoreConfigRepository>((ref) {
  return StoreConfigRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
