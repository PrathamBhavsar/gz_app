import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_feed_notifier.g.dart';

enum NotificationFeedType { booking, session, credit, dispute, general }

class NotificationFeedItem {
  const NotificationFeedItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
    this.isUnread = false,
    this.referenceId,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final NotificationFeedType type;
  final bool isUnread;
  final String? referenceId;

  NotificationFeedItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    NotificationFeedType? type,
    bool? isUnread,
    String? referenceId,
  }) {
    return NotificationFeedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isUnread: isUnread ?? this.isUnread,
      referenceId: referenceId ?? this.referenceId,
    );
  }
}

@riverpod
class NotificationFeed extends _$NotificationFeed {
  @override
  List<NotificationFeedItem> build() {
    return [
      NotificationFeedItem(
        id: 'notif-001',
        title: 'Booking confirmed',
        subtitle: 'PC Station 01',
        timestamp: DateTime(2026, 6, 8, 14, 45),
        isUnread: true,
        type: NotificationFeedType.booking,
        referenceId: 'BKG-001',
      ),
      NotificationFeedItem(
        id: 'notif-002',
        title: 'Session ending in 10 min',
        subtitle: 'Wrap up or extend your time',
        timestamp: DateTime(2026, 6, 8, 14, 38),
        isUnread: true,
        type: NotificationFeedType.session,
        referenceId: 'GZ-2406-4891',
      ),
      NotificationFeedItem(
        id: 'notif-003',
        title: 'Welcome Bonus campaign applied',
        subtitle: 'Credits added to your wallet',
        timestamp: DateTime(2026, 6, 7, 18, 0),
        type: NotificationFeedType.credit,
      ),
      NotificationFeedItem(
        id: 'notif-004',
        title: 'Session receipt ready',
        subtitle: 'GZ-2406-4891',
        timestamp: DateTime(2026, 6, 3, 12, 0),
        type: NotificationFeedType.session,
        referenceId: 'GZ-2406-4891',
      ),
      NotificationFeedItem(
        id: 'notif-005',
        title: 'New campaign: Happy Hours',
        subtitle: 'Check today\'s discounted slots',
        timestamp: DateTime(2026, 6, 2, 12, 0),
        type: NotificationFeedType.credit,
      ),
    ];
  }

  void markRead(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isUnread: false) else item,
    ];
  }

  void markAllRead() {
    state = [for (final item in state) item.copyWith(isUnread: false)];
  }

  void prependFromWs(Map<String, dynamic> payload) {
    final id =
        payload['id']?.toString() ??
        payload['notificationId']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final title =
        payload['title']?.toString() ??
        payload['message']?.toString() ??
        'New notification';
    final subtitle =
        payload['subtitle']?.toString() ??
        payload['body']?.toString() ??
        'Open notifications for details';
    final referenceId =
        payload['referenceId']?.toString() ?? payload['entityId']?.toString();
    final type = _typeFromPayload(payload);

    state = [
      NotificationFeedItem(
        id: id,
        title: title,
        subtitle: subtitle,
        timestamp: DateTime.now(),
        type: type,
        isUnread: true,
        referenceId: referenceId,
      ),
      ...state,
    ];
  }

  NotificationFeedType _typeFromPayload(Map<String, dynamic> payload) {
    final raw =
        payload['type']?.toString() ??
        payload['referenceType']?.toString() ??
        '';

    switch (raw) {
      case 'booking':
        return NotificationFeedType.booking;
      case 'session':
        return NotificationFeedType.session;
      case 'credit':
      case 'campaign':
        return NotificationFeedType.credit;
      case 'dispute':
        return NotificationFeedType.dispute;
      default:
        return NotificationFeedType.general;
    }
  }
}

@riverpod
int unreadNotificationCount(UnreadNotificationCountRef ref) {
  return ref.watch(
    notificationFeedProvider.select(
      (items) => items.where((item) => item.isUnread).length,
    ),
  );
}
