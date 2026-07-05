---
type: Module
title: Profile
description: Player profile view/edit, phone change, notification preferences, and disputes entry.
resource: file://lib/features/profile
tags: [profile, settings, preferences]
timestamp: 2026-07-04
---

# Responsibilities
Manage the player's account. Notifiers: `profile_notifier`, `edit_profile_notifier`,
`change_phone_notifier`, `notif_prefs_notifier`. Backend: [auth](../references/backend-brain-link.md) (profile,
device, phone-change) + [notifications](../references/backend-brain-link.md) (preferences) + [disputes](disputes.md).

# Screens

| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 34 | ProfileScreen | `/profile` (tab) | `GET /auth/me` |
| 35 | EditProfileScreen | `/profile/edit` | `PATCH /auth/me` (name-only contract, per WP4) |
| 36 | ChangePhoneScreen | `/profile/change-phone` | `POST /auth/phone/change`, `POST /auth/phone/change/verify` |
| 37 | NotifPrefsScreen | `/profile/notifications` | `GET /notifications/preferences`, `PATCH /notifications/preferences` |
| 38 | DisputesListScreen | `/profile/disputes` | `GET /stores/:storeId/disputes/my` |

# Notes
`DisputesListScreen` lives in `profile/presentation/screens/` but the create/detail screens are the
[disputes](disputes.md) module. FCM device registration uses `PATCH /auth/me/device`.
</content>
