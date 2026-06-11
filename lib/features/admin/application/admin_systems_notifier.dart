import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/system_types_repository.dart';
import '../data/repositories/systems_admin_repository.dart';
import 'admin_store_models.dart';

class AdminSystemsNotifier extends AsyncNotifier<AdminSystemsOverviewData> {
  @override
  Future<AdminSystemsOverviewData> build() => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AdminSystemsOverviewData> _load() async {
    final systemsRepo = ref.read(systemsAdminRepositoryProvider);
    final typesRepo = ref.read(systemTypesRepositoryProvider);
    final systems = await systemsRepo.fetchSystems();
    final systemTypes = await typesRepo.fetchSystemTypes();
    return AdminSystemsOverviewData(
      systems: systems,
      systemTypes: systemTypes,
      loadedAt: DateTime.now(),
    );
  }
}

final adminSystemsNotifierProvider =
    AsyncNotifierProvider<AdminSystemsNotifier, AdminSystemsOverviewData>(
      AdminSystemsNotifier.new,
    );
