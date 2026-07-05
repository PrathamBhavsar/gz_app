# Phase 2 — Home & Stores — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- Store docs still describe mixed payload shapes for public/store-scoped endpoints:
  - `GET /stores` may appear as envelope `data: []` or keyed list `stores: []`
  - `GET /stores/:storeId/campaigns/active` may appear as `data: { campaigns: [] }`
  - `GET /stores/:storeId/systems/available` may appear as `data: { systems: [] }`
- `StoreRepository` was implemented with defensive payload extraction to handle both shapes without changing every screen.

## Missing / renamed endpoints or constants
- Added missing constants in `lib/core/api/api_constants.dart`:
  - `ApiConstants.storesList`
  - `ApiConstants.storeBySlug`

## Model ↔ JSON field mismatches (nullable, casing, types)
- `StoreModel` only exposes core fields (`id`, `name`, `slug`, `address`, `city`, `country`, `timezone`, `currency`, `isActive`, `settings`).
- Local docs for `GET /stores/:slug` mention richer fields like `hours`, `contact`, and `systemTypes[]`; Phase 2 UI therefore renders the detail screen from the available core fields plus separate campaign/system calls.

## Registry ↔ code drift fixed
- `brain/features/.registry/home.md` updated from target-only to implemented.
- `brain/features/.registry/overlays.md` updated to reflect that `StoreSelectorSheet` now uses `homeNotifierProvider` + `activeStoreNotifierProvider`, not a nonexistent `presentation/providers/store_selector_notifier.dart`.
- `brain/code_map.md` updated with the new `features/home/data` and `features/home/application` files.

## Dummy data removed (file:line)
- `lib/features/home/presentation/screens/home_screen.dart` now reads `homeNotifierProvider` and `activeStoreNotifierProvider` instead of inline dummy lists (current live render starts at line 48).
- `lib/features/home/presentation/screens/store_search/store_search_screen.dart` now reads `storeSearchNotifierProvider` instead of inline dummy search fixtures (current live render starts at line 52).
- `lib/features/home/presentation/screens/store_detail/store_detail_screen.dart` now reads `storeDetailNotifierProvider(widget.slug)` and `activeStoreNotifierProvider` instead of hardcoded store detail content (current live render starts at line 47).
- `lib/shared/widgets/store_selector_sheet.dart` now reads `homeNotifierProvider` + `activeStoreNotifierProvider` instead of local `_stores` sheet data (current live render starts at line 63).

## Open TODOs / deferred
- If backend confirms stable response envelopes for store endpoints, simplify `StoreRepository` payload extraction helpers.
- If richer public store-detail fields are added to `StoreModel`, revisit the detail screen to show hours/contact/system-type metadata directly from the detail response instead of the current minimal profile presentation.
