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
| `lib/features/profile/application/profile_notifier.dart` | Load `/profile` data | Yes |
| `lib/features/profile/application/edit_profile_notifier.dart` | Edit profile action flow | Yes |
| `lib/features/profile/application/change_phone_notifier.dart` | Change-phone action flow | Yes |
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
- `POST /auth/phone/change/verify`
- `GET /notifications/preferences`
- `PATCH /notifications/preferences`

## Notes
- Notification preferences now reuse the notifications backend contract through `notif_prefs_notifier.dart` and `NotificationsRepository`.
- Phase 7 now reuses `AuthRepository` directly for `GET /auth/me`, `PATCH /auth/me`, `POST /auth/phone/change`, and `POST /auth/phone/change/verify` instead of adding a profile-specific repository layer.
- Stats and derived profile summaries should stay out of the UI until there is a real backend source for them.
- `disputes_list_screen.dart` is now backed by `myDisputesNotifierProvider` from the disputes feature instead of inline mock rows.
- `change_phone_screen.dart` continues to reuse the shared `otp_input_sheet.dart`; WP2 only closed the backend contract gap behind that existing UI.
- WP4 auth/profile pass verified that `PATCH /auth/me` accepts only `name`; `edit_profile_screen.dart` therefore keeps email visible but read-only and routes phone changes through the existing OTP flow.
- WP4 auth/profile pass now surfaces the meaningful `GET /auth/me` fields the backend returns: email, phone, `isVerified`, and `createdAt` are rendered in `profile_screen.dart` using existing shared primitives (`GzCard`, `GzMetaRow`, `GzTag`).
