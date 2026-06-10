# Profile Feature Registry
> TARGET SPEC — not yet implemented

## Reality Check
Existing files today:
- `lib/features/profile/presentation/screens/profile_screen.dart`
- `lib/features/profile/presentation/screens/edit_profile_screen.dart`
- `lib/features/profile/presentation/screens/change_phone_screen.dart`
- `lib/features/profile/presentation/screens/notif_prefs_screen.dart`
- `lib/features/profile/presentation/screens/disputes_list_screen.dart`

Missing today:
- `lib/features/profile/data/`
- Most profile-specific providers or repositories beyond notification preferences

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/profile/data/repositories/profile_repository.dart` | Optional profile-focused wrapper if auth repository reuse becomes noisy | No |
| `lib/features/profile/application/profile_notifier.dart` | Load `/profile` data | No |
| `lib/features/profile/application/edit_profile_notifier.dart` | Edit profile action flow | No |
| `lib/features/profile/application/change_phone_notifier.dart` | Change-phone action flow | No |
| `lib/features/profile/application/notif_prefs_notifier.dart` | Notification preferences read/write state | Yes |

## Planned Screens
| Screen | Route | File |
|---|---|---|
| S-31 Profile Home | `/profile` | `lib/features/profile/presentation/screens/profile_screen.dart` |
| S-32 Edit Profile | `/profile/edit` | `lib/features/profile/presentation/screens/edit_profile_screen.dart` |
| S-33 Change Phone | `/profile/change-phone` | `lib/features/profile/presentation/screens/change_phone_screen.dart` |
| S-34 Notification Prefs | `/profile/notifications` | `lib/features/profile/presentation/screens/notif_prefs_screen.dart` |
| S-35 Disputes List | `/profile/disputes` | `lib/features/profile/presentation/screens/disputes_list_screen.dart` |

## Planned Endpoints
- `GET /auth/me`
- `PATCH /auth/me`
- `POST /auth/phone/change`
- `GET /notifications/preferences`
- `PATCH /notifications/preferences`

## Notes
- Notification preferences now reuse the notifications backend contract through `notif_prefs_notifier.dart` and `NotificationsRepository`.
- Stats and derived profile summaries should stay out of the UI until there is a real backend source for them.
