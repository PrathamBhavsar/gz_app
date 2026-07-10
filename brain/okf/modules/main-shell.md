---
type: Module
title: Main Shell (Player)
description: The player bottom-navigation scaffold hosting the five primary tabs.
resource: file://lib/features/main_shell
tags: [shell, navigation, tabs]
timestamp: 2026-07-04
---

# Responsibilities
`main_page.dart` is the `ShellRoute` scaffold wrapping the five player tabs — **Home / Book / Sessions /
Wallet / Profile** — with the bottom nav. Detail and flow screens push on top (outside the shell). The
admin counterpart is `AdminShell` (see [admin](admin.md)). See [App Shell](../systems/app-shell-and-entry.md)
and [Navigation](../systems/navigation-routing.md).

# Back-button handling
Both shells wrap their `Scaffold` in `PopScope(canPop: false, onPopInvokedWithResult: ...)`:
* If the current tab isn't the first tab (Home for player, Dashboard for admin), system back
  switches to the first tab via `context.go(...)` — it does not exit or pop.
* If already on the first tab, back arms a 2-second "press back again to exit" snackbar, then
  calls `SystemNavigator.pop()` on the second press within that window.
This only fires when the shell page is the topmost route (nothing pushed on top of it); pushed
detail/flow screens pop normally beneath it. See [Navigation rule](../rules/navigation.md) for the
push-vs-go convention this depends on.
</content>
