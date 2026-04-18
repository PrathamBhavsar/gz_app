import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_auth_state.dart';
import '../../data/services/admin_auth_service.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/auth/token_storage.dart';

class AdminAuthNotifier extends Notifier<AdminAuthState> {
  late AdminAuthService _service;
  StreamSubscription<bool>? _connectivitySub;

  @override
  AdminAuthState build() {
    _service = ref.watch(adminAuthServiceProvider);

    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
          if (isConnected && state is AdminAuthError) {
            checkAdminStatus();
          }
        });

    ref.onDispose(() => _connectivitySub?.cancel());

    return const AdminAuthInitial();
  }

  // ─── Admin login (email + password) ────────────────────────────────
  Future<void> login(String email, String password) async {
    state = const AdminAuthLoading();
    try {
      final response = await _service.login(email, password);
      final data = response.data;
      if (data == null) {
        state = const AdminAuthError('No data returned from login');
        return;
      }

      // Persist access token in Riverpod in-memory state
      ref.read(accessTokenProvider.notifier).state = data.accessToken;

      // Persist refresh token in secure storage
      final tokenStorage = ref.read(tokenStorageProvider);
      if (data.refreshToken != null) {
        await tokenStorage.saveRefreshToken(data.refreshToken!);
      }

      // Persist admin-specific fields
      await tokenStorage.saveUserType('admin');
      if (data.admin?.role != null) {
        await tokenStorage.saveAdminRole(data.admin!.role!);
      }
      if (data.admin?.storeId != null) {
        await tokenStorage.saveAdminStoreId(data.admin!.storeId!);
      }

      if (data.admin != null) {
        state = AdminAuthAuthenticated(data.admin!);
      } else {
        state = const AdminAuthError('Admin data missing from response');
      }
    } catch (e) {
      state = AdminAuthError(e);
    }
  }

  // ─── Check admin session (validates token via GET /auth/admin/me) ──
  Future<void> checkAdminStatus() async {
    state = const AdminAuthLoading();
    try {
      final response = await _service.getProfile();
      if (response.success == true && response.data != null) {
        state = AdminAuthAuthenticated(response.data!);
      } else {
        state = const AdminAuthUnauthenticated();
      }
    } catch (e) {
      state = AdminAuthError(e);
    }
  }

  // ─── Admin logout ──────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      final tokenStorage = ref.read(tokenStorageProvider);
      final refreshToken = await tokenStorage.getRefreshToken();
      await _service.logout(refreshToken: refreshToken);
    } finally {
      ref.read(accessTokenProvider.notifier).state = null;
      state = const AdminAuthUnauthenticated();
    }
  }
}

final adminAuthNotifierProvider =
    NotifierProvider<AdminAuthNotifier, AdminAuthState>(() {
      return AdminAuthNotifier();
    });

// ─── Derived providers ────────────────────────────────────────────────

/// Whether the current session is an admin session.
final isAdminProvider = Provider<bool>((ref) {
  // We check synchronously — userType is persisted in secure storage,
  // but Provider can't be async. Use the auth state instead.
  final adminState = ref.watch(adminAuthNotifierProvider);
  return adminState is AdminAuthAuthenticated;
});

/// The logged-in admin's role (super_admin, admin, staff).
final adminRoleProvider = Provider<String?>((ref) {
  final adminState = ref.watch(adminAuthNotifierProvider);
  if (adminState is AdminAuthAuthenticated) {
    return adminState.admin.role;
  }
  return null;
});

/// Whether the current admin has super_admin role.
final isSuperAdminProvider = Provider<bool>((ref) {
  final role = ref.watch(adminRoleProvider);
  return role == 'super_admin';
});

/// The store ID the admin is managing.
final adminStoreIdProvider = Provider<String?>((ref) {
  final adminState = ref.watch(adminAuthNotifierProvider);
  if (adminState is AdminAuthAuthenticated) {
    return adminState.admin.storeId;
  }
  return null;
});
