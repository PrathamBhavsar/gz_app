import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_global.dart';
import '../../data/repositories/store_repository.dart';

class StoreSelectorNotifier extends Notifier<AsyncValue<List<StoreModel>>> {
  Timer? _debounce;

  @override
  AsyncValue<List<StoreModel>> build() {
    ref.onDispose(() => _debounce?.cancel());
    _fetch();
    return const AsyncLoading();
  }

  Future<void> _fetch({String? search}) async {
    try {
      final res = await ref
          .read(storeRepositoryProvider)
          .fetchStores(search: search?.isEmpty == true ? null : search);
      state = AsyncData(res.data ?? []);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = const AsyncLoading();
      _fetch(search: query);
    });
  }

  Future<void> refresh() => _fetch();
}

final storeSelectorNotifierProvider =
    NotifierProvider<StoreSelectorNotifier, AsyncValue<List<StoreModel>>>(
  () => StoreSelectorNotifier(),
);
