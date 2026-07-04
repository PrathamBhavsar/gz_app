/// Social-login (OAuth) configuration.
///
/// These are CLIENT-side public identifiers only. No secrets live here —
/// the Discord client secret and Google client secret stay in the backend.
class OAuthConfig {
  OAuthConfig._();

  // ─── Google ────────────────────────────────────────────────────────
  /// The **Web** OAuth client id ("Web client (auto created by Google
  /// Service)") from the gz-ideation Firebase/Google Cloud project.
  ///
  /// `google_sign_in` needs this as `serverClientId` so the returned ID token
  /// is minted with this client id as its audience, which the backend then
  /// validates. It is created the moment Google Sign-In is enabled in
  /// Firebase Authentication.
  ///
  /// "Web client (auto created by Google Service)" from gz-ideation.
  static const String googleServerClientId =
      '356415772589-gf0k3m8qnjs2pvsjghrb32t9c577jh7r.apps.googleusercontent.com';

  static bool get isGoogleConfigured => googleServerClientId.isNotEmpty;

  // ─── Discord ───────────────────────────────────────────────────────
  /// Discord application id ("Application ID" / OAuth2 client id). Public.
  static const String discordClientId = '1519955725043109898';

  /// Discord automatically supports redirect URIs whose scheme is
  /// `discord-{applicationId}://` — no portal registration needed. This also
  /// avoids colliding with the app's own `gzapp://` deep-link scheme.
  static const String discordCallbackScheme = 'discord-$discordClientId';

  /// Discord's native callback. Discord MANDATES this exact shape — note the
  /// SINGLE slash after the colon (`:/`, not `://`). The double-slash form is
  /// rejected with "Redirect URI ... is not supported by client".
  static const String discordRedirectUri =
      'discord-$discordClientId:/authorize/callback';

  /// Scopes: identify (id/username/avatar) + email (verified email for match).
  static const String discordScopes = 'identify email';
}
