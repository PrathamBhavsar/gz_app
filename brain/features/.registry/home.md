# Registry: Home Feature
> TARGET SPEC — not yet implemented

## Reality Check
Only the presentation screens exist today:
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/home/presentation/screens/store_search/store_search_screen.dart`
- `lib/features/home/presentation/screens/store_detail/store_detail_screen.dart`

No `data/` or `application/` folders exist under `lib/features/home/`.

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/home/data/repositories/store_repository.dart` | Fetch store lists, details, active campaigns, available systems | No |
| `lib/features/home/application/home_notifier.dart` | Home feed `AsyncValue<HomeData>` | No |
| `lib/features/home/application/store_search_notifier.dart` | Debounced search and filters | No |
| `lib/features/home/application/store_detail_notifier.dart` | Store detail + campaigns by slug | No |
| `lib/features/home/application/active_store_notifier.dart` | Persist and expose selected store | No |

## Planned Endpoints
- `GET /stores`
- `GET /stores?search=&platform=`
- `GET /stores/:slug`
- `GET /stores/:storeId/campaigns/active`
- `GET /stores/:storeId/systems/available`

## Notes
- This registry is a target blueprint for Phase 2 from `brain/API_INTEGRATION_PLAN.md`.
- Update this file to `Implemented` only when the referenced files exist in `lib/` and the screens no longer depend on dummy data.
