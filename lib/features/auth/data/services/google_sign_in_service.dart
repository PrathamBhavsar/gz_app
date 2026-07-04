import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/config/oauth_config.dart';
import '../../../../core/errors/app_exception.dart';

/// Result of a native Google sign-in. [idToken] is sent to the backend for
/// verification; the rest is used only to prefill the signup screen.
class GoogleSignInResult {
  const GoogleSignInResult({
    required this.idToken,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final String idToken;
  final String? email;
  final String? displayName;
  final String? photoUrl;
}

/// Thin wrapper over `google_sign_in` 7.x (singleton `GoogleSignIn.instance`).
class GoogleSignInService {
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    if (!OAuthConfig.isGoogleConfigured) {
      throw const OAuthSetupException(
        'Google sign-in is not configured yet. Set '
        'OAuthConfig.googleServerClientId to the Web client id from the '
        'gz-ideation Firebase project (enable Google in Firebase Auth first).',
      );
    }
    await GoogleSignIn.instance.initialize(
      serverClientId: OAuthConfig.googleServerClientId,
    );
    _initialized = true;
  }

  /// Opens the Google account picker and returns the ID token + profile.
  /// Throws [OAuthCancelledException] if the user backs out.
  Future<GoogleSignInResult> signIn() async {
    await _ensureInitialized();

    final signIn = GoogleSignIn.instance;
    if (!signIn.supportsAuthenticate()) {
      throw const OAuthSetupException(
        'Google authenticate() is not supported on this platform.',
      );
    }

    final GoogleSignInAccount account;
    try {
      account = await signIn.authenticate(
        scopeHint: const <String>['email', 'profile'],
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const OAuthCancelledException();
      }
      // code 10 / DEVELOPER_ERROR etc. surface as a setup error in debug.
      throw OAuthSetupException('Google sign-in failed: ${e.code.name}. '
          '${e.description ?? ''}'.trim());
    }

    final idToken = account.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const OAuthSetupException(
        'Google returned no ID token. Check that serverClientId is the Web '
        'client id and that the Google provider is enabled.',
      );
    }

    return GoogleSignInResult(
      idToken: idToken,
      email: account.email,
      displayName: account.displayName,
      photoUrl: account.photoUrl,
    );
  }

  Future<void> signOut() async {
    if (!_initialized) return;
    await GoogleSignIn.instance.signOut();
  }
}

final googleSignInServiceProvider = Provider<GoogleSignInService>(
  (ref) => GoogleSignInService(),
);
