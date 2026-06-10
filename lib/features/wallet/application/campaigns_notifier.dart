import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_loyalty.dart';
import '../data/repositories/wallet_repository.dart';

class CampaignsNotifier extends AsyncNotifier<List<CampaignModel>> {
  @override
  Future<List<CampaignModel>> build() async {
    ref.watch(activeStoreIdProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<List<CampaignModel>> _load() async {
    return ref.read(walletRepositoryProvider).fetchActiveCampaigns();
  }
}

final campaignsNotifierProvider =
    AsyncNotifierProvider<CampaignsNotifier, List<CampaignModel>>(
      CampaignsNotifier.new,
    );
