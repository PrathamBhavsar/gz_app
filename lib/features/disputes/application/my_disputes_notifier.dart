import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_billing.dart';
import '../data/repositories/disputes_repository.dart';

class MyDisputesNotifier extends AsyncNotifier<List<BillingDisputeModel>> {
  @override
  Future<List<BillingDisputeModel>> build() async {
    ref.watch(activeStoreIdProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  void prepend(BillingDisputeModel dispute) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    final id = dispute.id;
    final next = [
      dispute,
      ...current.where((item) => item.id == null || item.id != id),
    ];
    state = AsyncData(next);
  }

  void upsert(BillingDisputeModel dispute) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    final disputeId = dispute.id;
    final updated = current
        .map((item) => item.id == disputeId ? dispute : item)
        .toList(growable: false);
    final exists = current.any((item) => item.id == disputeId);
    state = AsyncData(exists ? updated : [dispute, ...updated]);
  }

  Future<List<BillingDisputeModel>> _load() async {
    return ref.read(disputesRepositoryProvider).fetchMyDisputes();
  }
}

final myDisputesNotifierProvider =
    AsyncNotifierProvider<MyDisputesNotifier, List<BillingDisputeModel>>(
      MyDisputesNotifier.new,
    );
