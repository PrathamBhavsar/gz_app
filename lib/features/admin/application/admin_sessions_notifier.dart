import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_systems.dart';
import '../data/repositories/admin_sessions_repository.dart';
import 'admin_operations_models.dart';

class AdminSessionsNotifier
    extends FamilyAsyncNotifier<AdminSessionsData, String?> {
  @override
  Future<AdminSessionsData> build(String? arg) => _load(arg);

  Future<void> refresh() async {
    final systemId = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(systemId));
  }

  Future<AdminSessionsData> _load(String? systemId) async {
    final repo = ref.read(adminSessionsRepositoryProvider);
    final sessions = await repo.fetchSessions(systemId: systemId);
    final activeSessions = await repo.fetchActiveSessions();

    SessionModel? selected;
    if (systemId != null && systemId.isNotEmpty) {
      for (final session in [...activeSessions, ...sessions]) {
        if (session.systemId == systemId || session.systemName == systemId) {
          selected = session;
          break;
        }
      }
    }
    selected ??= activeSessions.isNotEmpty
        ? activeSessions.first
        : (sessions.isNotEmpty ? sessions.first : null);

    final logs = selected?.id == null
        ? const <SessionLogModel>[]
        : await repo.fetchSessionLogs(selected!.id!);

    return AdminSessionsData(
      sessions: sessions,
      activeSessions: activeSessions,
      selectedSession: selected,
      logs: logs,
      loadedAt: DateTime.now(),
    );
  }
}

final adminSessionsNotifierProvider =
    AsyncNotifierProvider.family<
      AdminSessionsNotifier,
      AdminSessionsData,
      String?
    >(AdminSessionsNotifier.new);
