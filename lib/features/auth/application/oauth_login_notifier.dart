import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';

sealed class OAuthLoginState {
  const OAuthLoginState();
}

class OAuthLoginInitial extends OAuthLoginState {
  const OAuthLoginInitial();
}

class OAuthLoginLoading extends OAuthLoginState {
  const OAuthLoginLoading();
}

class OAuthLoginSuccess extends OAuthLoginState {
  const OAuthLoginSuccess();
}

class OAuthLoginError extends OAuthLoginState {
  const OAuthLoginError(this.error);

  final Object error;
}

class OAuthLoginNotifier extends Notifier<OAuthLoginState> {
  @override
  OAuthLoginState build() => const OAuthLoginInitial();

  Future<void> submit({
    required String provider,
    required String code,
    String? stateParam,
    String? redirectUri,
  }) async {
    state = const OAuthLoginLoading();

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .exchangeOAuthCode(
            provider: provider,
            code: code,
            state: stateParam,
            redirectUri: redirectUri,
          );
      await ref.read(authNotifierProvider.notifier).setAuthenticated(session);
      state = const OAuthLoginSuccess();
    } catch (error) {
      state = OAuthLoginError(error);
    }
  }

  void reset() {
    state = const OAuthLoginInitial();
  }
}

final oauthLoginNotifierProvider =
    NotifierProvider<OAuthLoginNotifier, OAuthLoginState>(
      OAuthLoginNotifier.new,
    );
