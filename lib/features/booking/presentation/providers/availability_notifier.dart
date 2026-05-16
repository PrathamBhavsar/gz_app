import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses.dart';
import '../../data/repositories/booking_repository.dart';

class AvailabilityData {
  final List<AvailabilitySlot> slots;
  final DateTime selectedDate;
  final String? selectedSlotStart;
  final String? selectedSlotEnd;

  const AvailabilityData({
    required this.slots,
    required this.selectedDate,
    this.selectedSlotStart,
    this.selectedSlotEnd,
  });

  bool get hasSlotSelected =>
      selectedSlotStart != null && selectedSlotEnd != null;

  AvailabilityData copyWith({
    List<AvailabilitySlot>? slots,
    DateTime? selectedDate,
    Object? selectedSlotStart = _sentinel,
    Object? selectedSlotEnd = _sentinel,
  }) {
    return AvailabilityData(
      slots: slots ?? this.slots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlotStart: selectedSlotStart == _sentinel
          ? this.selectedSlotStart
          : selectedSlotStart as String?,
      selectedSlotEnd: selectedSlotEnd == _sentinel
          ? this.selectedSlotEnd
          : selectedSlotEnd as String?,
    );
  }

  static const Object _sentinel = Object();
}

class AvailabilityNotifier extends Notifier<AsyncValue<AvailabilityData>> {
  @override
  AsyncValue<AvailabilityData> build() {
    final today = DateTime.now();
    // Auto-load today's availability when storeId is set
    final storeId = ref.watch(activeStoreIdProvider);
    if (storeId != null) {
      Future.microtask(() => fetchForDate(today));
    }
    return AsyncData(AvailabilityData(slots: const [], selectedDate: today));
  }

  Future<void> fetchForDate(DateTime date, {String? systemTypeId}) async {
    final storeId = ref.read(activeStoreIdProvider);
    if (storeId == null) return;
    state = const AsyncLoading();
    try {
      final repo = ref.read(bookingRepositoryProvider);
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await repo.fetchAvailability(
        storeId,
        date: dateStr,
        systemTypeId: systemTypeId,
      );
      state = AsyncData(AvailabilityData(
        slots: response.data ?? [],
        selectedDate: date,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void selectSlot(String startTime, String endTime) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      selectedSlotStart: startTime,
      selectedSlotEnd: endTime,
    ));
  }

  void clearSlot() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      selectedSlotStart: null,
      selectedSlotEnd: null,
    ));
  }
}

final availabilityNotifierProvider =
    NotifierProvider<AvailabilityNotifier, AsyncValue<AvailabilityData>>(
  () => AvailabilityNotifier(),
);
