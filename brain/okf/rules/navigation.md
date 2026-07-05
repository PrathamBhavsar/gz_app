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

See [Navigation & Routing system](../systems/navigation-routing.md).
</content>
