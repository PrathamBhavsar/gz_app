import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_global.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/domain_systems.dart';
import '../data/repositories/store_repository.dart';

class StoreDetailData {
  const StoreDetailData({
    required this.store,
    required this.campaigns,
    required this.systems,
  });

  final StoreModel store;
  final List<CampaignModel> campaigns;
  final List<SystemModel> systems;
}

class StoreDetailNotifier extends FamilyAsyncNotifier<StoreDetailData, String> {
  late String _slug;

  @override
  Future<StoreDetailData> build(String arg) {
    _slug = arg;
    return _load(arg);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(_slug));
  }

  Future<StoreDetailData> _load(String slug) async {
    final repo = ref.read(storeRepositoryProvider);
    final store = await repo.fetchStoreBySlug(slug);
    final storeId = store.id;
    if (storeId == null || storeId.isEmpty) {
      throw const ApiException(
        statusCode: 500,
        message: 'Store detail response is missing an id',
      );
    }

    final campaignsFuture = repo.fetchActiveCampaigns(storeId);
    final systemsFuture = repo.fetchAvailableSystems(storeId);

    final campaigns = await campaignsFuture;
    final systems = await systemsFuture;

    return StoreDetailData(
      store: store,
      campaigns: campaigns,
      systems: systems,
    );
  }
}

final storeDetailNotifierProvider = AsyncNotifierProvider.family<
  StoreDetailNotifier,
  StoreDetailData,
  String
>(StoreDetailNotifier.new);
