import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_billing_repository.dart';
import '../data/repositories/payments_repository.dart';
import 'admin_management_models.dart';

class AdminBillingNotifier extends AsyncNotifier<AdminBillingData> {
  String _selectedFilter = 'All';

  @override
  Future<AdminBillingData> build() => _load();

  Future<void> selectFilter(String value) async {
    _selectedFilter = value;
    final current = state.valueOrNull;
    if (current == null) {
      await refresh();
      return;
    }
    state = AsyncData(
      AdminBillingData(
        selectedFilter: value,
        ledger: current.ledger,
        payments: current.payments,
        summary: current.summary,
        reconciliation: current.reconciliation,
        loadedAt: current.loadedAt,
      ),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AdminBillingData> _load() async {
    final billingRepo = ref.read(adminBillingRepositoryProvider);
    final paymentsRepo = ref.read(paymentsRepositoryProvider);
    final ledger = await billingRepo.fetchLedger();
    final summary = await billingRepo.fetchRevenueSummary();
    final payments = await paymentsRepo.fetchPayments();
    final reconciliation = await paymentsRepo.fetchReconciliation();
    return AdminBillingData(
      selectedFilter: _selectedFilter,
      ledger: ledger,
      payments: payments,
      summary: summary,
      reconciliation: reconciliation,
      loadedAt: DateTime.now(),
    );
  }
}

final adminBillingNotifierProvider =
    AsyncNotifierProvider<AdminBillingNotifier, AdminBillingData>(
      AdminBillingNotifier.new,
    );
