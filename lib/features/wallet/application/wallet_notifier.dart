import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_loyalty.dart';
import '../data/repositories/wallet_repository.dart';
import 'wallet_ui_models.dart';

class WalletNotifier extends AsyncNotifier<WalletData> {
  @override
  Future<WalletData> build() async {
    ref.watch(activeStoreIdProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<WalletData> _load() async {
    final repo = ref.read(walletRepositoryProvider);
    final results = await Future.wait<dynamic>([
      repo.fetchBalance().catchError((_) => const CreditBalanceModel()),
      repo.fetchTransactions(limit: 3),
      repo.fetchActiveCampaigns(),
    ]);
    return WalletData(
      balance: results[0] as CreditBalanceModel,
      recentTransactions: (results[1] as WalletTransactionsPage).transactions,
      campaigns: results[2] as List<CampaignModel>,
    );
  }
}

final walletNotifierProvider =
    AsyncNotifierProvider<WalletNotifier, WalletData>(WalletNotifier.new);
