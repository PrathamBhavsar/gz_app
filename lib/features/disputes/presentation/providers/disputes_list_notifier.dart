import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_billing.dart';
import '../../../disputes/data/repositories/dispute_repository.dart';

class DisputesListNotifier extends Notifier<AsyncValue<List<BillingDisputeModel>>> {
  @override
  AsyncValue<List<BillingDisputeModel>> build() {
    _fetch();
    return const AsyncLoading();
  }

  Future<void> _fetch() async {
    state = const AsyncLoading();
    try {
      final storeId = ref.read(activeStoreIdProvider);
      if (storeId == null) {
        state = const AsyncData([]);
        return;
      }
      final repo = ref.read(disputeRepositoryProvider);
      final res = await repo.fetchMyDisputes(storeId);
      state = AsyncData(res.data ?? []);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _fetch();
}

final disputesListProvider =
    NotifierProvider<DisputesListNotifier, AsyncValue<List<BillingDisputeModel>>>(
  DisputesListNotifier.new,
);
