import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_systems.dart';
import '../../data/repositories/sessions_repository.dart';

class SessionsState {
  final List<SessionModel> activeSessions;
  final List<SessionModel> completedSessions;
  final bool isLoading;
  final String? error;

  const SessionsState({
    this.activeSessions = const [],
    this.completedSessions = const [],
    this.isLoading = true,
    this.error,
  });

  SessionsState copyWith({
    List<SessionModel>? activeSessions,
    List<SessionModel>? completedSessions,
    bool? isLoading,
    String? error,
  }) {
    return SessionsState(
      activeSessions: activeSessions ?? this.activeSessions,
      completedSessions: completedSessions ?? this.completedSessions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SessionsNotifier extends Notifier<SessionsState> {
  @override
  SessionsState build() {
    return const SessionsState();
  }

  /// Load sessions for a given store. Call from the UI with the active storeId.
  Future<void> loadSessions(String storeId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(sessionsRepositoryProvider);
      final activeResponse = await repo.fetchSessions(
        storeId,
        status: 'in_progress',
      );
      final completedResponse = await repo.fetchSessions(
        storeId,
        status: 'completed',
      );

      state = state.copyWith(
        activeSessions: activeResponse.data ?? [],
        completedSessions: completedResponse.data ?? [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh(String storeId) => loadSessions(storeId);
}

final sessionsNotifierProvider =
    NotifierProvider<SessionsNotifier, SessionsState>(() {
      return SessionsNotifier();
    });
