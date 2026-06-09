import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_systems.dart';
import '../data/repositories/booking_repository.dart';
import 'booking_notifier.dart';
import 'booking_summary_ui_notifier.dart';

sealed class BookingFormState {
  const BookingFormState();
}

class BookingFormInitial extends BookingFormState {
  const BookingFormInitial();
}

class BookingFormLoading extends BookingFormState {
  const BookingFormLoading();
}

class BookingFormSuccess extends BookingFormState {
  const BookingFormSuccess(this.booking);

  final BookingModel booking;
}

class BookingFormError extends BookingFormState {
  const BookingFormError(this.error);

  final Object error;
}

class BookingFormNotifier extends Notifier<BookingFormState> {
  @override
  BookingFormState build() => const BookingFormInitial();

  Future<void> submit() async {
    state = const BookingFormLoading();
    try {
      final bookingState = ref.read(bookingNotifierProvider);
      final slot = bookingState.selectedSlot;
      final system = bookingState.selectedSystem;
      final startTime = _parseRequiredTime(
        slot?.startTime,
        'Pick a booking slot before confirming',
      );
      final endTime = _parseRequiredTime(
        slot?.endTime,
        'Pick a booking slot before confirming',
      );
      final systemId = system?.id;
      if (systemId == null || systemId.isEmpty) {
        throw const ValidationException(
          'Pick a system before confirming the booking',
        );
      }
      final summaryUi = ref.read(bookingSummaryUiNotifierProvider).valueOrNull;

      final booking = await ref
          .read(bookingRepositoryProvider)
          .createBooking(
            systemId: systemId,
            systemTypeId:
                system?.systemTypeId ?? bookingState.selectedSystemTypeId,
            startTime: startTime,
            endTime: endTime,
            paymentMethod: bookingState.selectedPaymentMethod,
            campaignId: summaryUi?.selectedCampaignId,
            creditsToRedeem: summaryUi?.creditsToRedeem,
          );
      ref.read(bookingNotifierProvider.notifier).setCreatedBooking(booking);
      state = BookingFormSuccess(booking);
    } catch (error) {
      state = BookingFormError(error);
    }
  }

  void reset() {
    state = const BookingFormInitial();
  }

  DateTime _parseRequiredTime(String? value, String message) {
    final parsed = value == null || value.isEmpty
        ? null
        : DateTime.tryParse(value);
    if (parsed == null) {
      throw ValidationException(message);
    }
    return parsed;
  }
}

final bookingFormNotifierProvider =
    NotifierProvider<BookingFormNotifier, BookingFormState>(
      BookingFormNotifier.new,
    );
