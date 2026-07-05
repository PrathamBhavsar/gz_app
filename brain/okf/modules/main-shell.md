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
</content>
