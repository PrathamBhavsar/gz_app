import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_admin.dart';
import '../data/repositories/store_config_repository.dart';

class StoreConfigNotifier extends AsyncNotifier<StoreConfigModel> {
  @override
  Future<StoreConfigModel> build() {
    return ref.read(storeConfigRepositoryProvider).fetchConfig();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(storeConfigRepositoryProvider).fetchConfig(),
    );
  }
}

final storeConfigNotifierProvider =
    AsyncNotifierProvider<StoreConfigNotifier, StoreConfigModel>(
      StoreConfigNotifier.new,
    );
