import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../features/sessions/data/repositories/sessions_repository.dart';
import '../../../../models/domain_systems.dart';

class SessionDetailNotifier
    extends FamilyNotifier<AsyncValue<SessionModel>, String> {
  @override
  AsyncValue<SessionModel> build(String id) {
    _fetch(id);
    return const AsyncLoading();
  }

  Future<void> _fetch(String id) async {
    state = const AsyncLoading();
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final repo = ref.read(sessionsRepositoryProvider);
      final response = await repo.fetchSession(storeId, id);
      if (response.data != null) {
        state = AsyncData(response.data!);
      } else {
        state = AsyncError(Exception('Session not found'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh(String id) => _fetch(id);
}

final sessionDetailNotifierProvider = NotifierProviderFamily<
    SessionDetailNotifier,
    AsyncValue<SessionModel>,
    String>(SessionDetailNotifier.new);
