import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'credit_history_notifier.dart';
import 'wallet_notifier.dart';
import '../data/repositories/wallet_repository.dart';

sealed class RedeemCreditsState {
  const RedeemCreditsState();
}

class RedeemCreditsInitial extends RedeemCreditsState {
  const RedeemCreditsInitial();
}

class RedeemCreditsLoading extends RedeemCreditsState {
  const RedeemCreditsLoading();
}

class RedeemCreditsSuccess extends RedeemCreditsState {
  const RedeemCreditsSuccess(this.message);

  final String message;
}

class RedeemCreditsError extends RedeemCreditsState {
  const RedeemCreditsError(this.error);

  final Object error;
}

class RedeemCreditsNotifier extends Notifier<RedeemCreditsState> {
  @override
  RedeemCreditsState build() => const RedeemCreditsInitial();

  Future<void> redeem(int amount) async {
    state = const RedeemCreditsLoading();
    try {
      final message = await ref
          .read(walletRepositoryProvider)
          .redeemCredits(amount);
      await Future.wait([
        ref.read(walletNotifierProvider.notifier).refresh(),
        ref.read(creditHistoryNotifierProvider.notifier).refresh(),
      ]);
      state = RedeemCreditsSuccess(message);
    } catch (error) {
      state = RedeemCreditsError(error);
    }
  }

  void reset() {
    state = const RedeemCreditsInitial();
  }
}

final redeemCreditsNotifierProvider =
    NotifierProvider<RedeemCreditsNotifier, RedeemCreditsState>(
      RedeemCreditsNotifier.new,
    );
