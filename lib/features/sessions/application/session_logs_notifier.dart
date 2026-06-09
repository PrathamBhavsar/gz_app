import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/sessions_repository.dart';
import 'session_ui_models.dart';

class SessionLogsNotifier
    extends FamilyAsyncNotifier<List<SessionEventLogEntry>, String> {
  @override
  Future<List<SessionEventLogEntry>> build(String arg) => _load(arg);

  Future<void> refresh() async {
    final id = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(id));
  }

  Future<List<SessionEventLogEntry>> _load(String sessionId) async {
    final logs = await ref.read(sessionsRepositoryProvider).fetchSessionLogs(sessionId);
    return logs.map(mapLogEntry).toList(growable: false);
  }
}

final sessionLogsNotifierProvider = AsyncNotifierProvider.family<
    SessionLogsNotifier,
    List<SessionEventLogEntry>,
    String>(SessionLogsNotifier.new);
