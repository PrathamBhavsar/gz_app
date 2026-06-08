# FEATURE REGISTRY: Navigation + Auth Guard
> **Version**: 1.0 | **Updated**: 2026-05-16
> **Status**: [x] Complete
> **Role**: Both

---

## 1. OVERVIEW

**One-line description**: Complete `AppRoutes` constants, go_router wiring, auth guard, and deep-link config.

**Phase**: Phase 9

**Depends on**: `auth.md`, `splash.md`

---

## 2. CORE FILES

| File | Description | Status |
|---|---|---|
| `lib/core/navigation/routes.dart` | All `AppRoutes.*` constants | Complete |
| `lib/core/navigation/app_router.dart` | `routerProvider`, all `GoRoute` entries, auth guard | Complete |
| `android/app/src/main/AndroidManifest.xml` | `gzapp://` intent-filter | Complete |
| `ios/Runner/Info.plist` | `CFBundleURLTypes` with `gzapp` scheme | Complete |

---

## 3. AUTH GUARD

Lives in `routerProvider` (lib/core/navigation/app_router.dart).

- `refreshListenable`: `ValueNotifier<int>` incremented on `authNotifierProvider` or `adminAuthNotifierProvider` change
- Guard skips redirect during `AuthInitial` / `AuthLoading` (splash owns this window)
- Guard skips `/` and `/onboarding` (SplashNotifier owns those transitions)
- Unauthenticated + player route → `/auth`
- Authenticated + `/auth*` route → `/home`
- Admin route + not `AdminAuthAuthenticated` → `/auth/admin-login`

---

## 4. DEEP LINKS

| URI | Route |
|-----|-------|
| `gzapp://reset-password?token=` | `AppRoutes.resetPassword` |
| `gzapp://stores/:slug` | `AppRoutes.storeDetail` |
| `gzapp://bookings/:id` | `AppRoutes.bookingDetail` |
| `gzapp://notifications` | `AppRoutes.notifications` |

Phase 12 update:
- `routerProvider` now resolves `gzapp://...` links during startup via `initialLocation` and at runtime via `redirect`.
- Path-param deep links now interpolate into concrete app routes before screen build.

---

## 5. DECISIONS & CONSTRAINTS

| Decision | Rationale | Date |
|---|---|---|
| `paymentSheet` constant added but no GoRoute | Payment is a `showModalBottomSheet` per layout_engine.md overlay rule | 2026-05-16 |
| Guard doesn't redirect from `/` or `/onboarding` | SplashNotifier owns initial routing; guard interference causes double-nav | 2026-05-16 |
