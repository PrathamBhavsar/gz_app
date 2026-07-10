import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_systems.dart';
import '../data/repositories/booking_repository.dart';
import 'booking_notifier.dart';

sealed class BookingPaymentState {
  const BookingPaymentState();
}

class BookingPaymentInitial extends BookingPaymentState {
  const BookingPaymentInitial();
}

class BookingPaymentLoading extends BookingPaymentState {
  const BookingPaymentLoading();
}

class BookingPaymentSuccess extends BookingPaymentState {
  const BookingPaymentSuccess(this.booking);

  final BookingModel booking;
}

class BookingPaymentError extends BookingPaymentState {
  const BookingPaymentError(this.error);

  final Object error;
}

class BookingPaymentNotifier extends Notifier<BookingPaymentState> {
  @override
  BookingPaymentState build() => const BookingPaymentInitial();

  Future<void> submit() async {
    state = const BookingPaymentLoading();
    try {
      final bookingState = ref.read(bookingNotifierProvider);
      final bookingId = bookingState.createdBooking?.id;
      if (bookingId == null || bookingId.isEmpty) {
        throw const ValidationException(
          'Create a booking before making payment',
        );
      }

      // Backend `/pay` takes no body — the chosen payment method is not sent
      // (there's no field for it) and is purely cosmetic on this screen today.
      final booking = await ref
          .read(bookingRepositoryProvider)
          .payBooking(bookingId: bookingId);
      ref.read(bookingNotifierProvider.notifier).setCreatedBooking(booking);
      state = BookingPaymentSuccess(booking);
    } catch (error) {
      state = BookingPaymentError(error);
    }
  }

  void reset() {
    state = const BookingPaymentInitial();
  }
}

final bookingPaymentNotifierProvider =
    NotifierProvider<BookingPaymentNotifier, BookingPaymentState>(
      BookingPaymentNotifier.new,
    );
