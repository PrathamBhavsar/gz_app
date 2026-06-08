import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_auth_repository.dart';
import '../data/repositories/auth_repository.dart';

sealed class PasswordResetState {
  const PasswordResetState();
}

class PasswordResetInitial extends PasswordResetState {
  const PasswordResetInitial();
}

class PasswordResetLoading extends PasswordResetState {
  const PasswordResetLoading();
}

class PasswordResetSuccess extends PasswordResetState {
  const PasswordResetSuccess(this.message);

  final String message;
}

class PasswordResetError extends PasswordResetState {
  const PasswordResetError(this.error);

  final Object error;
}

class PasswordResetNotifier extends Notifier<PasswordResetState> {
  @override
  PasswordResetState build() => const PasswordResetInitial();

  Future<void> requestPlayerReset(String email) async {
    state = const PasswordResetLoading();
    try {
      final message = await ref
          .read(authRepositoryProvider)
          .requestPasswordReset(email: email);
      state = PasswordResetSuccess(message);
    } catch (error) {
      state = PasswordResetError(error);
    }
  }

  Future<void> requestAdminReset(String email) async {
    state = const PasswordResetLoading();
    try {
      final message = await ref
          .read(adminAuthRepositoryProvider)
          .requestPasswordReset(email: email);
      state = PasswordResetSuccess(message);
    } catch (error) {
      state = PasswordResetError(error);
    }
  }

  Future<void> confirmPlayerReset({
    required String token,
    required String password,
  }) async {
    state = const PasswordResetLoading();
    try {
      final message = await ref
          .read(authRepositoryProvider)
          .confirmPasswordReset(token: token, password: password);
      state = PasswordResetSuccess(message);
    } catch (error) {
      state = PasswordResetError(error);
    }
  }

  Future<void> confirmAdminReset({
    required String token,
    required String password,
  }) async {
    state = const PasswordResetLoading();
    try {
      final message = await ref
          .read(adminAuthRepositoryProvider)
          .confirmPasswordReset(token: token, password: password);
      state = PasswordResetSuccess(message);
    } catch (error) {
      state = PasswordResetError(error);
    }
  }

  void reset() {
    state = const PasswordResetInitial();
  }
}

final passwordResetNotifierProvider =
    NotifierProvider<PasswordResetNotifier, PasswordResetState>(
      PasswordResetNotifier.new,
    );
