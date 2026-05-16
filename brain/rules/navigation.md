# RULE: NAVIGATION
> **Enforcement Level**: CRITICAL — Raw Navigator calls and hardcoded route strings are violations.

## THE LAW: `go_router` ONLY

| Action | API |
|---|---|
| Switch tab | `context.go(AppRoutes.x)` |
| Drill into detail | `context.push(AppRoutes.x)` |
| Replace current | `context.pushReplacement(AppRoutes.x)` |
| Go back | `context.pop()` |
| Go back with result | `context.pop(result)` |

---

## ROUTE CONSTANTS — `lib/core/navigation/routes.dart`

```dart
class AppRoutes {
  AppRoutes._();

  // Auth Stack (Player)
  static const splash                   = '/';
  static const onboarding               = '/onboarding';
  static const authLanding              = '/auth';
  static const register                 = '/auth/register';
  static const otpVerification          = '/auth/otp';
  static const emailLogin               = '/auth/email-login';
  static const oauthHandler             = '/auth/oauth-handler';
  static const forgotPassword           = '/auth/forgot-password';
  static const resetPassword            = '/auth/reset-password';
  static const emailVerificationPending = '/auth/email-verification-pending';

  // Main App (Player)
  static const home         = '/home';
  static const storeSearch  = '/home/search';
  static const storeDetail  = '/home/store/:slug';  // push with slug interpolated
  static const book         = '/book';
  static const bookSystems  = '/book/systems';
  static const bookSummary  = '/book/summary';
  static const bookSuccess  = '/book/success';
  static const sessions     = '/sessions';
  static const wallet       = '/wallet';
  static const profile      = '/profile';

  // Admin Auth Stack
  static const adminLogin         = '/auth/admin-login';
  static const adminPasswordReset = '/auth/admin-password-reset';

  // Admin App
  static const adminDashboard    = '/admin/dashboard';
  static const adminSessions     = '/admin/sessions';
  static const adminWalkIn       = '/admin/walk-in';
  static const adminBookings     = '/admin/bookings';
  static const adminAnalytics    = '/admin/analytics';
  static const adminRevenue      = '/admin/analytics/revenue';
  static const adminUtilization  = '/admin/analytics/utilization';
  static const adminSessionStats = '/admin/analytics/sessions';
  static const adminPlayers      = '/admin/analytics/players';
  static const adminSystems      = '/admin/analytics/systems';
  static const adminPricing      = '/admin/pricing';
  static const adminBilling      = '/admin/billing';
  static const adminCampaigns    = '/admin/campaigns';
  static const adminCredits      = '/admin/credits';
  static const adminDisputes     = '/admin/disputes';
  static const adminSystemsMgmt  = '/admin/systems';
  static const adminStaff        = '/admin/staff';
  static const adminConfig       = '/admin/config';
  static const adminNotifications = '/admin/notifications';
}
```

---

## ROUTER STRUCTURE — TWO SHELLS

`routerProvider` in `lib/core/navigation/app_router.dart` contains:
1. **Auth routes** (no shell): `/`, `/onboarding`, `/auth`, `/auth/...`, `/auth/admin-login`
2. **Player ShellRoute** → `MainPage` → `MainMobileLayout` / `MainTabletLayout`
3. **Player sub-routes** outside shell: `/home/search`, `/home/store/:slug`, `/book/systems`, etc.
4. **Admin ShellRoute** → `AdminShell` → `AdminMobileLayout`

---

## AUTH GUARD

**Not yet wired** into `routerProvider` (marked TODO in `app_router.dart`). When implementing:

```dart
GoRouter(
  redirect: (context, state) {
    final auth = ProviderScope.containerOf(context).read(authNotifierProvider);
    final isAuth = auth is AuthAuthenticated;
    final isAuthRoute = [AppRoutes.authLanding, AppRoutes.onboarding, ...]
        .any((r) => state.matchedLocation.startsWith(r));

    if (!isAuth && !isAuthRoute) return AppRoutes.authLanding;
    if (isAuth && isAuthRoute) return AppRoutes.home;
    return null;
  },
)
```

Admin guard checks `adminAuthNotifierProvider` for `AdminAuthAuthenticated`.

---

## DEEP LINKS

| Deep Link Pattern | Route |
|---|---|
| `gzapp://reset-password?token=` | `AppRoutes.resetPassword` |
| `gzapp://verify-email?token=` | API call → `/home` |
| `gzapp://stores/{slug}` | `AppRoutes.storeDetail` |
| `gzapp://bookings/{id}` | Push booking detail (route TBD) |
| `gzapp://sessions/{id}` | Push session detail (route TBD) |
| `gzapp://notifications` | Show Notification Center overlay |

---

## PARAM PASSING

Pass IDs only via route params or extra. Never pass model objects through the router.

```dart
// Navigate with interpolated path
context.push('/home/store/$slug');

// Receive in GoRoute
GoRoute(
  path: AppRoutes.storeDetail, // '/home/store/:slug'
  builder: (context, state) =>
      StoreDetailScreen(slug: state.pathParameters['slug']!),
)
```

---

## BACK STACK RULES

| Scenario | Pattern |
|---|---|
| Post-login | `context.go(AppRoutes.home)` — clears auth stack |
| After booking confirmed | `context.go(AppRoutes.sessions)` — no booking flow in stack |
| After payment complete | `context.go(AppRoutes.sessions)` |
| After logout (player) | `context.go(AppRoutes.authLanding)` |
| After logout (admin) | `context.go(AppRoutes.adminLogin)` |
| After dispute filed | `context.pop()` → back to disputes list |

---

## FORBIDDEN

| Violation | Why |
|---|---|
| `Navigator.push/pop` | Bypasses go_router guard |
| Hardcoded path strings | Use `AppRoutes.*` |
| Model objects in route params | Pass ID only |
| `context.go()` for drill-downs | Clears back stack |
| `context.push()` for tab switches | Adds duplicate shell entries |

---

## PHASE 9 ADDITIONS (2026-05-16)

### New Route Constants
```dart
// Sessions
AppRoutes.paymentSheet         = '/sessions/booking/:id/pay'   // modal sheet — no GoRoute
AppRoutes.bookingDetail        = '/sessions/booking/:id'
AppRoutes.checkIn              = '/sessions/booking/:id/check-in'
AppRoutes.activeSessionDetail  = '/sessions/active/:id'
AppRoutes.sessionHistoryDetail = '/sessions/history/:id'
AppRoutes.billingHistory       = '/sessions/billing'

// Wallet
AppRoutes.creditHistory  = '/wallet/transactions'
AppRoutes.campaigns      = '/wallet/campaigns'
AppRoutes.campaignDetail = '/wallet/campaigns/:id'

// Profile
AppRoutes.editProfile   = '/profile/edit'
AppRoutes.changePhone   = '/profile/change-phone'
AppRoutes.notifPrefs    = '/profile/notifications'
AppRoutes.disputesList  = '/profile/disputes'
AppRoutes.disputeCreate = '/profile/disputes/create'
AppRoutes.disputeDetail = '/profile/disputes/:id'
```

### Auth Guard — WIRED (Phase 9)
`routerProvider` now uses `refreshListenable` + `redirect`. Guard logic:
- Skips redirect while `AuthInitial` / `AuthLoading` (splash owns initial routing)
- Skips `/` (splash) and `/onboarding` — `SplashNotifier` handles those
- Unauthenticated + non-auth + non-admin route → `AppRoutes.authLanding`
- Authenticated + `/auth*` route → `AppRoutes.home`
- Admin route + not admin authenticated → `AppRoutes.adminLogin`

### Deep Links — WIRED (Phase 9)
Android: `gzapp://` intent-filter in `AndroidManifest.xml`
iOS: `CFBundleURLTypes` in `ios/Runner/Info.plist`

| Deep Link | Route |
|-----------|-------|
| `gzapp://reset-password?token=` | `AppRoutes.resetPassword` |
| `gzapp://stores/:slug` | `AppRoutes.storeDetail` |
| `gzapp://bookings/:id` | `AppRoutes.bookingDetail` |
| `gzapp://notifications` | Open `NotificationCenter` overlay |
