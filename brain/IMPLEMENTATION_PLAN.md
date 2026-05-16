# GZ App — Implementation Plan
> **Read this before every session.** This file is the source of truth for build progress.
> After each phase completes, update the status column and sync brain feature registry.

---

## Quick-Start Prompt (copy into new conversation)

```
Read brain/IMPLEMENTATION_PLAN.md. Find the current phase (first row marked TODO).
Read brain/.ai_index.md, then all rule files in brain/rules/. Then build only the
items listed under that phase. After finishing, update brain/IMPLEMENTATION_PLAN.md
(mark phase DONE, note anything deferred), sync brain/features/.registry/ for every
feature touched, and commit.
```

---

## Phase Status

| Phase | Name | Status |
|-------|------|--------|
| 1 | Foundation — AppTheme + em_ widget library | DONE |
| 2 | Splash + Onboarding | DONE |
| 3 | Home feature (S-11, S-12, S-13) | DONE |
| 4 | Booking flow (S-14 → S-18) | DONE |
| 5 | Sessions + Player WebSocket (S-19 → S-25) | DONE |
| 6 | Wallet (S-26 → S-30) | DONE |
| 7 | Profile + Settings (S-31 → S-37) | DONE |
| 8 | Global Overlays (O-38, O-39, O-40, OTP sheet) | DONE |
| 9 | Routes — complete AppRoutes + auth guard | DONE |
| 10 | Polish — empty states, deep links, error surfaces | TODO |

---

## Phase 1 — Foundation ✓ DONE (2026-05-16)

> **Completed**: AppTheme.light created + wired in main.dart. All 7 gz_ widgets renamed to em_ (shims kept for backward compat). 9 new em_ widgets added: EmAvatar, EmCard, EmIconBtn, EmCollapse, EmSectionHead, EmScrollContent, EmBottomNav (extracted from MainMobileLayout), EmStoreSelectorPill, EmGzLogo. All usage sites updated to import em_ files. Registry at brain/features/.registry/shared_widgets.md.
> **Deferred**: Nothing — all Phase 1 deliverables complete.

### Goal
Unblocks all subsequent phases. No screen code yet.

### Deliverables

#### 1a. `lib/core/theme/app_theme.dart`
Create `AppTheme.light` — a full `ThemeData` so every screen gets correct defaults
without manual overrides.

```dart
abstract class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Geist',
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.buttonBg,
      onPrimary: AppColors.buttonFg,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      error: AppColors.err,
      onError: AppColors.buttonFg,
      secondary: AppColors.pillBg,
      onSecondary: AppColors.pillFg,
      // fill remaining required fields with appropriate AppColors values
    ),
    textTheme: TextTheme(
      titleLarge:  AppTypography.h1,
      titleMedium: AppTypography.h2,
      titleSmall:  AppTypography.h3,
      bodyLarge:   AppTypography.body,
      bodyMedium:  AppTypography.bodyR,
      bodySmall:   AppTypography.small,
      labelSmall:  AppTypography.meta,
    ),
  );
}
```

Wire in `main.dart`: `theme: AppTheme.light`

#### 1b. Rename `gz_` → `em_` shared widgets

All files live in `lib/shared/widgets/`. Rename file + class everywhere they are imported.

| Old file | New file | Old class | New class |
|----------|----------|-----------|-----------|
| `gz_button.dart` | `em_button.dart` | `GzButton`, `GzButtonFull`, `GzButtonVariant` | `EmButton`, `EmButtonFull`, `EmButtonVariant` |
| `gz_tag.dart` | `em_tag.dart` | `GzTag`, `GzTagKind` | `EmTag`, `EmTagKind` |
| `gz_chip.dart` | `em_chip.dart` | `GzChip` | `EmChip` |
| `gz_top_bar.dart` | `em_top_bar.dart` | `GzTopBar` | `EmTopBar` |
| `gz_meta_row.dart` | `em_meta_row.dart` | `GzMetaRow` | `EmMetaRow` |
| `gz_live_dot.dart` | `em_live_dot.dart` | `GzLiveDot` | `EmLiveDot` |
| `gz_progress_bar.dart` | `em_progress_bar.dart` | `GzProgressBar` | `EmProgressBar` |

Keep as-is (not design-system atoms):
- `page_error_display.dart` — architectural error widget
- `huge_icon_widget.dart` — third-party wrapper

#### 1c. New `em_` widgets to create

Direct translations from `design/src/components.jsx`. Each is a pure `StatelessWidget`
using only `AppColors.*`, `AppSpacing.*`, `AppTypography.*`.

---

**`em_avatar.dart` — `EmAvatar`**

Sizes: `sm`=32, `md`=34 (default), `lg`=40, `xl`=56.
Accepts: `icon` (Widget), `children` (String letter), or neither (blank).
Color: Walle palette (7 muted tones) indexed by `index` or first char of `children`.

```dart
// Walle palette — 7 entries, same as components.jsx AVATAR_COLORS
const _walleColors = [
  (bg: Color(0xFFEAD5C8), fg: Color(0xFF5C4A40)),
  (bg: Color(0xFFD4E4D8), fg: Color(0xFF3D5A45)),
  (bg: Color(0xFFDFD4E8), fg: Color(0xFF534968)),
  (bg: Color(0xFFE8D4D4), fg: Color(0xFF685454)),
  (bg: Color(0xFFD4E0E8), fg: Color(0xFF40536B)),
  (bg: Color(0xFFE8E4D4), fg: Color(0xFF6B6340)),
  (bg: Color(0xFFE4D8D4), fg: Color(0xFF6B5954)),
];
```

---

**`em_card.dart` — `EmCard`**

Three variants matching `tokens.css`:
- `CardVariant.base` — white bg (`AppColors.surface`), `borderRadiusCard` (26)
- `CardVariant.tint` — mint bg (`AppColors.surfaceTint`), same radius
- `CardVariant.inset` — pill-bg (`AppColors.pillBg`), `borderRadiusLg` (16)

Default padding: `AppSpacing.md` (16) all sides. Accept `padding` override.

---

**`em_icon_btn.dart` — `EmIconBtn`**

38×38 transparent `GestureDetector`. No border, no bg. Just tap target + child widget.

---

**`em_collapse.dart` — `EmCollapse`**

```
EmCard(variant: base, padding: 4)
  ├── header row: title (h2) + [right slot] + animated chevron
  └── if open: child with 16px padding
```

Uses `flutter_animate` for chevron rotation. State owned by caller (`isOpen` + `onToggle`).

---

**`em_section_head.dart` — `EmSectionHead`**

```
Row: title (h2) · subtitle (small, textTertiary) — stretched — trailing (optional)
Padding: 4px top, 12px bottom
```

---

**`em_scroll_content.dart` — `EmScrollContent`**

`Expanded` + `SingleChildScrollView` (physics: `AlwaysScrollableScrollPhysics`,
scrollbar hidden). `padded` flag adds `EdgeInsets.fromLTRB(16, 4, 16, 24)`.

---

**`em_bottom_nav.dart` — `EmBottomNav`**

Extract the private `_GzBottomNav` + `_NavBtn` + `_GzIconPainter` currently inside
`main_mobile_layout.dart` into a standalone public widget.
`MainMobileLayout` then references `EmBottomNav`.

---

**`em_store_selector_pill.dart` — `EmStoreSelectorPill`**

Pill-shaped `GestureDetector`. Shows store name (`body`, w600) + chevron-down icon.
Background: `AppColors.pillBg`. Radius: `AppSpacing.borderRadiusPill`.
`onTap` opens `StoreSelectorSheet` (Phase 8).

---

**`em_gz_logo.dart` — `EmGzLogo`**

32×32 dark rounded square (`AppColors.buttonBg`, radius 8).
"GZ" text in `AppTypography.num` (mono, w700) colored `AppColors.surfaceTintStrong`.

---

### Brain Sync After Phase 1

Update `brain/features/.registry/` — create `shared_widgets.md`:
- List every `em_` widget, its file path, props, and variants
- Note that `gz_` prefix is retired

---

## Phase 2 — Splash + Onboarding ✓ DONE (2026-05-16)

> **Completed**: SplashScreen rewritten as thin StatelessWidget. SplashNotifier (sealed: Checking/ToHome/ToAdmin/ToAuth/ToOnboarding) + SplashRepository created. hasSeenOnboarding flag added to TokenStorage. SplashMobileLayout/SplashTabletLayout now show EmGzLogo + EmLiveDot and navigate via ref.listen(splashNotifierProvider). OnboardingMobileLayout/OnboardingTabletLayout rewritten as ConsumerStatefulWidget with 3-card PageView using EmCard(tint), animated dot indicator, Skip/Next/Get Started CTAs, writes hasSeenOnboarding on completion. Registries: brain/features/.registry/splash.md + onboarding.md.
> **Deferred**: Nothing — all Phase 2 deliverables complete.

### Deliverables

#### S-01 Splash `/`
- `SplashScreen` → `SplashMobileLayout`
- Centered `EmGzLogo` + `EmLiveDot`
- `SplashNotifier` (sealed state: checking / navigating):
  1. `GET /auth/me` → if 200 → `context.go(AppRoutes.home)`
  2. If 401 → `POST /auth/refresh` → if ok → `context.go(AppRoutes.home)`
  3. If no token → check `hasSeenOnboarding` (secure storage) → `/onboarding` or `/auth`
- `SplashService` + `SplashRepository` (calls existing `AuthService`)

#### S-02 Onboarding `/onboarding`
- `OnboardingScreen` → `OnboardingMobileLayout`
- `PageView` of 3 cards using `EmCard(variant: tint)`:
  - "Book Gaming Slots", "Track Your Sessions", "Earn Credits & Rewards"
- Dot page indicator
- "Get Started" (`EmButtonFull`) on last card → set `hasSeenOnboarding` flag → `context.go(AppRoutes.authLanding)`
- "Skip" text link on all cards → same destination

### Brain Sync After Phase 2
Create `brain/features/.registry/splash.md` and `onboarding.md`.

---

## Phase 3 — Home Feature ✓ DONE (2026-05-16)

> **Completed**: `HomeData` struct added to `HomeNotifier` (stores list; active session + upcoming booking deferred to Phase 5). `StoreDetailNotifier` (FamilyNotifier by slug) created with `StoreDetailData` (store + campaigns). `StoreDetailScreen` simplified to thin `StatelessWidget` passing slug to layouts. `HomeMobileLayout` rewritten with EmGzLogo header, search tap-target, nearby stores horizontal scroll (`_StoreCardLg`), new-in-city list (`_NewStoreRow`). `HomeTabletLayout` updated for `HomeData`. `StoreDetailMobileLayout` wired to real notifier — hero carousel, store info, campaign cards (real data). `StoreDetailTabletLayout` wired to real notifier. `StoreSearchMobileLayout` rewritten with filter chips (All/PC/PS5/VR/Xbox/Open Now), debounced search, open badge. `StoreSearchNotifier` updated with `selectedFilter` state and `setFilter` method. Registry at `brain/features/.registry/home.md`.
> **Deferred**: Active session banner (S-11) — Phase 5. Upcoming booking card (S-11) — Phase 5. System type chips with live counts on S-13 — Phase 4 (systems data). Distance from user — not in API.

### Deliverables

#### Data Layer
- `HomeService` — `GET /stores` (nearby + featured, paginated)
- `HomeRepository` — wraps `NetworkChecker` → `HomeService`
- `HomeNotifier` — `AsyncValue<HomeData>` where `HomeData` holds stores + active session + upcoming booking
- `StoreModel` (if not already in `lib/models/`)
- `StoreDetailService` — `GET /stores/:slug`, `GET /stores/:storeId/campaigns/active`
- `StoreDetailNotifier(slug)` — `AsyncValue<StoreDetailData>`
- `StoreSearchNotifier` — debounced `AsyncValue<List<StoreModel>>`

#### S-11 Home Feed `/home`
Layout: `HomeMobileLayout` (ConsumerWidget)

Structure (top → bottom):
```
SafeArea top
  Header row: EmGzLogo | greeting "Hey, {name}" (h3) | EmIconBtn(bell) with badge
  Padding 12px horizontal:
    Search bar — EmCard(variant: base, inset padding) + search icon + placeholder text
  EmScrollContent(padded: false):
    if activeSession: ActiveSessionBanner (tint card, live dot, timer, store name, ">" chev)
    EmSectionHead("Nearby stores", sub: "{n} within 10km")
    Horizontal scroll: StoreCardLg × n  (name, dist, rating, count, open/closed badge)
    EmSectionHead("Your next booking", sub: date)  — only if upcoming booking exists
    UpcomingBookingCard (EmCard: system, store, EmChip pair, status tag, "View →")
    EmSectionHead("Active campaigns", sub: "Near you")
    Horizontal scroll: MiniCampaignCard × n
    EmSectionHead("New in Bengaluru", sub: "{n} stores")
    NewStoreRow × n
    SizedBox(height: AppSpacing.xl)
EmBottomNav(active: 0)
```

#### S-12 Store Search `/home/search`
Layout: `StoreSearchMobileLayout`
```
SafeArea top
  Search header: back IconBtn | TextField (auto-focus) | clear IconBtn
  Filter chips row (horizontal scroll): All / PC / PS5 / VR / Xbox / Open Now
  Divider
  Expanded ListView.builder of StoreSearchRow (name, dist, system chips, open badge)
  Empty state: EmCard centered text "No stores found"
```

#### S-13 Store Detail `/home/store/:slug`
Layout: `StoreDetailMobileLayout`
```
EmTopBar(title: store.name)
EmScrollContent(padded: false):
  Hero placeholder (grey rounded rect 200h, store icon centred)
  Padding(md):
    Store name (h1) + address (small)
    Hours row + contact row
    System type chips row: EmChip × types (e.g. "PC · 12")
    EmCard: address / rating / hours detail
  EmSectionHead("Active Campaigns")  — if any
  Horizontal scroll: MiniCampaignCard × n  → push S-30
  SizedBox(xl)
Sticky bottom (above safe area):
  EmButtonFull("Book Now") → set activeStoreIdProvider → context.go('/book')
```

### Brain Sync After Phase 3
Create `brain/features/.registry/home.md`.

---

## Phase 4 — Booking Flow ✓ DONE (2026-05-16)

> **Completed**: `SystemsService` + `SystemsRepository` created. `SystemsNotifier` with 30s auto-refresh + platform filter. `AvailabilityNotifier` with `AvailabilityData` (slots + selected slot state). `BookingFormNotifier` (sealed: Initial/Loading/Success/Error) wired to `BookingRepository.placeBooking()`. `BookingNotifier` extended with `selectedSlotStart/End`, `selectedSystem`, `selectedTypeFilter`. S-14 Systems Browser rewrites the old date/time picker at `/book` — shows live systems list, platform filter chips, EmStoreSelectorPill, "Check Availability" CTA. S-15 Availability Calendar at `/book/availability` — 7-day date strip, slot list from `AvailabilityNotifier`. S-16 System Picker at `/book/systems` — real systems from `SystemsNotifier`, "Select" → stores in `BookingNotifier`. S-17 Booking Summary wired to `BookingFormNotifier.submit()` via `ref.listen`; navigates to `/book/success` on `BookingFormSuccess`. S-18 Booking Confirmation redesigned with animate() checkmark, booking ref chip, EmCard summary, payment status tag, CTAs. `/book/availability` route added to `AppRoutes` + `app_router.dart`. Registry at `brain/features/.registry/booking.md`.
> **Deferred**: Real campaign/credit data in S-17 (hardcoded prototype UI — deferred to Phase 6 wallet integration).



### Deliverables

#### Data Layer
- `SystemsService` — `GET /stores/:storeId/systems/available`
- `AvailabilityService` — `GET /stores/:storeId/bookings/availability`
- `BookingService` — `POST /stores/:storeId/bookings`, `GET /stores/:storeId/campaigns/active`, `GET /stores/:storeId/credits/balance`
- `SystemsNotifier` — `AsyncValue<List<SystemModel>>` with 30s auto-refresh
- `AvailabilityNotifier` — `AsyncValue<AvailabilityData>`
- `BookingFormNotifier` — sealed state (Initial/Loading/Success/Error)
- Models: `SystemModel`, `SlotModel`, `BookingModel`, `AvailabilityData`

#### S-14 Systems Browser `/book`
```
EmStoreSelectorPill (top)
EmTopBar-style header with store name
Type filter chips row (horizontal scroll): All / PC / PS5 / Xbox / VR / Other
Expanded ListView.builder:
  SystemCard: EmAvatar(icon: platform icon) | name + specs | EmTag("Available"/"Booked") | price/hr EmChip
Pull-to-refresh + auto-refresh every 30s (Timer in notifier)
Sticky bottom: EmButtonFull("Check Availability") → push S-15
```

#### S-15 Availability Calendar (pushed from S-14)
```
EmTopBar("Pick a slot")
Date strip: horizontal ListView, next 7 days, EmChip per day (filled = selected)
Divider
Time slot grid: ListView of SlotRow (time range, availability colored EmTag, disabled if booked)
Sticky bottom: EmButtonFull("Select System") → push S-16
```

#### S-16 System Picker `/book/systems`
```
EmTopBar("Choose System")
Selected slot shown: EmChip(key: "WHEN", value: "Sat Apr 18 · 4–5 PM")
Divider
ListView.builder of SystemPickerRow:
  seat EmAvatar | specs (name, RTX model, Hz) | EmButton("Select", small: true)
```

#### S-17 Booking Summary `/book/summary`
```
EmTopBar("Review Booking")
EmScrollContent:
  EmCard: store name, system name, date/time, duration
  Divider
  EmMetaRow × price rows (rate, duration, subtotal, multiplier if any)
  EmCollapse("Apply Campaign"):
    ListView of CampaignSelectRow — radio select
  EmCollapse("Use Credits"):
    balance display, Slider (0..balance), equivalent rupee value
  EmCard(variant: inset): Total after discounts (large mono)
  EmSectionHead("Payment method")
  PaymentMethodGrid: 5 tiles (Cash/UPI/Card/Wallet/Credits) — tappable, selected = tint
  SizedBox(xl)
Sticky bottom: EmButtonFull("Confirm Booking") → BookingFormNotifier.submit()
  loading: EmButton(loading: true)
  error: show SnackBar
  success: context.pushReplacement(AppRoutes.bookSuccess)
```

#### S-18 Booking Confirmation `/book/success`
```
Scaffold (no nav, no back)
Center column:
  flutter_animate: scale+fade checkmark circle (AppColors.ok)
  SizedBox(lg)
  Booking ref EmChip(mono)
  EmCard: system, date/time
  Payment status EmTag
  Countdown "Check-in opens in Xh Ym" EmChip
  SizedBox(xl)
  EmButtonFull("View Booking") → context.push(bookingDetail)
  SizedBox(sm)
  EmButton("Back to Home", variant: ghost) → context.go(AppRoutes.home)
```

Note: on enter this screen, `context.go` (not push) was used so back stack is clean.

### Brain Sync After Phase 4
Create `brain/features/.registry/booking.md`.

---

## Phase 5 — Sessions + Player WebSocket ✓ DONE (2026-05-16)

> **Completed**: PlayerWsService created with exponential backoff reconnect. ActivityHubNotifier rewritten from UI-only state to real data (AsyncValue<ActivityHubData>) with parallel booking + session fetches. Provider name kept as `activityHubProvider`. BookingDetailNotifier, PaymentNotifier (sealed), ActiveSessionNotifier (30s poll), SessionDetailNotifier, BillingNotifier all created. BillingService + BillingRepository added. BillingRow + PaginatedBillingResponse added to api_responses.dart. New routes: bookingDetail, checkIn, activeSessionDetail, sessionHistoryDetail, billingHistory. Screens S-20 → S-25 built: BookingDetailScreen (status-contextual CTAs), PaymentSheet (showPaymentSheet function), CheckInScreen (QR placeholder + tap), ActiveSessionDetailScreen (Timer countdown from real session data), SessionHistoryDetailScreen, BillingHistoryScreen (grouped by month). sessions_mobile_layout.dart updated to real data with loading/error/empty states. Router updated with 5 new GoRoute entries. Registry at brain/features/.registry/sessions.md.
> **Deferred**: WS event handlers (session.ended navigation, session.extended timer update) — the WS service is built and connected but event dispatch to providers requires Phase 9 app wiring. Check-in window logic uses real DateTime.now() comparison. Billing detail expand functionality not yet wired to billing endpoint.

### Deliverables

#### Player WebSocket — `lib/core/network/player_ws_service.dart`
```dart
class PlayerWsService {
  // Endpoint: /ws/users/:userId/notify?token={accessToken}
  // Reconnect: exponential backoff (1s, 2s, 4s, 8s, max 30s)
  // Exposes: Stream<WsEvent>
  // Auto-connect when auth state is AuthAuthenticated
  // Auto-disconnect on dispose / logout
}

final playerWsProvider = StreamProvider.autoDispose<WsEvent>((ref) {
  // watch authNotifierProvider
  // on AuthAuthenticated: connect PlayerWsService
  // on dispose: disconnect
});
```

WS event types to handle:
| Event | Action |
|-------|--------|
| `notification.new` | `ref.read(notificationsNotifierProvider.notifier).prependNew(event)` |
| `session.started` | Refresh `activityHubNotifierProvider` |
| `session.ended` | If on ActiveSessionScreen → `context.go('/sessions')` + toast |
| `session.extended` | Update timer in `activeSessionNotifierProvider` |
| `booking.checked_in` | Refresh booking status |

#### Data Layer
- `SessionsService` — `GET /stores/:storeId/sessions/my`, `GET /stores/:storeId/sessions/:id`
- `SessionsRepository`
- `ActivityHubNotifier` — `AsyncValue<ActivityHubData>` (upcoming bookings + active session + history)
- `BookingDetailNotifier(id)` — `AsyncValue<BookingModel>`
- `PaymentNotifier` — sealed state
- `ActiveSessionNotifier(id)` — `AsyncValue<SessionModel>` + 30s poll fallback
- `BillingService` — `GET /stores/:storeId/billing/my`
- `BillingNotifier` — `AsyncValue<List<BillingRow>>`
- Models: `SessionModel`, `ActivityHubData`, `BillingRow`

#### S-19 Activity Hub `/sessions`
```
Header: "My Games" title (h1) + EmIconBtn(bell)
TabBar: Upcoming | Active | History  (EmChip-style or standard TabBar themed)
TabBarView:
  Tab A — Upcoming:
    ListView.builder of BookingCard:
      EmAvatar(platform icon) | store + system | date/time | status EmTag | countdown EmChip
    Empty: EmCard centered "No upcoming bookings" + EmButton("Book a slot →")
  Tab B — Active:
    if active session: large tint EmCard with EmLiveDot + timer (h1 mono) + system + store + "View" chev
    below: checked-in bookings awaiting session start
    Empty: EmCard "No active session right now"
  Tab C — History:
    SliverList grouped by month:
      EmSectionHead(month + year, sub: total count)
      BookingHistoryRow or SessionHistoryRow per item
```

#### S-20 Booking Detail `/sessions/booking/:id`
```
EmTopBar("Booking")
EmScrollContent:
  Large status EmTag(kind, label) — full width centered
  EmCard: system EmAvatar(lg) | store name | system name | seat
  EmMetaRow × booking time fields (date, start, end, duration)
  Divider
  EmMetaRow × pricing (base, discounts, total)
  EmMetaRow × payment (method, status EmTag)
  SizedBox(xl)
Sticky bottom — contextual by status:
  pending      → Row[EmButton("Pay Now"), EmButton("Cancel", variant: ghost)]
  confirmed (before window) → EmButtonFull("Cancel Booking", variant: dangerOutline)
  confirmed (in window)     → Row[EmButtonFull("Check In"), EmButton("Cancel", variant: ghost)]
  checked_in   → EmButtonFull("View Active Session")
  cancelled / no_show → EmButtonFull("File Dispute", variant: ghost)
```

#### S-21 Payment (bottom sheet)
```
Sheet drag handle
EmSectionHead("Payment")
EmCard(inset): booking summary + amount EmChip
PaymentMethodList: 5 tappable rows (Cash/UPI/Card/Credits)
  Credits: shows balance
SizedBox(lg)
EmButtonFull("Confirm Payment") → PaymentNotifier.pay()
```

#### S-22 Check-In `/sessions/booking/:id/check-in`
```
EmTopBar("Check In")
Center column:
  QR code widget (booking ID encoded, white EmCard background, 200×200)
  EmSectionHead("OR")
  EmButtonFull("Tap to Check In") → POST check-in
  countdown "Check-in window open for Xm"
```

#### S-23 Active Session `/sessions/active/:id`
```
StatefulWidget (AnimationController for pulsing dot — AnimationController is the ONLY reason)
SafeArea
Padding(md):
  Row: store name (small) | system type EmChip
  SizedBox(xl)
  Center: EmLiveDot + "IN PROGRESS" meta label
  SizedBox(sm)
  Center: time remaining in AppTypography.hero (mono, countdown)
  Center: "elapsed Xh Ym" in bodyR
  SizedBox(xl)
  EmCard(variant: tint):
    system name (h2) | seat EmChip
  SizedBox(md)
  EmCard(variant: inset):
    EmMetaRow("Est. cost", "₹X.XX")
  SizedBox(md)
  EmCard(variant: inset):
    info row: sos icon + "Need more time? Visit the counter"
  SizedBox(md)
  EmCard(variant: inset):
    "X events logged" — session logs teaser
```

WebSocket: listen on `playerWsProvider` → `session.ended` navigates away, `session.extended` updates state.
Fallback: `Timer.periodic(30s)` calls `activeSessionNotifierProvider.notifier.refresh()` if WS unavailable.

#### S-24 Session History Detail `/sessions/history/:id`
```
EmTopBar("Session")
EmScrollContent:
  EmCard: store, system, platform EmChip, date
  EmMetaRow × time (start, end, duration)
  Divider
  EmMetaRow × billing (rate, multiplier, total)
  EmMetaRow × payment (method, status EmTag)
  if creditsEarned > 0: EmCard(variant: tint) credits earned row
  SizedBox(xl)
  if disputeWindowOpen: EmButtonFull("File a Dispute", variant: ghost) → push S-37
```

#### S-25 Billing History `/sessions/billing`
```
EmTopBar("Billing History")
EmStoreSelectorPill (top)
SliverList grouped by month:
  EmSectionHead(month, sub: "Total ₹X")
  BillingRow: date | store | duration | amount | method | status EmTag
  Expandable: tap row shows inline breakdown EmCard(inset)
```

### Brain Sync After Phase 5
Create `brain/features/.registry/sessions.md`.
Update `brain/IMPLEMENTATION_PLAN.md` Phase 5 status → DONE.

---

## Phase 6 — Wallet ✓ DONE (2026-05-16)

> **Completed**: `WalletService` rewritten to use `ApiConstants.*` endpoints + added `getCampaigns()`. `WalletRepository` fixed `redeemCredits` to return `void`. `WalletData` class introduced with `balance + recentTransactions + campaigns`. `WalletNotifier` now `AsyncValue<WalletData>`, parallel-fetches all three in `_fetch()`. `CreditHistoryNotifier` with paginated append pattern. `RedeemCreditsNotifier` sealed state with two-step confirmation. `CampaignsNotifier` with `CampaignType?` filter + computed `filtered` getter. `CampaignDetailNotifier` as `FamilyNotifier<CampaignDetailState, String>`. Routes added: `creditHistory=/wallet/transactions`, `campaigns=/wallet/campaigns`, `campaignDetail=/wallet/campaigns/:id`. Screens: `CreditHistoryScreen`, `CampaignsScreen`, `CampaignDetailScreen`. Layouts: credit_history_mobile_layout (paginated, grouped by month), campaigns_mobile_layout (filter chips, campaign cards), campaign_detail_mobile_layout (full campaign detail + redeem CTA), redeem_credits_sheet (modal bottom sheet). `WalletMobileLayout` rewritten with real data — no more mock state. Registry at `brain/features/.registry/wallet.md`.
> **Deferred**: Wallet tablet layout still delegates to mobile (single-pane appropriate for now). `wallet_ui_notifier.dart` (old mock notifier) not deleted — still in codebase but no longer imported.

### Deliverables

#### Data Layer
- `CreditsService` — `GET /stores/:storeId/credits/balance`, `GET /stores/:storeId/credits/transactions`, `POST /stores/:storeId/credits/redeem`
- `CampaignsService` — `GET /stores/:storeId/campaigns/active`, `POST /stores/:storeId/campaigns/:id/redeem`
- `WalletNotifier` — `AsyncValue<WalletData>` (balance + recent transactions + campaigns)
- `CreditHistoryNotifier` — `AsyncValue<List<CreditTxModel>>` (paginated)
- `RedeemCreditsNotifier` — sealed state
- `CampaignsNotifier` — `AsyncValue<List<CampaignModel>>`
- `CampaignDetailNotifier(id)` — sealed state for redemption
- Models: `CreditBalanceModel`, `CreditTxModel`, `CampaignModel`

#### S-26 Wallet Home `/wallet`
```
Header: "Wallet" (title) + EmIconBtn(bell)
EmStoreSelectorPill
EmScrollContent:
  EmCard(variant: tint, padding: 22):
    "YOUR CREDITS" meta label
    credit count in AppTypography.hero (mono)
    "= ₹X.XX in-store value" body
    divider
    "Valid at {store} only" small + "How do I earn?" link
  Quick actions grid (3 cols):
    QuickActionTile: EmAvatar(icon) + label — Redeem / History / Campaigns
  EmCard(padding: 0):
    header row: "Recent" h2 + "See all →" link
    TransactionRow × 3: EmAvatar(icon, ok/err bg) | label + sub | ±amount num
  EmSectionHead("Active Campaigns")
  Horizontal scroll: MiniCampaignCard × n
```

#### S-27 Credit Transaction History `/wallet/transactions`
```
EmTopBar("Transactions")
Grouped ListView:
  EmSectionHead(month + year)
  TransactionRow × n: EmAvatar | description | date | ±amount EmChip
Pagination: load more on scroll end
```

#### S-28 Redeem Credits (bottom sheet)
```
Sheet handle
EmSectionHead("Redeem Credits")
EmCard(inset): balance display
Row: TextField(amount) + "Max" EmButton(small, ghost)
"500 credits = ₹50 off" body hint
SizedBox(lg)
EmButtonFull("Redeem") → RedeemCreditsNotifier.redeem(amount)
  success: pop + SnackBar
  INSUFFICIENT_CREDITS / CREDITS_EXPIRED: inline EmTag(err)
Confirmation step: replace button area with "Are you sure?" + confirm/cancel
```

#### S-29 Campaigns List `/wallet/campaigns`
```
EmTopBar("Campaigns")
Filter chips row: All / Discounts / Bonus Credits / Happy Hour / First Visit
ListView.builder of CampaignCard:
  EmAvatar(icon) | name (h3) | type EmTag | validity small
  EmProgressBar (if limited campaign — shows redeemed/total)
  "Eligible for you" EmTag(ok) if applicable
  EmButton("View", small: true) → push S-30
```

#### S-30 Campaign Detail `/wallet/campaigns/:id`
```
EmTopBar(campaign name)
EmScrollContent:
  Banner placeholder EmCard (grey, 160h)
  name (h1) + type EmTag
  EmCard: description + terms bodyR
  EmCard(inset): validity dates + time restrictions EmChip row
  EmCard(inset): eligibility info (tier, usage limit)
  EmCard(variant: tint): benefit summary (large) — "Save ₹100" or "Get 200 credits"
  if already redeemed: "Redeemed X time(s)" EmTag(mute)
  SizedBox(xl)
EmButtonFull("Redeem Now") → CampaignDetailNotifier.redeem()
```

### Brain Sync After Phase 6
Create `brain/features/.registry/wallet.md`.

---

## Phase 7 — Profile + Settings ✓ DONE (2026-05-16)

> **Completed**: `ProfileNotifier` (delegates to `AuthRepository.getUserProfile()`), `EditProfileNotifier` (sealed: Initial/Loading/Success/Error), `ChangePhoneNotifier` (sealed: Initial/Loading/OtpSent/Success/Error), `NotifPrefsNotifier` with `NotifPrefsData` (9 bool fields, debounced 1s PATCH), `DisputesListNotifier` (`AsyncValue<List<BillingDisputeModel>>`), `DisputeDetailNotifier` (FamilyNotifier by id, sealed: Loading/Data/Error), `CreateDisputeNotifier` (sealed: Initial/Loading/Success/Error). Screens: S-31 profile home, S-32 edit profile, S-33 change phone, S-34 notification prefs, S-35 disputes list. Dispute screens S-36 (detail) and S-37 (create) rewritten with real API + new sealed state. Routes moved from `/disputes/*` → `/profile/disputes/*`. `app_router.dart` updated with 4 new GoRoute entries. Registries: `brain/features/.registry/profile.md` + `disputes.md`.
> **Deferred**: OTP entry widget for change-phone step 2 — stub button shown pending Phase 8 OTP sheet. Stats row (sessions/hours/stores) shows `—` pending a dedicated stats API endpoint. Billing history route (`/sessions/billing`) navigation from profile reuses Phase 5 BillingHistoryScreen.

### Deliverables

#### Data Layer
- `ProfileService` — `GET /auth/me`, `PATCH /auth/me`, `POST /auth/phone/change`, `POST /auth/logout`
- `NotificationPrefsService` — `GET /notifications/preferences`, `PATCH /notifications/preferences`, `PATCH /auth/me/device`
- `DisputesService` — `GET /stores/:storeId/disputes/my`, `GET /stores/:storeId/disputes/:id`, `POST /stores/:storeId/disputes`, `POST /stores/:storeId/disputes/:id/withdraw`
- `ProfileNotifier` — `AsyncValue<UserModel>`
- `EditProfileNotifier` — sealed state
- `ChangePhoneNotifier` — sealed state (step1: send OTP / step2: verify)
- `NotificationPrefsNotifier` — `AsyncValue<NotificationPrefs>` + debounced PATCH
- `DisputesListNotifier` — `AsyncValue<List<DisputeModel>>`
- `DisputeDetailNotifier(id)` — `AsyncValue<DisputeModel>`
- `CreateDisputeNotifier` — sealed state
- Models: `NotificationPrefs`, `DisputeModel`

#### S-31 Profile Home `/profile`
```
EmScrollContent:
  EmCard(variant: tint):
    Row: EmAvatar(xl, letter=initial) | name (h2) + email/phone (bodyR) + "Member since X" small
  Stats row: 3 EmChip (sessions played, hours, stores visited)
  SizedBox(md)
  Menu list (EmCard, padding 0):
    MenuItem × 6: HugeIcon + label (body) + chevron EmIconBtn
      Edit Profile, Change Phone, Notification Preferences,
      Billing History, My Disputes, Help & Support
  SizedBox(xl)
  EmButtonFull("Sign Out", variant: dangerOutline)
    → showDialog confirm → POST /auth/logout → context.go('/auth')
```

#### S-32 Edit Profile `/profile/edit`
```
EmTopBar("Edit Profile") with save trailing button
EmScrollContent:
  TextField: Full Name (required)
  TextField: Email + verification badge EmTag(ok/"Unverified")
  if email changed: show verification pending notice
EmButtonFull("Save Changes") → EditProfileNotifier.save()
```

#### S-33 Change Phone `/profile/change-phone`
```
EmTopBar("Change Phone")
Step 1:
  Phone input with country code picker + TextField
  EmButtonFull("Send OTP") → POST /auth/phone/change → show OtpInputSheet
Step 2 handled by OtpInputSheet (Phase 8)
```

#### S-34 Notification Preferences `/profile/notifications`
```
EmTopBar("Notifications")
EmScrollContent:
  EmSectionHead("Channels")
  EmCard(padding 0):
    ToggleRow × 4: Push / Email / SMS / In-App (last disabled, always on)
  EmSectionHead("When to notify me")
  EmCard(padding 0):
    ToggleRow × 6: booking confirm / reminders / session ending / credits / campaigns / disputes
Every toggle → NotificationPrefsNotifier.update() (debounced 1s)
Push toggle ON → request OS permission → PATCH /auth/me/device
```

#### S-35 Disputes List `/profile/disputes`
```
EmTopBar("My Disputes") with trailing "+" → push S-37
EmScrollContent:
  ListView.builder of DisputeRow:
    session ref EmChip | date | disputed amount | status EmTag
  Empty: EmCard "No disputes filed"
```

#### S-36 Dispute Detail `/profile/disputes/:id`
```
EmTopBar("Dispute")
EmScrollContent:
  Large status EmTag (full width, appropriate kind)
  EmCard: session ID, date, store, system
  EmMetaRow × amounts (original charge, disputed)
  EmCard(inset): player's description bodyR
  if resolved: EmCard(variant: tint): resolution type + admin notes
  EmSectionHead("Timeline")
  TimelineList: status change rows with timestamps
  SizedBox(xl)
  if status == open: EmButtonFull("Withdraw Dispute", variant: dangerOutline)
    → confirm dialog → POST .../withdraw
```

#### S-37 Create Dispute (bottom sheet or push)
```
EmTopBar("File a Dispute")
EmScrollContent:
  Session selector (if not pre-filled): tap to open session picker sheet
  Selected session: EmCard(inset) — session ref + date
  TextField: Reason (max 500 chars, required) + char counter
  TextField: Disputed amount (optional, numeric)
  TextField: Additional notes (optional)
EmButtonFull("Submit Dispute") → CreateDisputeNotifier.submit()
  success: context.pushReplacement(disputeDetail) + SnackBar
```

### Brain Sync After Phase 7
Create `brain/features/.registry/profile.md` and `disputes.md`.

---

## Phase 8 — Global Overlays ✓ DONE (2026-05-16)

> **Completed**: `NotificationsNotifier` rewritten with `AsyncValue<NotificationsData>` backed by real API (replaces mock `NotifItem` data). `showNotificationCenter(context)` full-screen modal sheet (O-38) with `NotificationCenterContent` ConsumerWidget — lists notifications with unread dot, mark-all-read, inline empty state. `showNotificationDetail(context, ref, notification)` sheet (O-39) with auto-mark-as-read on open and action CTA. `StoreSelectorNotifier` (`AsyncValue<List<StoreModel>>`, debounced search) + `showStoreSelectorSheet(context)` (O-40) — updates `activeStoreIdProvider` + persists via `TokenStorage`. `showOtpInputSheet(context, phone, onVerify, onResend)` — 6-box auto-advance OTP, 45s countdown, attempt counter warning. Bell icon in Home/Sessions/Wallet layouts now calls `showNotificationCenter` (not route push). Store selector in Wallet + Booking layouts now calls `showStoreSelectorSheet`. `ChangePhoneMobileLayout` wired to show OTP sheet via `ref.listen` on `ChangePhoneOtpSent`; `ChangePhoneNotifier.verifyOtp` + `AuthService/Repository.verifyPhoneChange` added. Registry at `brain/features/.registry/overlays.md`.
> **Deferred**: Bell badge (unread count dot) — Phase 10 polish. Notification detail deep-link navigation — Phase 9. WS `prependNew()` dispatch — Phase 9 app wiring.

### Deliverables

#### O-38 Notification Center (full-screen modal)
Opened via bell icon in any header. Uses `showModalBottomSheet(isScrollControlled: true, useSafeArea: true)`.

```
Sheet handle
Row: "Notifications" (h2) + "Mark all read" link → POST /notifications/read-all
ListView.builder of NotificationRow:
  EmAvatar(icon: type icon, bg: kind-appropriate) | title (body, bold if unread) + preview (small) + time (meta) | unread dot EmLiveDot
Tap row → show O-39 (push inside modal)
Empty: EmCard "You're all caught up"
```

State: `notificationsNotifierProvider` — `AsyncValue<NotificationsData>` (list + unread count).
Unread count badge on bell icon (shown in all tab headers).

#### O-39 Notification Detail Sheet (bottom sheet)
Pushed from within Notification Center, or shown directly.

```
EmTopBar(notification.title)
EmScrollContent:
  notification.body (bodyR, full text)
  SizedBox(sm)
  timestamp (meta)
  SizedBox(xl)
  if deepLink action exists: EmButtonFull(actionLabel) → navigate to linked screen
```

Auto-marks as read on open: `PATCH /notifications/:id/read`.

#### O-40 Store Selector Sheet (bottom sheet)
Opened from `EmStoreSelectorPill` anywhere.

```
Sheet handle + "Select Store" EmSectionHead
TextField (search, auto-focus, debounced 300ms)
SliverList:
  EmSectionHead("Recent") — stores from user history
  StoreSelectRow × n: store name | location small | active indicator if current
  EmSectionHead("All Stores")
  StoreSelectRow × n
Tap row:
  ref.read(activeStoreIdProvider.notifier).state = store.id
  TokenStorage.saveActiveStoreId(store.id)
  Navigator.pop(context)
  caller screen auto-refreshes via provider watch
```

State: `storeSelectorNotifierProvider` — `AsyncValue<List<StoreModel>>`.

#### OTP Input Sheet (reusable bottom sheet)
Used by: Change Phone (S-33) and any future re-auth flow.

```
Sheet handle
masked phone display (small)
6-box OTP input (Row of 6 TextField, auto-advance on digit, auto-submit on last)
countdown "Resend in 0:45" + Resend link (active after 0)
attempt counter warning after 3 fails
EmButtonFull("Verify") (shown only if not auto-submitting)
```

State managed via `OtpSheetNotifier` (sealed: idle / loading / success / error).
On success → caller-provided `onSuccess(String otp)` callback.

### Brain Sync After Phase 8
Create `brain/features/.registry/overlays.md`.

---

## Phase 9 — Routes + Auth Guard ✓ DONE (2026-05-16)

> **Completed**: `paymentSheet` route constant added to `AppRoutes`. All GoRoutes were already wired from prior phases. Auth guard wired in `routerProvider` with `ValueNotifier` `refreshListenable` + `redirect` callback. Deep link `gzapp://` scheme registered in `AndroidManifest.xml` and `ios/Runner/Info.plist`. `brain/rules/navigation.md` updated with Phase 9 additions section. Registry at `brain/features/.registry/navigation.md`.
> **Deferred**: Deep link path parameter routing (e.g. `gzapp://bookings/:id` → open notification overlay) — the URI scheme is registered but actual go_router `initialLocation` parsing from deep-link URIs is Phase 10 polish territory. WS event dispatch (`session.ended` navigation, `session.extended` timer) from Phase 5 deferral still pending Phase 10.

### Deliverables

#### Complete `AppRoutes` in `lib/core/navigation/routes.dart`
Add all missing constants:
```dart
// Sessions sub-routes
static const bookingDetail    = '/sessions/booking/:id';
static const paymentSheet     = '/sessions/booking/:id/pay';
static const checkIn          = '/sessions/booking/:id/check-in';
static const activeSession    = '/sessions/active/:id';
static const sessionDetail    = '/sessions/history/:id';
static const billingHistory   = '/sessions/billing';

// Wallet sub-routes
static const creditHistory    = '/wallet/transactions';
static const campaigns        = '/wallet/campaigns';
static const campaignDetail   = '/wallet/campaigns/:id';

// Profile sub-routes
static const editProfile      = '/profile/edit';
static const changePhone      = '/profile/change-phone';
static const notifPrefs       = '/profile/notifications';
static const disputesList     = '/profile/disputes';
static const createDispute    = '/profile/disputes/create';
static const disputeDetail    = '/profile/disputes/:id';

// Booking sub-routes (outside shell)
static const availability     = '/book/availability';
static const systemPicker     = '/book/systems';
static const bookSummary      = '/book/summary';
static const bookSuccess      = '/book/success';
```

#### Wire all `GoRoute` entries in `app_router.dart`

Screens outside the player shell (no BottomNav):
`/home/search`, `/home/store/:slug`, all `/book/*` sub-routes,
all `/sessions/booking/:id` sub-routes, `/sessions/active/:id`,
`/sessions/history/:id`, `/sessions/billing`,
all `/wallet/*` sub-routes, all `/profile/*` sub-routes.

#### Auth Guard
```dart
redirect: (context, state) {
  final authState = ref.read(authNotifierProvider);
  final isAuthenticated = authState is AuthAuthenticated;
  final isAdminAuthenticated = ref.read(adminAuthNotifierProvider) is AdminAuthAuthenticated;

  final loc = state.matchedLocation;
  final isAuthRoute = loc.startsWith('/auth') || loc == '/' || loc == '/onboarding';
  final isAdminRoute = loc.startsWith('/admin');

  if (!isAuthenticated && !isAuthRoute && !isAdminRoute) return AppRoutes.authLanding;
  if (isAuthenticated && isAuthRoute) return AppRoutes.home;
  if (isAdminRoute && !isAdminAuthenticated) return AppRoutes.adminLogin;
  return null;
}
```

#### Deep Link Handler
Register URI scheme `gzapp://` in Android `AndroidManifest.xml` and iOS `Info.plist`.
Map in router:
| URI | Route |
|-----|-------|
| `gzapp://reset-password?token=` | `AppRoutes.resetPassword` |
| `gzapp://stores/:slug` | `AppRoutes.storeDetail` |
| `gzapp://bookings/:id` | `AppRoutes.bookingDetail` |
| `gzapp://notifications` | open NotificationCenter overlay |

### Brain Sync After Phase 9
Update `brain/rules/navigation.md` with all new route constants (append section).

---

## Phase 10 — Polish

### Deliverables

#### Empty States
Every list screen must have a designed empty state — centered `EmCard`:
- Icon (EmAvatar with appropriate icon)
- Title (h2)
- Body text (bodyR, textSecondary)
- Optional CTA `EmButtonFull`

| Screen | Empty State |
|--------|-------------|
| S-11 Home (no stores) | "No stores nearby. Pull to refresh." |
| S-12 Store Search | "No stores found for '{query}'" |
| S-19 Activity — Upcoming | "No upcoming bookings. [Book a slot →]" |
| S-19 Activity — Active | "No active session right now" |
| S-19 Activity — History | "No activity yet" |
| S-25 Billing History | "No billing records" |
| S-27 Credit Tx History | "No transactions yet" |
| S-29 Campaigns | "No active campaigns at this store" |
| S-35 Disputes | "No disputes filed" |
| O-38 Notifications | "You're all caught up" |

#### Error Surfaces
All `AsyncValue.error` states use `PageErrorDisplay(error: AppPageError.from(e), onRetry: ...)`.
Check `lib/core/errors/` for `AppException` types and ensure all service errors map correctly.

#### Pull-to-Refresh
Add `RefreshIndicator` wrapper in:
S-11 (home feed), S-14 (systems), S-19 (activity hub), S-26 (wallet), S-35 (disputes list).

#### Connectivity Banner
Show `ConnectivityBanner` (or existing `NetworkChecker` integration) on any screen that
needs live data. When offline → banner + disable CTAs gracefully.

#### Entrance Animations
All list items: `flutter_animate` `.fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0)`
Staggered: `.animate(delay: (i * 60).ms)`
Screen transitions: default go_router (no custom transitions needed).

#### Accessibility
- All interactive widgets: `Semantics` label
- All `EmIconBtn`: `tooltip` param
- Minimum tap target 44×44 (already guaranteed by 38px + padding)

### Brain Sync After Phase 10
Final sync: review all `.registry/` files, update any gaps.
Update `IMPLEMENTATION_PLAN.md` — all phases DONE.

---

## Design Reference

All visual specs come from `design/src/`. Key mapping:

| Design file | Screens covered |
|-------------|-----------------|
| `screen-home.jsx` | S-11 |
| `screen-storesearch.jsx` | S-12 |
| `screen-store.jsx` | S-13 |
| `screen-booking.jsx` | S-14 → S-18 |
| `screen-activity.jsx` | S-19 |
| `screen-booking-detail.jsx` | S-20 |
| `screen-payment.jsx` | S-21 |
| `screen-checkin.jsx` | S-22 |
| `screen-session.jsx` | S-23 |
| `screen-session-history.jsx` | S-24 |
| `screen-billing-history.jsx` | S-25 |
| `screen-wallet.jsx` | S-26 |
| `screen-credit-transactions.jsx` | S-27 |
| `screen-redeem-credits.jsx` | S-28 |
| `screen-campaigns-list.jsx` | S-29 |
| `screen-campaign.jsx` | S-30 |
| `screen-profile-home.jsx` | S-31 |
| `screen-profile.jsx` | S-32 |
| `screen-change-phone.jsx` | S-33 |
| `screen-notification-prefs.jsx` | S-34 |
| `screen-disputes-list.jsx` | S-35 |
| `screen-dispute-detail.jsx` (TBD) | S-36 |
| `screen-dispute-create.jsx` (TBD) | S-37 |
| `screen-notifications.jsx` | O-38 |
| `screen-sheet-overlays.jsx` | O-39, O-40, OTP |
| `components.jsx` | All em_ widgets |
| `tokens.css` | AppColors, AppSpacing, AppTypography (already synced) |

---

## Architecture Reminders

- **No `setState`** in feature screens. `StatefulWidget` only for `AnimationController`.
- **No raw colors/sizes** — `AppColors.*`, `AppSpacing.*`, `AppTypography.*` always.
- **Screen is thin**: `XScreen extends StatelessWidget`, no `ref.watch`.
- **Layout owns state**: `XMobileLayout extends ConsumerWidget`, all `ref.watch` here.
- **Service → Repository → Notifier** chain. Never skip layers.
- **Icons**: `HugeIcon(icon: HugeIcons.strokeRounded*, color: ...)` only.
- **Navigation**: `context.go` for tab switches, `context.push` for drill-downs.
- **Models**: hand-written `fromJson`/`toJson`. No `freezed`, no `json_serializable`.
