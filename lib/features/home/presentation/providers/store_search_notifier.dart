import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_global.dart';
import '../../data/repositories/store_repository.dart';
import 'dart:async';

class StoreSearchState {
  final bool isLoading;
  final List<StoreModel> results;
  final String? error;
  final String selectedFilter;

  const StoreSearchState({
    this.isLoading = false,
    this.results = const [],
    this.error,
    this.selectedFilter = 'All',
  });

  StoreSearchState copyWith({
    bool? isLoading,
    List<StoreModel>? results,
    String? error,
    String? selectedFilter,
  }) =>
      StoreSearchState(
        isLoading: isLoading ?? this.isLoading,
        results: results ?? this.results,
        error: error,
        selectedFilter: selectedFilter ?? this.selectedFilter,
      );
}

class StoreSearchNotifier extends Notifier<StoreSearchState> {
  Timer? _debounceTimer;
  String _currentQuery = '';

  @override
  StoreSearchState build() => const StoreSearchState();

  void search(String query) {
    _currentQuery = query;
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      state = StoreSearchState(selectedFilter: state.selectedFilter);
      return;
    }

    state = state.copyWith(isLoading: true);

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await _runSearch(query, state.selectedFilter);
    });
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
    if (_currentQuery.isNotEmpty) {
      _debounceTimer?.cancel();
      _runSearch(_currentQuery, filter);
    }
  }

  Future<void> _runSearch(String query, String filter) async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(storeRepositoryProvider);
      final platform = filter == 'All' ? null : filter;
      final res = await repo.fetchStores(search: query, platform: platform);
      state = state.copyWith(isLoading: false, results: res.data ?? []);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final storeSearchProvider =
    NotifierProvider<StoreSearchNotifier, StoreSearchState>(
  StoreSearchNotifier.new,
);
