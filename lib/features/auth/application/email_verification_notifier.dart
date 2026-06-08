import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';

sealed class EmailVerificationState {
  const EmailVerificationState();
}

class EmailVerificationInitial extends EmailVerificationState {
  const EmailVerificationInitial();
}

class EmailVerificationLoading extends EmailVerificationState {
  const EmailVerificationLoading();
}

class EmailVerificationSuccess extends EmailVerificationState {
  const EmailVerificationSuccess(this.message);

  final String message;
}

class EmailVerificationError extends EmailVerificationState {
  const EmailVerificationError(this.error);

  final Object error;
}

class EmailVerificationNotifier extends Notifier<EmailVerificationState> {
  @override
  EmailVerificationState build() => const EmailVerificationInitial();

  Future<void> verifyToken(String token) async {
    state = const EmailVerificationLoading();
    try {
      final message = await ref
          .read(authRepositoryProvider)
          .verifyEmailToken(token);
      state = EmailVerificationSuccess(message);
    } catch (error) {
      state = EmailVerificationError(error);
    }
  }

  Future<void> checkCurrentUserStatus() async {
    state = const EmailVerificationLoading();
    try {
      final user = await ref.read(authRepositoryProvider).fetchCurrentUser();
      if (user.isVerified == true) {
        state = const EmailVerificationSuccess('Email verified.');
        return;
      }
      state = const EmailVerificationError(
        FormatException('Email not verified yet. Check your inbox.'),
      );
    } catch (error) {
      state = EmailVerificationError(error);
    }
  }

  void reset() {
    state = const EmailVerificationInitial();
  }
}

final emailVerificationNotifierProvider =
    NotifierProvider<EmailVerificationNotifier, EmailVerificationState>(
      EmailVerificationNotifier.new,
    );
