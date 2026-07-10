import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/domain_activity.dart';
import '../data/repositories/admin_activity_repository.dart';
import '../data/repositories/admin_sessions_repository.dart';
import '../data/repositories/systems_admin_repository.dart';
import 'admin_operations_models.dart';

/// Per-system activity backing SystemSessionsScreen: highlights the live (or
/// most recent) session, and lists incoming bookings + past-7-days sessions
/// scoped to that one system.
class AdminSystemSessionsNotifier
    extends FamilyAsyncNotifier<AdminSystemSessionsData, String> {
  @override
  Future<AdminSystemSessionsData> build(String arg) => _load(arg);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(arg));
  }

  Future<AdminSystemSessionsData> _load(String systemId) async {
    final systemsRepo = ref.read(systemsAdminRepositoryProvider);
    final activityRepo = ref.read(adminActivityRepositoryProvider);
    final sessionsRepo = ref.read(adminSessionsRepositoryProvider);

    final system = await systemsRepo.fetchSystemDetail(systemId);
    final liveStatus = (await systemsRepo.fetchLiveSystems())
        .where((item) => item.systemId == systemId)
        .cast()
        .firstOrNull;

    final items = await activityRepo.fetchFeed(
      scope: 'system',
      systemId: systemId,
    );

    final current = items
        .where((i) => i.bucket == ActivityBucket.current)
        .cast<AdminActivityItem?>()
        .firstOrNull;
    final incoming = items
        .where((i) => i.bucket == ActivityBucket.incoming)
        .toList(growable: false);
    final past = items
        .where((i) => i.bucket == ActivityBucket.past)
        .toList(growable: false);

    final currentLogs = current?.id == null
        ? const []
        : await sessionsRepo.fetchSessionLogs(current!.id!);

    return AdminSystemSessionsData(
      system: system,
      liveStatus: liveStatus,
      current: current,
      incoming: incoming,
      past: past,
      currentLogs: currentLogs.cast(),
      loadedAt: DateTime.now(),
    );
  }
}

final adminSystemSessionsNotifierProvider = AsyncNotifierProvider.family<
  AdminSystemSessionsNotifier,
  AdminSystemSessionsData,
  String
>(AdminSystemSessionsNotifier.new);
