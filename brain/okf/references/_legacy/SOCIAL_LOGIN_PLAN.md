# SOCIAL LOGIN PLAN — Google + Discord (Player App)

> Status: PLAN ONLY. No code written yet. Implement after this doc is approved.
> Scope: Player mobile app (`gz_app`) + backend (`gz_ideation`). Admin login is unaffected.
> Author intent: Native "Continue with Google" and "Continue with Discord"; if the
> identity is not already linked to an account, show a "Do you want to sign up?" popup,
> then open a signup-details screen to finish registration. Must run **fully locally**
> first using a debug signing certificate (SHA-1).

---

## 0. TL;DR of the key decisions

1. **Google = native SDK flow.** Use the `google_sign_in` package. The device gets a
   Google **ID token**, sends it to the backend, backend verifies it. No web redirect,
   no `client_secret` on the Google path.
2. **Discord = browser OAuth2 (authorization-code) flow.** Discord has no native SDK.
   Open Discord's consent page in a system browser tab (`flutter_web_auth_2`), get an
   authorization `code` back via a custom-scheme deep link, send the `code` to the
   backend, backend exchanges it with Discord (using `client_secret`).
3. **Two-phase auth so we can ask before creating an account:**
   - **Phase 1 — verify:** backend verifies the provider identity only. If the identity
     (or its email) already maps to a user → return a full session immediately. If not →
     return `isNewUser: true` + a short-lived **signup token** + prefill (email, name,
     avatar). **No user row is created yet.**
   - **Phase 2 — complete signup:** after the user taps "Yes, sign up" and fills the
     details screen, the app posts the signup token + profile fields → backend creates
     the user + credential → returns a full session.
4. **Reuse the existing Firebase project** (the one already wired for FCM). Add Android +
   iOS apps to it to obtain the OAuth client IDs and the config files.
5. **"debug ssh" = the debug signing certificate SHA-1 (and SHA-256) fingerprint.** This
   is required so Google Sign-In trusts your debug builds. Discord does not use SHA.

---

## 1. Why the current scaffolding can't be reused as-is

| Piece | Current behaviour | Problem for our goal |
|---|---|---|
| `auth_landing_screen.dart` | Routes to `oauth_handler?provider=google` and "waits for a callback" | No real sign-in is ever triggered; there is no Google/Discord SDK call |
| `oauth_handler_screen.dart` | Expects `provider` + `code` from route params | Nothing ever supplies `code`; dead-ends |
| `auth_repository.exchangeOAuthCode` | POSTs `{code, state, redirectUri}` to `/auth/login/oauth/:provider` | Works for a **code** flow only; Google native gives an **idToken**, not a code |
| backend `loginWithOAuth` | Exchanges an auth `code`, then **auto-creates** the user | We must NOT auto-create — we must ask first |
| `authMethodEnum` / `ProviderParam` | `google` / `apple` only | Need `discord`; drop Apple from the UI |

Conclusion: keep the file/route skeleton, but rewrite the flow on both ends.

---

## 2. Accounts & developer-console setup (do this FIRST)

### 2.1 Firebase / Google Cloud (for Google Sign-In)

We reuse the existing Firebase project that already powers FCM. Open the Firebase
console → that project.

**A. Register the Android app**
1. Project settings → "Add app" → Android.
2. **Android package name** must exactly match the app's `applicationId`.
   - Current value: `com.example.gz_app` (`android/app/build.gradle.kts`).
   - Recommendation: change it once now to a real id (e.g. `app.splin.gz`) before
     shipping, because `com.example.*` cannot be published. If you change it, do it
     *before* registering, so the SHA + package match.
3. **Add the debug SHA-1 AND SHA-256.** (See §3 for how to get them.)
4. Download **`google-services.json`**.

**B. Register the iOS app** (only needed when you test on iOS/macOS)
1. Add app → iOS, bundle id = the iOS bundle identifier in Xcode.
2. Download **`GoogleService-Info.plist`**.

**C. Note the OAuth client IDs** (Google Cloud Console → "APIs & Services" → Credentials,
same project). Firebase auto-creates these:
- **Web client (auto created by Google Service)** → this is the **`serverClientId`** the
  app passes to `google_sign_in` to receive an ID token, and it is the **audience** the
  backend validates against. **This is the most common failure point — write it down.**
- **Android client** (package + SHA-1) → used implicitly; you don't paste it anywhere.
- **iOS client** → used by the plist.

> You do NOT have to enable Firebase Authentication providers for this approach — we only
> use Google's ID token + the OAuth client. (If you later prefer Firebase Auth to mint the
> token, that's an alternative, but the plan below uses plain Google Sign-In to match the
> backend's existing `sub`-based model.)

### 2.2 Discord developer portal (for Discord login)

1. Go to https://discord.com/developers/applications → **New Application** → name it.
2. Copy the **Application ID** → this is your **`DISCORD_CLIENT_ID`**.
3. **OAuth2** tab → **Reset Secret** → copy the **Client Secret** → `DISCORD_CLIENT_SECRET`.
4. **OAuth2 → Redirects** → add the deep-link redirect URI the app will use:
   - `gzapp://oauth/discord` (custom scheme — simplest for local/native).
   - Add a second one for any future web build if needed.
5. Scopes we request: **`identify email`**. (`identify` = id/username/avatar, `email` =
   the verified email — required so we can match/prefill.)
6. No SHA / no app verification needed for `identify email`.

### 2.3 Backend already has Firebase Admin

`src/lib/fcm.ts` initialises `firebase-admin` from `FCM_SERVICE_ACCOUNT_JSON`. We do **not**
need a second service-account file for login — Google ID-token verification is done with a
public OAuth client ID (audience check), not the service account. So **no new JSON file is
required in the backend** for Google or Discord.

---

## 3. The "debug SHA" explained (this is what you asked about)

Google Sign-In only trusts an app whose signing certificate fingerprint is registered for
the Android OAuth client. In debug builds your app is auto-signed with the **debug
keystore** at `~/.android/debug.keystore` (password `android`, alias `androiddebugkey`).

Get the fingerprints one of two ways:

```bash
# Option A — keytool (works anywhere)
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android

# Option B — gradle signing report (also shows release if configured)
cd /Users/pratham/code/gz_app/android && ./gradlew signingReport
```

Copy the **SHA1** and **SHA-256** lines from the `debug` variant into the Firebase Android
app (Project settings → your Android app → "Add fingerprint"). After adding, **re-download
`google-services.json`** (it may change).

> If Google Sign-In throws `PlatformException(sign_in_failed, ..., 10)` that is
> `DEVELOPER_ERROR` = wrong/missing SHA or wrong package name. 90% of setup pain is here.

Discord needs none of this — it's a browser redirect, not a signed-app trust check.

---

## 4. Where each file goes

| File | Project | Exact path | Committed to git? |
|---|---|---|---|
| `google-services.json` | app | `gz_app/android/app/google-services.json` | NO — gitignore it (contains client IDs) |
| `GoogleService-Info.plist` | app | `gz_app/ios/Runner/GoogleService-Info.plist` (add to Xcode target) | NO — gitignore |
| Google/Discord client IDs & secrets | backend | `gz_ideation/.env` (see §6) | NO — `.env` already gitignored |
| FCM service account | backend | already in `.env` as `FCM_SERVICE_ACCOUNT_JSON` | NO (unchanged) |

The app needs Gradle plugin wiring so `google-services.json` is read:
- `android/build.gradle.kts` → add `com.google.gms.google-services` classpath/plugin.
- `android/app/build.gradle.kts` → apply the plugin; set the real `applicationId`.
- iOS: drop the plist into `Runner` and add to the target in Xcode.

---

## 5. End-to-end flows (sequence)

### 5.1 Google — existing user

```
App: tap "Continue with Google"
 → google_sign_in opens account picker
 → returns { idToken, email, displayName, photoUrl }
App → POST /auth/oauth/google/verify  { idToken }
Backend: verify idToken (audience = Web client id, issuer = accounts.google.com, not expired)
 → find user_credentials(google_oauth, sub) → found
 → create session → 200 { accessToken, refreshToken, user, isNewUser:false }
App: persist session → go Home
```

### 5.2 Google — new identity (the "ask before signup" path)

```
App → POST /auth/oauth/google/verify { idToken }
Backend: verify idToken → no google_oauth credential for sub
 → also no users.email match (see §7 for the email-collision case)
 → DO NOT create user
 → 200 { isNewUser:true, signupToken, prefill:{ email, name, avatarUrl } }
App: show dialog "No account found for this Google email. Do you want to sign up?"
   - Cancel → back to landing, nothing created
   - Continue → push SignupDetailsScreen prefilled with name/email (email read-only)
App: user fills remaining required fields (e.g. name confirm, phone optional, accept terms)
   → POST /auth/oauth/signup { signupToken, name, phone? }
Backend: validate signupToken (short TTL, signed, provider+sub+email inside)
 → create users + user_credentials(google_oauth, sub, verified)
 → create session → 201 { accessToken, refreshToken, user }
App: persist session → go Home
```

### 5.3 Discord — both cases

```
App: tap "Continue with Discord"
 → build authorize URL:
   https://discord.com/oauth2/authorize?response_type=code
     &client_id=DISCORD_CLIENT_ID&scope=identify%20email
     &redirect_uri=gzapp://oauth/discord&state=<random>&prompt=consent
 → flutter_web_auth_2 opens it, user approves
 → browser redirects to gzapp://oauth/discord?code=...&state=...
App: verify state matches → POST /auth/oauth/discord/verify { code, redirectUri }
Backend: POST https://discord.com/api/oauth2/token (code, client_id, client_secret, redirect_uri)
 → GET https://discord.com/api/users/@me with the access token
 → sub = discord user id, email = verified email, name = global_name/username
 → same branch as Google: existing → session; new → { isNewUser, signupToken, prefill }
(then identical to 5.1 / 5.2)
```

> Note the asymmetry: Google sends an **idToken**, Discord sends a **code + redirectUri**.
> The `/verify` endpoint body is a discriminated union per provider (see §6.2).

---

## 6. Backend changes (`gz_ideation`)

### 6.1 Schema / migration (`src/modules/auth/schema.ts`)
- Add `discord_oauth` to `authMethodEnum`.
- Keep `apple_oauth` value (harmless) but it's unused by the app.
- Run `bun run db:generate` then `bun run db:migrate` (enum add is a real migration).
- `user_credentials` already has the right shape: `(authMethod, identifier)` unique →
  `identifier` = provider `sub`; `metadata` holds `{ email, avatarUrl }`.

### 6.2 Models (`src/modules/auth/model.ts`)
- `ProviderParam`: `t.Union([Literal('google'), Literal('discord')])`.
- New `OAuthVerifyBody` (per provider): `google` → `{ idToken: string }`;
  `discord` → `{ code: string, redirectUri: string }`. Validate per `:provider`.
- New `OAuthVerifyResponse`: union of
  - existing-user → the current `LoginResponse` shape (+ `isNewUser:false`)
  - new-user → `{ success, message, data: { isNewUser:true, signupToken, prefill:{email,name,avatarUrl} } }`
- New `OAuthSignupBody`: `{ signupToken: string, name: string, phone?: E164 }`.

### 6.3 Service (`src/modules/auth/service.ts`)
- Replace `verifyOAuthCode` with two verifiers:
  - `verifyGoogleIdToken(idToken)` → call `https://oauth2.googleapis.com/tokeninfo?id_token=`
    **and assert `aud === GOOGLE_CLIENT_ID` and `iss` is google and `exp` not passed**
    (current code does NOT check `aud` — that's a vuln; add it). Prefer the
    `google-auth-library` `OAuth2Client.verifyIdToken` if added.
  - `verifyDiscordCode(code, redirectUri)` → token exchange + `/users/@me`.
- Split `loginWithOAuth` into:
  - `oauthVerify(provider, payload)`:
    1. resolve `{ sub, email, name, avatarUrl }`
    2. look up credential by `(authMethod, sub)` → if found, return session (existing).
    3. else build a **signupToken** = signed JWT `{ purpose:'oauth_signup', provider,
       sub, email, name, avatarUrl, exp: now+10min }`. Return `isNewUser:true` + prefill.
       **Do not create the user. Do not auto-link by email here** (see §7 decision).
  - `oauthCompleteSignup(signupToken, profile)`:
    1. verify signupToken (signature + purpose + not expired).
    2. re-check no credential for `(authMethod, sub)` was created meanwhile (race).
    3. decide email linking per §7.
    4. insert `users` + `user_credentials` in a tx, `isVerified:true`.
    5. create session, return tokens.
- Keep `createSession`, `sanitizeUser`, refresh, logout unchanged.

### 6.4 Routes (`src/modules/auth/index.ts`)
- Replace `POST /login/oauth/:provider` with:
  - `POST /auth/oauth/:provider/verify` → `oauthVerify`
  - `POST /auth/oauth/signup` → `oauthCompleteSignup`
- Both are **public** (no auth middleware). Rate-limit `/verify` per IP.

### 6.5 Config / env (`src/config/index.ts` + `.env` + `.env.example`)
Add to the config schema and `.env.example`:
```
# Google OAuth (Sign-In ID-token verification)
GOOGLE_CLIENT_ID=<Web client id from Firebase/Google Cloud>   # audience to validate
GOOGLE_CLIENT_SECRET=<only needed if you keep a web auth-code path; not needed for idToken>

# Discord OAuth
DISCORD_CLIENT_ID=<Application ID>
DISCORD_CLIENT_SECRET=<OAuth2 client secret>
DISCORD_REDIRECT_URI=gzapp://oauth/discord
```
- Move `GOOGLE_CLIENT_ID` into `config` (currently read ad-hoc from `Bun.env`).
- The **signupToken** is signed with the existing `JWT_SECRET` (distinct `purpose` claim).

---

## 7. The email-collision decision (MUST decide — security-sensitive)

Scenario: user signs in with Google whose email is `a@x.com`, and a `users` row already
exists with `email a@x.com` created via **email+password** or **another provider**.

Three options:
- **(A) Auto-link** silently to the existing user (current backend behaviour). Convenient,
  but a provider that doesn't verify email could let an attacker hijack an account.
  Both Google and Discord DO return verified emails, so the risk is low **but** Discord
  only marks `verified:true` when the user verified — we must check that flag.
- **(B) Block + tell the user** "This email already has an account, sign in with your
  existing method first, then link Discord in settings." Safest, more friction.
- **(C) Ask** in the popup: "a@x.com already exists — link this Google login to it?"

**Recommended: (A) but only when the provider reports the email as verified** (Google
always; Discord only if `verified === true`). If the provider email is unverified → fall
through to the new-signup path with email left blank/editable. Capture this rule in the
service and in the test matrix.

---

## 8. Frontend changes (`gz_app`)

### 8.1 Dependencies (`pubspec.yaml`)
- `google_sign_in` (native Google) — latest 6.x.
- `flutter_web_auth_2` (Discord browser flow + deep-link capture).
- (Android) ensure `minSdkVersion >= 21`. (iOS) add URL scheme + `LSApplicationQueriesSchemes`.
- Register the custom scheme `gzapp` for the Discord redirect:
  - Android: an `intent-filter` on the callback activity (flutter_web_auth_2 provides one;
    set `appAuthRedirectScheme = gzapp`).
  - iOS: `CFBundleURLTypes` with scheme `gzapp` in `Info.plist`.

### 8.2 New repository methods (`auth_repository.dart`)
Replace `exchangeOAuthCode` with:
- `oauthVerify({ provider, idToken?, code?, redirectUri? }) → OAuthVerifyResult`
  where `OAuthVerifyResult` is a sealed type: `ExistingUser(AuthTokenResponse)` or
  `NewUser(signupToken, prefill)`.
- `oauthCompleteSignup({ signupToken, name, phone? }) → AuthTokenResponse`.

### 8.3 New platform helpers
- `GoogleSignInService.signIn()` → returns `idToken` (pass `serverClientId = Web client id`).
- `DiscordOAuthService.signIn()` → builds authorize URL with random `state`, calls
  `FlutterWebAuth2.authenticate(scheme: 'gzapp')`, validates `state`, returns `code`.

### 8.4 Notifiers (`application/`)
- Rework `oauth_login_notifier.dart` into `SocialLoginNotifier` with states:
  `Initial / Loading / NeedsSignup(provider, signupToken, prefill) / Success / Error`.
- Add `oauth_signup_notifier.dart` for Phase 2 (submit details).

### 8.5 Screens / UI
- `auth_landing_screen.dart`:
  - Replace the Apple button with a **Discord** button (brand colour `#5865F2`, Discord
    glyph). Keep Google. Both call the notifier directly (no more route-to-handler dance).
  - On `NeedsSignup` → show the **confirm dialog** ("No account found for `<email>`. Do you
    want to sign up?") → on confirm push `OAuthSignupDetailsScreen`.
  - On `Success` → go Home. On `Error` → snackbar (map `OAUTH_FAILED`, cancelled, network).
- New `oauth_signup_details_screen.dart`: prefilled name (editable), email (read-only,
  from prefill), optional phone, terms checkbox → submit → on success go Home.
- `oauth_handler_screen.dart`: now only used as a transient "Signing you in…" overlay, or
  delete it if the notifier drives a busy state on the landing screen.

### 8.6 Routes (`core/navigation/routes.dart` + `app_router.dart`)
- Add `oauthSignupDetails = '/auth/oauth/signup'`.
- Remove the `provider`/`code` query-param expectation from `oauthHandler` (or drop it).

### 8.7 Update `brain/code_map.md`
- Add `google_sign_in_service.dart`, `discord_oauth_service.dart`,
  `oauth_signup_notifier.dart`, `oauth_signup_details_screen.dart`.
- Update the auth feature registry entry.

---

## 9. Run-it-locally checklist (your "make it work locally fully")

**Backend**
1. Postgres + Redis running (see `gz_ideation` README / `.env`).
2. `.env` has `GOOGLE_CLIENT_ID` (Web client id), `DISCORD_CLIENT_ID/SECRET`,
   `DISCORD_REDIRECT_URI=gzapp://oauth/discord`.
3. `bun run db:generate && bun run db:migrate` (for the `discord_oauth` enum).
4. `bun run dev` → API on `:3000`. Confirm `/docs` shows the new routes.

**App**
5. `google-services.json` in `android/app/`; Gradle plugin applied; real `applicationId`.
6. Debug SHA-1 + SHA-256 added to Firebase; `google-services.json` re-downloaded.
7. `pubspec.yaml` deps added; `flutter pub get`.
8. Point `AppEnv.currentBaseUrl` at the machine the backend runs on:
   - Physical device on same Wi-Fi → `http://<mac-LAN-ip>:3000` (already `192.168.1.6:3000`).
   - Android emulator → `http://10.0.2.2:3000`.
   - iOS simulator → `http://localhost:3000`.
9. `flutter run`.

**Why this works without a public backend:** the device talks to Google/Discord directly
over the internet, and to your backend over LAN. The backend reaches Google/Discord over
the internet to verify. Nothing needs a public URL or ngrok for the native paths. (Discord's
redirect is a `gzapp://` deep link handled on-device, not an HTTP callback to your server.)

---

## 10. Full edge-case / failure matrix

### Frontend / device
| Case | Handling |
|---|---|
| User cancels Google picker / Discord consent | Notifier → `Initial`, no error toast (silent) |
| `DEVELOPER_ERROR (10)` on Google | Wrong SHA / package / serverClientId — dev-time; show generic error, log details |
| No `idToken` returned (only accessToken) | Means `serverClientId` not set — guard and surface a clear dev error |
| Discord `state` mismatch on return | Reject (possible CSRF) → error, do not call backend |
| Deep link not captured (scheme not registered) | `flutter_web_auth_2` times out → error + setup note |
| No network | `networkChecker.assertConnection()` already throws typed `AppException` |
| App killed mid-browser-flow | On resume, no `code` → treat as cancel |
| Backend returns `isNewUser` but user cancels signup dialog | Nothing persisted; `signupToken` simply expires |
| Double-tap the social button | Notifier guards while `Loading` |
| Token persist fails (secure storage) | Surface error, clear partial session |

### Backend
| Case | Handling |
|---|---|
| Google idToken `aud` ≠ our client id | Reject `OAUTH_FAILED` (critical check, currently missing) |
| Google idToken expired / bad signature | Reject `OAUTH_FAILED` |
| Discord code already used / expired | Token exchange 4xx → `OAUTH_FAILED` |
| Discord email `verified:false` | Don't auto-link; route to new signup with blank/editable email (§7) |
| Provider returns no email | Allow signup but `users.email = null`; rely on `sub` for identity |
| Email collision with existing account | Apply §7 rule (link only if provider-verified) |
| Same person, two providers, same email | Linking creates a 2nd `user_credentials` row for one `users` row |
| `signupToken` reused after account created | Phase-2 re-checks credential existence → idempotent / conflict |
| `signupToken` forged / wrong `purpose` | JWT verify fails → reject |
| `signupToken` expired (>10 min) | Reject; user must restart social login |
| Race: two Phase-2 calls | `(authMethod, identifier)` unique constraint → catch, return existing session |
| Unique violation on `users.email` | Map to a clean conflict error, not a 500 |
| Rate-limit abuse on `/verify` | Redis sliding-window limit per IP |
| `is_verified` semantics | Social signups are `isVerified:true` (provider vouches for email) |

---

## 11. Test plan
- **Backend unit:** `oauthVerify` (existing vs new), `verifyGoogleIdToken` audience check,
  Discord email-verified branch, `signupToken` expiry/forgery, email-collision rule, race.
- **Backend integration:** `/auth/oauth/google/verify`, `/auth/oauth/discord/verify`,
  `/auth/oauth/signup` happy + failure paths (`bun test`).
- **App manual (local):**
  1. Google new user → popup → details → Home.
  2. Google returning user → straight to Home.
  3. Discord new user → popup → details → Home.
  4. Discord returning user → Home.
  5. Cancel at each step; airplane mode; wrong SHA (expect DEVELOPER_ERROR).

---

## 12. Phased task checklist (implementation order)

**Phase A — Console & local infra (no code)**
- [ ] Decide & set final `applicationId`.
- [ ] Firebase: add Android+iOS apps, add debug SHA-1/256, download config files.
- [ ] Discord: create app, get client id/secret, add `gzapp://oauth/discord` redirect.
- [ ] Put config files in place; gitignore them; fill backend `.env`.

**Phase B — Backend**
- [ ] Schema: add `discord_oauth`; generate + migrate.
- [ ] Config: add Google/Discord env to `config` + `.env.example`.
- [ ] Service: `verifyGoogleIdToken` (with `aud` check), `verifyDiscordCode`,
      `oauthVerify`, `oauthCompleteSignup`, signupToken helpers.
- [ ] Model + routes: `/auth/oauth/:provider/verify`, `/auth/oauth/signup`; rate-limit.
- [ ] Tests.

**Phase C — Frontend**
- [ ] Deps + Android/iOS scheme & Gradle wiring.
- [ ] `GoogleSignInService`, `DiscordOAuthService`.
- [ ] Repository `oauthVerify` / `oauthCompleteSignup` + sealed result type.
- [ ] `SocialLoginNotifier`, `OAuthSignupNotifier`.
- [ ] Landing screen: Google + Discord buttons + confirm dialog.
- [ ] `OAuthSignupDetailsScreen` + route.
- [ ] Update `code_map.md` + auth registry.

**Phase D — Verify**
- [ ] Run the §11 manual matrix on a real device with debug SHA.

---

## 14. Implementation status (2026-06-26)

**Firebase / FlutterFire — DONE**
- `flutterfire configure --project=gz-ideation` ran; Android + iOS apps registered.
- Debug SHA-1 `16:42:6E:DA:B7:2C:19:C2:21:46:B1:D6:44:99:AD:C2:51:85:A4:BB` and SHA-256
  registered against the Android app via `firebase apps:android:sha:create`.
- `android/app/google-services.json` + `ios/Runner/GoogleService-Info.plist` written.
- `firebase_options.dart` was generated then deleted (we don't use the Firebase SDK; the
  flow is `google_sign_in` + backend verification).
- **Android app id `1:356415772589:android:d9b69e11b775155a36b324`.**

**Authoritative callback values (FINAL):**
- Discord MANDATES the native redirect **`discord-{applicationId}:/authorize/callback`** —
  note the **SINGLE slash** after the colon (`:/`, not `://`). For us:
  `discord-1519955725043109898:/authorize/callback`. Verified against the working
  getnautiai-app / multimodal Flutter apps. (Earlier attempts `gzappauth://oauth2/discord` and
  `discord-...://authorize/callback` both failed with "Redirect URI ... is not supported by client";
  the double-slash form is rejected.)
- flutter_web_auth_2 `CallbackActivity` scheme in `AndroidManifest.xml` = `discord-1519955725043109898`
  (scheme = the part before the colon).
- Discord call passes `intentFlags: 0x40000000` (FLAG_ACTIVITY_NO_HISTORY) so Chrome returns to
  the app after the callback instead of hanging on the callback URL.
- The backend's Discord token-exchange uses the **app-provided** `redirectUri` from the request
  body (not `config.DISCORD_REDIRECT_URI`), so app + manifest are the source of truth; the env var
  is documentation/fallback only.

**⚠️ Discord does NOT use `flutter_web_auth_2`.** Why:
- v5 (`^5.0.3`) uses the new Android `AuthTabIntent` path (`shouldUseAuthTabs()` returns true
  whenever `preferEphemeral` is false, and for Chrome ≥141 regardless). On Android 16 / Chrome
  149 (Pixel 9a) this handled the redirect inside the browser and broke Discord's custom-scheme
  redirect → "Redirect URI ... is not supported by client".
- v4.1.0 (what the working getnautiai-app uses) can't build here: it ships Kotlin 1.7.22, whose
  compiler throws `IllegalArgumentException: 26.0.1` under this machine's JDK 26.
- So Discord uses **`url_launcher` (LaunchMode.externalApplication) → full Chrome → custom-scheme
  redirect → `app_links` capture**, and the flow is **PKCE public-client** (matches the working
  getnautiai-app): the app sends `code_challenge`/`code_challenge_method=S256` in the authorize
  request, exchanges the `code` for an `access_token` ON-DEVICE (no client secret), and posts the
  **access token** to `POST /auth/oauth/discord/verify`. The backend redeems it at
  `https://discord.com/api/users/@me` (no token exchange backend-side). Discord auto-allows the
  `discord-<appId>:/authorize/callback` redirect for this public-client/PKCE shape — registering a
  redirect in the portal (esp. the `://` form) actually BREAKS it; portal redirects must be empty
  (or exactly `discord-<appId>:/authorize/callback`).
- `DISCORD_CLIENT_SECRET` is now unused by the backend (kept in env, harmless). `crypto` added
  app-side for the S256 challenge.
- `MainActivity` registers the `discord-1519955725043109898` scheme; the router redirect ignores
  `discord-*` / `/authorize/callback` so go_router doesn't fight app_links. Cancel is detected via
  an app-lifecycle resume watcher (+ 3-min timeout) since url_launcher has no CANCELED signal.

**Flutter code — DONE (compiles, `flutter analyze` clean):**
- deps: `google_sign_in: ^7.2.0`, `url_launcher: ^6.3.0`, `app_links: ^6.3.0` (NO flutter_web_auth_2).
- `lib/core/config/oauth_config.dart` — Google web client id (**placeholder, empty**),
  Discord client id `1519955725043109898`, scheme, redirect, scopes.
- `lib/core/errors/app_exception.dart` — `OAuthCancelledException`, `OAuthSetupException`.
- `data/services/google_sign_in_service.dart`, `data/services/discord_oauth_service.dart`.
- `auth_repository.dart` — `oauthVerify` + `oauthCompleteSignup` + `OAuthVerifyResult`
  (`OAuthExistingUser` / `OAuthNewUser`) + `OAuthPrefill`. Old `exchangeOAuthCode` removed.
- `application/social_login_notifier.dart` (replaces `oauth_login_notifier.dart`) +
  `application/oauth_signup_notifier.dart`.
- `auth_landing_screen.dart` rewritten: Google + Discord buttons + needs-signup dialog.
- `oauth_signup_details/oauth_signup_details_screen.dart` (phase 2 screen).
- `oauth_handler_screen.dart` deleted; routes/router updated (`oauthSignupDetails`).
- API consts: `authOAuthVerify(provider)`, `authOAuthSignup`.

**BLOCKED on two manual items (cannot be done via CLI):**
1. **Enable Google in Firebase Auth** (Console → Authentication → Sign-in method → Google →
   Enable → Save). This auto-creates the **Web client id**.
2. Paste that Web client id into `OAuthConfig.googleServerClientId`. Until then Google
   sign-in throws a clear `OAuthSetupException` (Discord is unaffected and testable now,
   once the backend Phase B endpoints exist).
3. Register `gzappauth://oauth2/discord` in Discord Developer Portal → OAuth2 → Redirects.

**Backend Phase B — DONE (smoke-tested against the running dev server):**
- `discord_oauth` added to `auth_method` enum (applied to the dev DB via `ALTER TYPE`, not a
  migration — this project uses `db:push` and has no committed migration baseline).
- `config` + `.env` + `.env.example`: `GOOGLE_CLIENT_ID` (= the web client id, used as the
  ID-token audience), `DISCORD_CLIENT_ID/SECRET/REDIRECT_URI`.
- `service.ts`: `oauthVerify` (existing-session / verified-email auto-link / new),
  `oauthCompleteSignup` (idempotent, 23505→CONFLICT), `verifyGoogleIdToken` (**aud + iss +
  exp checks**), `verifyDiscordCode` (token exchange + `/users/@me`, email-verified flag).
  Old `loginWithOAuth`/`verifyOAuthCode` removed.
- `index.ts`: `POST /auth/oauth/:provider/verify`, `POST /auth/oauth/signup` (signs/verifies
  a 10-min `purpose:oauth_signup` JWT). Old `/login/oauth/:provider` removed.
- `model.ts`: `ProviderParam` google|discord, `OAuthVerifyBody/Response`, `OAuthSignupBody`.
- Verified: bogus Google token → 401; `apple` provider → 422; Discord missing code → 401;
  bad signup token → 401; forged-valid signup token → 201 + user/credential created +
  idempotent re-submit (no dupe). tsc(project config) + biome clean.

**Remaining to go fully end-to-end:**
1. Enable Google in Firebase Auth — **DONE** (web client id wired both sides).
2. Register `gzappauth://oauth2/discord` in the Discord portal (still needed for Discord).
3. Run the app against the local backend and walk the §11 manual matrix on a device.

**iOS note:** `google_sign_in` on iOS additionally needs the reversed-client-id URL scheme in
`Info.plist`; deferred until iOS testing (Android debug-SHA is the current target).

---

## 13. Decisions (locked 2026-06-26)
1. **`applicationId` = `com.example.gz_app`** for now. Register the debug SHA against this
   id. NOTE: must change to a real reverse-domain id before any Play Store release, which
   will require re-registering the SHA + re-downloading `google-services.json`.
2. **Email collision = auto-link only when provider-verified** (Google always; Discord only
   if `verified === true`). Unverified provider email → fresh-signup path. (See §7 option A.)
3. **Apple = removed from the app UI**, but `apple_oauth` stays in the DB enum (no migration
   to drop it). The `discord_oauth` value is still added.
4. Signup-details screen fields: name (editable) + optional phone + terms — confirm final
   field list at start of Phase C.
</content>
</invoke>
