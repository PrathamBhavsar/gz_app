# Phase 12 — Admin Campaigns & Disputes — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- No DELETE endpoint exists for campaigns in the documented API (`GET/POST/PATCH .../campaigns`).
  The "Delete Campaign" button from the original design was removed; pause/resume are the lifecycle controls.
- `campaign_type` is sent to the API as snake_case (`percentage_off`, `bonus_credits`, etc.).
  The backend `CampaignType` enum uses snake_case; Dart enum `.name` gives camelCase, so explicit
  mapping constants are used in the form screens instead of `.name` serialization.
- `DisputeResolution` enum values are similarly mapped explicitly (`full_refund`, `partial_refund`,
  `credit_issued`, `upheld`) rather than relying on `.name` to avoid camelCase/snake_case mismatch.
- `resolution_amount` is always included in the resolve body (nullable allowed by backend).

## Missing / renamed endpoints or constants
- No explicit `campaignCreate` / `campaignUpdate` constants were needed — `campaignsAdminList`
  (POST) and `campaignDetail` (PATCH) paths were reused, consistent with how billing uses `billingLedger`.

## Model ↔ JSON field mismatches (nullable, casing, types)
- `BillingDisputeModel` has no timeline/history array. Timeline is synthesized in the UI from
  `createdAt`, `updatedAt`, `status`, and `resolvedAt` fields.
- `CampaignModel.applicableSystemTypes` is `List<String>` (system type names, not IDs). The form
  sends names; the backend's expected shape (names vs IDs) may need a field-level check against live data.

## Registry ↔ code drift fixed
- No existing registry entry for Phase 12 campaigns/disputes.

## Dummy data removed (file:line)
- `campaign_management_screen.dart` — `_CampaignData` class + `_campaigns` list
- `dispute_resolution_screen.dart` — `_DisputeData` class + `_disputes` list + `_filters` hardcode
- `admin_dispute_detail_screen.dart` — `_timeline` list + `_resolutionOptions` list
- `create_campaign_screen.dart` — `_systemTypes` hardcode + fake `_saved` flag
- `edit_campaign_screen.dart` — `_systemTypes` hardcode + fake `_saved` flag + hardcoded date strings

## Open TODOs / deferred
- `applicableSystemTypes` field shape (name strings vs ID strings) should be verified against a
  live campaign create response once backend is reachable.
- Campaign redemptions list screen is not wired (no dedicated screen exists; `campaignRedemptions`
  endpoint + `AdminCampaignsRepository.fetchRedemptions` are built and ready).
- If backend adds campaign DELETE, add `deleteCampaign(id)` to `AdminCampaignsRepository` and a
  command method without further restructuring.
