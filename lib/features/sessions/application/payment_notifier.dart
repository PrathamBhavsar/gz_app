import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/bookings_repository.dart';
import 'booking_detail_notifier.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/enums.dart';

sealed class PaymentFlowState {
  const PaymentFlowState();
}

class PaymentInitial extends PaymentFlowState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentFlowState {
  const PaymentLoading();
}

class PaymentSuccess extends PaymentFlowState {
  const PaymentSuccess(this.payment);

  final PaymentModel payment;
}

class PaymentError extends PaymentFlowState {
  const PaymentError(this.error);

  final Object error;
}

class PaymentNotifier extends FamilyNotifier<PaymentFlowState, String> {
  @override
  PaymentFlowState build(String arg) => const PaymentInitial();

  Future<void> submit(PaymentMethod method) async {
    state = const PaymentLoading();
    try {
      final payment = await ref.read(bookingsRepositoryProvider).payBooking(
        bookingId: arg,
        paymentMethod: method,
        idempotencyKey: _idempotencyKey(),
      );
      await ref.read(bookingDetailNotifierProvider(arg).notifier).refresh();
      state = PaymentSuccess(payment);
    } catch (error) {
      state = PaymentError(error);
    }
  }

  void reset() {
    state = const PaymentInitial();
  }

  String _idempotencyKey() {
    final random = Random();
    final suffix = random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0');
    return 'gz-session-pay-$suffix';
  }
}

final paymentNotifierProvider = NotifierProvider.family<
    PaymentNotifier,
    PaymentFlowState,
    String>(PaymentNotifier.new);
