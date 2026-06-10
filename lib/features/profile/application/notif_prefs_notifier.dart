import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifications/data/repositories/notifications_repository.dart';

const Map<String, bool> kDefaultNotifPrefs = <String, bool>{
  'push_notifications': true,
  'booking_updates': true,
  'session_alerts': true,
  'promotions': false,
  'new_campaigns': true,
  'system_availability': false,
  'credit_expiry': true,
};

class NotifPrefsNotifier extends AsyncNotifier<Map<String, bool>> {
  @override
  Future<Map<String, bool>> build() async {
    final remote = await ref
        .read(notificationsRepositoryProvider)
        .fetchPreferences();
    return _mergeDefaults(remote);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> setPreference(String key, bool value) async {
    final current = state.valueOrNull ?? kDefaultNotifPrefs;
    final next = Map<String, bool>.from(current)..[key] = value;
    state = AsyncData(next);

    try {
      final updated = await ref
          .read(notificationsRepositoryProvider)
          .updatePreferences(next);
      state = AsyncData(_mergeDefaults(updated));
    } catch (error, stackTrace) {
      state = AsyncData(current);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Map<String, bool> _mergeDefaults(Map<String, bool> remote) {
    return <String, bool>{...kDefaultNotifPrefs, ...remote};
  }
}

final notifPrefsNotifierProvider =
    AsyncNotifierProvider<NotifPrefsNotifier, Map<String, bool>>(
      NotifPrefsNotifier.new,
    );
