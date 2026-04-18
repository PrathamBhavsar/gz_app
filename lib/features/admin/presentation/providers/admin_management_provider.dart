import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/admin_management_service.dart';
import '../../../../core/network/connectivity_service.dart';
import 'admin_auth_provider.dart';

// ============================================================
// Generic Management State — reused for all 5 management screens
// ============================================================

sealed class ManagementState<T> {
  const ManagementState();
}

class ManagementInitial<T> extends ManagementState<T> {
  const ManagementInitial();
}

class ManagementLoading<T> extends ManagementState<T> {
  const ManagementLoading();
}

class ManagementLoaded<T> extends ManagementState<T> {
  final T data;
  const ManagementLoaded(this.data);
}

class ManagementError<T> extends ManagementState<T> {
  final Object error;
  const ManagementError(this.error);
}

// ============================================================
// Pricing Rules Provider (Screen 52)
// ============================================================

class PricingRulesNotifier extends Notifier<ManagementState<List<dynamic>>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  ManagementState<List<dynamic>> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is ManagementError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const ManagementInitial();
  }

  Future<void> load() async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const ManagementLoading();
    try {
      final data = await ref
          .read(adminManagementServiceProvider)
          .getPricingRules(storeId);
      final rules = (data['data'] as List?) ?? [];
      state = ManagementLoaded(rules);
    } catch (e) {
      state = ManagementError(e);
    }
  }

  Future<bool> createRule(Map<String, dynamic> body) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref
          .read(adminManagementServiceProvider)
          .createPricingRule(storeId: storeId, body: body);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateRule(String ruleId, Map<String, dynamic> body) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref
          .read(adminManagementServiceProvider)
          .updatePricingRule(storeId: storeId, ruleId: ruleId, body: body);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final pricingRulesProvider = NotifierProvider<PricingRulesNotifier,
    ManagementState<List<dynamic>>>(PricingRulesNotifier.new);

// ============================================================
// Billing Provider (Screen 53)
// ============================================================

class BillingNotifier extends Notifier<ManagementState<List<dynamic>>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  ManagementState<List<dynamic>> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is ManagementError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const ManagementInitial();
  }

  Future<void> load({String? status}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const ManagementLoading();
    try {
      final data = await ref
          .read(adminManagementServiceProvider)
          .getBillingLedger(storeId, status: status);
      final entries = (data['data'] as List?) ?? [];
      state = ManagementLoaded(entries);
    } catch (e) {
      state = ManagementError(e);
    }
  }

  Future<bool> overrideBilling({
    required String billingId,
    required String reason,
    required double amount,
  }) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref.read(adminManagementServiceProvider).billingOverride(
            storeId: storeId,
            billingId: billingId,
            reason: reason,
            amount: amount,
          );
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final billingProvider = NotifierProvider<BillingNotifier,
    ManagementState<List<dynamic>>>(BillingNotifier.new);

// ============================================================
// Campaigns Provider (Screen 54)
// ============================================================

class CampaignsNotifier extends Notifier<ManagementState<List<dynamic>>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  ManagementState<List<dynamic>> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is ManagementError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const ManagementInitial();
  }

  Future<void> load() async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const ManagementLoading();
    try {
      final data = await ref
          .read(adminManagementServiceProvider)
          .getCampaigns(storeId);
      final campaigns = (data['data'] as List?) ?? [];
      state = ManagementLoaded(campaigns);
    } catch (e) {
      state = ManagementError(e);
    }
  }

  Future<bool> pauseCampaign(String campaignId) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref.read(adminManagementServiceProvider).pauseCampaign(
            storeId: storeId,
            campaignId: campaignId,
          );
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resumeCampaign(String campaignId) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref.read(adminManagementServiceProvider).resumeCampaign(
            storeId: storeId,
            campaignId: campaignId,
          );
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final campaignsProvider = NotifierProvider<CampaignsNotifier,
    ManagementState<List<dynamic>>>(CampaignsNotifier.new);

// ============================================================
// Credits Provider (Screen 55)
// ============================================================

class CreditsNotifier extends Notifier<ManagementState<Map<String, dynamic>>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  ManagementState<Map<String, dynamic>> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is ManagementError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    return const ManagementInitial();
  }

  Future<void> load({required String userId}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const ManagementLoading();
    try {
      final balanceData = await ref
          .read(adminManagementServiceProvider)
          .getCreditBalance(storeId: storeId, userId: userId);
      final txData = await ref
          .read(adminManagementServiceProvider)
          .getCreditTransactions(storeId: storeId, userId: userId);

      state = ManagementLoaded({
        'balance': balanceData['data'],
        'transactions': (txData['data'] as List?) ?? [],
      });
    } catch (e) {
      state = ManagementError(e);
    }
  }

  Future<bool> adjustCredits({
    required String userId,
    required double amount,
    String? reason,
  }) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref.read(adminManagementServiceProvider).adjustCredits(
            storeId: storeId,
            userId: userId,
            amount: amount,
            reason: reason,
          );
      await load(userId: userId);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final creditsProvider = NotifierProvider<CreditsNotifier,
    ManagementState<Map<String, dynamic>>>(CreditsNotifier.new);

// ============================================================
// Disputes Provider (Screen 56)
// ============================================================

class DisputesNotifier extends Notifier<ManagementState<List<dynamic>>> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  ManagementState<List<dynamic>> build() {
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state is ManagementError) load();
    });
    ref.onDispose(() => _connectivitySub?.cancel());
    Future.microtask(() => load());
    return const ManagementInitial();
  }

  Future<void> load({String? status}) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const ManagementLoading();
    try {
      final data = await ref
          .read(adminManagementServiceProvider)
          .getDisputes(storeId, status: status);
      final disputes = (data['data'] as List?) ?? [];
      state = ManagementLoaded(disputes);
    } catch (e) {
      state = ManagementError(e);
    }
  }

  Future<bool> resolveDispute({
    required String disputeId,
    required String resolution,
    String? notes,
  }) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref.read(adminManagementServiceProvider).resolveDispute(
            storeId: storeId,
            disputeId: disputeId,
            resolution: resolution,
            notes: notes,
          );
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final disputesProvider = NotifierProvider<DisputesNotifier,
    ManagementState<List<dynamic>>>(DisputesNotifier.new);
