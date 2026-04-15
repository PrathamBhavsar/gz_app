import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/network/connectivity_service.dart';

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
            // Auto-retry checking user status if connection comes back and we were in error state
            checkAuthStatus();
          }
        });

    ref.onDispose(() => _connectivitySub?.cancel());

    return const AuthInitial();
  }

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

  Future<void> submitOtp(String phone, String otp) async {
    state = const AuthLoading();
    try {
      final response = await _repository.verifyPhoneOtp(phone, otp);
      if (response.success == true && response.data != null) {
        state = AuthAuthenticated(response.data!);
      } else {
        throw Exception('Invalid OTP or login failed');
      }
    } catch (e) {
      state = AuthError(e);
    }
  }

  void logout() {
    state = const AuthUnauthenticated();
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
