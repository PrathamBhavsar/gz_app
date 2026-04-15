# General Layout Phase-Wise Implementation

This phased roadmap schedules the development of all 40 screens across the Player Mobile App. The implementation closely maps the `docs/general-layout.md` screen architecture against the endpoints defined, employing the models already loaded under `lib/models`. 

Every feature phase will meticulously follow the `docs/main-rules.md` guidelines, ensuring:
- Separate Mobile/Tablet Layouts per screen
- Single responsibility Riverpod Notifiers & explicit Riverpod Repository states.
- Reusing `PageErrorDisplay` and guarding API endpoints via the implemented `NetworkChecker`.

## User Review Required

> [!IMPORTANT]
> Since we are tackling the entirety of the application, please review these phases. Once approved, I will begin executing **Phase 1 (Routing & Auth Stack)**. At the completion of each phase, I will push code, perform validation, and show you exactly what was built via a Walthrough, before asking to proceed to the next milestone.

---

## Proposed Changes

### Phase 1: Shared Routing & The Auth Stack (10 Screens)
**Focus:** Scaffold out centralized navigation and handle all unauthenticated and login/signup flows up to `Home`.
* **Routing setup**: Create `GoRouter` foundation under `lib/core/navigation/` to handle redirects (auth boundary guarding).
* **Screens**:
  1. Splash Screen
  2. Onboarding Screen
  3. Auth Landing Screen
  4. Register Screen
  5. OTP Verification Screen
  6. Email Login Screen
  7. OAuth Handler Screen
  8. Forgot Password Screen
  9. Reset Password Screen
  10. Email Verification Pending Screen
* **Endpoints integrated**: `GET /auth/me`, `POST /auth/refresh`, `POST /auth/login/otp`, `POST /auth/register`, `POST /auth/verify/otp`, `POST /auth/login/email`, `POST /auth/login/oauth/:provider`, `POST /auth/password/reset/request`, `POST /auth/password/reset/confirm`.
* **Models**: `UserResponse` (`UserModel`).

---

### Phase 2: Home & Discovery Hub - Tab 1 (3 Screens)
**Focus:** Allow players to search, view, and select stores.
* **Core Mechanisms**: Introduce the Global `ActiveStoreNotifier` to persist the selected store logic.
* **Screens**:
  1. Home Feed
  2. Store Search Screen
  3. Store Detail Screen
* **Endpoints integrated**: `GET /stores` (lists and search queries), `GET /stores/:slug`, `GET /stores/:storeId/campaigns/active`.
* **Models**: `PaginatedStoresResponse`, `StoreResponse`, `PaginatedCampaignsResponse`.

---

### Phase 3: Booking & Systems Flow - Tab 2 (5 Screens)
**Focus:** The core booking funnel and selecting appropriate slots/systems based on the currently active store.
* **Screens**:
  1. Systems Browser
  2. Availability Calendar
  3. System Picker
  4. Booking Summary
  5. Booking Confirmation
* **Endpoints integrated**: `GET /stores/:storeId/systems/available`, `GET /stores/:storeId/bookings/availability`, `GET /stores/:storeId/credits/balance`, `POST /stores/:storeId/bookings`.
* **Models**: `PaginatedSystemsResponse`, `BookingResponse`.

---

### Phase 4: Session Tracking & Activity Hub - Tab 3 (7 Screens)
**Focus:** Live session management and historic data viewing. Includes Check-in and Payment modules.
* **Screens**:
  1. Activity Hub (Upcoming / Active / History sub-tabs)
  2. Booking Detail
  3. Payment Screen (Modal)
  4. Check-In Screen
  5. Active Session Screen
  6. Session History Detail
  7. Billing History
* **Endpoints integrated**: `GET /stores/:storeId/bookings/my`, `GET /stores/:storeId/sessions/my`, `GET /stores/:storeId/bookings/:id`, `POST /stores/:storeId/bookings/:id/pay`, `POST /stores/:storeId/bookings/:id/check-in`, `GET /stores/:storeId/sessions/:id`, `GET /stores/:storeId/billing/my`.
* **Models**: `PaginatedBookingsResponse`, `BookingResponse`, `PaginatedSessionsResponse`, `SessionResponse`, `PaginatedPaymentsResponse`.
* **WebSocket Simulation**: Will implement Mock Websocket hooks or polling (`GET /sessions/:id`) for live timer syncing since the backend WS isn't provided directly here.

---

### Phase 5: Wallet, Loyalty, & Campaigns - Tab 4 (5 Screens)
**Focus:** In-store loyalty transactions and applying promotional discounts within the global store scope.
* **Screens**:
  1. Wallet Home
  2. Credit Transaction History
  3. Redeem Credits (Modal)
  4. Campaigns List
  5. Campaign Detail
* **Endpoints integrated**: `GET /stores/:storeId/credits/balance`, `GET /stores/:storeId/credits/transactions`, `POST /stores/:storeId/credits/redeem`, `GET /stores/:storeId/campaigns/active`, `POST /stores/:storeId/campaigns/:id/redeem`.
* **Models**: `CampaignResponse`, `PaginatedCampaignsResponse`.

---

### Phase 6: Profile, Settings, & Disputes - Tab 5 (7 Screens)
**Focus:** Global user settings, device tokens, and dispute tracking.
* **Screens**:
  1. Profile Home
  2. Edit Profile
  3. Change Phone
  4. Notification Preferences
  5. Disputes List
  6. Dispute Detail
  7. Create Dispute
* **Endpoints integrated**: `PATCH /auth/me`, `POST /auth/phone/change`, `GET /notifications/preferences`, `PATCH /notifications/preferences`, `PATCH /auth/me/device` along with standard `GET /disputes`.

---

### Phase 7: Global Overlays & Final Polish (3 Overlays)
**Focus:** Implementing the final floating widgets accessible anywhere and ensuring smooth cross-tab interaction.
* **Components**: Notification Center, Notification Detail Sheet, Store Selector Sheet, Reusable OTP Sheet.

## Verification Plan
1. **Per-Phase Checklist:** Before finalizing any phase, I will trigger the `New Page Checklist` specified inside `main-rules.md`.
2. **State Analysis:** Validate `ConnectivityService` is bound properly inside each Notifier allowing auto-retrying.
3. **Artifact Logging:** A detailed `walkthrough.md` will be documented at the end of each Phase reflecting completion.
