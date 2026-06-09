import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/sessions_repository.dart';
import 'session_ui_models.dart';

class ActiveSessionNotifier
    extends FamilyAsyncNotifier<ActiveSessionDetailState, String> {
  Timer? _pollTimer;

  @override
  Future<ActiveSessionDetailState> build(String arg) async {
    _startPolling();
    ref.onDispose(() => _pollTimer?.cancel());
    return _load(arg);
  }

  Future<void> refresh() async {
    final id = arg;
    state = await AsyncValue.guard(() => _load(id));
  }

  Future<ActiveSessionDetailState> _load(String sessionId) async {
    final repo = ref.read(sessionsRepositoryProvider);
    final session = await repo.fetchSessionDetail(sessionId);
    final logs = await repo.fetchSessionLogs(sessionId);
    return mapActiveSessionDetail(session, logs);
  }

  void extendTimer(DateTime newEndTime) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(
      current.copyWith(
        endTime: newEndTime,
        events: [
          SessionEventLogEntry(
            time: formatReadableTime(DateTime.now()) ?? '--:--',
            event: 'Session extended',
            category: 'Alerts',
          ),
          ...current.events,
        ],
      ),
    );
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(refresh());
    });
  }
}

final activeSessionNotifierProvider = AsyncNotifierProvider.family<
    ActiveSessionNotifier,
    ActiveSessionDetailState,
    String>(ActiveSessionNotifier.new);
