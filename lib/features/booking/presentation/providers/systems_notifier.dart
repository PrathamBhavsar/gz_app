import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_systems.dart';
import '../../data/repositories/systems_repository.dart';

class SystemsNotifier extends Notifier<AsyncValue<List<SystemModel>>> {
  Timer? _refreshTimer;

  @override
  AsyncValue<List<SystemModel>> build() {
    final storeId = ref.watch(activeStoreIdProvider);
    _refreshTimer?.cancel();
    if (storeId == null) return const AsyncData([]);
    ref.onDispose(() => _refreshTimer?.cancel());
    _fetch(storeId);
    _startAutoRefresh(storeId);
    return const AsyncLoading();
  }

  void _startAutoRefresh(String storeId) {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetch(storeId);
    });
  }

  Future<void> _fetch(String storeId) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(systemsRepositoryProvider);
      final response = await repo.fetchAvailableSystems(storeId);
      state = AsyncData(response.data ?? []);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    final storeId = ref.read(activeStoreIdProvider);
    if (storeId == null) return;
    await _fetch(storeId);
  }
}

final systemsNotifierProvider =
    NotifierProvider<SystemsNotifier, AsyncValue<List<SystemModel>>>(
  () => SystemsNotifier(),
);

/// Selected platform filter for the systems browser: 'all' | 'pc' | 'ps5' | 'xbox' | 'vr' | 'other'
final systemsFilterProvider = StateProvider<String>((ref) => 'all');
