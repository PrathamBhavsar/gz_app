# Registry: Home Feature
> IMPLEMENTED — Phase 2 live store wiring is in place

## Reality Check
The home feature now has a real data layer, application state, and live presentation wiring:
- `lib/features/home/data/repositories/store_repository.dart`
- `lib/features/home/application/home_notifier.dart`
- `lib/features/home/application/store_search_notifier.dart`
- `lib/features/home/application/store_detail_notifier.dart`
- `lib/features/home/application/active_store_notifier.dart`
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/home/presentation/screens/store_search/store_search_screen.dart`
- `lib/features/home/presentation/screens/store_detail/store_detail_screen.dart`

The shared overlay `lib/shared/widgets/store_selector_sheet.dart` also now reads these Phase 2 providers.

## Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/home/data/repositories/store_repository.dart` | Fetch store lists, details, active campaigns, available systems | Yes |
| `lib/features/home/application/home_notifier.dart` | Home feed `AsyncValue<HomeData>` | Yes |
| `lib/features/home/application/store_search_notifier.dart` | Debounced search and filters | Yes |
| `lib/features/home/application/store_detail_notifier.dart` | Store detail + campaigns + systems by slug | Yes |
| `lib/features/home/application/active_store_notifier.dart` | Persist and expose selected store | Yes |
| `lib/shared/widgets/store_selector_sheet.dart` | Shared overlay backed by Phase 2 home providers | Yes |

## Endpoints In Use
- `GET /stores`
- `GET /stores?search=&platform=&isOpen=`
- `GET /stores/:slug`
- `GET /stores/:storeId/campaigns/active`
- `GET /stores/:storeId/systems/available`

## Notes
- `HomeScreen` now shows live store lists, real auth greeting fallback, and persistent selected-store state.
- `StoreSearchScreen` now debounces API-backed search and filter changes through `storeSearchNotifierProvider`.
- `StoreDetailScreen` now loads store detail, campaigns, and available systems, and the Book CTA persists `activeStoreId` before routing to `/book`.
- The implementation uses defensive repository parsing because local docs still show some store endpoints returning keyed payloads (`stores`, `campaigns`, `systems`) instead of the standard `data` envelope.
