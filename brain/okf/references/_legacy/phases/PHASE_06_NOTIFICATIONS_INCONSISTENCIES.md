# Phase 6 — Notifications — Inconsistencies & Notes
Pass 1 review: [ ]    Pass 2 review: [ ]
Dummy data fully removed: [ ]    flutter analyze clean: [ ]

## Endpoint / contract mismatches (backend vs Flutter)
- Added `ApiConstants.playerNotificationDetail = '/notifications/{id}'`; this path was missing even though Phase 6 requires `GET /notifications/:id`.

## Missing / renamed endpoints or constants
- Removed the old generated `presentation/providers/notification_feed_notifier.dart` sample feed and replaced it with the phase-plan structure:
  `data/repositories/notifications_repository.dart`
  `application/notifications_notifier.dart`
  `application/notification_detail_notifier.dart`
  `application/notifications_ui_models.dart`

## Model ↔ JSON field mismatches (nullable, casing, types)
- `NotificationListResponse` already supports multiple envelope shapes; repository now uses it directly and falls back to raw `data` for detail payloads.

## Registry ↔ code drift fixed
- `brain/code_map.md` and `brain/features/.registry/overlays.md` updated to reflect the real notifications architecture.

## Dummy data removed (file:line)
- Removed inline sample notification feed from `lib/features/notifications/presentation/providers/notification_feed_notifier.dart`.

## Open TODOs / deferred
- Notification preferences are now wired into the profile notification preferences screen through `lib/features/profile/application/notif_prefs_notifier.dart`, even though the broader Profile phase remains incomplete.
