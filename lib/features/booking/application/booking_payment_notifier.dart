import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_billing.dart';
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
  const BookingPaymentSuccess(this.payment);

  final PaymentModel payment;
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

      final payment = await ref
          .read(bookingRepositoryProvider)
          .payBooking(
            bookingId: bookingId,
            paymentMethod: bookingState.selectedPaymentMethod,
            idempotencyKey: _idempotencyKey(),
          );
      state = BookingPaymentSuccess(payment);
    } catch (error) {
      state = BookingPaymentError(error);
    }
  }

  void reset() {
    state = const BookingPaymentInitial();
  }

  String _idempotencyKey() {
    final random = Random();
    final suffix = random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0');
    return 'gz-book-$suffix';
  }
}

final bookingPaymentNotifierProvider =
    NotifierProvider<BookingPaymentNotifier, BookingPaymentState>(
      BookingPaymentNotifier.new,
    );
