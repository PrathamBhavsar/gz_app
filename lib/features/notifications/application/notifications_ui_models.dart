import '../../../../models/domain_misc.dart';

class NotificationsData {
  const NotificationsData({required this.items, required this.unreadCount});

  final List<NotificationModel> items;
  final int unreadCount;

  bool get hasUnread => unreadCount > 0;

  NotificationsData markRead(String id) {
    var changed = false;
    final updatedItems = items
        .map((item) {
          if (item.id != id || !isUnreadNotification(item)) {
            return item;
          }
          changed = true;
          return NotificationModel(
            id: item.id,
            storeId: item.storeId,
            userId: item.userId,
            channel: item.channel,
            status: item.status,
            title: item.title,
            body: item.body,
            scheduledAt: item.scheduledAt,
            sentAt: item.sentAt,
            deliveredAt: item.deliveredAt,
            readAt: DateTime.now(),
            referenceType: item.referenceType,
            referenceId: item.referenceId,
            gatewayResponse: item.gatewayResponse,
            createdAt: item.createdAt,
          );
        })
        .toList(growable: false);

    return NotificationsData(
      items: updatedItems,
      unreadCount: changed && unreadCount > 0 ? unreadCount - 1 : unreadCount,
    );
  }

  NotificationsData markAllRead() {
    if (!hasUnread) {
      return this;
    }

    return NotificationsData(
      items: items
          .map(
            (item) => isUnreadNotification(item)
                ? NotificationModel(
                    id: item.id,
                    storeId: item.storeId,
                    userId: item.userId,
                    channel: item.channel,
                    status: item.status,
                    title: item.title,
                    body: item.body,
                    scheduledAt: item.scheduledAt,
                    sentAt: item.sentAt,
                    deliveredAt: item.deliveredAt,
                    readAt: DateTime.now(),
                    referenceType: item.referenceType,
                    referenceId: item.referenceId,
                    gatewayResponse: item.gatewayResponse,
                    createdAt: item.createdAt,
                  )
                : item,
          )
          .toList(growable: false),
      unreadCount: 0,
    );
  }

  NotificationsData prepend(NotificationModel item) {
    final remaining = items
        .where((existing) => existing.id != item.id)
        .toList(growable: false);
    return NotificationsData(
      items: [item, ...remaining],
      unreadCount: unreadCount + (isUnreadNotification(item) ? 1 : 0),
    );
  }

  NotificationsData upsert(NotificationModel item) {
    final existingIndex = items.indexWhere(
      (existing) => existing.id == item.id,
    );
    if (existingIndex == -1) {
      return prepend(item);
    }

    final existing = items[existingIndex];
    final updatedItems = [...items];
    updatedItems[existingIndex] = item;
    final nextUnreadCount =
        unreadCount -
        (isUnreadNotification(existing) ? 1 : 0) +
        (isUnreadNotification(item) ? 1 : 0);
    return NotificationsData(
      items: updatedItems,
      unreadCount: nextUnreadCount < 0 ? 0 : nextUnreadCount,
    );
  }
}

bool isUnreadNotification(NotificationModel item) =>
    item.readAt == null && item.status?.name != 'read';
