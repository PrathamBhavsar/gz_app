# Admin Login Integration — Unified Mobile App

**Purpose**: Modifications to the existing Player Mobile App to support **Store Admin** and **Staff** login, making it a unified app for all user types.

---

## 1. Auth Flow Changes

### Current Flow (Player-only)
```
Splash → Auth Landing (Phone OTP / Email / OAuth / Register) → Main App (5 tabs)
```

### New Flow (Unified)
```
Splash → Auth Landing
         ├── Player Auth (Phone OTP / Email / OAuth / Register) → Player Main App (5 tabs)
         └── Admin Login (Email + Password) → Admin Main App (admin screens)
```

---

## 2. Auth Landing Screen Modifications

### Add to Screen 03 (Auth Landing)

Insert a new section at the bottom of the existing auth options:

```dart
// After existing player auth buttons, add:
const Divider(label: 'OR'),

TextButton(
  onPressed: () => context.go('/auth/admin-login'),
  child: Text('Store Admin / Staff Login'),
),
```

**New navigation route**: `/auth/admin-login`

---

## 3. New Screen: Admin Login (Screen 41)

### Route: `/auth/admin-login`

**Form fields:**
- Email address (required, validated format)
- Password (required, min 8 chars, show/hide toggle)
- "Forgot password?" link → Admin Password Reset Screen

**API call**: `POST /auth/admin/login`
```json
{
  "email": "admin@store.com",
  "password": "password123"
}
```

**Success response**:
```json
{
  "success": true,
  "message": "Admin login successful",
  "data": {
    "accessToken": "eyJ...",
    "refreshToken": "eyJ...",
    "admin": {
      "id": "uuid",
      "name": "Store Owner",
      "email": "admin@store.com",
      "role": "super_admin",
      "storeId": "uuid",
      "permissions": {},
      "lastLoginAt": "2026-04-18T...",
      "isActive": true
    }
  }
}
```

**Logic:**
- On success → Store `accessToken` + `refreshToken` in secure storage WITH a `userType: 'admin'` flag
- On `INVALID_CREDENTIALS` → Show inline error "Invalid email or password"
- Navigate to Admin Dashboard (Screen 42)

### Key difference from player login:
- Admin login uses `email + password` only (no OTP, no OAuth)
- JWT payload has `type: 'admin'` (vs `type: 'user'` for players)
- Admin JWT includes `storeId` and `role` fields

---

## 4. Token Storage Changes

### Add to token storage:

```dart
// New fields in secure storage:
static const String userTypeKey = 'user_type';     // 'player' | 'admin'
static const String adminRoleKey = 'admin_role';   // 'super_admin' | 'admin' | 'staff'
static const String storeIdKey = 'active_store_id'; // Admin's store ID
```

### Admin token payload shape:
```json
{
  "sub": "admin-uuid",
  "type": "admin",
  "storeId": "store-uuid",
  "role": "super_admin",
  "iat": 1745000000,
  "exp": 1745000900
}
```

### Player token payload shape (unchanged):
```json
{
  "sub": "user-uuid",
  "type": "user",
  "iat": 1745000000,
  "exp": 1745000900
}
```

---

## 5. Splash Screen Changes (Screen 01)

### Modified logic:
```dart
// After token validation:
final userType = await storage.getUserType();

if (userType == 'admin') {
  // Validate admin token with GET /auth/admin/me
  // If valid → Navigate to Admin Dashboard
  // If expired → Try POST /auth/refresh with admin refresh token
  // If refresh fails → Navigate to Auth Landing
} else {
  // Existing player flow (unchanged)
  // Validate player token with GET /auth/me
}
```

### New API calls:
- `GET /auth/admin/me` — Validate admin token + get admin profile
- `POST /auth/refresh` — Token refresh (same endpoint for both user types, but admin JWT has `type: 'admin'`)

---

## 6. New Routes Needed

### In `lib/core/navigation/routes.dart`:

```dart
// Add to AppRoutes:
static const adminLogin = '/auth/admin-login';
static const adminDashboard = '/admin/dashboard';
static const adminSessions = '/admin/sessions';
static const adminWalkIn = '/admin/walk-in';
static const adminBookings = '/admin/bookings';
static const adminAnalytics = '/admin/analytics';
static const adminRevenue = '/admin/analytics/revenue';
static const adminUtilization = '/admin/analytics/utilization';
static const adminSessionStats = '/admin/analytics/sessions';
static const adminPlayers = '/admin/analytics/players';
static const adminSystems = '/admin/analytics/systems';
static const adminPricing = '/admin/pricing';
static const adminBilling = '/admin/billing';
static const adminCampaigns = '/admin/campaigns';
static const adminCredits = '/admin/credits';
static const adminDisputes = '/admin/disputes';
static const adminSystemsMgmt = '/admin/systems';
static const adminStaff = '/admin/staff';
static const adminConfig = '/admin/config';
static const adminNotifications = '/admin/notifications';
```

---

## 7. API Constants Additions

### In `api_constants.dart`:

```dart
// ─── Admin Auth Endpoints ──────────────────────────────────────────
static const String authAdminLogin = '/auth/admin/login';
static const String authAdminLogout = '/auth/admin/logout';
static const String authAdminMe = '/auth/admin/me';
static const String authAdminPasswordResetRequest = '/auth/admin/password-reset/request';
static const String authAdminPasswordResetConfirm = '/auth/admin/password-reset/confirm';

// ─── Analytics Endpoints ───────────────────────────────────────────
static const String analyticsDashboard = '/stores/{storeId}/analytics/dashboard';
static const String analyticsRevenue = '/stores/{storeId}/analytics/revenue';
static const String analyticsUtilization = '/stores/{storeId}/analytics/utilization';
static const String analyticsSessionStats = '/stores/{storeId}/analytics/sessions/stats';
static const String analyticsPlayers = '/stores/{storeId}/analytics/players';
static const String analyticsSystemPerformance = '/stores/{storeId}/analytics/systems/performance';

// ─── Store Admins Endpoints ────────────────────────────────────────
static const String storeAdminsList = '/stores/{storeId}/admins';
static const String storeAdminsCreate = '/stores/{storeId}/admins';
static const String storeAdminsUpdate = '/stores/{storeId}/admins/{id}';
static const String storeAdminsDeactivate = '/stores/{storeId}/admins/{id}';

// ─── Systems Management Endpoints ──────────────────────────────────
static const String systemsLive = '/stores/{storeId}/systems/live';
static const String systemsList = '/stores/{storeId}/systems';
static const String systemDetail = '/stores/{storeId}/systems/{id}';

// ─── Pricing Endpoints ────────────────────────────────────────────
static const String pricingRules = '/stores/{storeId}/pricing/rules';
static const String pricingCalculate = '/stores/{storeId}/pricing/calculate';

// ─── Billing Endpoints ────────────────────────────────────────────
static const String billingLedger = '/stores/{storeId}/billing/ledger';
static const String billingRevenueSummary = '/stores/{storeId}/billing/revenue/summary';

// ─── Payments Endpoints ───────────────────────────────────────────
static const String paymentsList = '/stores/{storeId}/payments';
static const String paymentsReconciliation = '/stores/{storeId}/payments/reconciliation';

// ─── Credits Admin Endpoints ──────────────────────────────────────
static const String creditsUserBalance = '/stores/{storeId}/credits/balance/{userId}';
static const String creditsUserTransactions = '/stores/{storeId}/credits/transactions/{userId}';
static const String creditsAdjust = '/stores/{storeId}/credits/adjust';

// ─── Campaigns Admin Endpoints ────────────────────────────────────
static const String campaignsAdminList = '/stores/{storeId}/campaigns';
static const String campaignDetail = '/stores/{storeId}/campaigns/{id}';
static const String campaignRedemptions = '/stores/{storeId}/campaigns/{id}/redemptions';

// ─── Disputes Admin Endpoints ─────────────────────────────────────
static const String disputesAdminList = '/stores/{storeId}/disputes';
static const String disputeDetail = '/stores/{storeId}/disputes/{id}';

// ─── Notifications Admin Endpoints ────────────────────────────────
static const String notificationsAdminSend = '/notifications/admin/send';
static const String notificationsAdminSendTopic = '/notifications/admin/send/topic';

// ─── Store Config Endpoints ───────────────────────────────────────
static const String storeConfig = '/stores/{id}/config';

// ─── System Types Endpoints ───────────────────────────────────────
static const String systemTypes = '/stores/{storeId}/system-types';
```

---

## 8. API Client Changes

### Add admin-specific methods:

```dart
// In ApiClient, add:
Future<Map<String, dynamic>> adminLogin({
  required String email,
  required String password,
}) async {
  return post(
    ApiConstants.authAdminLogin,
    body: {'email': email, 'password': password},
  );
}

Future<Map<String, dynamic>> getAdminProfile() async {
  return get(ApiConstants.authAdminMe);
}

Future<void> adminLogout({String? refreshToken, bool allDevices = false}) async {
  return post(
    ApiConstants.authAdminLogout,
    body: {
      if (refreshToken != null) 'refreshToken': refreshToken,
      if (allDevices) 'all': true,
    },
  );
}
```

### Token refresh note:
- `POST /auth/refresh` works for BOTH user types
- The refresh token itself encodes the user type
- The returned access token will have the correct `type` field

---

## 9. State Management Changes

### New providers (Riverpod):

```dart
// Admin auth state
final adminAuthProvider = StateNotifierProvider<AdminAuthNotifier, AsyncValue<AdminModel?>>((ref) {
  return AdminAuthNotifier(ref.read(apiClientProvider), ref.read(tokenStorageProvider));
});

// Admin role-based access
final adminRoleProvider = Provider<String?>((ref) {
  return ref.read(tokenStorageProvider).getAdminRole();
});

// Admin store context
final adminStoreIdProvider = Provider<String?>((ref) {
  return ref.read(tokenStorageProvider).getStoreId();
});

// Role check helpers
final isAdminProvider = Provider<bool>((ref) {
  final userType = ref.read(userTypeProvider);
  return userType == 'admin';
});

final isSuperAdminProvider = Provider<bool>((ref) {
  final role = ref.read(adminRoleProvider);
  return role == 'super_admin';
});
```

---

## 10. WebSocket Changes

### Admin WebSocket channel:
```
WS /ws/stores/:storeId/live?token={adminAccessToken}
```

### Connect when:
- Admin logs in successfully
- App foregrounds while admin is authenticated

### Events to handle:
```dart
// Admin WS events
'system.status_changed'   // Update live floor map
'session.started'         // Update active sessions list
'session.ended'           // Remove from active, update billing
'session.extended'        // Update session timer
'session.paused'          // Update session status
'session.resumed'         // Update session status
'booking.created'         // Update bookings list
'booking.cancelled'       // Update bookings list
'booking.checked_in'      // Update booking status
'payment.received'        // Update payments/revenue
```

---

## 11. Admin Password Reset Flow

### New screens needed:

**Admin Forgot Password Screen** (from Admin Login → "Forgot password?"):
- Email input
- `POST /auth/admin/password-reset/request { email }`
- Always shows success (no email enumeration)
- "Back to Login" button

**Admin Reset Password Screen** (deep link from reset email):
- New password + confirm password
- `POST /auth/admin/password-reset/confirm { token, newPassword }`
- On success → Navigate to Admin Login

### Deep link:
```
gzapp://admin/reset-password?token={token}
```

---

## 12. Navigation Shell Changes

### New shell pattern:

```dart
// After login, check user type:
final userType = await storage.getUserType();

if (userType == 'admin') {
  // Show admin navigation shell
  // Admin shell has: Dashboard / Sessions / Analytics / More
} else {
  // Show existing player shell (5 tabs)
}
```

### Admin bottom tabs:
| Tab | Icon | Screen |
|-----|------|--------|
| Dashboard | Grid/Grid | Screen 42 — Live Floor Map |
| Sessions | Clock | Screen 43 — Session Management |
| Analytics | Chart | Screen 46 — Analytics Dashboard |
| More | Menu | Admin settings menu (bookings, pricing, billing, etc.) |

---

## 13. Logout Changes

### Admin logout:
```dart
// Clear admin-specific state
await apiClient.adminLogout(refreshToken: storedRefreshToken);
await storage.clearAll(); // Clears tokens + userType + adminRole
// Navigate to Auth Landing
```

### Player logout (unchanged):
```dart
await apiClient.post(ApiConstants.authLogout);
await storage.clearAll();
```

---

## 14. Security Considerations

1. **Token separation**: Admin and player tokens have different `type` field. Backend validates this in middleware.
2. **No role escalation**: A player token cannot access admin endpoints (middleware checks `type: 'admin'`).
3. **No cross-store access**: Admin JWT includes `storeId`, validated on every admin endpoint.
4. **Single session type**: User can be logged in as player OR admin, not both simultaneously. Storage uses `userType` to disambiguate.
5. **Admin login is email+password only** — no OTP, no OAuth. This is intentional — admins are store employees with known emails.

---

## 15. Files to Create/Modify Summary

### New files:
| File | Purpose |
|------|---------|
| `lib/features/admin/` | Admin feature directory (mirrors `lib/features/auth/` pattern) |
| `lib/features/admin/data/services/admin_auth_service.dart` | Admin auth API calls |
| `lib/features/admin/data/services/admin_service.dart` | Admin CRUD operations |
| `lib/features/admin/presentation/screens/admin_login_screen.dart` | Admin login UI |
| `lib/features/admin/presentation/screens/admin_dashboard_screen.dart` | Live floor map |
| `lib/features/admin/presentation/widgets/admin_shell.dart` | Admin navigation shell |

### Modified files:
| File | Change |
|------|--------|
| `lib/core/navigation/routes.dart` | Add admin routes |
| `lib/core/api/api_constants.dart` | Add admin endpoint constants |
| `lib/core/api/api_client.dart` | Add admin-specific methods |
| `lib/core/auth/token_storage.dart` | Add `userType`, `adminRole`, `storeId` storage |
| `lib/features/auth/presentation/screens/splash_screen.dart` | Admin vs player auth check |
| `lib/features/auth/presentation/screens/auth_landing_screen.dart` | Add "Admin Login" button |

### New model files:
| File | Purpose |
|------|---------|
| `lib/models/domain_admin.dart` | StoreConfigModel, AdminAuthTokenResponse, WalkInBookingResponse |
| `lib/models/domain_analytics.dart` | AnalyticsDashboardModel, RevenueAnalyticsModel, UtilizationModel, etc. |
| `lib/models/api_responses_admin.dart` | Response wrappers for admin/analytics models |
