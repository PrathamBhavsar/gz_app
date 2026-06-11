import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/api_responses.dart';
import '../../../../models/domain_billing.dart';
import '../../sessions/data/repositories/billing_repository.dart';
import '../data/repositories/disputes_repository.dart';
import 'my_disputes_notifier.dart';

class DisputeDetailData {
  const DisputeDetailData({required this.dispute, this.billing});

  final BillingDisputeModel dispute;
  final BillingRow? billing;
}

class DisputeDetailNotifier
    extends FamilyAsyncNotifier<DisputeDetailData, String> {
  @override
  Future<DisputeDetailData> build(String arg) => _load(arg);

  Future<void> refresh() async {
    final id = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(id));
  }

  Future<DisputeDetailData> _load(String id) async {
    final dispute = await ref
        .read(disputesRepositoryProvider)
        .fetchDisputeById(id);
    final billing = await _findBillingRow(dispute);
    final data = DisputeDetailData(dispute: dispute, billing: billing);
    ref.read(myDisputesNotifierProvider.notifier).upsert(dispute);
    return data;
  }

  Future<BillingRow?> _findBillingRow(BillingDisputeModel dispute) async {
    final billingId = dispute.billingId;
    final sessionId = dispute.sessionId;
    if ((billingId == null || billingId.isEmpty) &&
        (sessionId == null || sessionId.isEmpty)) {
      return null;
    }

    final rows = await ref
        .read(billingRepositoryProvider)
        .fetchBillingHistory();
    for (final row in rows) {
      if (billingId != null && billingId.isNotEmpty && row.id == billingId) {
        return row;
      }
      if (sessionId != null &&
          sessionId.isNotEmpty &&
          row.sessionId == sessionId) {
        return row;
      }
    }
    return null;
  }
}

final disputeDetailNotifierProvider =
    AsyncNotifierProvider.family<
      DisputeDetailNotifier,
      DisputeDetailData,
      String
    >(DisputeDetailNotifier.new);

sealed class DisputeCommandState {
  const DisputeCommandState();
}

class DisputeCommandInitial extends DisputeCommandState {
  const DisputeCommandInitial();
}

class DisputeCommandLoading extends DisputeCommandState {
  const DisputeCommandLoading();
}

class DisputeCommandSuccess extends DisputeCommandState {
  const DisputeCommandSuccess(this.message);

  final String message;
}

class DisputeCommandError extends DisputeCommandState {
  const DisputeCommandError(this.error);

  final Object error;
}

class DisputeCommandNotifier
    extends FamilyNotifier<DisputeCommandState, String> {
  @override
  DisputeCommandState build(String arg) => const DisputeCommandInitial();

  Future<void> withdraw() async {
    state = const DisputeCommandLoading();
    try {
      final message = await ref
          .read(disputesRepositoryProvider)
          .withdrawDispute(arg);
      await ref.read(disputeDetailNotifierProvider(arg).notifier).refresh();
      await ref.read(myDisputesNotifierProvider.notifier).refresh();
      state = DisputeCommandSuccess(message);
    } catch (error) {
      state = DisputeCommandError(error);
    }
  }

  void reset() {
    state = const DisputeCommandInitial();
  }
}

final disputeCommandNotifierProvider =
    NotifierProvider.family<
      DisputeCommandNotifier,
      DisputeCommandState,
      String
    >(DisputeCommandNotifier.new);
