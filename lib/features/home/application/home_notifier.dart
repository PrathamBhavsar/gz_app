import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_global.dart';
import '../data/repositories/store_repository.dart';

class HomeData {
  const HomeData({required this.stores});

  final List<StoreModel> stores;
}

class HomeNotifier extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<HomeData> _load() async {
    final stores = await ref.read(
      storeRepositoryProvider,
    ).fetchStores(limit: 50);
    return HomeData(stores: stores);
  }
}

final homeNotifierProvider = AsyncNotifierProvider<HomeNotifier, HomeData>(
  HomeNotifier.new,
);
