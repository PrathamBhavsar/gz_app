# Phase 11 — Admin Money — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- Credits management UI originally implied search by phone/email/name, but the documented Phase 11 API only defines:
  - `GET /stores/:storeId/credits/balance/:userId`
  - `GET /stores/:storeId/credits/transactions/:userId`
  - `POST /stores/:storeId/credits/adjust`
  The screen is wired to `userId` lookup to stay API-correct.
- Billing ledger display still lacks documented joined presentation fields for player and system names. The current UI falls back to `userId` and `systemId` when richer values are absent from the payload.

## Missing / renamed endpoints or constants
- No dedicated `ApiConstants` entry exists for pricing rule detail/update/delete. Phase 11 uses `pricingRules + '/:id'` path composition in `PricingRepository`.
- Payments refund transport exists in repository form, but there is no dedicated refund UI surface in the current management screens.

## Model ↔ JSON field mismatches (nullable, casing, types)
- `BillingLedgerModel` does not yet model enriched joined fields like `user_name` / `system_name`; if backend starts returning them consistently, extend `lib/models/domain_billing.dart`.
- Credits account lookup may return nested `user` objects or flattened identity fields; `AdminCreditsRepository` now tolerates both.

## Registry ↔ code drift fixed
- Added `brain/features/.registry/admin_management.md` because admin money had no registry entry despite Phase 11 now being implemented.
- Updated `brain/code_map.md` with Phase 11 repositories, notifiers, and management presentation files.

## Dummy data removed (file:line)
- `lib/features/admin/presentation/screens/management/pricing_rules_screen.dart`
- `lib/features/admin/presentation/screens/management/create_pricing_rule_screen.dart`
- `lib/features/admin/presentation/screens/management/edit_pricing_rule_screen.dart`
- `lib/features/admin/presentation/screens/management/billing_payments_screen.dart`
- `lib/features/admin/presentation/screens/management/billing_override_sheet.dart`
- `lib/features/admin/presentation/screens/management/credits_management_screen.dart`
- `lib/features/admin/presentation/screens/management/adjust_credits_sheet.dart`

## Open TODOs / deferred
- If backend exposes admin player-search for credits, replace the `userId` lookup prompt with the original search UX.
- If backend exposes joined billing display fields, switch billing cards from raw IDs to player/system names without further UI restructuring.
