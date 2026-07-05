---
type: System
title: Navigation & Routing
description: go_router config — auth guards, the two shells, deep links, and where every route is declared.
resource: file://lib/core/navigation/app_router.dart
tags: [navigation, go-router, routing, guards, deep-links]
timestamp: 2026-07-04
---

# Two files
* `lib/core/navigation/routes.dart` — the `AppRoutes` constants + path builders (**the only place path strings live**).
* `lib/core/navigation/app_router.dart` — the `routerProvider` (`GoRouter`), redirect/guard logic, and screen wiring.

# Auth guard (`_authRedirect`)
Runs on every navigation. Watches `authNotifierProvider` (player) + `adminAuthNotifierProvider` (admin)
via a `refreshListenable`. Rules:
* `splash` / `onboarding` — never redirected (bootstrap).
* While auth state is `Initial`/`Loading` — no redirect (wait).
* `/admin/*` route but not admin-authed → **`/auth/admin-login`**.
* Protected player route but not player-authed → **`/auth`** (auth landing).
* Player-authed on a public/auth route → **`/home`**; admin-authed → **`/admin/dashboard`**.

Public player routes: authLanding, register, otp, emailLogin, oauthSignupDetails, forgotPassword,
resetPassword, emailVerificationPending, emailVerified. Public admin routes: adminLogin, adminPasswordReset.

# Two shells (bottom-nav scaffolds)
* **Player shell** — `ShellRoute` → `MainPage`, hosting 5 tabs: `/home`, `/book`, `/sessions`, `/wallet`, `/profile`. All other player screens (detail/flow pages) are top-level routes outside the shell.
* **Admin shell** — `ShellRoute` → `AdminShell`, grouping routes into 4 tabs: **Operations** (dashboard, sessions, walk-in, bookings), **Analytics** (analytics + revenue/utilization/session-stats/players/systems), **Management** (management, pricing, billing, campaigns, credits, disputes), **Store** (systems, staff, config, notifications). CRUD sub-routes live inside the admin shell too.

# Deep links (`_mapIncomingUriToRoute`)
Custom scheme **`gzapp://`**: `gzapp://bookings/:id` → booking detail; `gzapp://stores/:slug` → store detail;
`gzapp://notifications` → home + pending notifications overlay; `reset-password` / `verify-email` / `admin/reset-password`
→ the matching screen with a `?token=`. The **Discord OAuth callback** (`discord-<appId>://authorize/callback`)
is captured out-of-band and redirected back to `/auth`. Initial location resolves from the launch URI.

# The full route map
Every route + its screen + API calls + navigation edges is enumerated per feature in [modules/](../modules/index.md),
and the whole 72-screen inventory is in [references/ux-flow](../references/ux-flow.md).

# Rule
Feature screens must not invent inline path strings — add a constant/builder to `routes.dart`. See
[Navigation rule](../rules/navigation.md).
</content>
