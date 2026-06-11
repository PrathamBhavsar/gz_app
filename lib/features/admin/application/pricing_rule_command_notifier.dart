import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/pricing_repository.dart';
import 'admin_command_state.dart';
import 'admin_pricing_notifier.dart';

class PricingRuleCommandNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> createRule(Map<String, dynamic> body) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(pricingRepositoryProvider).createRule(body);
      ref.invalidate(adminPricingNotifierProvider);
      state = const AdminCommandSuccess('Pricing rule created');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> updateRule(String id, Map<String, dynamic> body) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(pricingRepositoryProvider).updateRule(id, body);
      ref.invalidate(adminPricingNotifierProvider);
      state = const AdminCommandSuccess('Pricing rule updated');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> deleteRule(String id) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(pricingRepositoryProvider).deleteRule(id);
      ref.invalidate(adminPricingNotifierProvider);
      state = const AdminCommandSuccess('Pricing rule deleted');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() {
    state = const AdminCommandInitial();
  }
}

final pricingRuleCommandNotifierProvider =
    NotifierProvider<PricingRuleCommandNotifier, AdminCommandState>(
      PricingRuleCommandNotifier.new,
    );
