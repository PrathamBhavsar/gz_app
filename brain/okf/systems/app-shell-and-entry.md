---
type: System
title: App Shell & Entry
description: How the app boots and the two tabbed shells that host authenticated screens.
resource: file://lib/features/main_shell
tags: [shell, bootstrap, tabs]
timestamp: 2026-07-04
---

# Entry
`main.dart` wraps the app in a Riverpod `ProviderScope` and builds `MaterialApp.router` from
`routerProvider` ([Navigation](navigation-routing.md)). The initial route is `SplashScreen` (`/`), which
resolves auth state (via the splash notifier / token storage) and the guard then routes to `/home`,
`/admin/dashboard`, or `/auth`.

# Player shell — `MainPage`
`lib/features/main_shell/presentation/screens/main_page.dart`. A `ShellRoute` scaffold with a bottom nav
of 5 tabs: **Home / Book / Sessions / Wallet / Profile**. Detail and multi-step flow screens push on top
(outside the shell).

# Admin shell — `AdminShell`
`lib/features/admin/presentation/widgets/admin_shell.dart`. A `ShellRoute` scaffold grouping admin routes
into 4 areas: **Operations / Analytics / Management / Store**. See the tab breakdown in [Navigation](navigation-routing.md).

The store the player/admin operates on is the [active store](../modules/home.md); admin scope comes from the admin JWT.
</content>
