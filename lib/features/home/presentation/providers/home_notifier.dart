import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_global.dart';
import '../../data/repositories/store_repository.dart';

class HomeData {
  final List<StoreModel> stores;

  const HomeData({required this.stores});
}

class HomeNotifier extends Notifier<AsyncValue<HomeData>> {
  @override
  AsyncValue<HomeData> build() {
    _fetch();
    return const AsyncLoading();
  }

  Future<void> _fetch() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(storeRepositoryProvider);
      final res = await repo.fetchStores();
      state = AsyncData(HomeData(stores: res.data ?? []));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _fetch();
}

final homeNotifierProvider =
    NotifierProvider<HomeNotifier, AsyncValue<HomeData>>(HomeNotifier.new);
