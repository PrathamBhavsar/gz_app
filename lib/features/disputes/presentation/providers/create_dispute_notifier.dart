import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_billing.dart';
import '../../../disputes/data/repositories/dispute_repository.dart';

sealed class CreateDisputeState { const CreateDisputeState(); }
class CreateDisputeInitial extends CreateDisputeState { const CreateDisputeInitial(); }
class CreateDisputeLoading extends CreateDisputeState { const CreateDisputeLoading(); }
class CreateDisputeSuccess extends CreateDisputeState {
  final BillingDisputeModel dispute;
  const CreateDisputeSuccess(this.dispute);
}
class CreateDisputeError extends CreateDisputeState {
  final String message;
  const CreateDisputeError(this.message);
}

class CreateDisputeNotifier extends Notifier<CreateDisputeState> {
  @override
  CreateDisputeState build() => const CreateDisputeInitial();

  Future<void> submit({
    required String sessionId,
    required String reason,
    double? disputedAmount,
  }) async {
    state = const CreateDisputeLoading();
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final repo = ref.read(disputeRepositoryProvider);
      final res = await repo.fileDispute(
        storeId,
        sessionId: sessionId,
        reason: reason,
        disputedAmount: disputedAmount,
      );
      if (res.data == null) throw Exception('No dispute data returned');
      state = CreateDisputeSuccess(res.data!);
    } on ValidationException catch (e) {
      state = CreateDisputeError(e.message);
    } catch (e) {
      state = CreateDisputeError(e.toString());
    }
  }

  void reset() => state = const CreateDisputeInitial();
}

final createDisputeProvider =
    NotifierProvider<CreateDisputeNotifier, CreateDisputeState>(
  CreateDisputeNotifier.new,
);
