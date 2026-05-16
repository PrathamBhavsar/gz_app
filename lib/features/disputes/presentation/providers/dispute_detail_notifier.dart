import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_billing.dart';
import '../../../disputes/data/repositories/dispute_repository.dart';

sealed class DisputeDetailState { const DisputeDetailState(); }
class DisputeDetailLoading extends DisputeDetailState { const DisputeDetailLoading(); }
class DisputeDetailData extends DisputeDetailState {
  final BillingDisputeModel dispute;
  final bool confirmOpen;
  const DisputeDetailData(this.dispute, {this.confirmOpen = false});
}
class DisputeDetailError extends DisputeDetailState {
  final Object error;
  final StackTrace stackTrace;
  const DisputeDetailError(this.error, this.stackTrace);
}

class DisputeDetailNotifier
    extends FamilyNotifier<DisputeDetailState, String> {
  @override
  DisputeDetailState build(String id) {
    _fetch(id);
    return const DisputeDetailLoading();
  }

  Future<void> _fetch(String id) async {
    state = const DisputeDetailLoading();
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final repo = ref.read(disputeRepositoryProvider);
      final res = await repo.fetchDispute(storeId, id);
      if (res.data == null) throw Exception('Dispute not found');
      state = DisputeDetailData(res.data!);
    } catch (e, st) {
      state = DisputeDetailError(e, st);
    }
  }

  void openConfirm() {
    final s = state;
    if (s is DisputeDetailData) state = DisputeDetailData(s.dispute, confirmOpen: true);
  }

  void closeConfirm() {
    final s = state;
    if (s is DisputeDetailData) state = DisputeDetailData(s.dispute, confirmOpen: false);
  }

  Future<void> withdraw(String id) async {
    final s = state;
    if (s is! DisputeDetailData) return;
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final repo = ref.read(disputeRepositoryProvider);
      final res = await repo.withdrawDispute(storeId, id);
      if (res.data != null) {
        state = DisputeDetailData(res.data!, confirmOpen: false);
      }
    } catch (e, st) {
      state = DisputeDetailError(e, st);
    }
  }

  Future<void> refresh(String id) => _fetch(id);
}

final disputeDetailProvider = NotifierProviderFamily<
    DisputeDetailNotifier,
    DisputeDetailState,
    String>(DisputeDetailNotifier.new);
