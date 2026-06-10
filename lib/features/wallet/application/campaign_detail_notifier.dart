import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'campaigns_notifier.dart';
import '../../../../models/domain_loyalty.dart';
import 'wallet_notifier.dart';
import '../data/repositories/wallet_repository.dart';

class CampaignDetailNotifier
    extends FamilyAsyncNotifier<CampaignModel, String> {
  @override
  Future<CampaignModel> build(String arg) => _load(arg);

  Future<void> refresh() async {
    final id = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(id));
  }

  Future<CampaignModel> _load(String id) async {
    final list = ref.read(campaignsNotifierProvider).valueOrNull;
    if (list != null) {
      for (final campaign in list) {
        if (campaign.id == id) {
          return campaign;
        }
      }
    }
    return ref.read(walletRepositoryProvider).fetchCampaignById(id);
  }
}

final campaignDetailNotifierProvider =
    AsyncNotifierProvider.family<CampaignDetailNotifier, CampaignModel, String>(
      CampaignDetailNotifier.new,
    );

sealed class CampaignRedeemState {
  const CampaignRedeemState();
}

class CampaignRedeemInitial extends CampaignRedeemState {
  const CampaignRedeemInitial();
}

class CampaignRedeemLoading extends CampaignRedeemState {
  const CampaignRedeemLoading();
}

class CampaignRedeemSuccess extends CampaignRedeemState {
  const CampaignRedeemSuccess(this.message);

  final String message;
}

class CampaignRedeemError extends CampaignRedeemState {
  const CampaignRedeemError(this.error);

  final Object error;
}

class CampaignRedeemNotifier
    extends FamilyNotifier<CampaignRedeemState, String> {
  @override
  CampaignRedeemState build(String arg) => const CampaignRedeemInitial();

  Future<void> redeem() async {
    state = const CampaignRedeemLoading();
    try {
      final message = await ref
          .read(walletRepositoryProvider)
          .redeemCampaign(arg);
      await Future.wait([
        ref.read(campaignsNotifierProvider.notifier).refresh(),
        ref.read(walletNotifierProvider.notifier).refresh(),
      ]);
      state = CampaignRedeemSuccess(message);
    } catch (error) {
      state = CampaignRedeemError(error);
    }
  }

  void reset() {
    state = const CampaignRedeemInitial();
  }
}

final campaignRedeemNotifierProvider =
    NotifierProvider.family<
      CampaignRedeemNotifier,
      CampaignRedeemState,
      String
    >(CampaignRedeemNotifier.new);
