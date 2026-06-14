import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_disputes_repository.dart';
import 'admin_command_state.dart';
import 'admin_dispute_detail_notifier.dart';
import 'admin_disputes_notifier.dart';

class AdminDisputeCommandNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> review(String id, {String? notes}) async {
    state = const AdminCommandLoading();
    try {
      final msg = await ref
          .read(adminDisputesRepositoryProvider)
          .reviewDispute(id, notes: notes);
      ref.invalidate(adminDisputesNotifierProvider);
      ref.invalidate(adminDisputeDetailNotifierProvider(id));
      state = AdminCommandSuccess(msg);
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> resolve(
    String id, {
    required String resolution,
    String? notes,
    double? resolutionAmount,
  }) async {
    state = const AdminCommandLoading();
    try {
      final msg = await ref
          .read(adminDisputesRepositoryProvider)
          .resolveDispute(
            id,
            resolution: resolution,
            notes: notes,
            resolutionAmount: resolutionAmount,
          );
      ref.invalidate(adminDisputesNotifierProvider);
      ref.invalidate(adminDisputeDetailNotifierProvider(id));
      state = AdminCommandSuccess(msg);
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() => state = const AdminCommandInitial();
}

final adminDisputeCommandNotifierProvider =
    NotifierProvider<AdminDisputeCommandNotifier, AdminCommandState>(
      AdminDisputeCommandNotifier.new,
    );
