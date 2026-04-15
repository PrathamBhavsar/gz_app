import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_global.dart';
import '../../data/repositories/store_repository.dart';
import 'dart:async';

class StoreSearchState {
  final bool isLoading;
  final List<StoreModel> results;
  final String? error;

  const StoreSearchState({this.isLoading = false, this.results = const [], this.error});
}

class StoreSearchNotifier extends Notifier<StoreSearchState> {
  Timer? _debounceTimer;

  @override
  StoreSearchState build() {
    return const StoreSearchState();
  }

  void search(String query) {
    _debounceTimer?.cancel();
    if (query.isEmpty) {
      state = const StoreSearchState();
      return;
    }

    state = StoreSearchState(isLoading: true, results: state.results);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final repo = ref.read(storeRepositoryProvider);
        final res = await repo.fetchStores(search: query);
        state = StoreSearchState(isLoading: false, results: res.data ?? []);
      } catch (e) {
        state = StoreSearchState(isLoading: false, error: e.toString());
      }
    });
  }
}

final storeSearchProvider = NotifierProvider<StoreSearchNotifier, StoreSearchState>(() {
  return StoreSearchNotifier();
});
