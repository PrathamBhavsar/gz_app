# FEATURE REGISTRY: [FEATURE NAME]
> **Version**: 1.0 | **Updated**: YYYY-MM-DD
> **Status**: [ ] Planned | [ ] In Progress | [ ] Complete | [ ] Deprecated
> **Role**: Player | Admin | Both
>
> **AI INSTRUCTIONS**: Fill every section before writing code. `TODO` = resolve before proceeding. This is the single source of truth for this feature. Keep updated as work progresses.

---

## 1. OVERVIEW

**One-line description**:

**Screens this covers** (from `ux_flow.md`):
> e.g. Screen 14 — Systems Browser, Screen 15 — Availability Calendar

**Screens in `feature_spec.md`** (section numbers):
> e.g. Section 6, Screens 14–18

**Depends on**:
> Other registry files. e.g. `auth.md`, `home.md`. Write "None" if standalone.

**External APIs used**:
> e.g. None, or Firebase FCM

---

## 2. STATE SPECIFICATION

| State Name | Type | Provider Name | Provider Type | Notes |
|---|---|---|---|---|
| `storeList` | `AsyncValue<List<StoreModel>>` | `storeListProvider` | `NotifierProvider<N, AsyncValue<List<StoreModel>>>` | Fetched on load |
| `selectedId` | `String?` | `selectedIdProvider` | `StateProvider<String?>` | Null = none selected |

---

## 3. CORE FILES

### Models (in `lib/models/`)
| File | Model Class | Status |
|---|---|---|
| `domain_global.dart` | `StoreModel` | `TODO` |

### Services
| File | Description | Status |
|---|---|---|
| `features/<name>/data/services/<name>_service.dart` | Calls ApiClient, parses JSON | `TODO` |

### Repositories
| File | Description | Status |
|---|---|---|
| `features/<name>/data/repositories/<name>_repository.dart` | NetworkChecker + Service | `TODO` |

### Providers
| File | Description | Status |
|---|---|---|
| `features/<name>/presentation/providers/<name>_notifier.dart` | Notifier + sealed state | `TODO` |

### Screens + Layouts
| File | Description | Status |
|---|---|---|
| `features/<name>/presentation/screens/<name>_screen.dart` | Thin coordinator (no Consumer) | `TODO` |
| `features/<name>/presentation/widgets/<name>_mobile_layout.dart` | ConsumerWidget, reads providers | `TODO` |
| `features/<name>/presentation/widgets/<name>_tablet_layout.dart` | ConsumerWidget, reads providers | `TODO` |

---

## 4. ACTIVE PROVIDERS (Public API)

| Provider | Exported From | Consumed By |
|---|---|---|
| `storeListProvider` | `providers/store_notifier.dart` | `HomeMobileLayout`, `HomeTabletLayout` |

---

## 5. API ENDPOINTS

| Method | HTTP | `ApiConstants` Key | Endpoint Pattern | Request Body | Response |
|---|---|---|---|---|---|
| `fetchStores()` | GET | `ApiConstants.systemsList` | `/stores/{storeId}/systems` | None | `List<StoreModel>` |
| `createBooking(params)` | POST | `ApiConstants.bookingsList` | `/stores/{storeId}/bookings` | `CreateBookingParams.toJson()` | `BookingModel` |

---

## 6. NAVIGATION

**Route constant(s)**: `AppRoutes.book = '/book'`

**Entry from**: e.g. Tab bar tap, or `context.push(AppRoutes.book)` from Store Detail

**Exit to**: e.g. `context.go(AppRoutes.sessions)` after booking success

**Mobile flow**:
- Root: `/book` — list/browser
- Detail: `/book/systems` → push
- Completion: `context.go(AppRoutes.bookSuccess)`

**Tablet flow**:
- Master-detail side by side (tablet layout widget handles this)

**Overlays**: e.g. `StoreSelectorSheet` shown via `showModalBottomSheet`

---

## 7. ERROR HANDLING

| Error | Trigger | UI Response |
|---|---|---|
| `NetworkException` | No internet | `PageErrorDisplay(error: AppPageError.noInternet, onRetry: ...)` |
| `ApiException` | Server error | `PageErrorDisplay(error: AppPageError.from(e), onRetry: ...)` |
| `UnauthorizedException` | Token expired | Handled globally by `ApiClient.onLogout` → redirects to `/auth` |
| `ValidationException` | Bad request | `ref.listen` snackbar with `e.message` |

---

## 8. LAYOUT BEHAVIOUR

**Mobile**: Single-pane. Lists as `ListView.builder`. Tap → `context.push` detail route.

**Tablet**: `AppRoutes.*` same — tablet layout widget renders master-detail side by side. No selection → placeholder.

---

## 9. PENDING TASKS

| # | Task | Status | Blocker |
|---|---|---|---|
| 1 | Define models in `lib/models/` | `TODO` | — |
| 2 | Service implementation | `TODO` | API URL pattern confirmed? |
| 3 | Repository + provider | `TODO` | Depends on 1, 2 |
| 4 | Notifier + state sealed class | `TODO` | Depends on 3 |
| 5 | Screen + Mobile/Tablet layout widgets | `TODO` | Depends on 4 |
| 6 | Register route in `app_router.dart` + `AppRoutes` | `TODO` | — |
| 7 | Wire error states via `ref.listen` | `TODO` | Depends on 4 |

---

## 10. DECISIONS & CONSTRAINTS

| Decision | Rationale | Date |
|---|---|---|
| | | |
