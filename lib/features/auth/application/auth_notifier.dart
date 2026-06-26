import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_global.dart';
import '../data/repositories/auth_repository.dart';

sealed class AuthSessionState {
  const AuthSessionState();
}

class AuthInitial extends AuthSessionState {
  const AuthInitial();
}

class AuthLoading extends AuthSessionState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthSessionState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthSessionState {
  const AuthAuthenticated(this.user);

  final UserModel user;
}

class AuthNotifier extends Notifier<AuthSessionState> {
  @override
  AuthSessionState build() {
    ref.listen(forceLogoutSignalProvider, (prev, next) {
      state = const AuthUnauthenticated();
    });
    return const AuthInitial();
  }

  Future<bool> bootstrap() async {
    state = const AuthLoading();

    try {
      final user = await ref.read(authRepositoryProvider).fetchCurrentUser();
      state = AuthAuthenticated(user);
      return true;
    } on UnauthorizedException catch (_) {
      // Token is genuinely invalid — clear stored session so the user must log in again.
      await ref.read(authRepositoryProvider).clearLocalSession();
      state = const AuthUnauthenticated();
      return false;
    } catch (_) {
      // Network error or server error — keep the refresh token intact so the next
      // app open can retry automatically once connectivity is restored.
      state = const AuthUnauthenticated();
      return false;
    }
  }

  Future<void> setAuthenticated(AuthTokenResponse session) async {
    state = const AuthLoading();
    final user = await ref.read(authRepositoryProvider).persistSession(session);
    state = AuthAuthenticated(user);
  }

  Future<UserModel> refreshCurrentUser() async {
    final user = await ref.read(authRepositoryProvider).fetchCurrentUser();
    state = AuthAuthenticated(user);
    return user;
  }

  void setCurrentUser(UserModel user) {
    state = AuthAuthenticated(user);
  }

  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await ref.read(authRepositoryProvider).logout();
    } finally {
      state = const AuthUnauthenticated();
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthSessionState>(
  AuthNotifier.new,
);
