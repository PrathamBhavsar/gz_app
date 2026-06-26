import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_global.dart';
import '../data/repositories/store_repository.dart';

const _storeSearchUnset = Object();

class StoreSearchState {
  const StoreSearchState({
    this.query = '',
    this.selectedPlatform,
    this.openNow = false,
    this.helperMessage,
    this.results = const AsyncLoading<List<StoreModel>>(),
  });

  final String query;
  final String? selectedPlatform;
  final bool openNow;
  final String? helperMessage;
  final AsyncValue<List<StoreModel>> results;

  StoreSearchState copyWith({
    String? query,
    Object? selectedPlatform = _storeSearchUnset,
    bool? openNow,
    Object? helperMessage = _storeSearchUnset,
    Object? results = _storeSearchUnset,
  }) {
    return StoreSearchState(
      query: query ?? this.query,
      selectedPlatform: selectedPlatform == _storeSearchUnset
          ? this.selectedPlatform
          : selectedPlatform as String?,
      openNow: openNow ?? this.openNow,
      helperMessage: helperMessage == _storeSearchUnset
          ? this.helperMessage
          : helperMessage as String?,
      results: results == _storeSearchUnset
          ? this.results
          : results as AsyncValue<List<StoreModel>>,
    );
  }
}

class StoreSearchNotifier extends Notifier<StoreSearchState> {
  Timer? _debounce;
  int _requestId = 0;

  @override
  StoreSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(refresh);
    return const StoreSearchState();
  }

  void setQuery(String value) {
    state = state.copyWith(query: value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), refresh);
  }

  void togglePlatform(String? platform) {
    state = state.copyWith(
      selectedPlatform: state.selectedPlatform == platform ? null : platform,
    );
    refresh();
  }

  void toggleOpenNow() {
    state = state.copyWith(openNow: !state.openNow);
    refresh();
  }

  Future<void> refresh() async {
    final query = state.query.trim();
    if (query.isNotEmpty && query.length < 2) {
      state = state.copyWith(
        helperMessage: 'Type at least 2 characters to search.',
        results: const AsyncData(<StoreModel>[]),
      );
      return;
    }

    final requestId = ++_requestId;
    state = state.copyWith(
      helperMessage: null,
      results: const AsyncLoading<List<StoreModel>>(),
    );

    try {
      final stores = await ref.read(storeRepositoryProvider).fetchStores(
        search: query.isEmpty ? null : query,
        platform: state.selectedPlatform,
        isOpen: state.openNow ? true : null,
      );
      if (requestId != _requestId) {
        return;
      }
      state = state.copyWith(results: AsyncData(stores));
    } catch (error, stackTrace) {
      if (requestId != _requestId) {
        return;
      }
      state = state.copyWith(results: AsyncError(error, stackTrace));
    }
  }
}

final storeSearchNotifierProvider =
    NotifierProvider<StoreSearchNotifier, StoreSearchState>(
      StoreSearchNotifier.new,
    );
