import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/admin_store_service.dart';
import '../../../../core/network/connectivity_service.dart';
import 'admin_auth_provider.dart';

// Reuse ManagementState from management provider for consistency
export 'admin_management_provider.dart' show ManagementState, ManagementInitial, ManagementLoading, ManagementLoaded, ManagementError;

// ============================================================
// Systems Provider (Screen 57)
// ============================================================

class SystemsNotifier extends Notifier<ManagementState<List<dynamic>>> {
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
      final data = await ref.read(adminStoreServiceProvider).getSystems(storeId);
      final systems = (data['data'] as List?) ?? [];
      state = ManagementLoaded(systems);
    } catch (e) {
      state = ManagementError(e);
    }
  }
}

final systemsProvider = NotifierProvider<SystemsNotifier,
    ManagementState<List<dynamic>>>(SystemsNotifier.new);

// ============================================================
// System Types Provider (Screen 57 — types tab)
// ============================================================

class SystemTypesNotifier extends Notifier<ManagementState<List<dynamic>>> {
  @override
  ManagementState<List<dynamic>> build() {
    Future.microtask(() => load());
    return const ManagementInitial();
  }

  Future<void> load() async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const ManagementLoading();
    try {
      final data = await ref.read(adminStoreServiceProvider).getSystemTypes(storeId);
      final types = (data['data'] as List?) ?? [];
      state = ManagementLoaded(types);
    } catch (e) {
      state = ManagementError(e);
    }
  }
}

final systemTypesProvider = NotifierProvider<SystemTypesNotifier,
    ManagementState<List<dynamic>>>(SystemTypesNotifier.new);

// ============================================================
// Staff Provider (Screen 58)
// ============================================================

class StaffNotifier extends Notifier<ManagementState<List<dynamic>>> {
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
      final data = await ref.read(adminStoreServiceProvider).getStaff(storeId);
      final staff = (data['data'] as List?) ?? [];
      state = ManagementLoaded(staff);
    } catch (e) {
      state = ManagementError(e);
    }
  }

  Future<bool> addStaff(Map<String, dynamic> body) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref.read(adminStoreServiceProvider).addStaff(storeId: storeId, body: body);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deactivateStaff(String adminId) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref.read(adminStoreServiceProvider).deactivateStaff(
            storeId: storeId,
            adminId: adminId,
          );
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final staffProvider = NotifierProvider<StaffNotifier,
    ManagementState<List<dynamic>>>(StaffNotifier.new);

// ============================================================
// Store Config Provider (Screen 59)
// ============================================================

class StoreConfigNotifier extends Notifier<ManagementState<Map<String, dynamic>>> {
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
    Future.microtask(() => load());
    return const ManagementInitial();
  }

  Future<void> load() async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return;

    state = const ManagementLoading();
    try {
      final response = await ref.read(adminStoreServiceProvider).getConfig(storeId);
      if (response.data != null) {
        state = ManagementLoaded(response.data!.toJson());
      } else {
        state = const ManagementError('No config data returned');
      }
    } catch (e) {
      state = ManagementError(e);
    }
  }

  Future<bool> updateConfig(Map<String, dynamic> body) async {
    final storeId = ref.read(adminStoreIdProvider);
    if (storeId == null) return false;
    try {
      await ref.read(adminStoreServiceProvider).updateConfig(
            storeId: storeId,
            body: body,
          );
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final storeConfigProvider = NotifierProvider<StoreConfigNotifier,
    ManagementState<Map<String, dynamic>>>(StoreConfigNotifier.new);
