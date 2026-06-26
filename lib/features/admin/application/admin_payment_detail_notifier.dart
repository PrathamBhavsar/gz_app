import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_billing.dart';
import '../data/repositories/payments_repository.dart';

class AdminPaymentDetailNotifier
    extends FamilyAsyncNotifier<PaymentModel, String> {
  @override
  Future<PaymentModel> build(String arg) {
    return ref.read(paymentsRepositoryProvider).fetchPaymentDetail(arg);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(paymentsRepositoryProvider).fetchPaymentDetail(arg),
    );
  }
}

final adminPaymentDetailNotifierProvider =
    AsyncNotifierProvider.family<
      AdminPaymentDetailNotifier,
      PaymentModel,
      String
    >(AdminPaymentDetailNotifier.new);
