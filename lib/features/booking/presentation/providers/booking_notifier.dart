import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_systems.dart';
import '../../data/repositories/booking_repository.dart';

class BookingState {
  final DateTime? selectedDate;
  final int selectedDurationMinutes;
  final SystemTypeModel? selectedSystemType;
  final bool isLoading;
  final String? error;

  // Phase 4: slot + specific system selection (accumulated across the booking flow)
  final DateTime? selectedSlotStart;
  final DateTime? selectedSlotEnd;
  final SystemModel? selectedSystem;
  final String selectedTypeFilter; // 'all' | 'pc' | 'ps5' | 'xbox' | 'vr' | 'other'

  const BookingState({
    this.selectedDate,
    this.selectedDurationMinutes = 60,
    this.selectedSystemType,
    this.isLoading = false,
    this.error,
    this.selectedSlotStart,
    this.selectedSlotEnd,
    this.selectedSystem,
    this.selectedTypeFilter = 'all',
  });

  BookingState copyWith({
    DateTime? selectedDate,
    int? selectedDurationMinutes,
    SystemTypeModel? selectedSystemType,
    bool? isLoading,
    String? error,
    DateTime? selectedSlotStart,
    DateTime? selectedSlotEnd,
    SystemModel? selectedSystem,
    String? selectedTypeFilter,
  }) {
    return BookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedDurationMinutes:
          selectedDurationMinutes ?? this.selectedDurationMinutes,
      selectedSystemType: selectedSystemType ?? this.selectedSystemType,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedSlotStart: selectedSlotStart ?? this.selectedSlotStart,
      selectedSlotEnd: selectedSlotEnd ?? this.selectedSlotEnd,
      selectedSystem: selectedSystem ?? this.selectedSystem,
      selectedTypeFilter: selectedTypeFilter ?? this.selectedTypeFilter,
    );
  }

  bool get hasSlot => selectedSlotStart != null && selectedSlotEnd != null;
}

class BookingNotifier extends Notifier<BookingState> {
  @override
  BookingState build() {
    return BookingState(selectedDate: DateTime.now());
  }

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateDuration(int minutes) {
    state = state.copyWith(selectedDurationMinutes: minutes);
  }

  void selectSystemType(SystemTypeModel system) {
    state = state.copyWith(selectedSystemType: system);
  }

  void setTypeFilter(String filter) {
    state = state.copyWith(selectedTypeFilter: filter);
  }

  void selectSlot(DateTime start, DateTime end) {
    state = state.copyWith(selectedSlotStart: start, selectedSlotEnd: end);
  }

  void selectSystem(SystemModel system) {
    state = state.copyWith(selectedSystem: system);
  }

  void resetFlow() {
    state = BookingState(selectedDate: DateTime.now());
  }

  Future<bool> confirmBooking(
    String storeId, {
    required String systemId,
    required String systemTypeId,
    required DateTime startTime,
    required DateTime endTime,
    String? paymentMethod,
    String? campaignId,
    int? creditsToRedeem,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(bookingRepositoryProvider);
      final response = await repo.placeBooking(
        storeId,
        systemId: systemId,
        startTime: startTime.toUtc().toIso8601String(),
        endTime: endTime.toUtc().toIso8601String(),
        systemTypeId: systemTypeId,
        paymentMethod: paymentMethod,
        campaignId: campaignId,
        creditsToRedeem: creditsToRedeem,
      );
      state = state.copyWith(isLoading: false);
      return response.success == true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final bookingNotifierProvider = NotifierProvider<BookingNotifier, BookingState>(
  () => BookingNotifier(),
);
