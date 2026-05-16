import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../features/sessions/data/repositories/sessions_repository.dart';
import '../../../../models/domain_systems.dart';

class ActiveSessionNotifier
    extends FamilyNotifier<AsyncValue<SessionModel>, String> {
  Timer? _pollTimer;

  @override
  AsyncValue<SessionModel> build(String id) {
    _startPolling(id);
    ref.onDispose(() => _pollTimer?.cancel());
    _fetch(id);
    return const AsyncLoading();
  }

  void _startPolling(String id) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _fetch(id),
    );
  }

  Future<void> _fetch(String id) async {
    // Only show loading if we don't have data yet
    if (state is! AsyncData) {
      state = const AsyncLoading();
    }
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

final activeSessionNotifierProvider = NotifierProviderFamily<
    ActiveSessionNotifier,
    AsyncValue<SessionModel>,
    String>(ActiveSessionNotifier.new);
