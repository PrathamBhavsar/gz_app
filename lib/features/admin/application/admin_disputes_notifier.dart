import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_disputes_repository.dart';
import 'admin_management_models.dart';

class AdminDisputesNotifier extends AsyncNotifier<AdminDisputeData> {
  String _selectedFilter = 'All';

  @override
  Future<AdminDisputeData> build() => _load();

  Future<void> selectFilter(String value) async {
    _selectedFilter = value;
    final current = state.valueOrNull;
    if (current == null) {
      await refresh();
      return;
    }
    state = AsyncData(
      AdminDisputeData(
        disputes: current.disputes,
        selectedFilter: value,
        loadedAt: current.loadedAt,
      ),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AdminDisputeData> _load() async {
    final repo = ref.read(adminDisputesRepositoryProvider);
    final disputes = await repo.fetchDisputes();
    return AdminDisputeData(
      disputes: disputes,
      selectedFilter: _selectedFilter,
      loadedAt: DateTime.now(),
    );
  }
}

final adminDisputesNotifierProvider =
    AsyncNotifierProvider<AdminDisputesNotifier, AdminDisputeData>(
      AdminDisputesNotifier.new,
    );
