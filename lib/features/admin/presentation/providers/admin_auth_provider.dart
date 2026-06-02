import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_admin.dart';
import 'admin_auth_state.dart';

class AdminAuthNotifier extends Notifier<AdminAuthState> {
  @override
  AdminAuthState build() => const AdminAuthUnauthenticated();

  Future<void> login(String email, String password) async {
    state = AdminAuthAuthenticated(
      AdminAuthModel(
        id: 'admin-demo',
        name: 'GameZone Operator',
        email: email,
        role: 'admin',
        storeId: 'store-01',
        isActive: true,
      ),
    );
  }

  Future<void> checkAdminStatus() async {
    if (state is! AdminAuthAuthenticated) {
      state = const AdminAuthUnauthenticated();
    }
  }

  Future<void> logout() async {
    state = const AdminAuthUnauthenticated();
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
