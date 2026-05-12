import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotifItem {
  const NotifItem({
    required this.id,
    required this.icon,
    required this.kind,
    required this.read,
    required this.title,
    required this.body,
    required this.when,
    required this.action,
  });

  final String id;
  final String icon;
  final String kind; // ok | warn | err | info | purple | mute
  final bool read;
  final String title;
  final String body;
  final String when;
  final String action;

  NotifItem copyWith({bool? read}) =>
      NotifItem(id: id, icon: icon, kind: kind, read: read ?? this.read,
          title: title, body: body, when: when, action: action);
}

class NotificationsState {
  const NotificationsState({required this.items, this.expandedId});

  final List<NotifItem> items;
  final String? expandedId;

  NotificationsState copyWith({List<NotifItem>? items, Object? expandedId = _s}) {
    return NotificationsState(
      items:      items      ?? this.items,
      expandedId: expandedId == _s ? this.expandedId : expandedId as String?,
    );
  }

  static const Object _s = Object();
}

class NotificationsNotifier extends Notifier<NotificationsState> {
  @override
  NotificationsState build() => NotificationsState(items: _initial);

  void toggleExpand(String id) {
    final next = state.expandedId == id ? null : id;
    final items = state.items
        .map((n) => n.id == id ? n.copyWith(read: true) : n)
        .toList();
    state = state.copyWith(items: items, expandedId: next);
  }

  void markAllRead() {
    state = state.copyWith(
      items: state.items.map((n) => n.copyWith(read: true)).toList(),
    );
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, NotificationsState>(
  () => NotificationsNotifier(),
);

const _initial = [
  NotifItem(id: 'n1', icon: 'clock', kind: 'info',   read: false,
    title: 'Your session starts in 30 min',
    body: 'GameZone Koramangala, Seat 3. Make sure to check in 5 minutes before 4:00 PM.',
    when: '28 min ago', action: 'View booking →'),
  NotifItem(id: 'n2', icon: 'check', kind: 'ok',     read: false,
    title: 'Payment confirmed — ₹82',
    body: 'Your booking for Sat, 18 Apr (RTX 4090 — Seat 3) is paid in full.',
    when: '2 hrs ago', action: 'View receipt →'),
  NotifItem(id: 'n3', icon: 'star',  kind: 'ok',     read: false,
    title: '850 credits earned this month',
    body: 'You hit our top tier. Use them at GameZone Koramangala for up to ₹85 off.',
    when: '5 hrs ago', action: 'Open wallet →'),
  NotifItem(id: 'n4', icon: 'bell',  kind: 'warn',   read: true,
    title: 'Happy Hour ends tomorrow',
    body: '30% off all weekday sessions between 10am and 2pm — last day to claim is tomorrow.',
    when: 'Yesterday', action: 'View campaign →'),
  NotifItem(id: 'n5', icon: 'info',  kind: 'info',   read: true,
    title: 'Dispute #DIS-0042 resolved',
    body: 'Full refund of ₹80 has been issued back to your original UPI account.',
    when: '2 days ago', action: 'View dispute →'),
  NotifItem(id: 'n6', icon: 'pin',   kind: 'purple', read: true,
    title: 'New store added near you',
    body: 'GameZone Whitefield is now live, 18 PC stations, 6 PS5s. 8 km away.',
    when: '3 days ago', action: 'Explore store →'),
  NotifItem(id: 'n7', icon: 'pad',   kind: 'mute',   read: true,
    title: 'Session completed — ₹160 charged',
    body: '2 hours at GameZone MG Road on RTX 3080. You earned 80 credits.',
    when: '4 days ago', action: 'View session →'),
];
