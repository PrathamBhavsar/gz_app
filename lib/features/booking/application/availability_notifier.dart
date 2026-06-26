import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses.dart';
import '../data/repositories/booking_repository.dart';
import 'booking_notifier.dart';

class AvailabilityData {
  const AvailabilityData({required this.slots});

  final List<AvailabilitySlot> slots;
}

class AvailabilityNotifier extends AsyncNotifier<AvailabilityData> {
  @override
  Future<AvailabilityData> build() async {
    ref.watch(activeStoreIdProvider);
    ref.watch(bookingNotifierProvider.select((state) => state.selectedDate));
    ref.watch(
      bookingNotifierProvider.select((state) => state.selectedSystemTypeId),
    );
    ref.watch(
      bookingNotifierProvider.select((state) => state.selectedSystem?.id),
    );
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AvailabilityData> _load() async {
    final booking = ref.read(bookingNotifierProvider);
    final systemId = booking.selectedSystem?.id;
    if (systemId == null || systemId.isEmpty) {
      return const AvailabilityData(slots: []);
    }

    final date = booking.selectedDate;
    final start = DateTime.utc(date.year, date.month, date.day);
    final end = DateTime.utc(date.year, date.month, date.day, 23, 59, 59);

    final slots = await ref
        .read(bookingRepositoryProvider)
        .fetchAvailability(systemId: systemId, start: start, end: end);
    return AvailabilityData(slots: slots);
  }
}

final availabilityNotifierProvider =
    AsyncNotifierProvider<AvailabilityNotifier, AvailabilityData>(
      AvailabilityNotifier.new,
    );
