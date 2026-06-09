import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses.dart';
import '../data/repositories/billing_repository.dart';

class BillingNotifier extends AsyncNotifier<List<BillingRow>> {
  @override
  Future<List<BillingRow>> build() async {
    ref.watch(activeStoreIdProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<List<BillingRow>> _load() async {
    return ref.read(billingRepositoryProvider).fetchBillingHistory();
  }
}

final billingNotifierProvider =
    AsyncNotifierProvider<BillingNotifier, List<BillingRow>>(
      BillingNotifier.new,
    );
