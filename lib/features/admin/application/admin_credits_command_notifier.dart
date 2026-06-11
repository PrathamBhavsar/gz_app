import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_credits_repository.dart';
import 'admin_command_state.dart';
import 'admin_credits_notifier.dart';

class AdminCreditsCommandNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> adjustCredits({
    required String userId,
    required int amount,
    required String reason,
    required bool isAddition,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref
          .read(adminCreditsRepositoryProvider)
          .adjustCredits(
            userId: userId,
            amount: amount,
            reason: reason,
            isAddition: isAddition,
          );
      ref.invalidate(adminCreditsNotifierProvider);
      state = const AdminCommandSuccess('Credits updated');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() {
    state = const AdminCommandInitial();
  }
}

final adminCreditsCommandNotifierProvider =
    NotifierProvider<AdminCreditsCommandNotifier, AdminCommandState>(
      AdminCreditsCommandNotifier.new,
    );
