import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_global.dart';
import '../../data/repositories/store_repository.dart';

class ActiveStoreNotifier extends Notifier<AsyncValue<StoreModel?>> {
  @override
  AsyncValue<StoreModel?> build() {
    return const AsyncData(null);
  }

  void setActiveStore(StoreModel payload) {
    state = AsyncData(payload);
  }

  Future<void> fetchAndSetActiveStore(String slug) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(storeRepositoryProvider);
      final response = await repository.fetchStoreDetails(slug);
      state = AsyncData(response.data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clearActiveStore() {
    state = const AsyncData(null);
  }
}

final activeStoreProvider = NotifierProvider<ActiveStoreNotifier, AsyncValue<StoreModel?>>(() {
  return ActiveStoreNotifier();
});
