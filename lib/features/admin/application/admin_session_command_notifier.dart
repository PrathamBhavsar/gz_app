import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_sessions_repository.dart';
import 'admin_command_state.dart';

class AdminSessionCommandNotifier
    extends FamilyNotifier<AdminCommandState, String> {
  @override
  AdminCommandState build(String arg) => const AdminCommandInitial();

  Future<void> pause() async =>
      _run(() => ref.read(adminSessionsRepositoryProvider).pauseSession(arg));

  Future<void> resume() async =>
      _run(() => ref.read(adminSessionsRepositoryProvider).resumeSession(arg));

  Future<void> end() async =>
      _run(() => ref.read(adminSessionsRepositoryProvider).endSession(arg));

  Future<void> extend(int extraMinutes) async => _run(
    () => ref
        .read(adminSessionsRepositoryProvider)
        .extendSession(arg, extraMinutes: extraMinutes),
  );

  Future<void> _run(Future<String> Function() action) async {
    state = const AdminCommandLoading();
    try {
      final message = await action();
      state = AdminCommandSuccess(message);
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
      rethrow;
    }
  }
}

final adminSessionCommandNotifierProvider =
    NotifierProvider.family<
      AdminSessionCommandNotifier,
      AdminCommandState,
      String
    >(AdminSessionCommandNotifier.new);
