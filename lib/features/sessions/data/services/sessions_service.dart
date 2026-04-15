import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class SessionsService {
  final ApiClient _apiClient;

  SessionsService(this._apiClient);

  Future<PaginatedSessionsResponse> getActiveSessions() async {
    // Simulated delay
    await Future.delayed(const Duration(milliseconds: 600));
    return const PaginatedSessionsResponse(
      data: [],
    ); // Return mock empty or populated
  }

  Future<PaginatedSessionLogsResponse> getSessionHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const PaginatedSessionLogsResponse(data: []);
  }
}

final sessionsServiceProvider = Provider<SessionsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SessionsService(apiClient);
});
