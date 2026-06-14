import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_billing.dart';
import '../data/repositories/admin_disputes_repository.dart';

class AdminDisputeDetailNotifier
    extends FamilyAsyncNotifier<BillingDisputeModel, String> {
  @override
  Future<BillingDisputeModel> build(String arg) =>
      ref.read(adminDisputesRepositoryProvider).fetchDisputeDetail(arg);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(adminDisputesRepositoryProvider).fetchDisputeDetail(arg),
    );
  }
}

final adminDisputeDetailNotifierProvider =
    AsyncNotifierProvider.family<
      AdminDisputeDetailNotifier,
      BillingDisputeModel,
      String
    >(AdminDisputeDetailNotifier.new);
