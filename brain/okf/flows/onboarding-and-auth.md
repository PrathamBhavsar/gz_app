---
type: Flow
title: Onboarding & Auth
description: How a player gets from launch to an authenticated home, and how admins enter.
tags: [flow, auth, onboarding]
timestamp: 2026-07-04
---

```
Splash (/) ─resolve session─▶ authed? ─yes─▶ /home  (admin ─▶ /admin/dashboard)
                                  └no──▶ /auth (landing) ─▶ OTP | Email | Social | Register
```

1. **Splash** restores tokens ([token storage](../systems/auth-and-token.md)); the [router guard](../systems/navigation-routing.md) redirects.
2. **AuthLanding** offers phone-OTP, email, or [social](social-login.md). New users → Register (email) or auto-register (OTP).
3. On success, tokens are stored, the auth notifier flips to `Authenticated`, the router's `refreshListenable` fires, and the guard lands the player on `/home` (or admin on `/admin/dashboard`).
4. Email verify / password reset arrive as **deep links** (`gzapp://verify-email?token=`, `reset-password?token=`).

See [auth module](../modules/auth.md) and the backend [onboarding-and-auth](../references/backend-brain-link.md).
</content>
