# Phase 7 — Profile — Inconsistencies & Notes
Pass 1 review: [ ]    Pass 2 review: [ ]
Dummy data fully removed: [ ]    flutter analyze clean: [ ]

## Endpoint / contract mismatches (backend vs Flutter)

## Missing / renamed endpoints or constants
- Notification preferences UI is already wired through `NotificationsRepository` + `notif_prefs_notifier.dart`; remaining Phase 7 profile data flows are still unimplemented.

## Model ↔ JSON field mismatches (nullable, casing, types)

## Registry ↔ code drift fixed
- `brain/features/.registry/profile.md` and `brain/code_map.md` updated to reflect the new `lib/features/profile/application/notif_prefs_notifier.dart`.

## Dummy data removed (file:line)

## Open TODOs / deferred
