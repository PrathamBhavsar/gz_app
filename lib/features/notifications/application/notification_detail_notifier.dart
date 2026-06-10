import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_misc.dart';
import '../data/repositories/notifications_repository.dart';
import 'notifications_notifier.dart';

class NotificationDetailNotifier
    extends FamilyAsyncNotifier<NotificationModel, String> {
  @override
  Future<NotificationModel> build(String arg) => _load(arg);

  Future<void> refresh() async {
    final id = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(id));
  }

  Future<NotificationModel> _load(String id) async {
    final notification = await ref
        .read(notificationsRepositoryProvider)
        .fetchNotificationById(id);
    ref.read(notificationsNotifierProvider.notifier).mergeDetail(notification);
    return notification;
  }
}

final notificationDetailNotifierProvider =
    AsyncNotifierProvider.family<
      NotificationDetailNotifier,
      NotificationModel,
      String
    >(NotificationDetailNotifier.new);
