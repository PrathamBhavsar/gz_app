import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../data/repositories/wallet_repository.dart';
import 'wallet_notifier.dart';

sealed class RedeemCreditsState { const RedeemCreditsState(); }
class RedeemCreditsIdle extends RedeemCreditsState { const RedeemCreditsIdle(); }
class RedeemCreditsConfirming extends RedeemCreditsState {
  final double amount;
  const RedeemCreditsConfirming(this.amount);
}
class RedeemCreditsLoading extends RedeemCreditsState { const RedeemCreditsLoading(); }
class RedeemCreditsSuccess extends RedeemCreditsState { const RedeemCreditsSuccess(); }
class RedeemCreditsError extends RedeemCreditsState {
  final String message;
  const RedeemCreditsError(this.message);
}

class RedeemCreditsNotifier extends Notifier<RedeemCreditsState> {
  @override
  RedeemCreditsState build() => const RedeemCreditsIdle();

  void requestConfirm(double amount) => state = RedeemCreditsConfirming(amount);
  void cancelConfirm() => state = const RedeemCreditsIdle();
  void reset() => state = const RedeemCreditsIdle();

  Future<void> confirm() async {
    final confirming = state;
    if (confirming is! RedeemCreditsConfirming) return;
    final storeId = ref.read(activeStoreIdProvider);
    if (storeId == null) {
      state = const RedeemCreditsError('No store selected');
      return;
    }
    state = const RedeemCreditsLoading();
    try {
      await ref.read(walletRepositoryProvider).redeemCredits(storeId, amount: confirming.amount);
      state = const RedeemCreditsSuccess();
      ref.read(walletNotifierProvider.notifier).refresh();
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('INSUFFICIENT_CREDITS')) {
        state = const RedeemCreditsError('Insufficient credits');
      } else if (msg.contains('CREDITS_EXPIRED')) {
        state = const RedeemCreditsError('Credits have expired');
      } else {
        state = RedeemCreditsError(msg);
      }
    }
  }
}

final redeemCreditsNotifierProvider =
    NotifierProvider<RedeemCreditsNotifier, RedeemCreditsState>(
  () => RedeemCreditsNotifier(),
);
