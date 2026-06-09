import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';

const _bookingUnset = Object();

class BookingState {
  const BookingState({
    required this.selectedDate,
    this.selectedSystemTypeId,
    this.selectedSystemTypeName,
    this.selectedSlot,
    this.selectedSystem,
    this.createdBooking,
    this.selectedPaymentMethod = PaymentMethod.upi,
  });

  final DateTime selectedDate;
  final String? selectedSystemTypeId;
  final String? selectedSystemTypeName;
  final AvailabilitySlot? selectedSlot;
  final SystemModel? selectedSystem;
  final BookingModel? createdBooking;
  final PaymentMethod selectedPaymentMethod;

  BookingState copyWith({
    DateTime? selectedDate,
    Object? selectedSystemTypeId = _bookingUnset,
    Object? selectedSystemTypeName = _bookingUnset,
    Object? selectedSlot = _bookingUnset,
    Object? selectedSystem = _bookingUnset,
    Object? createdBooking = _bookingUnset,
    PaymentMethod? selectedPaymentMethod,
  }) {
    return BookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSystemTypeId: selectedSystemTypeId == _bookingUnset
          ? this.selectedSystemTypeId
          : selectedSystemTypeId as String?,
      selectedSystemTypeName: selectedSystemTypeName == _bookingUnset
          ? this.selectedSystemTypeName
          : selectedSystemTypeName as String?,
      selectedSlot: selectedSlot == _bookingUnset
          ? this.selectedSlot
          : selectedSlot as AvailabilitySlot?,
      selectedSystem: selectedSystem == _bookingUnset
          ? this.selectedSystem
          : selectedSystem as SystemModel?,
      createdBooking: createdBooking == _bookingUnset
          ? this.createdBooking
          : createdBooking as BookingModel?,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }
}

class BookingNotifier extends Notifier<BookingState> {
  @override
  BookingState build() {
    ref.listen<String?>(activeStoreIdProvider, (previous, next) {
      if (previous != next) {
        state = _initialState();
      }
    });
    return _initialState();
  }

  void setSystemType({
    required String? systemTypeId,
    required String? systemTypeName,
  }) {
    state = state.copyWith(
      selectedSystemTypeId: systemTypeId,
      selectedSystemTypeName: systemTypeName,
      selectedSystem: null,
      selectedSlot: null,
      createdBooking: null,
    );
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(
      selectedDate: _normalizeDate(date),
      selectedSlot: null,
      selectedSystem: null,
      createdBooking: null,
    );
  }

  void setSelectedSlot(AvailabilitySlot slot) {
    state = state.copyWith(
      selectedSlot: slot,
      selectedSystem: null,
      createdBooking: null,
    );
  }

  void setSelectedSystem(SystemModel system) {
    state = state.copyWith(
      selectedSystem: system,
      selectedSystemTypeId: system.systemTypeId,
      createdBooking: null,
    );
  }

  void setPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  void setCreatedBooking(BookingModel booking) {
    state = state.copyWith(createdBooking: booking);
  }

  void clearCreatedBooking() {
    state = state.copyWith(createdBooking: null);
  }

  void reset() {
    state = _initialState();
  }

  BookingState _initialState() {
    return BookingState(selectedDate: _normalizeDate(DateTime.now()));
  }

  DateTime _normalizeDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

final bookingNotifierProvider = NotifierProvider<BookingNotifier, BookingState>(
  BookingNotifier.new,
);
