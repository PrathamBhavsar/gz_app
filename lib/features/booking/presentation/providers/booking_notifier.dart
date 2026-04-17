import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_systems.dart';
import '../../data/repositories/booking_repository.dart';

class BookingState {
  final DateTime? selectedDate;
  final int selectedDurationMinutes;
  final SystemTypeModel? selectedSystemType;
  final bool isLoading;
  final String? error;

  const BookingState({
    this.selectedDate,
    this.selectedDurationMinutes = 60,
    this.selectedSystemType,
    this.isLoading = false,
    this.error,
  });

  BookingState copyWith({
    DateTime? selectedDate,
    int? selectedDurationMinutes,
    SystemTypeModel? selectedSystemType,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedDurationMinutes:
          selectedDurationMinutes ?? this.selectedDurationMinutes,
      selectedSystemType: selectedSystemType ?? this.selectedSystemType,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
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

  /// Confirm a booking for the given store.
  /// Requires storeId + systemId + systemTypeId from the UI layer
  /// (derived from the store detail / system picker screens).
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
  () {
    return BookingNotifier();
  },
);
