import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_global.dart';
import '../../../../models/domain_loyalty.dart';
import '../../data/repositories/store_repository.dart';

class StoreDetailData {
  final StoreModel store;
  final List<CampaignModel> campaigns;

  const StoreDetailData({required this.store, required this.campaigns});
}

class StoreDetailNotifier
    extends FamilyNotifier<AsyncValue<StoreDetailData>, String> {
  @override
  AsyncValue<StoreDetailData> build(String arg) {
    _fetch(arg);
    return const AsyncLoading();
  }

  Future<void> _fetch(String slug) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(storeRepositoryProvider);
      final storeRes = await repo.fetchStoreDetails(slug);
      final store = storeRes.data;
      if (store == null) {
        state = AsyncError(Exception('Store not found'), StackTrace.current);
        return;
      }
      List<CampaignModel> campaigns = [];
      if (store.id != null) {
        try {
          final campRes = await repo.fetchActiveCampaigns(store.id!);
          campaigns = campRes.data ?? [];
        } catch (_) {
          // campaigns are optional — don't fail the whole screen
        }
      }
      state = AsyncData(StoreDetailData(store: store, campaigns: campaigns));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh(String slug) => _fetch(slug);
}

final storeDetailNotifierProvider = NotifierProviderFamily<StoreDetailNotifier,
    AsyncValue<StoreDetailData>, String>(
  StoreDetailNotifier.new,
);
