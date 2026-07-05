---
type: Index
title: Modules
description: The feature areas under lib/features, each documenting every screen, its route, and its API calls.
tags: [modules, features, index, screens]
timestamp: 2026-07-04
---

# Modules (feature areas)

Each page lists every screen: route, purpose, the backend endpoint(s) it calls, and navigation edges.
Domain names match the backend brain 1:1. **72 screens total** (40 player + 32 admin).

## Player
| Module | `lib/features/` | Screens |
| --- | --- | --- |
| [auth](auth.md) | `auth` | 11 (splash → login/register/OTP/OAuth/reset/verify) |
| [home](home.md) | `home` | 3 (home, search, store detail) + active-store state |
| [booking](booking.md) | `booking` | 5 (slot → availability → systems → summary → success) |
| [sessions](sessions.md) | `sessions` | 9 (list, active, booking detail, check-in, pay, history, billing, logs) |
| [wallet](wallet.md) | `wallet` | 4 (wallet, credit history, campaigns, campaign detail) |
| [notifications](notifications.md) | `notifications` | 1 (inbox) |
| [profile](profile.md) | `profile` | 5 (profile, edit, change phone, notif prefs, disputes list) |
| [disputes](disputes.md) | `disputes` | 2 (create, detail) |
| [main-shell](main-shell.md) | `main_shell` | Player bottom-nav shell |

## Admin
| Module | `lib/features/` | Screens |
| --- | --- | --- |
| [admin](admin.md) | `admin` | 32 (auth + Operations / Analytics / Management / Store tabs + CRUD) |

Cross-cutting layers: [systems/](../systems/index.md). Journeys: [flows/](../flows/index.md).
Full inventory: [references/ux-flow](../references/ux-flow.md).
</content>
