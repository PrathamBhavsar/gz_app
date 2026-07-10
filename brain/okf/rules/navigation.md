---
type: Rule
title: Navigation
description: Route strings and guards live in the navigation layer, not in screens.
tags: [navigation, routing]
timestamp: 2026-07-04
---

* All path strings are `AppRoutes` constants + path builders in `lib/core/navigation/routes.dart`. Screens
  **never** hard-code inline path strings.
* Guards/redirects and screen wiring live in `app_router.dart`. Add new screens there and add the constant to `routes.dart`.
* Deep links go through `_mapIncomingUriToRoute` (`gzapp://` scheme). Auth redirects are centralized in `_authRedirect`.

## push vs go
* **`context.push(...)`** for any drill-down into a detail/sub-screen/form that the user expects to back out
  of (list row → detail, dashboard tile → form, etc.). This is the default — most navigation should push.
* **`context.go(...)`** only for: (1) switching bottom-nav tabs (player: home/book/sessions/wallet/profile;
  admin: dashboard/sessions/management/store), (2) terminal/replace flows after a completed action where
  returning to the previous screen makes no sense (post-login/signup redirect, post-payment success, logout).
* Screens reached via `push` should let the top bar's default back button behavior
  (`if (context.canPop()) context.pop()` in `GzTopBar`/`GzAdminTopBar`) handle back — don't override `onBack`
  with a hard-coded `go()` target. Getting this wrong is what causes system back to exit the app instead of
  popping: `go()` replaces the current route so there's nothing left to pop.

See [Navigation & Routing system](../systems/navigation-routing.md).
</content>
