import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

class LoginError extends LoginState {
  const LoginError(this.error);

  final Object error;
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginInitial();

  Future<void> submit({required String email, required String password}) async {
    state = const LoginLoading();

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .loginWithEmail(email: email, password: password);
      await ref.read(authNotifierProvider.notifier).setAuthenticated(session);
      state = const LoginSuccess();
    } catch (error) {
      state = LoginError(error);
    }
  }

  void reset() {
    state = const LoginInitial();
  }
}

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
