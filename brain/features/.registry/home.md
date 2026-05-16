# Registry: Home Feature

## Screens

### S-11 Home Feed `/home`
- Screen: `lib/features/home/presentation/screens/home_screen.dart`
- Layouts: `home_mobile_layout.dart`, `home_tablet_layout.dart`
- Provider: `homeNotifierProvider` → `HomeNotifier` → `AsyncValue<HomeData>`
- `HomeData.stores: List<StoreModel>` (active session + upcoming booking deferred to Phase 5)
- Mobile layout: Header (EmGzLogo, greeting, bell), search tap-target, EmScrollContent with nearby stores horizontal scroll + new-in-city list rows
- Sub-widgets: `_StoreCardLg` (horizontal scroll card, 190w × 188h), `_NewStoreRow` (EmCard row with EmAvatar)

### S-12 Store Search `/home/search`
- Screen: `lib/features/home/presentation/screens/store_search/store_search_screen.dart`
- Layout: `store_search_mobile_layout.dart`
- Provider: `storeSearchProvider` → `StoreSearchNotifier` → `StoreSearchState`
- State: `{ isLoading, results, error, selectedFilter }`
- Filters: All / PC / PS5 / VR / Xbox / Open Now (horizontal chip row)
- Debounce: 300ms on query; filter changes trigger immediate re-search
- Empty: EmCard(inset) centered text

### S-13 Store Detail `/home/store/:slug`
- Screen: `lib/features/home/presentation/screens/store_detail/store_detail_screen.dart` (thin StatelessWidget, passes slug)
- Layouts: `store_detail_mobile_layout.dart`, `store_detail_tablet_layout.dart`
- Provider: `storeDetailNotifierProvider(slug)` → `StoreDetailNotifier` (FamilyNotifier) → `AsyncValue<StoreDetailData>`
- `StoreDetailData` = `{ store: StoreModel, campaigns: List<CampaignModel> }`
- Mobile: Hero carousel (3 hue placeholders), store name/address/status tag, info tiles (hours/call/directions), system type chips, campaigns horizontal scroll (if any), sticky Book CTA
- Carousel state: `_slideProvider.family<int, String>` (autoDispose)
- Book CTA: sets `activeStoreIdProvider` + calls `tokenStorageProvider.saveActiveStoreId` + `context.go(AppRoutes.book)`

## Data Layer

### `StoreService` (`lib/features/home/data/services/store_service.dart`)
- `getStores({search, platform, isOpen, page, limit})` → `PaginatedStoresResponse`
- `getStore(slug)` → `StoreResponse`
- `getActiveCampaigns(storeId)` → `PaginatedCampaignsResponse`
- `getAvailableSystems(storeId, {systemTypeId, startTime, endTime})` → `SystemsListResponse`

### `StoreRepository` (`lib/features/home/data/repositories/store_repository.dart`)
- All methods call `networkChecker.assertConnection()` before delegating to service

## Providers

| Provider | Type | State |
|---|---|---|
| `homeNotifierProvider` | `NotifierProvider<HomeNotifier, AsyncValue<HomeData>>` | stores list |
| `storeDetailNotifierProvider(slug)` | `NotifierProviderFamily<StoreDetailNotifier, AsyncValue<StoreDetailData>, String>` | store + campaigns |
| `storeSearchProvider` | `NotifierProvider<StoreSearchNotifier, StoreSearchState>` | search results + filter |
| `activeStoreProvider` | `NotifierProvider<ActiveStoreNotifier, AsyncValue<StoreModel?>>` | active store (in-memory) |

## Notes
- `homeNotifierProvider` returns `HomeData` (not raw list) — future phases add `activeSession` and `upcomingBooking` fields
- `StoreDetailNotifier` catches campaign fetch errors silently (campaigns optional)
- `storeSearchProvider` tracks `_currentQuery` in notifier to re-run on filter change
- Active session banner (Phase 5) and upcoming booking card (Phase 5) — null-guarded in layout, not rendered until data added
