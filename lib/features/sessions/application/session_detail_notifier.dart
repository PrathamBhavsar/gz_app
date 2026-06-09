import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/api_responses.dart';
import '../data/repositories/billing_repository.dart';
import '../data/repositories/sessions_repository.dart';
import 'session_ui_models.dart';

class SessionDetailNotifier
    extends FamilyAsyncNotifier<SessionHistoryDetailState, String> {
  @override
  Future<SessionHistoryDetailState> build(String arg) => _load(arg);

  Future<void> refresh() async {
    final id = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(id));
  }

  Future<SessionHistoryDetailState> _load(String sessionId) async {
    final sessionsRepo = ref.read(sessionsRepositoryProvider);
    final billingRepo = ref.read(billingRepositoryProvider);
    final session = await sessionsRepo.fetchSessionDetail(sessionId);
    final logs = await sessionsRepo.fetchSessionLogs(sessionId);
    final billing = await billingRepo.fetchBillingHistory();
    BillingRow? billingRow;
    for (final row in billing) {
      if (row.sessionId == sessionId) {
        billingRow = row;
        break;
      }
    }
    return mapSessionHistoryDetail(session, billingRow, logs);
  }
}

final sessionDetailNotifierProvider = AsyncNotifierProvider.family<
    SessionDetailNotifier,
    SessionHistoryDetailState,
    String>(SessionDetailNotifier.new);
