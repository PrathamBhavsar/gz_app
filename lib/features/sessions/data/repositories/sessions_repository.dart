import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/sessions_service.dart';
import '../../../../models/api_responses.dart';

class SessionsRepository {
  final SessionsService _sessionsService;
  final NetworkChecker _networkChecker;

  SessionsRepository(this._sessionsService, this._networkChecker);

  Future<PaginatedSessionsResponse> fetchSessions(
    String storeId, {
    String? status,
    int? page,
    int? limit,
  }) async {
    await _networkChecker.assertConnection();
    return await _sessionsService.getSessions(
      storeId,
      status: status,
      page: page ?? 1,
      limit: limit ?? 20,
    );
  }

  Future<SessionResponse> fetchSession(String storeId, String sessionId) async {
    await _networkChecker.assertConnection();
    return await _sessionsService.getSession(storeId, sessionId);
  }
}

final sessionsRepositoryProvider = Provider<SessionsRepository>((ref) {
  final service = ref.watch(sessionsServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return SessionsRepository(service, network);
});
