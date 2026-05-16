import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../features/sessions/data/repositories/billing_repository.dart';
import '../../../../models/api_responses.dart';

class BillingNotifier extends Notifier<AsyncValue<List<BillingRow>>> {
  @override
  AsyncValue<List<BillingRow>> build() {
    // Re-fetch when the active store changes
    ref.watch(activeStoreIdProvider);
    _fetch();
    return const AsyncLoading();
  }

  Future<void> _fetch() async {
    state = const AsyncLoading();
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final repo = ref.read(billingRepositoryProvider);
      final response = await repo.fetchMyBilling(storeId);
      state = AsyncData(response.data ?? []);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _fetch();
}

final billingNotifierProvider =
    NotifierProvider<BillingNotifier, AsyncValue<List<BillingRow>>>(
  BillingNotifier.new,
);
