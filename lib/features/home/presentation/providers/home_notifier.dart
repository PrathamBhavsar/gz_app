import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_global.dart';
import '../../data/repositories/store_repository.dart';

class HomeNotifier extends Notifier<AsyncValue<List<StoreModel>>> {
  @override
  AsyncValue<List<StoreModel>> build() {
    _fetchHomeFeed();
    return const AsyncLoading();
  }

  Future<void> _fetchHomeFeed() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(storeRepositoryProvider);
      final res = await repo.fetchStores();
      state = AsyncData(res.data ?? []);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    return _fetchHomeFeed();
  }
}

final homeNotifierProvider = NotifierProvider<HomeNotifier, AsyncValue<List<StoreModel>>>(() {
  return HomeNotifier();
});
