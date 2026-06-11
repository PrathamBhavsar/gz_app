import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_billing.dart';
import '../data/repositories/disputes_repository.dart';
import 'my_disputes_notifier.dart';

sealed class CreateDisputeState {
  const CreateDisputeState();
}

class CreateDisputeInitial extends CreateDisputeState {
  const CreateDisputeInitial();
}

class CreateDisputeLoading extends CreateDisputeState {
  const CreateDisputeLoading();
}

class CreateDisputeSuccess extends CreateDisputeState {
  const CreateDisputeSuccess(this.dispute);

  final BillingDisputeModel dispute;
}

class CreateDisputeError extends CreateDisputeState {
  const CreateDisputeError(this.error);

  final Object error;
}

class CreateDisputeNotifier extends Notifier<CreateDisputeState> {
  @override
  CreateDisputeState build() => const CreateDisputeInitial();

  Future<void> submit({
    required String sessionId,
    required String reason,
    double? disputedAmount,
    String? notes,
  }) async {
    state = const CreateDisputeLoading();
    try {
      final dispute = await ref
          .read(disputesRepositoryProvider)
          .createDispute(
            CreateDisputeInput(
              sessionId: sessionId,
              reason: reason,
              disputedAmount: disputedAmount,
              notes: notes,
            ),
          );
      ref.read(myDisputesNotifierProvider.notifier).prepend(dispute);
      state = CreateDisputeSuccess(dispute);
    } catch (error) {
      state = CreateDisputeError(error);
    }
  }

  void reset() {
    state = const CreateDisputeInitial();
  }
}

final createDisputeNotifierProvider =
    NotifierProvider<CreateDisputeNotifier, CreateDisputeState>(
      CreateDisputeNotifier.new,
    );
