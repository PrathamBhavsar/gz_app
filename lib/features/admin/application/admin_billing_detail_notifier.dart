import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_billing.dart';
import '../data/repositories/admin_billing_repository.dart';

class AdminBillingDetailNotifier
    extends FamilyAsyncNotifier<BillingLedgerDetailModel, String> {
  @override
  Future<BillingLedgerDetailModel> build(String arg) {
    return ref.read(adminBillingRepositoryProvider).fetchLedgerDetail(arg);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(adminBillingRepositoryProvider).fetchLedgerDetail(arg),
    );
  }
}

final adminBillingDetailNotifierProvider =
    AsyncNotifierProvider.family<
      AdminBillingDetailNotifier,
      BillingLedgerDetailModel,
      String
    >(AdminBillingDetailNotifier.new);
