# Profile Feature Registry
> Phase 7 — built 2026-05-16

## Screens

| Screen | Route | File |
|--------|-------|------|
| S-31 Profile Home | `/profile` | `lib/features/profile/presentation/screens/profile_screen.dart` |
| S-32 Edit Profile | `/profile/edit` | `lib/features/profile/presentation/screens/edit_profile_screen.dart` |
| S-33 Change Phone | `/profile/change-phone` | `lib/features/profile/presentation/screens/change_phone_screen.dart` |
| S-34 Notification Prefs | `/profile/notifications` | `lib/features/profile/presentation/screens/notif_prefs_screen.dart` |
| S-35 Disputes List | `/profile/disputes` | `lib/features/profile/presentation/screens/disputes_list_screen.dart` |

## Layouts

| Layout | File |
|--------|------|
| `ProfileMobileLayout` | `lib/features/profile/presentation/widgets/profile_mobile_layout.dart` |
| `EditProfileMobileLayout` | `lib/features/profile/presentation/widgets/edit_profile_mobile_layout.dart` |
| `ChangePhoneMobileLayout` | `lib/features/profile/presentation/widgets/change_phone_mobile_layout.dart` |
| `NotifPrefsMobileLayout` | `lib/features/profile/presentation/widgets/notif_prefs_mobile_layout.dart` |
| `DisputesListMobileLayout` | `lib/features/profile/presentation/widgets/disputes_list_mobile_layout.dart` |

## Providers

| Provider | Type | File |
|----------|------|------|
| `profileNotifierProvider` | `NotifierProvider<ProfileNotifier, AsyncValue<UserModel>>` | `lib/features/profile/presentation/providers/profile_notifier.dart` |
| `editProfileProvider` | `NotifierProvider<EditProfileNotifier, EditProfileState>` | `lib/features/profile/presentation/providers/edit_profile_notifier.dart` |
| `changePhoneProvider` | `NotifierProvider<ChangePhoneNotifier, ChangePhoneState>` | `lib/features/profile/presentation/providers/change_phone_notifier.dart` |
| `notifPrefsProvider` | `NotifierProvider<NotifPrefsNotifier, AsyncValue<NotifPrefsData>>` | `lib/features/profile/presentation/providers/notif_prefs_notifier.dart` |

## Notes

- Disputes list screen lives under `/profile/disputes` (not a separate top-level route)
- `ProfileNotifier` delegates to `AuthRepository.getUserProfile()` — no separate `ProfileRepository`
- `NotifPrefsNotifier` debounces PATCH calls by 1s (Timer-based)
- Phone change flow sends OTP via `AuthRepository.requestPhoneChange()` — the OTP entry UI is a stub pending real OTP widget integration
- Stats row (sessions / hours / stores) shows placeholder `—` pending a dedicated stats API
