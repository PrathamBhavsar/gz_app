import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_systems.dart';
import '../data/repositories/systems_repository.dart';

class SystemTypesNotifier extends AsyncNotifier<List<SystemTypeModel>> {
  @override
  Future<List<SystemTypeModel>> build() async {
    ref.watch(activeStoreIdProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<List<SystemTypeModel>> _load() async {
    return ref.read(systemsRepositoryProvider).fetchSystemTypes();
  }
}

final systemTypesNotifierProvider =
    AsyncNotifierProvider<SystemTypesNotifier, List<SystemTypeModel>>(
      SystemTypesNotifier.new,
    );
