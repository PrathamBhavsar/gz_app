---
type: System
title: Auth & Token Storage
description: Player vs admin sessions, token persistence, and how auth state drives the router.
resource: file://lib/core/auth/token_storage.dart
tags: [auth, token, session]
timestamp: 2026-07-04
---

# Two parallel sessions
The app supports a **player** session and an **admin** session, each with its own notifier:
`authNotifierProvider` (`AuthSessionState`: Initial/Loading/Authenticated/…) and
`adminAuthNotifierProvider` (`AdminAuthSessionState`). The [router](navigation-routing.md) watches both
and redirects accordingly.

# Token storage
`lib/core/auth/token_storage.dart` persists access + refresh tokens. On boot, `SplashScreen` / the splash
notifier restores the session; `ApiClient` reads the access token for the bearer header. Login flows
([auth module](../modules/auth.md)) write tokens via the repositories (`auth_repository.dart`,
`admin_auth_repository.dart`); logout clears them and refreshes the router.

# Config
`lib/core/config/` holds `app_env.dart` and `oauth_config.dart` (Google web client id, Discord client
id/scheme/redirect) used by the [social login flow](../flows/social-login.md).
</content>
