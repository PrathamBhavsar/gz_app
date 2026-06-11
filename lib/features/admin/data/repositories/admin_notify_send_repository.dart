import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/network/network_checker.dart';

class AdminNotifySendRepository {
  AdminNotifySendRepository(this._api, this._net);

  final ApiClient _api;
  final NetworkChecker _net;

  Future<void> sendNotification({
    required String title,
    required String body,
    required String channel,
    required String audience,
  }) async {
    await _net.assertConnection();

    if (channel == 'push') {
      final topic = audience == 'active' ? 'current-players' : 'all-users';
      await _api.post(
        ApiConstants.notificationsAdminSendTopic,
        body: {
          'topic': topic,
          'audience': audience,
          'target': audience,
          'channel': channel,
          'title': title,
          'body': body,
          'message': body,
        },
      );
      return;
    }

    await _api.post(
      ApiConstants.notificationsAdminSend,
      body: {
        'title': title,
        'body': body,
        'message': body,
        'channel': channel,
        'audience': audience,
        'target': audience,
      },
    );
  }
}

final adminNotifySendRepositoryProvider = Provider<AdminNotifySendRepository>((
  ref,
) {
  return AdminNotifySendRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
  );
});
