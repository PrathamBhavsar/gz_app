import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_dashboard_repository.dart';
import 'admin_operations_models.dart';

class AdminDashboardNotifier extends AsyncNotifier<AdminDashboardData> {
  @override
  Future<AdminDashboardData> build() => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AdminDashboardData> _load() async {
    final repo = ref.read(adminDashboardRepositoryProvider);
    final dashboard = await repo.fetchDashboard();
    final systems = await repo.fetchLiveSystems();
    return AdminDashboardData(
      dashboard: dashboard,
      liveSystems: systems,
      loadedAt: DateTime.now(),
    );
  }
}

final adminDashboardNotifierProvider =
    AsyncNotifierProvider<AdminDashboardNotifier, AdminDashboardData>(
      AdminDashboardNotifier.new,
    );
