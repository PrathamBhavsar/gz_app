import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/systems_admin_repository.dart';
import 'admin_store_models.dart';

class AdminSystemDetailNotifier
    extends FamilyAsyncNotifier<AdminSystemDetailData, String> {
  @override
  Future<AdminSystemDetailData> build(String arg) => _load(arg);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(arg));
  }

  Future<AdminSystemDetailData> _load(String id) async {
    final repo = ref.read(systemsAdminRepositoryProvider);
    final system = await repo.fetchSystemDetail(id);
    final liveStatus = (await repo.fetchLiveSystems())
        .where((item) => item.systemId == id)
        .cast()
        .firstOrNull;
    return AdminSystemDetailData(system: system, liveStatus: liveStatus);
  }
}

final adminSystemDetailNotifierProvider = AsyncNotifierProvider.family<
  AdminSystemDetailNotifier,
  AdminSystemDetailData,
  String
>(AdminSystemDetailNotifier.new);
