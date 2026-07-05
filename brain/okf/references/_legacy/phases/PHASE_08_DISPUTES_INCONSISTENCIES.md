# Phase 8 — Disputes — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- `DisputeResponse` and `DisputeListResponse` were broadened to accept either top-level `dispute` / `disputes` payloads or standard `{ data: ... }` envelopes. Existing model code only handled the former.
- Second-pass fix: create-dispute now follows the documented body shape `{ sessionId, reason, disputedAmount? }` instead of the earlier inferred billing-based payload.

## Missing / renamed endpoints or constants
- None found in `ApiConstants`; Phase 8 player endpoints already existed.

## Model ↔ JSON field mismatches (nullable, casing, types)
- Create-dispute notes are treated as optional metadata (`metadata.notes`) because `BillingDisputeModel` has no top-level `notes` field today.
- Create-dispute now validates `disputedAmount` as positive and not greater than the selected billing row amount, matching the local API rules.

## Registry ↔ code drift fixed
- `brain/features/.registry/disputes.md` flipped from target-only to implemented, with repository/notifier files listed.
- `brain/features/.registry/profile.md` updated to note that the disputes list now uses the disputes notifier layer.
- `brain/code_map.md` updated for the new disputes data/application files.

## Dummy data removed (file:line)
- `lib/features/profile/presentation/screens/disputes_list_screen.dart`
- `lib/features/disputes/presentation/screens/create_dispute_screen.dart`
- `lib/features/disputes/presentation/screens/dispute_detail_screen.dart`

## Open TODOs / deferred
- Supporting detail is still stored in `metadata.notes` because the documented create body only specifies `sessionId`, `reason`, and optional `disputedAmount`.
