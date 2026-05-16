import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_loyalty.dart';
import '../../data/repositories/wallet_repository.dart';

class WalletData {
  final CreditBalanceModel balance;
  final List<CreditLedgerModel> recentTransactions;
  final List<CampaignModel> campaigns;

  const WalletData({
    required this.balance,
    required this.recentTransactions,
    required this.campaigns,
  });

  static const empty = WalletData(
    balance: CreditBalanceModel(),
    recentTransactions: [],
    campaigns: [],
  );
}

class WalletNotifier extends Notifier<AsyncValue<WalletData>> {
  @override
  AsyncValue<WalletData> build() {
    final storeId = ref.watch(activeStoreIdProvider);
    if (storeId == null) return const AsyncData(WalletData.empty);
    _fetch(storeId);
    return const AsyncLoading();
  }

  Future<void> _fetch(String storeId) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(walletRepositoryProvider);
      final results = await Future.wait([
        repo.fetchBalance(storeId),
        repo.fetchTransactions(storeId, limit: 5),
        repo.fetchCampaigns(storeId),
      ]);
      final balance = (results[0] as dynamic).data as CreditBalanceModel? ?? const CreditBalanceModel();
      final txList = (results[1] as dynamic).data as List<CreditLedgerModel>? ?? [];
      final campaigns = results[2] as List<CampaignModel>;
      state = AsyncData(WalletData(
        balance: balance,
        recentTransactions: txList,
        campaigns: campaigns,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    final storeId = ref.read(activeStoreIdProvider);
    if (storeId == null) return;
    await _fetch(storeId);
  }
}

final walletNotifierProvider =
    NotifierProvider<WalletNotifier, AsyncValue<WalletData>>(
  () => WalletNotifier(),
);
