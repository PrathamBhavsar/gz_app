import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_systems.dart';
import '../../data/repositories/sessions_repository.dart';

class SessionsState {
  final List<SessionModel> activeSessions;
  final List<SessionLogModel> sessionLogs;
  final bool isLoading;
  final String? error;

  const SessionsState({
    this.activeSessions = const [],
    this.sessionLogs = const [],
    this.isLoading = true,
    this.error,
  });

  SessionsState copyWith({
    List<SessionModel>? activeSessions,
    List<SessionLogModel>? sessionLogs,
    bool? isLoading,
    String? error,
  }) {
    return SessionsState(
      activeSessions: activeSessions ?? this.activeSessions,
      sessionLogs: sessionLogs ?? this.sessionLogs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SessionsNotifier extends Notifier<SessionsState> {
  @override
  SessionsState build() {
    _loadData();
    return const SessionsState();
  }

  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(sessionsRepositoryProvider);
      final activeResponse = await repo.fetchActiveSessions();
      final logsResponse = await repo.fetchSessionHistory();
      
      state = state.copyWith(
        activeSessions: List<SessionModel>.from(activeResponse.data ?? []),
        sessionLogs: List<SessionLogModel>.from(logsResponse.data ?? []),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => _loadData();
}

final sessionsNotifierProvider = NotifierProvider<SessionsNotifier, SessionsState>(() {
  return SessionsNotifier();
});
