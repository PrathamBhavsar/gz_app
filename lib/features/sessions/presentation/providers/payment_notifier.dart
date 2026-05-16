import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';

sealed class PaymentState {
  const PaymentState();
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentSuccess extends PaymentState {
  final String bookingId;
  const PaymentSuccess(this.bookingId);
}

class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);
}

class PaymentNotifier extends Notifier<PaymentState> {
  @override
  PaymentState build() => const PaymentInitial();

  Future<void> pay(String bookingId, String method) async {
    state = const PaymentLoading();
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final endpoint = ApiConstants.bookingPayment
          .replaceAll('{storeId}', storeId)
          .replaceAll('{id}', bookingId);
      final api = ref.read(apiClientProvider);
      await api.post(endpoint, body: {'method': method});
      state = PaymentSuccess(bookingId);
    } on ValidationException catch (e) {
      state = PaymentError(e.message);
    } catch (e) {
      state = PaymentError(e.toString());
    }
  }

  void reset() => state = const PaymentInitial();
}

final paymentNotifierProvider =
    NotifierProvider<PaymentNotifier, PaymentState>(PaymentNotifier.new);
