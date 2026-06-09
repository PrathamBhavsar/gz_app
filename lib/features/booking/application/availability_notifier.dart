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
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AvailabilityData> _load() async {
    final booking = ref.read(bookingNotifierProvider);
    final slots = await ref
        .read(bookingRepositoryProvider)
        .fetchAvailability(
          date: booking.selectedDate,
          systemTypeId: booking.selectedSystemTypeId,
        );
    return AvailabilityData(slots: slots);
  }
}

final availabilityNotifierProvider =
    AsyncNotifierProvider<AvailabilityNotifier, AvailabilityData>(
      AvailabilityNotifier.new,
    );
