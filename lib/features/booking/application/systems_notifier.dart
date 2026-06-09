import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_systems.dart';
import '../data/repositories/systems_repository.dart';
import 'booking_notifier.dart';

class SystemsNotifier extends AsyncNotifier<List<SystemModel>> {
  Timer? _poller;

  @override
  Future<List<SystemModel>> build() async {
    ref.watch(activeStoreIdProvider);
    ref.watch(
      bookingNotifierProvider.select((state) => state.selectedSlot?.startTime),
    );
    ref.watch(
      bookingNotifierProvider.select((state) => state.selectedSlot?.endTime),
    );
    ref.watch(
      bookingNotifierProvider.select((state) => state.selectedSystemTypeId),
    );

    _poller ??= Timer.periodic(const Duration(seconds: 30), (_) => refresh());
    ref.onDispose(() => _poller?.cancel());

    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<List<SystemModel>> _load() async {
    final booking = ref.read(bookingNotifierProvider);
    final slot = booking.selectedSlot;
    return ref
        .read(systemsRepositoryProvider)
        .fetchAvailableSystems(
          startTime: _parseIso(slot?.startTime),
          endTime: _parseIso(slot?.endTime),
          systemTypeId: booking.selectedSystemTypeId,
        );
  }

  DateTime? _parseIso(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}

final systemsNotifierProvider =
    AsyncNotifierProvider<SystemsNotifier, List<SystemModel>>(
      SystemsNotifier.new,
    );

final filteredSystemsProvider = Provider<AsyncValue<List<SystemModel>>>((ref) {
  return ref.watch(systemsNotifierProvider);
});
