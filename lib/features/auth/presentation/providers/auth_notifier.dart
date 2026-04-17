import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/auth/token_storage.dart';

class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository _repository;
  StreamSubscription<bool>? _connectivitySub;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);

    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
          if (isConnected && state is AuthError) {
            checkAuthStatus();
          }
        });

    ref.onDispose(() => _connectivitySub?.cancel());

    return const AuthInitial();
  }

  // ─── Check auth status on app start (uses stored access token) ────
  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    try {
      final response = await _repository.getUserProfile();
      if (response.success == true && response.data != null) {
        state = AuthAuthenticated(response.data!);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      state = AuthError(e);
    }
  }

  // ─── Email + password login ────────────────────────────────────────
  Future<void> loginWithEmail(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _repository.loginWithEmail(email, password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e);
    }
  }

  // ─── OTP verify ───────────────────────────────────────────────────
  Future<void> submitOtp(String phone, String otp) async {
    state = const AuthLoading();
    try {
      final user = await _repository.verifyPhoneOtp(phone, otp);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e);
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      // Clear access token from memory
      ref.read(accessTokenProvider.notifier).state = null;
      state = const AuthUnauthenticated();
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
