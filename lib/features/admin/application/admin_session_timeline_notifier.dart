import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/domain_systems.dart';
import '../data/repositories/admin_sessions_repository.dart';

class AdminSessionTimelineData {
  const AdminSessionTimelineData({
    required this.session,
    required this.logs,
    required this.loadedAt,
  });

  final SessionModel session;
  final List<SessionLogModel> logs;
  final DateTime loadedAt;
}

/// Session detail + event log timeline, shared by every "open a session"
/// entry point (SystemSessionsScreen, SessionManagementScreen).
class AdminSessionTimelineNotifier
    extends FamilyAsyncNotifier<AdminSessionTimelineData, String> {
  @override
  Future<AdminSessionTimelineData> build(String arg) => _load(arg);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(arg));
  }

  Future<AdminSessionTimelineData> _load(String sessionId) async {
    final repo = ref.read(adminSessionsRepositoryProvider);
    final session = await repo.fetchSessionDetail(sessionId);
    final logs = await repo.fetchSessionLogs(sessionId);
    return AdminSessionTimelineData(
      session: session,
      logs: logs,
      loadedAt: DateTime.now(),
    );
  }
}

final adminSessionTimelineNotifierProvider = AsyncNotifierProvider.family<
  AdminSessionTimelineNotifier,
  AdminSessionTimelineData,
  String
>(AdminSessionTimelineNotifier.new);
