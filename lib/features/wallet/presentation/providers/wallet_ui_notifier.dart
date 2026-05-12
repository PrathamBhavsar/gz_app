import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletUiState {
  const WalletUiState({
    this.storeId = 'kor',
    this.showStores = false,
    this.redeemOpen = false,
    this.redeemAmt = 100,
    this.seeAllTx = false,
    this.earnInfoOpen = false,
    this.campDetail,
  });

  final String storeId;
  final bool showStores;
  final bool redeemOpen;
  final int redeemAmt;
  final bool seeAllTx;
  final bool earnInfoOpen;
  final String? campDetail; // title of open campaign detail sheet

  WalletUiState copyWith({
    String? storeId,
    bool? showStores,
    bool? redeemOpen,
    int? redeemAmt,
    bool? seeAllTx,
    bool? earnInfoOpen,
    Object? campDetail = _s,
  }) {
    return WalletUiState(
      storeId:      storeId      ?? this.storeId,
      showStores:   showStores   ?? this.showStores,
      redeemOpen:   redeemOpen   ?? this.redeemOpen,
      redeemAmt:    redeemAmt    ?? this.redeemAmt,
      seeAllTx:     seeAllTx     ?? this.seeAllTx,
      earnInfoOpen: earnInfoOpen ?? this.earnInfoOpen,
      campDetail:   campDetail == _s ? this.campDetail : campDetail as String?,
    );
  }

  static const Object _s = Object();
}

class WalletUiNotifier extends Notifier<WalletUiState> {
  @override
  WalletUiState build() => const WalletUiState();

  void selectStore(String id) => state = state.copyWith(storeId: id, showStores: false);
  void openStores()           => state = state.copyWith(showStores: true);
  void closeStores()          => state = state.copyWith(showStores: false);
  void openRedeem()           => state = state.copyWith(redeemOpen: true);
  void closeRedeem()          => state = state.copyWith(redeemOpen: false);
  void setRedeemAmt(int v)    => state = state.copyWith(redeemAmt: v);
  void toggleAllTx()          => state = state.copyWith(seeAllTx: !state.seeAllTx);
  void openEarnInfo()         => state = state.copyWith(earnInfoOpen: true);
  void closeEarnInfo()        => state = state.copyWith(earnInfoOpen: false);
  void openCampDetail(String t) => state = state.copyWith(campDetail: t);
  void closeCampDetail()        => state = state.copyWith(campDetail: null);
}

final walletUiProvider =
    NotifierProvider<WalletUiNotifier, WalletUiState>(
  () => WalletUiNotifier(),
);
