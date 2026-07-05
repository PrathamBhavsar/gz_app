---
type: Flow
title: Social Login
description: The two-phase Google/Discord sign-in — native token capture, verify, then complete signup.
tags: [flow, oauth, social-login, google, discord]
timestamp: 2026-07-04
---

# Phase 1 — capture + verify
1. User taps Google/Discord on [AuthLanding](../modules/auth.md).
2. Native transport (`auth/data/services/`): **Google** via `google_sign_in` (7.x) → an **ID token**; **Discord** via `flutter_web_auth_2` → an **auth code** (callback `discord-<appId>://authorize/callback`, captured out-of-band; the [router](../systems/navigation-routing.md) redirects the stray callback back to `/auth`).
3. `social_login_notifier` calls `POST /auth/oauth/:provider/verify`.
   * **Existing identity** → tokens returned → land on `/home`.
   * **New identity** → a short-lived `signupToken` + prefill → route to **OAuthSignupDetailsScreen**.

# Phase 2 — complete signup
4. `oauth_signup_notifier` collects remaining details and calls `POST /auth/oauth/signup` with the `signupToken` → account created → tokens → `/home`.

Config (client ids, redirect scheme) lives in `lib/core/config/oauth_config.dart`. See the backend
[auth module](../references/backend-brain-link.md).
</content>
