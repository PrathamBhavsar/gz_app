import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_admin.dart';
import '../data/repositories/admin_auth_repository.dart';

sealed class AdminAuthSessionState {
  const AdminAuthSessionState();
}

class AdminAuthInitial extends AdminAuthSessionState {
  const AdminAuthInitial();
}

class AdminAuthLoading extends AdminAuthSessionState {
  const AdminAuthLoading();
}

class AdminAuthUnauthenticated extends AdminAuthSessionState {
  const AdminAuthUnauthenticated();
}

class AdminAuthAuthenticated extends AdminAuthSessionState {
  const AdminAuthAuthenticated(this.admin);

  final AdminAuthModel admin;
}

class AdminAuthNotifier extends Notifier<AdminAuthSessionState> {
  @override
  AdminAuthSessionState build() => const AdminAuthInitial();

  Future<bool> bootstrap() async {
    state = const AdminAuthLoading();

    try {
      final admin = await ref
          .read(adminAuthRepositoryProvider)
          .fetchCurrentAdmin();
      state = AdminAuthAuthenticated(admin);
      return true;
    } catch (_) {
      await ref.read(adminAuthRepositoryProvider).clearLocalSession();
      state = const AdminAuthUnauthenticated();
      return false;
    }
  }

  Future<void> setAuthenticated(AdminAuthTokenResponse session) async {
    state = const AdminAuthLoading();
    final admin = await ref
        .read(adminAuthRepositoryProvider)
        .persistSession(session);
    state = AdminAuthAuthenticated(admin);
  }

  Future<void> logout() async {
    if (state is AdminAuthLoading || state is AdminAuthUnauthenticated) {
      return;
    }

    state = const AdminAuthLoading();
    try {
      await ref.read(adminAuthRepositoryProvider).logout();
    } finally {
      state = const AdminAuthUnauthenticated();
    }
  }
}

final adminAuthNotifierProvider =
    NotifierProvider<AdminAuthNotifier, AdminAuthSessionState>(
      AdminAuthNotifier.new,
    );
