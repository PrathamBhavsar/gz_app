import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_global.dart';
import '../data/repositories/store_repository.dart';

class ActiveStoreState {
  const ActiveStoreState({
    this.isLoading = true,
    this.isSaving = false,
    this.selectedStore,
    this.actionError,
  });

  final bool isLoading;
  final bool isSaving;
  final StoreModel? selectedStore;
  final Object? actionError;

  ActiveStoreState copyWith({
    bool? isLoading,
    bool? isSaving,
    Object? selectedStore = _activeStoreUnset,
    Object? actionError = _activeStoreUnset,
  }) {
    return ActiveStoreState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      selectedStore: selectedStore == _activeStoreUnset
          ? this.selectedStore
          : selectedStore as StoreModel?,
      actionError: actionError == _activeStoreUnset
          ? this.actionError
          : actionError,
    );
  }
}

const _activeStoreUnset = Object();

class ActiveStoreNotifier extends Notifier<ActiveStoreState> {
  @override
  ActiveStoreState build() {
    Future.microtask(_hydrate);
    return const ActiveStoreState();
  }

  Future<void> refresh() => _hydrate();

  Future<void> selectStore(StoreModel store) async {
    final storeId = store.id;
    if (storeId == null || storeId.isEmpty) {
      state = state.copyWith(
        isSaving: false,
        actionError: const ValidationException('Store is missing an id'),
      );
      return;
    }

    final previousStore = state.selectedStore;
    final previousStoreId = ref.read(activeStoreIdProvider);
    state = state.copyWith(isSaving: true, actionError: null);

    try {
      ref.read(activeStoreIdProvider.notifier).state = storeId;
      await ref.read(tokenStorageProvider).saveActiveStoreId(storeId);
      state = state.copyWith(
        isLoading: false,
        isSaving: false,
        selectedStore: store,
        actionError: null,
      );
    } catch (error) {
      ref.read(activeStoreIdProvider.notifier).state = previousStoreId;
      state = state.copyWith(
        isLoading: false,
        isSaving: false,
        selectedStore: previousStore,
        actionError: error,
      );
    }
  }

  void clearActionError() {
    if (state.actionError == null) {
      return;
    }
    state = state.copyWith(actionError: null);
  }

  Future<void> _hydrate() async {
    state = state.copyWith(isLoading: true, actionError: null);

    try {
      final storage = ref.read(tokenStorageProvider);
      final repo = ref.read(storeRepositoryProvider);
      final storeId = await storage.getActiveStoreId();

      if (storeId == null || storeId.isEmpty) {
        // No store saved yet (first login) — auto-select the first available store
        // so the sessions and wallet tabs work without user interaction.
        final stores = await repo.fetchStores(limit: 50);
        if (stores.isNotEmpty) {
          final first = stores.first;
          final firstId = first.id ?? '';
          if (firstId.isNotEmpty) {
            ref.read(activeStoreIdProvider.notifier).state = firstId;
            await storage.saveActiveStoreId(firstId);
            state = state.copyWith(
              isLoading: false,
              selectedStore: first,
              actionError: null,
            );
            return;
          }
        }
        ref.read(activeStoreIdProvider.notifier).state = null;
        state = state.copyWith(isLoading: false, selectedStore: null, actionError: null);
        return;
      }

      ref.read(activeStoreIdProvider.notifier).state = storeId;
      final store = await repo.findStoreById(storeId);
      state = state.copyWith(
        isLoading: false,
        selectedStore: store,
        actionError: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, actionError: error);
    }
  }
}

final activeStoreNotifierProvider =
    NotifierProvider<ActiveStoreNotifier, ActiveStoreState>(
      ActiveStoreNotifier.new,
    );
