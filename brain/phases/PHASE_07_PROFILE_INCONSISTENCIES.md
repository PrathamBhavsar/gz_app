# Phase 7 — Profile — Inconsistencies & Notes
Pass 1 review: [ ]    Pass 2 review: [ ]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)

## Missing / renamed endpoints or constants
- Notification preferences UI remains wired through `NotificationsRepository` + `notif_prefs_notifier.dart`.
- `ApiConstants.authPhoneChange` and `ApiConstants.authPhoneChangeVerify` are now both used by the Phase 7 phone-change flow.

## Model ↔ JSON field mismatches (nullable, casing, types)

## Registry ↔ code drift fixed
- `brain/features/.registry/profile.md` and `brain/code_map.md` updated to reflect the new `lib/features/profile/application/notif_prefs_notifier.dart`.
- `brain/features/.registry/profile.md` and `brain/code_map.md` now include `profile_notifier.dart`, `edit_profile_notifier.dart`, and `change_phone_notifier.dart`.

## Dummy data removed (file:line)
- `lib/features/profile/presentation/screens/profile_screen.dart:65` now loads user identity from `profileNotifierProvider` instead of hardcoded `Rahul Mehra / rahul@example.com`.
- `lib/features/profile/presentation/screens/edit_profile_screen.dart:59` now seeds fields from live profile data and submits through `editProfileNotifierProvider` instead of local-only save feedback.
- `lib/features/profile/presentation/screens/change_phone_screen.dart:50` now renders current phone from live profile data, validates E.164 input with a country picker, submits `POST /auth/phone/change`, and completes OTP verification through `showOtpInputSheet` + `changePhoneNotifierProvider`.

## Open TODOs / deferred
- None for Phase 7 profile flows. OTP verification for phone change is now implemented in the existing bottom-sheet flow.
