import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/discord_oauth_service.dart';
import '../data/services/google_sign_in_service.dart';
import 'auth_notifier.dart';

sealed class SocialLoginState {
  const SocialLoginState();
}

class SocialLoginInitial extends SocialLoginState {
  const SocialLoginInitial();
}

class SocialLoginLoading extends SocialLoginState {
  const SocialLoginLoading(this.provider);
  final String provider; // 'google' | 'discord'
}

/// No account for this identity — UI shows the "do you want to sign up?" dialog.
class SocialLoginNeedsSignup extends SocialLoginState {
  const SocialLoginNeedsSignup(this.newUser);
  final OAuthNewUser newUser;
}

class SocialLoginSuccess extends SocialLoginState {
  const SocialLoginSuccess();
}

class SocialLoginError extends SocialLoginState {
  const SocialLoginError(this.error);
  final Object error;
}

class SocialLoginNotifier extends Notifier<SocialLoginState> {
  @override
  SocialLoginState build() => const SocialLoginInitial();

  Future<void> continueWithGoogle() async {
    state = const SocialLoginLoading('google');
    await _run(() async {
      final google = await ref.read(googleSignInServiceProvider).signIn();
      return ref.read(authRepositoryProvider).oauthVerify(
            provider: 'google',
            idToken: google.idToken,
          );
    });
  }

  Future<void> continueWithDiscord() async {
    state = const SocialLoginLoading('discord');
    await _run(() async {
      final discord = await ref.read(discordOAuthServiceProvider).signIn();
      return ref.read(authRepositoryProvider).oauthVerify(
            provider: 'discord',
            accessToken: discord.accessToken,
          );
    });
  }

  Future<void> _run(Future<OAuthVerifyResult> Function() verify) async {
    try {
      final result = await verify();
      switch (result) {
        case OAuthExistingUser(:final session):
          await ref.read(authNotifierProvider.notifier).setAuthenticated(
                session,
              );
          state = const SocialLoginSuccess();
        case OAuthNewUser():
          state = SocialLoginNeedsSignup(result);
      }
    } on OAuthCancelledException {
      // User backed out — silent reset, no error toast.
      state = const SocialLoginInitial();
    } catch (error) {
      state = SocialLoginError(error);
    }
  }

  void reset() => state = const SocialLoginInitial();
}

final socialLoginNotifierProvider =
    NotifierProvider<SocialLoginNotifier, SocialLoginState>(
      SocialLoginNotifier.new,
    );
