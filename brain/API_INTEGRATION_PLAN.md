# Backend API Integration — Master Implementation Plan (Feature-First, Phase-Wise)

> **Canonical execution contract** for wiring every screen in `gz_app` to the live `gz_ideation`
> backend, feature by feature, with a real repository + Riverpod notifier layer and full
> loading / error / empty / data handling. **When a feature's phase is complete, that feature contains
> zero dummy data — every value comes from the API.** No test files are produced by this plan.

---

## 0. Context — Why this exists

`gz_app` is a **dual-client** Flutter app (Player app + Admin dashboard) for the Gaming-Zone SaaS
backend `gz_ideation` (Bun + ElysiaJS + PostgreSQL + Drizzle, 16 modules, REST + 3 WebSocket channels).

**Today the app is design-phase / presentation-only.** Every screen renders **inline dummy data**
(e.g. `lib/features/wallet/presentation/screens/wallet_screen.dart` declares hardcoded
`static const _transactions` / `_campaigns` lists). There are **no API calls** from any feature.

**This plan wires every screen to the live backend**, feature by feature, with a proper repository +
Riverpod notifier layer and full loading / error / empty / data handling.

### What already exists (DO NOT rebuild — reuse)

| Concern | File(s) | Status |
|---|---|---|
| HTTP transport | `lib/core/api/api_client.dart` (`ApiClient`, `apiClientProvider`) | ✅ built — `http`, 401→refresh→retry, envelope unwrap, logging, admin convenience methods |
| Endpoint constants | `lib/core/api/api_constants.dart` (`ApiConstants`) | ✅ most endpoints present; extend per phase |
| Typed errors | `lib/core/errors/app_exception.dart` | ✅ `NetworkException`/`ApiException`/`UnauthorizedException`/`ValidationException` + `AppPageError`/`AppPageErrorKind` |
| Error UI | `lib/shared/widgets/page_error_display.dart` | ✅ built |
| Tokens / session | `lib/core/auth/token_storage.dart` | ✅ `TokenStorage`, `accessTokenProvider`, `activeStoreIdProvider`, `tokenStorageProvider` |
| Connectivity | `lib/core/network/{connectivity_service,network_checker}.dart` | ✅ `networkCheckerProvider.assertConnection()`, real ping |
| WebSockets | `lib/core/network/{player_ws_service,admin_live_service}.dart` | ✅ built, need wiring |
| Models | `lib/models/*.dart` (~3,200 lines) | ✅ manual `fromJson`, match backend envelopes; extend only where missing |
| Routing | `lib/core/navigation/{routes,app_router}.dart` (`AppRoutes`) | ✅ all routes + path builders |
| Theme / responsive / shared widgets | `lib/core/theme/*`, `lib/core/responsive/*`, `lib/shared/widgets/*` | ✅ built |

### What is missing (the entire scope of this work)

- **Per-feature `data/repositories/*.dart`** — none exist (0 repository classes in the whole repo).
- **Per-feature `application/*_notifier.dart`** — none exist (0 notifiers / 0 `NotifierProvider`).
- **Wiring** screens to notifiers and **removing dummy data** — not started.
- A small amount of shared scaffolding (loading/skeleton view, snackbar helper) + brain truth-up.

### The brain is stale on two axes (reconciled in Phase 0)

1. **Tech-stack rules are fictional.** `brain/.ai_index.md` + `brain/rules/*.md` mandate
   `dio` + `freezed` + `json_serializable` + `@riverpod` codegen + `flutter_screenutil`.
   The repo uses **none** of these: `http`, manual models, plain Riverpod `Notifier`, custom responsive.
   `pubspec.yaml` `dev_dependencies` is empty — there is **no build_runner / codegen**.
2. **Registries claim completed work that does not exist.** `brain/features/.registry/{home,booking,
   wallet,sessions}.md` describe full data layers (`data/services/*`, `data/repositories/*`,
   `presentation/providers/*_notifier.dart`, "wired" widgets) marked "Phase 4/5/6 completed."
   **None of those files exist.** They are excellent **target blueprints**, not records of reality —
   reused as targets, but re-flagged "TARGET — not yet implemented."

### Decisions locked (with the user)

- **Stack:** keep `http` + manual `lib/models/` + plain Riverpod `Notifier` (**no codegen**).
  **Rewrite the stale brain rules to match reality.**
- **Models:** stay **central** in `lib/models/`; each feature adds `data/` + `application/`.
- **Order:** **Foundation → Player → Admin.**
- **Review:** 2 passes per feature; each phase ships an inconsistency file + DoD checklist.

---

## 1. Backend contract (what the app talks to)

- **Base URL:** `ApiConstants.devBaseUrl = http://192.168.1.2:3000` (prod `https://gz.api.splin.app`).
  Swagger/OpenAPI at `:3000/docs`. Health at `/health`.
- **Response envelopes** (already handled by models in `lib/models/core.dart`):
  - Success: `{ "success": true, "message": string, "data": T }`
  - Paginated: `{ "success": true, "data": T[], "meta": { total, page, limit, totalPages } }`
  - Error: `{ "success": false, "error": { code, message, details } }`
- **Auth:** User JWT `Authorization: Bearer` (15 min) + refresh (7 d, body). Admin JWT same shape with
  `{ storeId, role }`. Agent uses `X-Agent-Key` (not used by this app).
- **Multi-tenancy:** store-scoped paths embed `{storeId}` / `{id}` — interpolate at call time.
- **Enums:** backend uses `snake_case` strings; Flutter enums + `String.toXxx()` parsers live in
  `lib/models/enums.dart` (e.g. `in_progress` → `SessionStatus.inProgress`).

Full endpoint catalog: `gz_ideation/docs/api-overview.md` §5. Business rules: §9. Auth detail: §10.

---

## 2. Target Architecture & Conventions (the reconciled rules)

These supersede the conflicting brain rules and are written into `brain/` in Phase 0.

### 2.1 Per-feature folder layout
```
lib/features/<feature>/
  data/
    repositories/<x>_repository.dart    # ONLY data-layer class per concern (no separate "service")
  application/
    <x>_notifier.dart                   # Notifier/AsyncNotifier + its State (or AsyncValue<T>)
  presentation/
    screens/  | widgets/ | layouts/     # EXISTING — wired to notifiers, dummy data deleted
```
Models stay in `lib/models/` (imported by repositories). The registries' extra `data/services/*` split
is intentionally **dropped** — one repository layer keeps the convention consistent with
`rules/data_layer.md` (`Widget → Notifier → Repository → ApiClient → API`).

### 2.2 Repository pattern (canonical skeleton)
```dart
// lib/features/<f>/data/repositories/<x>_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/api_responses.dart';

class StoreRepository {
  StoreRepository(this._api, this._net, this._ref);
  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  // resolve store-scoped path: replaces {storeId} (and optional {id}) safely
  String _store(String template, {String? id}) {
    final storeId = _ref.read(activeStoreIdProvider);
    if (storeId == null) throw const ValidationException('No active store selected');
    var p = template.replaceAll('{storeId}', storeId);
    if (id != null) p = p.replaceAll('{id}', id);
    return p;
  }

  String _withQuery(String path, Map<String, String> qs) =>
      qs.isEmpty ? path : '$path?${Uri(queryParameters: qs).query}';

  Future<List<StoreModel>> fetchStores({String? search, String? platform}) async {
    await _net.assertConnection();                       // typed NetworkException if offline
    final qs = <String, String>{
      if (search != null) 'search': search,
      if (platform != null) 'platform': platform,
    };
    final raw = await _api.get(_withQuery(ApiConstants.storesList, qs)); // ApiClient maps 4xx/5xx → AppException
    return PaginatedStoresResponse.fromJson(raw as Map<String, dynamic>).data ?? const [];
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) => StoreRepository(
      ref.watch(apiClientProvider), ref.watch(networkCheckerProvider), ref));
```
Rules:
- Every method calls `assertConnection()` first, then `ApiClient`, then a `lib/models` `fromJson`.
- Never swallow errors. `ApiClient` already throws typed `AppException`; let them propagate.
- Repositories are **stateless** and constructed via a `Provider`.

### 2.3 Notifier patterns (plain Riverpod 2.x — no codegen)

**Read screens → `AsyncNotifier` exposing `AsyncValue<T>`:**
```dart
class HomeNotifier extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() async => _load();
  Future<HomeData> _load() async {
    final repo = ref.read(storeRepositoryProvider);
    final stores = await repo.fetchStores();
    return HomeData(stores: stores);
  }
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);   // captures any error into AsyncError
  }
}
final homeNotifierProvider = AsyncNotifierProvider<HomeNotifier, HomeData>(HomeNotifier.new);
```

**Action flows (login, pay, redeem, create…) → `Notifier` exposing a sealed state:**
```dart
sealed class LoginState { const LoginState(); }
class LoginInitial extends LoginState { const LoginInitial(); }
class LoginLoading extends LoginState { const LoginLoading(); }
class LoginSuccess extends LoginState { const LoginSuccess(this.user); final UserModel user; }
class LoginError   extends LoginState { const LoginError(this.message); final String message; }

class LoginNotifier extends Notifier<LoginState> {
  @override LoginState build() => const LoginInitial();
  Future<void> submit(String email, String password) async {
    state = const LoginLoading();
    try {
      final res = await ref.read(authRepositoryProvider).loginEmail(email, password);
      state = LoginSuccess(res.user!);
    } catch (e) {
      state = LoginError(AppPageError.from(e).message); // map any AppException → message
    }
  }
}
final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
```
- `.family` variants for id-scoped notifiers (`bookingDetailNotifierProvider(id)`).
- Polling notifiers (active session 30s, live systems 30s) start a `Timer` in `build()` and cancel it
  via `ref.onDispose`.

### 2.4 The four mandatory UI states (every data-bound screen)
```dart
ref.watch(homeNotifierProvider).when(
  loading: () => const GzLoadingView(),                       // shared spinner/skeleton
  error:   (e, _) => PageErrorDisplay(                        // existing widget
              error: AppPageError.from(e),
              onRetry: () => ref.read(homeNotifierProvider.notifier).refresh()),
  data:    (d) => d.stores.isEmpty
              ? const PageErrorDisplay(error: AppPageError.empty)  // AppPageErrorKind.empty exists
              : HomeMobileLayout(data: d),
);
```
- **Action errors** (sealed states) surface via `ref.listen(provider, ...)` → snackbar, never in `build`.
- Empty is a first-class state — list endpoints that return `[]` show `AppPageError.empty`.

### 2.5 Error contract (3 layers)
`Repository` throws typed `AppException` → `Notifier` catches (sealed `*Error` / `AsyncValue.guard`) →
`Widget` renders `PageErrorDisplay` (read) or snackbar (action). **No `print`, no swallowed errors.**
> Note: today the 4 exception classes only `implements Exception` (no shared base). Phase 0 adds an
> optional sealed `AppException` base so `on AppException catch` works cleanly; `AppPageError.from`
> already normalizes any error for the UI regardless.

### 2.6 Store scoping
Player active store is set on the Store-Detail "Book" CTA (Phase 2):
`activeStoreIdProvider = store.id` + `TokenStorage.saveActiveStoreId(store.id)`. Admin store comes from
the admin JWT / `TokenStorage.getAdminStoreId()`. Repositories resolve it via the `_store()` helper and
throw a typed error if unset (router guards send the user to store selection).

### 2.7 State-sync mandate (brain)
On any `.dart` create/move/delete: **immediately** update `brain/code_map.md` + the relevant
`brain/features/.registry/<feature>.md` in the same change. **No build_runner** (no codegen).

---

## 3. Phase 0 — Foundation & Brain Reconciliation

No feature wiring; makes every later phase mechanical + reviewable.

### 3.1 Brain truth pass (proposed new content)
- **`brain/.ai_index.md` → TECH STACK table** becomes:
  | Concern | Package | Notes |
  |---|---|---|
  | State | `flutter_riverpod` | Plain `Notifier`/`AsyncNotifier` + `NotifierProvider`. **No codegen.** |
  | HTTP | `http` (via `ApiClient`) | Repository layer only. Never called from UI. |
  | Models | manual classes in `lib/models/` | `fromJson` by hand. No freezed/json_serializable. |
  | Routing | `go_router` | Constants in `AppRoutes`. |
  | UI/Sizing | custom responsive (`lib/core/responsive/`) | No screenutil. |
  Remove the "run build_runner" line from the context-load sequence.
- **`brain/rules/data_layer.md`** → repository-only flow `Widget→Notifier→Repository→ApiClient→API`;
  manual models; typed `AppException` mapping (done by `ApiClient`).
- **`brain/rules/state_management.md`** → plain Riverpod `Notifier`/`AsyncNotifier`; `.when()` for
  `AsyncValue`; sealed states for actions; **delete** the build_runner mandate.
- **`brain/rules/ui_standards.md`** → tokens from `app_colors`/`app_typography`/`app_spacing`; custom
  responsive (not screenutil).
- **`brain/rules/error_handling.md`** → keep 3-layer contract; reference `AppPageError`/`PageErrorDisplay`.
- **`brain/code_map.md`** → reflect real `core/` (`api/`, `auth/`, `errors/`, `navigation/`, `network/`,
  `responsive/`, `theme/`), `models/` (11 files), and the per-feature `data/ + application/` convention.
- **Registries** → header set to `TARGET SPEC — not yet implemented`, add an `Implemented?` column.
- **`brain/features/feature_spec.md`** → populate (summary of backend `docs/api-overview.md` + §9 rules).
- **`brain/features/ux_flow.md`** → numbered screen inventory from `AppRoutes` + screen IDs (S-11…, admin).

### 3.2 Shared scaffolding
- Add `lib/shared/widgets/gz_loading_view.dart` (centered spinner) + optional list skeleton; there is no
  Shimmer/Skeleton widget today.
- Add a `ref.listen` snackbar helper (e.g. `lib/core/errors/error_snackbar.dart`) for action errors.
- (Optional) add sealed base `AppException` in `app_exception.dart` for clean `on AppException catch`.

### 3.3 Inconsistency-file system
Create `brain/phases/` with one stub per phase (1–13). Template:
```markdown
# Phase <n> — <Feature> — Inconsistencies & Notes
Pass 1 review: [ ]    Pass 2 review: [ ]
Dummy data fully removed: [ ]    flutter analyze clean: [ ]

## Endpoint / contract mismatches (backend vs Flutter)
- (e.g. ApiConstants.authAdminLogin = '/auth/admin/login' vs backend '/stores/:storeId/admins/login')

## Missing / renamed endpoints or constants
## Model ↔ JSON field mismatches (nullable, casing, types)
## Registry ↔ code drift fixed
## Dummy data removed (file:line)
## Open TODOs / deferred
```

### 3.4 DoD (Phase 0)
`flutter analyze` clean; brain no longer references dio/freezed/codegen/screenutil; `brain/phases/`
stubs exist; `feature_spec.md` + `ux_flow.md` populated; shared loading + snackbar helpers added.

---

## 4. Player Phases (1–8)

Each phase: build `data/repositories/*` + `application/*_notifier.dart`, wire the listed screens off
dummy data, reuse `lib/models/*`, update `code_map.md` + registry, fill the inconsistency file. Tables
below give **screen → endpoint → model** per feature.

### Phase 1 — Auth & Identity  (`features/auth` + admin auth screens in `features/admin`)

**Screens (routes):** splash `/`, onboarding `/onboarding`, auth landing `/auth`, register
`/auth/register`, OTP `/auth/otp`, email login `/auth/email-login`, oauth handler
`/auth/oauth-handler`, forgot `/auth/forgot-password`, reset `/auth/reset-password`,
email-verification-pending, email-verified; admin login `/auth/admin-login`, admin password reset.

**Endpoints:**
| Method | Path | Used by |
|---|---|---|
| POST | `/auth/register` | register |
| POST | `/auth/login/otp` + `/auth/verify/otp` | OTP login |
| POST | `/auth/login/email` | email login |
| POST | `/auth/login/oauth/:provider` | oauth handler |
| POST | `/auth/password/reset/request` + `/reset/confirm` | forgot/reset |
| POST | `/auth/refresh` (exists) / `/auth/logout` | session |
| GET/PATCH | `/auth/me` | profile bootstrap |
| PATCH | `/auth/me/device` | FCM token register |
| POST/GET | `/auth/admin/login`, `/auth/admin/me`, `/auth/admin/logout` | admin |
| POST | `/auth/admin/password-reset/request`+`/confirm` | admin reset |

**Repositories:** `AuthRepository`, `AdminAuthRepository`.
**Notifiers:** `authNotifier` (app session state → drives `app_router` redirect), `registerNotifier`,
`otpNotifier`, `loginNotifier`, `passwordResetNotifier`, `adminAuthNotifier` (all sealed action states).
**On success:** persist refresh token + userId + userType via `TokenStorage`; set `accessTokenProvider`;
register FCM device token via `/auth/me/device`.
**Models:** `AuthTokenResponse`, `UserModel` (`api_responses.dart`, `domain_global.dart`).
**Inconsistencies to log:** admin-login path mismatch; OAuth callback shape; email-verify-by-link transport.

### Phase 2 — Home & Stores  (`features/home`) — gates all store-scoped player features

| Screen (ID, route) | Endpoint | Model |
|---|---|---|
| S-11 Home `/home` | `GET /stores` | `StoreModel` |
| S-12 Search `/home/search` (300ms debounce, filters) | `GET /stores?search=&platform=` | `StoreModel` |
| S-13 Detail `/home/store/:slug` | `GET /stores/:slug`, `GET /stores/:storeId/campaigns/active`, `GET /stores/:storeId/systems/available` | `StoreModel`, `CampaignModel`, `SystemModel` |

**Repository:** `StoreRepository`. **Notifiers:** `homeNotifier (AsyncValue<HomeData>)`,
`storeSearchNotifier` (filter+debounce state), `storeDetailNotifier.family(slug)`, `activeStoreNotifier`.
**Book CTA:** sets `activeStoreIdProvider` + `TokenStorage.saveActiveStoreId` → `context.go('/book')`.

### Phase 3 — Booking  (`features/booking`)

| Screen (ID) | Endpoint | Model |
|---|---|---|
| S-14 slot select `/book` | `GET /stores/:storeId/systems/available` | `SystemModel` |
| S-15 availability `/book/availability` | `GET /stores/:storeId/bookings/availability` | `AvailabilitySlot` |
| S-16 system select `/book/systems` | (uses systems list) | `SystemModel` |
| S-17 summary `/book/summary` | `POST /stores/:storeId/bookings`, (credits/campaign from Phase 5 repos) | `BookingModel` |
| S-18 success `/book/success` | `POST /stores/:storeId/bookings/:id/pay` | `BookingModel` |

**Repositories:** `BookingRepository`, `SystemsRepository`.
**Notifiers:** `systemsNotifier` (30s refresh, watches `activeStoreIdProvider`), `availabilityNotifier`,
`bookingNotifier` (flow accumulation: date/slot/system/typeFilter), `bookingFormNotifier` (sealed
submit), `bookingSummaryUiNotifier`. Real campaign/credit application in S-17 (depends on Phase 5
`WalletRepository` — log as cross-phase dependency if Phase 5 not yet done).

### Phase 4 — Sessions, My-Bookings & Billing  (`features/sessions`)

| Screen (ID) | Endpoint |
|---|---|
| S-19 hub `/sessions` | `GET .../sessions/my`, `GET .../bookings/my` |
| S-20 booking detail `/sessions/booking/:id` | `GET .../bookings/:id`, `POST .../bookings/:id/cancel` |
| S-22 check-in `/sessions/booking/:id/check-in` | `POST .../bookings/:id/check-in` |
| S-23 active session `/sessions/active/:id` | `GET .../sessions/:id` (30s poll + countdown) |
| S-24 history detail `/sessions/history/:id` | `GET .../sessions/:id` |
| billing history `/sessions/billing` | `GET .../billing/my` |
| session logs `/sessions/logs/:id` | `GET .../sessions/:id/logs` |
| payment sheet | `POST .../bookings/:id/pay` |

**Repositories:** `SessionsRepository`, `BookingsRepository`, `BillingRepository`.
**Notifiers:** `activityHubNotifier`, `bookingDetailNotifier.family`, `paymentNotifier` (sealed),
`activeSessionNotifier.family` (Timer poll), `sessionDetailNotifier.family`, `billingNotifier`.
**Models:** `SessionModel`, `BookingModel` (`domain_systems.dart`), `BillingRow`/`PaginatedBillingResponse`
(`api_responses.dart`). **Network:** wire `PlayerWsService` (`/ws/users/:userId/notify`) for live events.

### Phase 5 — Wallet, Credits & Campaigns  (`features/wallet`)

| Screen (ID) | Endpoint |
|---|---|
| S-26 wallet `/wallet` | `GET .../credits/balance`, `GET .../credits/transactions`, `GET .../campaigns/active` |
| S-27 credit history `/wallet/transactions` | `GET .../credits/transactions` (paginated) |
| S-28 redeem sheet | `POST .../credits/redeem` |
| S-29 campaigns `/wallet/campaigns` | `GET .../campaigns/active` |
| S-30 campaign detail `/wallet/campaigns/:id` | (detail via list `extra` or fetch), `POST .../campaigns/:id/redeem` |

**Repository:** `WalletRepository`. **Notifiers:** `walletNotifier (AsyncValue<WalletData>)`,
`creditHistoryNotifier` (pagination), `redeemCreditsNotifier` (sealed), `campaignsNotifier`,
`campaignDetailNotifier.family`. **⚠ Delete `wallet_screen.dart` `_transactions`/`_campaigns` constants.**
**Models:** `CreditBalanceModel`, `CreditLedgerModel`, `CampaignModel` (`domain_loyalty.dart`).

### Phase 6 — Notifications  (`features/notifications`)

| Screen | Endpoint |
|---|---|
| list `/notifications` | `GET /notifications`, `POST /notifications/read-all` |
| detail sheet | `GET /notifications/:id`, `PATCH /notifications/:id/read` |
| (prefs shared w/ Profile) | `GET/PATCH /notifications/preferences` |

**Repository:** `NotificationsRepository`. **Notifiers:** `notificationsNotifier` (list + unread badge,
live via `PlayerWsService`), `notificationDetailNotifier`. Mark-read refreshes the badge count.

### Phase 7 — Profile  (`features/profile`)

| Screen (route) | Endpoint |
|---|---|
| profile `/profile` | `GET /auth/me` |
| edit profile `/profile/edit` | `PATCH /auth/me` |
| change phone `/profile/change-phone` | `POST /auth/phone/change` (+ verify) |
| notif prefs `/profile/notifications` | `GET/PATCH /notifications/preferences` |

**Repositories:** reuse `AuthRepository` + `NotificationsRepository`.
**Notifiers:** `profileNotifier`, `editProfileNotifier` (sealed), `changePhoneNotifier` (sealed),
`notifPrefsNotifier`. Logout → clears tokens, `context.go('/auth')`.

### Phase 8 — Disputes (player)  (`features/disputes` + `profile/disputes_list_screen.dart`)

| Screen (route) | Endpoint |
|---|---|
| disputes list `/profile/disputes` | `GET /stores/:storeId/disputes/my` |
| create dispute `/profile/disputes/create` | `POST /stores/:storeId/disputes` |
| dispute detail `/profile/disputes/:id` | `GET .../disputes/:id`, `POST .../disputes/:id/withdraw` |

**Repository:** `DisputesRepository`. **Notifiers:** `myDisputesNotifier`,
`disputeDetailNotifier.family`, `createDisputeNotifier` (sealed). Entry point: billing record (Phase 4)
→ "Raise dispute". **Models:** dispute models in `domain_billing.dart` / `domain_misc.dart`.

---

## 5. Admin Phases (9–13)

### Phase 9 — Admin Operations  (`features/admin/.../operations` + dashboard)

| Screen | Endpoint |
|---|---|
| dashboard `/admin/dashboard` | `GET .../analytics/dashboard`, `GET .../systems/live` |
| session mgmt `/admin/sessions` | `GET .../sessions`, `.../sessions/active` |
| end/extend/pause/resume sheets | `POST .../sessions/:id/{end,extend,pause,resume}` |
| session start (walk-in) | `POST .../sessions` |
| booking mgmt `/admin/bookings` | `GET .../bookings`, `PATCH .../bookings/:id` |
| admin booking detail `/admin/bookings/:id` | `GET .../bookings/:id` |
| cancel/check-in sheets | `POST .../bookings/:id/{cancel,check-in}` |
| walk-in `/admin/walk-in` | `POST .../bookings/walk-in` |
| session logs | `GET .../sessions/:id/logs` |

**Repositories:** `AdminSessionsRepository`, `AdminBookingsRepository`, `AdminDashboardRepository`.
**Notifiers:** live-refresh list notifiers + sealed action notifiers. **WS:** wire `AdminLiveService`
(`/ws/stores/:storeId/live`) for live system/session feed.
**Models:** `domain_systems.dart`, `domain_admin.dart`, `api_responses_admin.dart`.

### Phase 10 — Admin Store & Systems  (`features/admin/.../store`)

| Screen | Endpoint |
|---|---|
| system mgmt `/admin/systems` / list | `GET .../systems`, `GET .../systems/live` |
| add/edit system | `POST .../systems`, `PATCH .../systems/:id`, `DELETE .../systems/:id` |
| system detail `/admin/systems/:id` | `GET .../systems/:id` |
| system types | `GET/POST/PATCH/DELETE .../system-types` |
| store config `/admin/config` | `GET/PATCH /stores/:id/config` |
| staff mgmt `/admin/staff` + invite/edit | `GET/POST/PATCH/DELETE /stores/:storeId/admins` |
| admin notifications `/admin/notifications` | `POST /notifications/admin/send`, `/admin/send/topic` |

**Repositories:** `SystemsAdminRepository`, `SystemTypesRepository`, `StoreConfigRepository`,
`StoreAdminsRepository`, `AdminNotifySendRepository` + per-screen notifiers (list + sealed CRUD).

### Phase 11 — Admin Money  (`features/admin/.../management`: pricing, billing, payments, credits)

| Screen | Endpoint |
|---|---|
| pricing rules `/admin/pricing` + create/edit | `GET/POST/PATCH/DELETE .../pricing/rules`, `POST .../pricing/calculate` |
| billing & payments `/admin/billing` | `GET .../billing/ledger(/:id)`, `GET .../billing/revenue/summary` |
| billing override sheet | `POST .../billing/:id/override` |
| payments | `GET/POST .../payments`, `POST .../payments/:id/refund`, `GET .../payments/reconciliation` |
| credits mgmt `/admin/credits` + adjust sheet | `GET .../credits/balance/:userId`, `GET .../credits/transactions/:userId`, `POST .../credits/adjust` |

**Repositories:** `PricingRepository`, `AdminBillingRepository`, `PaymentsRepository`,
`AdminCreditsRepository` + notifiers (list + sealed create/override/refund/adjust).

### Phase 12 — Admin Campaigns & Disputes  (`features/admin/.../management`)

| Screen | Endpoint |
|---|---|
| campaign mgmt `/admin/campaigns` + create/edit | `GET/POST/PATCH .../campaigns`, `POST .../campaigns/:id/{pause,resume}`, `GET .../campaigns/:id/redemptions` |
| dispute resolution `/admin/disputes` + detail `/admin/disputes/:id` | `GET .../disputes`, `GET .../disputes/:id`, `POST .../disputes/:id/{review,resolve}` |

**Repositories:** `AdminCampaignsRepository`, `AdminDisputesRepository` + notifiers.

### Phase 13 — Admin Analytics  (`features/admin/.../analytics`)

| Screen | Endpoint |
|---|---|
| analytics overview `/admin/analytics` | `GET .../analytics/dashboard` |
| revenue `/admin/analytics/revenue` | `GET .../analytics/revenue` |
| utilization `/admin/analytics/utilization` | `GET .../analytics/utilization` |
| session stats `/admin/analytics/sessions` | `GET .../analytics/sessions/stats` |
| players `/admin/analytics/players` | `GET .../analytics/players` |
| system performance `/admin/analytics/systems` | `GET .../analytics/systems/performance` |

**Repository:** `AnalyticsRepository`; one param/`.family` notifier per report (date-range params).
**Models:** `domain_analytics.dart`.

---

## 6. Per-Phase Definition of Done (supports the 2-pass review)

A phase is **done** only when ALL hold:
1. `data/repositories/*` + `application/*_notifier.dart` exist for **every** screen in the feature.
2. **Zero dummy/hardcoded data** in the feature — verify:
   `grep -rn "static const _\|_mock\|dummy\|sample\|hardcoded" lib/features/<f>` → no data literals.
3. Every data-bound screen renders all four states: **loading / error (+retry) / empty / data**.
4. Errors flow Repository→Notifier→UI as typed `AppException`; no `print`, no swallowed errors.
5. `brain/code_map.md` + `brain/features/.registry/<feature>.md` updated; registry status → Implemented.
6. `brain/phases/PHASE_<n>_*_INCONSISTENCIES.md` filled; Pass 1 + Pass 2 checkboxes present.
7. `flutter analyze` clean for the feature; app builds.

**Pass 1 (functional):** real data renders, dummy data gone, happy path works per screen.
**Pass 2 (robustness):** error/empty/loading verified, retry works, pagination/polling correct,
inconsistency file complete, brain synced.

---

## 7. Verification (run per phase, end-to-end)

1. **Backend up:** in `gz_ideation` → `bun run dev` (Swagger `:3000/docs`). Confirm
   `ApiConstants.devBaseUrl` reachable (`/health`); adjust dev URL to `localhost`/LAN if needed.
2. **Seed/login:** Phase 1 login → Phase 2 select a store (sets `activeStoreId`).
3. **Happy path:** open each feature screen → loading → real data; confirm inline dummy values gone.
4. **Error state:** stop backend → `PageErrorDisplay` (server / no-internet) + Retry recovers.
5. **Empty state:** store/user with no rows → empty view (no crash/blank).
6. **Auth/refresh:** force 401 → silent refresh + retry; refresh-fail → logout redirect.
7. `flutter analyze` after each phase. (No test files are created.)

---

## 8. File manifest (per phase, shape)

- **New (×13 features):** `lib/features/<f>/data/repositories/*.dart`,
  `lib/features/<f>/application/*_notifier.dart`.
- **Modified:** existing `presentation/screens|widgets|layouts/*.dart` (wired; dummy data deleted).
- **`lib/models/*`:** extend only where a response shape is missing (most exist).
- **`lib/core/api/api_constants.dart`:** add missing endpoint constants surfaced per phase.
- **Phase 0 brain:** `.ai_index.md`, `rules/{data_layer,state_management,ui_standards,error_handling}.md`,
  `code_map.md`, `features/{feature_spec,ux_flow}.md`, registry headers; **new** `brain/phases/PHASE_*.md`;
  **new** `lib/shared/widgets/gz_loading_view.dart`, `lib/core/errors/error_snackbar.dart`.
- **No** new pub dependencies. **No** codegen / build_runner. **No** test files.

---

## 9. Phase index (execution order)

| # | Phase | Feature folder | Client |
|---|---|---|---|
| 0 | Foundation & Brain Reconciliation | core / brain / shared | both |
| 1 | Auth & Identity | `auth` (+ admin auth) | both |
| 2 | Home & Stores | `home` | player |
| 3 | Booking | `booking` | player |
| 4 | Sessions, My-Bookings & Billing | `sessions` | player |
| 5 | Wallet, Credits & Campaigns | `wallet` | player |
| 6 | Notifications | `notifications` | player |
| 7 | Profile | `profile` | player |
| 8 | Disputes | `disputes` | player |
| 9 | Admin Operations | `admin/operations` | admin |
| 10 | Admin Store & Systems | `admin/store` | admin |
| 11 | Admin Money | `admin/management` | admin |
| 12 | Admin Campaigns & Disputes | `admin/management` | admin |
| 13 | Admin Analytics | `admin/analytics` | admin |
