import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';

/// Holds the pending social-signup handoff so the details screen survives
/// GoRouter rebuilds. `state.extra` is dropped whenever the router refreshes
/// (e.g. when auth state changes after signup), so it cannot be relied on.
final pendingOAuthSignupProvider = StateProvider<OAuthNewUser?>((ref) => null);

sealed class OAuthSignupState {
  const OAuthSignupState();
}

class OAuthSignupInitial extends OAuthSignupState {
  const OAuthSignupInitial();
}

class OAuthSignupLoading extends OAuthSignupState {
  const OAuthSignupLoading();
}

class OAuthSignupSuccess extends OAuthSignupState {
  const OAuthSignupSuccess();
}

class OAuthSignupError extends OAuthSignupState {
  const OAuthSignupError(this.error);
  final Object error;
}

/// Phase 2 of social login: completes registration using the signup token
/// minted by `/auth/oauth/:provider/verify`.
class OAuthSignupNotifier extends Notifier<OAuthSignupState> {
  @override
  OAuthSignupState build() => const OAuthSignupInitial();

  Future<void> submit({
    required String signupToken,
    required String name,
    String? phone,
  }) async {
    state = const OAuthSignupLoading();
    try {
      final session = await ref.read(authRepositoryProvider).oauthCompleteSignup(
            signupToken: signupToken,
            name: name,
            phone: phone,
          );
      await ref.read(authNotifierProvider.notifier).setAuthenticated(session);
      state = const OAuthSignupSuccess();
    } catch (error) {
      state = OAuthSignupError(error);
    }
  }

  void reset() => state = const OAuthSignupInitial();
}

final oauthSignupNotifierProvider =
    NotifierProvider<OAuthSignupNotifier, OAuthSignupState>(
      OAuthSignupNotifier.new,
    );
