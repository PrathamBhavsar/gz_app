import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_billing_repository.dart';
import 'admin_billing_notifier.dart';
import 'admin_command_state.dart';

class BillingOverrideNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> submit({
    required String billingId,
    required double amount,
    required String reason,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref
          .read(adminBillingRepositoryProvider)
          .overrideBilling(
            billingId: billingId,
            amount: amount,
            reason: reason,
          );
      ref.invalidate(adminBillingNotifierProvider);
      state = const AdminCommandSuccess('Billing overridden');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() {
    state = const AdminCommandInitial();
  }
}

final billingOverrideNotifierProvider =
    NotifierProvider<BillingOverrideNotifier, AdminCommandState>(
      BillingOverrideNotifier.new,
    );
