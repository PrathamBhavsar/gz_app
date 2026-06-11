import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_systems.dart';
import '../data/repositories/store_admins_repository.dart';

class StoreAdminsNotifier extends AsyncNotifier<List<StoreAdminModel>> {
  @override
  Future<List<StoreAdminModel>> build() {
    return ref.read(storeAdminsRepositoryProvider).fetchAdmins();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(storeAdminsRepositoryProvider).fetchAdmins(),
    );
  }
}

final storeAdminsNotifierProvider =
    AsyncNotifierProvider<StoreAdminsNotifier, List<StoreAdminModel>>(
      StoreAdminsNotifier.new,
    );
