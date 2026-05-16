import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/notifications/data/repositories/notification_repository.dart';

class NotifPrefsData {
  final bool push;
  final bool email;
  final bool sms;
  final bool bookingConfirmations;
  final bool bookingReminders;
  final bool sessionEnding;
  final bool creditUpdates;
  final bool newCampaigns;
  final bool disputeUpdates;

  const NotifPrefsData({
    this.push = true,
    this.email = true,
    this.sms = true,
    this.bookingConfirmations = true,
    this.bookingReminders = true,
    this.sessionEnding = true,
    this.creditUpdates = true,
    this.newCampaigns = true,
    this.disputeUpdates = true,
  });

  factory NotifPrefsData.fromMap(Map<String, bool> map) => NotifPrefsData(
    push: map['push'] ?? true,
    email: map['email'] ?? true,
    sms: map['sms'] ?? true,
    bookingConfirmations: map['bookingConfirmations'] ?? map['booking_confirmations'] ?? true,
    bookingReminders: map['bookingReminders'] ?? map['booking_reminders'] ?? true,
    sessionEnding: map['sessionEnding'] ?? map['session_ending'] ?? true,
    creditUpdates: map['creditUpdates'] ?? map['credit_updates'] ?? true,
    newCampaigns: map['newCampaigns'] ?? map['new_campaigns'] ?? true,
    disputeUpdates: map['disputeUpdates'] ?? map['dispute_updates'] ?? true,
  );

  Map<String, bool> toMap() => {
    'push': push,
    'email': email,
    'sms': sms,
    'bookingConfirmations': bookingConfirmations,
    'bookingReminders': bookingReminders,
    'sessionEnding': sessionEnding,
    'creditUpdates': creditUpdates,
    'newCampaigns': newCampaigns,
    'disputeUpdates': disputeUpdates,
  };

  NotifPrefsData copyWith({
    bool? push,
    bool? email,
    bool? sms,
    bool? bookingConfirmations,
    bool? bookingReminders,
    bool? sessionEnding,
    bool? creditUpdates,
    bool? newCampaigns,
    bool? disputeUpdates,
  }) => NotifPrefsData(
    push: push ?? this.push,
    email: email ?? this.email,
    sms: sms ?? this.sms,
    bookingConfirmations: bookingConfirmations ?? this.bookingConfirmations,
    bookingReminders: bookingReminders ?? this.bookingReminders,
    sessionEnding: sessionEnding ?? this.sessionEnding,
    creditUpdates: creditUpdates ?? this.creditUpdates,
    newCampaigns: newCampaigns ?? this.newCampaigns,
    disputeUpdates: disputeUpdates ?? this.disputeUpdates,
  );
}

class NotifPrefsNotifier extends Notifier<AsyncValue<NotifPrefsData>> {
  Timer? _debounce;

  @override
  AsyncValue<NotifPrefsData> build() {
    ref.onDispose(() => _debounce?.cancel());
    _fetch();
    return const AsyncLoading();
  }

  Future<void> _fetch() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(notificationRepositoryProvider);
      final res = await repo.fetchPreferences();
      state = AsyncData(NotifPrefsData.fromMap(res.data ?? {}));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void update(NotifPrefsData newPrefs) {
    state = AsyncData(newPrefs);
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      try {
        final repo = ref.read(notificationRepositoryProvider);
        await repo.updatePreferences(newPrefs.toMap());
      } catch (_) {}
    });
  }

  Future<void> refresh() => _fetch();
}

final notifPrefsProvider =
    NotifierProvider<NotifPrefsNotifier, AsyncValue<NotifPrefsData>>(
  NotifPrefsNotifier.new,
);
