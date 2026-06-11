import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_notify_send_repository.dart';
import 'admin_command_state.dart';

class AdminNotifySendNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> send({
    required String title,
    required String body,
    required String channel,
    required String audience,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(adminNotifySendRepositoryProvider).sendNotification(
        title: title,
        body: body,
        channel: channel,
        audience: audience,
      );
      state = const AdminCommandSuccess('Notification sent');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() {
    state = const AdminCommandInitial();
  }
}

final adminNotifySendNotifierProvider =
    NotifierProvider<AdminNotifySendNotifier, AdminCommandState>(
      AdminNotifySendNotifier.new,
    );
