import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/oauth_config.dart';
import '../../../../core/errors/app_exception.dart';

/// Result of the Discord OAuth flow: an access token that the backend redeems
/// at Discord's `/users/@me` endpoint.
class DiscordOAuthResult {
  const DiscordOAuthResult({required this.accessToken});

  final String accessToken;
}

/// Native Discord sign-in (public client + PKCE), matching the working
/// getnautiai-app flow:
///   1. open `/oauth2/authorize` (with a PKCE `code_challenge`) in the external
///      browser via url_launcher; capture `discord-<appId>:/authorize/callback`
///      via app_links.
///   2. exchange the `code` for an `access_token` directly with Discord on the
///      device (no client secret — PKCE proves the request).
///   3. hand the `access_token` to the backend, which redeems it server-side.
///
/// Discord auto-allows the `discord-<appId>:/authorize/callback` redirect for
/// this public-client/PKCE shape — no portal registration required.
class DiscordOAuthService {
  static const String _tokenEndpoint = 'https://discord.com/api/oauth2/token';

  final AppLinks _appLinks = AppLinks();

  String _randomToken() {
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  String _codeChallenge(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  Future<DiscordOAuthResult> signIn() async {
    final verifier = _randomToken();
    final challenge = _codeChallenge(verifier);
    final state = _randomToken();
    final scheme = OAuthConfig.discordCallbackScheme; // discord-<appId>

    final authorizeUrl = Uri.https('discord.com', '/oauth2/authorize', {
      'client_id': OAuthConfig.discordClientId,
      'response_type': 'code',
      'redirect_uri': OAuthConfig.discordRedirectUri,
      'scope': OAuthConfig.discordScopes,
      'state': state,
      'code_challenge': challenge,
      'code_challenge_method': 'S256',
      'prompt': 'consent',
    });

    final completer = Completer<Uri>();
    void tryComplete(Uri uri) {
      if (uri.scheme == scheme && !completer.isCompleted) {
        completer.complete(uri);
      }
    }

    final sub = _appLinks.uriLinkStream.listen(tryComplete);
    unawaited(_appLinks.getInitialLink().then((uri) {
      if (uri != null) tryComplete(uri);
    }));

    final lifecycle = _ResumeWatcher(() {
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (!completer.isCompleted) {
          completer.completeError(const OAuthCancelledException());
        }
      });
    });
    WidgetsBinding.instance.addObserver(lifecycle);

    try {
      final launched = await launchUrl(
        authorizeUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw const OAuthSetupException(
          'Could not open a browser for Discord sign-in.',
        );
      }

      final Uri returned;
      try {
        returned = await completer.future.timeout(const Duration(minutes: 3));
      } on TimeoutException {
        throw const OAuthCancelledException();
      }

      final error = returned.queryParameters['error'];
      if (error != null && error.isNotEmpty) {
        if (error == 'access_denied') throw const OAuthCancelledException();
        throw OAuthSetupException('Discord authorization failed: $error');
      }
      if (returned.queryParameters['state'] != state) {
        throw const OAuthSetupException('Discord state mismatch. Aborting.');
      }
      final code = returned.queryParameters['code'];
      if (code == null || code.isEmpty) {
        throw const OAuthSetupException('Discord returned no authorization code.');
      }

      final accessToken = await _exchangeCode(code, verifier);
      return DiscordOAuthResult(accessToken: accessToken);
    } finally {
      await sub.cancel();
      WidgetsBinding.instance.removeObserver(lifecycle);
    }
  }

  Future<String> _exchangeCode(String code, String verifier) async {
    final res = await http.post(
      Uri.parse(_tokenEndpoint),
      headers: const {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: {
        'client_id': OAuthConfig.discordClientId,
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': OAuthConfig.discordRedirectUri,
        'code_verifier': verifier,
      },
    );
    if (res.statusCode != 200) {
      throw OAuthSetupException(
        'Discord token exchange failed (${res.statusCode}).',
      );
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final token = data['access_token'] as String?;
    if (token == null || token.isEmpty) {
      throw const OAuthSetupException('Discord returned no access token.');
    }
    return token;
  }
}

/// Fires [onResumed] the first time the app returns to the foreground.
class _ResumeWatcher with WidgetsBindingObserver {
  _ResumeWatcher(this.onResumed);

  final VoidCallback onResumed;
  bool _fired = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_fired) {
      _fired = true;
      onResumed();
    }
  }
}

final discordOAuthServiceProvider = Provider<DiscordOAuthService>(
  (ref) => DiscordOAuthService(),
);
