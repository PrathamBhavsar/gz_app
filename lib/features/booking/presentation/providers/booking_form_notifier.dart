import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_systems.dart';
import '../../data/repositories/booking_repository.dart';

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
  final BookingModel booking;
  const BookingFormSuccess(this.booking);
}

class BookingFormError extends BookingFormState {
  final String message;
  const BookingFormError(this.message);
}

class BookingFormNotifier extends Notifier<BookingFormState> {
  @override
  BookingFormState build() => const BookingFormInitial();

  Future<void> submit({
    required String storeId,
    required String systemId,
    required String startTime,
    required String endTime,
    required String systemTypeId,
    required String paymentMethod,
    String? campaignId,
    int? creditsToRedeem,
  }) async {
    state = const BookingFormLoading();
    try {
      final repo = ref.read(bookingRepositoryProvider);
      final response = await repo.placeBooking(
        storeId,
        systemId: systemId,
        startTime: startTime,
        endTime: endTime,
        systemTypeId: systemTypeId,
        paymentMethod: paymentMethod,
        campaignId: campaignId,
        creditsToRedeem: creditsToRedeem,
      );
      if (response.data != null) {
        state = BookingFormSuccess(response.data!);
      } else {
        state = const BookingFormError('Booking failed. Please try again.');
      }
    } on ValidationException catch (e) {
      state = BookingFormError(e.message);
    } catch (e) {
      state = BookingFormError(e.toString());
    }
  }

  void reset() => state = const BookingFormInitial();
}

final bookingFormNotifierProvider =
    NotifierProvider<BookingFormNotifier, BookingFormState>(
  () => BookingFormNotifier(),
);
