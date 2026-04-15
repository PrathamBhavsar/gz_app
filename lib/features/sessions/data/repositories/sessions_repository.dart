import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import 'sessions_service.dart';
import '../../../../models/api_responses.dart';

class SessionsRepository {
  final SessionsService _sessionsService;
  final NetworkChecker _networkChecker;

  SessionsRepository(this._sessionsService, this._networkChecker);

  Future<PaginatedSessionsResponse> fetchActiveSessions() async {
    await _networkChecker.assertConnection();
    return await _sessionsService.getActiveSessions();
  }

  Future<PaginatedSessionLogsResponse> fetchSessionHistory() async {
    await _networkChecker.assertConnection();
    return await _sessionsService.getSessionHistory();
  }
}

final sessionsRepositoryProvider = Provider<SessionsRepository>((ref) {
  final service = ref.watch(sessionsServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return SessionsRepository(service, network);
});
