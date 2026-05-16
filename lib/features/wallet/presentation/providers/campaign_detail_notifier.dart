import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_loyalty.dart';
import '../../data/repositories/wallet_repository.dart';
import 'wallet_notifier.dart';

sealed class CampaignDetailState { const CampaignDetailState(); }
class CampaignDetailIdle extends CampaignDetailState { const CampaignDetailIdle(); }
class CampaignDetailLoading extends CampaignDetailState { const CampaignDetailLoading(); }
class CampaignDetailSuccess extends CampaignDetailState {
  final CampaignRedemptionModel result;
  const CampaignDetailSuccess(this.result);
}
class CampaignDetailError extends CampaignDetailState {
  final String message;
  const CampaignDetailError(this.message);
}

class CampaignDetailNotifier extends FamilyNotifier<CampaignDetailState, String> {
  @override
  CampaignDetailState build(String campaignId) => const CampaignDetailIdle();

  Future<void> redeem() async {
    final storeId = ref.read(activeStoreIdProvider);
    if (storeId == null) {
      state = const CampaignDetailError('No store selected');
      return;
    }
    state = const CampaignDetailLoading();
    try {
      final res = await ref.read(walletRepositoryProvider).redeemCampaign(storeId, arg);
      state = CampaignDetailSuccess(res.data ?? CampaignRedemptionModel());
      ref.read(walletNotifierProvider.notifier).refresh();
    } catch (e) {
      state = CampaignDetailError(e.toString());
    }
  }

  void reset() => state = const CampaignDetailIdle();
}

final campaignDetailNotifierProvider =
    NotifierProvider.family<CampaignDetailNotifier, CampaignDetailState, String>(
  () => CampaignDetailNotifier(),
);
