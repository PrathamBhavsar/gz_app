import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_global.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthUnauthenticated();

  Future<void> checkAuthStatus() async {
    if (state is! AuthAuthenticated) {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> signInDemo({
    String? name,
    String? email,
    String? phone,
  }) async {
    state = AuthAuthenticated(
      UserModel(
        id: 'demo-user',
        name: name ?? 'Rahul Sharma',
        email: email ?? 'rahul@example.com',
        phone: phone ?? '+91 98765 43210',
        isVerified: true,
      ),
    );
  }

  Future<void> register({
    String? name,
    String? email,
    String? phone,
  }) async {
    await signInDemo(name: name, email: email, phone: phone);
  }

  Future<void> loginWithEmail(String email, String password) async {
    await signInDemo(email: email);
  }

  Future<void> submitOtp(String phone, String otp) async {
    await signInDemo(phone: phone);
  }

  Future<void> logout() async {
    state = const AuthUnauthenticated();
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
