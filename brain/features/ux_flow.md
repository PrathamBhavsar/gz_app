# Gaming Zone — Mobile UX Flow & Screen Inventory
> **Covers**: Player app only (single role) · 40 screens · All API endpoints
> **Design Philosophy**: Maximum data per screen. Navigate only when context genuinely changes. No empty screens.
> **For AI agents**: This file defines WHAT goes on each screen. Use `ui_standards.md` for HOW to build it. Use the feature registry for state, providers, and endpoints.

---

## NAVIGATION ARCHITECTURE

```
Auth Stack (no shell)
  / → /onboarding → /auth → /auth/register → /auth/otp → /auth/email-login
  /auth/oauth-handler, /auth/forgot-password, /auth/reset-password, /auth/email-verification-pending

Main App — 5-Tab Shell (MainPage)
  Tab 1: Home      /home
  Tab 2: Book      /book
  Tab 3: Sessions  /sessions
  Tab 4: Wallet    /wallet
  Tab 5: Profile   /profile

Global Overlays (modal sheets, no routes)
  NotificationCenter, NotificationDetailSheet, StoreSelectorSheet, OtpInputSheet
```

---

## AUTH SCREENS (10 screens)

### S-01: Splash `/`
- Logo + animation (~1.5s)
- Silent `GET /auth/me`
  - Valid token → `/home`
  - Expired → `POST /auth/refresh` → `/home` or `/auth`
  - No token → `/onboarding` (first launch) or `/auth`

### S-02: Onboarding `/onboarding`
- First launch only (local flag)
- 3–4 swipeable feature cards: "Book Gaming Slots", "Track Your Sessions", "Earn Credits & Rewards", "Real-Time Notifications"
- "Get Started" / "Skip" → `/auth`

### S-03: Auth Landing `/auth`
- Phone OTP button → bottom sheet for phone input → `POST /auth/login/otp` → `/auth/otp`
- "Continue with Email" → `/auth/email-login`
- Google + Apple OAuth buttons → `POST /auth/login/oauth/:provider`
- "Create account" → `/auth/register`

### S-04: Register `/auth/register`
- Full Name (required)
- Phone (optional, E.164 with country picker)
- Email (optional)
- Password (if email provided, min 8 chars)
- At least phone OR email required
- `POST /auth/register`
- Phone provided → `/auth/otp`; Email provided → `/auth/email-verification-pending`

### S-05: OTP Verification `/auth/otp`
- Masked phone display
- 6-box OTP input (auto-submit on last digit)
- Countdown + Resend link
- Attempt counter (warning after 3 fails)
- `POST /auth/verify/otp` → success: store tokens → `/home`
- Error states: `OTP_INVALID` (shake), `OTP_MAX_ATTEMPTS` (disable), `OTP_EXPIRED` (show resend)

### S-06: Email Login `/auth/email-login`
- Email + password (show/hide toggle)
- "Forgot password?" → `/auth/forgot-password`
- `POST /auth/login/email`
- `EMAIL_NOT_VERIFIED` → resend verification banner

### S-07: OAuth Handler `/auth/oauth-handler`
- Loading spinner only
- `POST /auth/login/oauth/:provider { code, state }`
- Success → `/home`; Failure → `/auth` with error toast

### S-08: Forgot Password `/auth/forgot-password`
- Email field
- `POST /auth/password/reset/request`
- Always show: "If registered, a link has been sent" (no email existence leak)

### S-09: Reset Password `/auth/reset-password` (deep link)
- Token extracted from `gzapp://reset-password?token=`
- New password + confirm (strength indicator)
- `POST /auth/password/reset/confirm { token, newPassword }`
- `TOKEN_EXPIRED` → error + link to `/auth/forgot-password`

### S-10: Email Verification Pending `/auth/email-verification-pending`
- Envelope animation + "Check your inbox"
- Email address shown
- Resend button (rate-limited 60s)
- "I've verified" → `GET /auth/me` to confirm

---

## TAB 1: HOME (3 screens)

### S-11: Home Feed `/home`
**All on one scroll:**
- Header: app logo + "Hey, [Name]" + bell icon (→ NotificationCenter overlay)
- Search bar → S-12
- Nearby/Featured stores: horizontal scroll cards (name, location, system count, rating, "Open now" badge) — Tap → S-13
- "New in your city" stores section
- Quick actions (if recent store): "Resume [store]" + upcoming booking card → S-20
- **API**: `GET /stores`
- Pull-to-refresh. Auto-refresh every 60s.

### S-12: Store Search `/home/search`
- Auto-focused search input
- Filter chips: PC / PS5 / VR / Xbox / Open Now
- Debounced search (300ms, min 2 chars)
- Results in same card format as Home Feed
- **API**: `GET /stores?search=&platform=`

### S-13: Store Detail `/home/store/:slug`
**All on one scroll:**
- Hero image carousel
- Store name, address, hours, contact
- System type chips with counts (PC, PS5, VR, Xbox)
- Active campaigns banner (horizontal scroll) → S-30
- "Book Now" CTA → sets store context → `/book`
- "View Slots" → `/book` (availability) with store pre-selected
- **API**: `GET /stores/:slug`, `GET /stores/:storeId/campaigns/active`

---

## TAB 2: BOOK (5 screens)

> All screens show "Booking at: {Store Name}" header with "Change store" → StoreSelectorSheet

### S-14: Systems Browser `/book`
- System type filter tabs: All / PC / PS5 / Xbox / VR / Other
- Grid of available system cards: name, type icon, "Available" badge, price/hr
- "Check Availability" CTA → S-15
- **API**: `GET /stores/:storeId/systems/available`
- Pull-to-refresh + auto-refresh every 30s

### S-15: Availability Calendar `/book` (sub-view or `/book/availability` TBD)
- Date strip: next 7 days (horizontal scroll)
- Time slot grid: Available (green) / Booked (grey, disabled) / Walk-in only (orange)
- Selected slot highlights in primary color
- "Select System" CTA → S-16
- **API**: `GET /stores/:storeId/bookings/availability?date=&systemTypeId=&duration=`

### S-16: System Picker `/book/systems`
- Selected date/time shown at top
- List of available systems for that slot: seat number, specs, image
- "Select" button per card → S-17
- **API**: `GET /stores/:storeId/systems/available` (filtered by slot)

### S-17: Booking Summary `/book/summary`
**All on one scroll — review + apply discounts + confirm:**
- Booking card: store, system, date/time, duration
- Price breakdown: rate × duration = subtotal + multiplier
- Apply Campaign section (collapsible): active campaigns list → select one
- Use Credits section (collapsible): balance shown, slider for amount to redeem
- Total after discounts
- Payment method selector: Cash / Card / UPI / Wallet / Credits
- "Confirm Booking" CTA
- **API**: `GET /stores/:storeId/campaigns/active`, `GET /stores/:storeId/credits/balance`
- **Confirm**: `POST /stores/:storeId/bookings { systemId, startTime, endTime, systemTypeId, campaignId?, creditsToRedeem?, paymentMethod }`

### S-18: Booking Confirmation `/book/success`
- Success checkmark animation
- Booking reference ID
- System name + date + time
- "Add to Calendar" button
- Payment status: "Payment confirmed" OR "Pay at store before {deadline}"
- Countdown: "Check-in opens in X hr Y min"
- "View Booking" → S-20 | "Back to Home" → `/home`

---

## TAB 3: SESSIONS / MY GAMES (7 screens)

### S-19: Activity Hub `/sessions`
**Top-tab navigator (3 tabs):**

**Tab A — Upcoming:**
- Bookings: pending, confirmed, checked_in
- Cards: store, system, date/time, status badge, countdown
- Tap → S-20
- Empty: "No upcoming bookings. [Book a slot →]"
- **API**: `GET /stores/:storeId/bookings/my?status=upcoming`

**Tab B — Active Session:**
- Live session card (if active): system, store, live timer, "View Session" → S-23
- WebSocket keeps this real-time
- Empty: "No active session right now"
- **API**: `GET /stores/:storeId/sessions/my?status=in_progress`

**Tab C — History:**
- All past bookings + ended sessions, grouped by month
- Tap booking → S-20; tap session → S-24
- **API**: `GET /stores/:storeId/bookings/my?status=past`, `GET /stores/:storeId/sessions/my?status=completed`

### S-20: Booking Detail (route TBD — pushed)
**All on one screen — status-aware action buttons:**
- Status badge (large, colored)
- Store + system info + seat number
- Date, start–end time, duration
- Pricing: base + discounts + total
- Payment: method + status
- Action buttons (contextual by status):
  - `pending` → Pay Now (→ S-21), Cancel Booking
  - `confirmed` (before check-in window) → Cancel Booking
  - `confirmed` (within check-in window) → Check In (→ S-22), Cancel Booking
  - `checked_in` → View Active Session (→ S-23)
  - `cancelled` / `no_show` → File Dispute (→ S-37)
- **API**: `GET /stores/:storeId/bookings/:id`
- Cancel: `POST /stores/:storeId/bookings/:id/cancel`

### S-21: Payment Screen (modal sheet — route TBD)
- Booking summary + amount due
- Payment method selector: Cash / UPI (QR or ID) / Card / Credits (shows balance)
- "Confirm Payment" CTA
- Idempotency key generated client-side (UUID)
- **API**: `POST /stores/:storeId/bookings/:id/pay { paymentMethod, idempotencyKey }`

### S-22: Check-In Screen (route TBD — pushed)
- Large animated QR code (booking ID encoded)
- "Tap to Check In" button (self-service)
- Countdown for check-in window
- **API**: `POST /stores/:storeId/bookings/:id/check-in`
- Success → S-23 (if session started) or S-20 (checked_in status)

### S-23: Active Session (route TBD — pushed)
**THE MOST TIME-CRITICAL SCREEN — WebSocket required:**
- Large live countdown timer (time remaining) + elapsed time
- System name, seat, platform icon, store name
- Pulsing green "In Progress" indicator (AnimationController loop)
- Estimated cost so far (rate × elapsed)
- "Need more time?" → info: "Visit the counter to extend"
- Session logs teaser
- **API**: `GET /stores/:storeId/sessions/:id`
- **WebSocket**: `/ws/users/:userId/notify?token=` → `session.ended` navigate away; `session.extended` update timer
- **Fallback**: poll every 30s if WebSocket unavailable

### S-24: Session History Detail (route TBD — pushed)
- Session summary: store, system, platform, date
- Time: start → end, total duration
- Billing: base rate, multiplier, total charged
- Payment: method, status
- Credits earned (if any)
- "File a Dispute" button (if within dispute window) → S-37
- **API**: `GET /stores/:storeId/sessions/:id`

### S-25: Billing History (route TBD — pushed)
- Grouped by month with month total
- Each row: store, date, duration, amount, payment method, status chip
- Tap row → inline expansion showing breakdown
- Store filter dropdown
- **API**: `GET /stores/:storeId/billing/my` (paginated)

---

## TAB 4: WALLET (5 screens)

> Store selector at top — credits are store-scoped. Always label "Credits at {Store Name}"

### S-26: Wallet Home `/wallet`
**All on one scroll:**
- Store selector pill: "Store: {name} ▼" → StoreSelectorSheet
- Credit balance card: large amount + store logo + "Earn more" tooltip
- Quick actions row: [Redeem Credits] [View History] [Campaigns]
- Recent transactions (last 5): amount, type, date — "See all" → S-27
- Active campaigns: horizontal scroll → S-30
- **API**: `GET /stores/:storeId/credits/balance`, `GET /stores/:storeId/credits/transactions?limit=5`, `GET /stores/:storeId/campaigns/active`

### S-27: Credit Transaction History (route TBD — pushed)
- Grouped by month
- Each row: type icon (Earned/Redeemed/Bonus/Adjust/Expired/Refund), description, amount (+/-), date
- **API**: `GET /stores/:storeId/credits/transactions` (paginated, 20/page)

### S-28: Redeem Credits (modal sheet)
- Current balance at top
- Amount input + "Max" button
- Equivalent value: "500 credits = ₹50 off"
- Confirmation step before redeem
- **API**: `POST /stores/:storeId/credits/redeem { amount }`
- `INSUFFICIENT_CREDITS` / `CREDITS_EXPIRED` → inline errors

### S-29: Campaigns List (route TBD — pushed)
- Filter tabs: All / Discounts / Bonus Credits / Happy Hour / First Visit
- Campaign cards: name, type badge, validity, eligibility, progress bar (if limited)
- **API**: `GET /stores/:storeId/campaigns/active`

### S-30: Campaign Detail (route TBD — pushed)
**All on one scroll:**
- Campaign banner image
- Name + type (e.g., "Happy Hour — 30% Off")
- Description + terms
- Validity: dates + time restrictions
- Eligibility: tier + usage limits
- Benefit: "Save ₹100" or "Get 200 bonus credits"
- "Redeem Now" CTA
- Redemption count if already redeemed
- **API**: `POST /stores/:storeId/campaigns/:id/redeem`

---

## TAB 5: PROFILE (7 screens)

### S-31: Profile Home `/profile`
**All on one scroll:**
- User card: avatar (initials), name, email/phone, member since
- Stats row: total sessions, hours played, stores visited
- Menu list: Edit Profile → S-32, Change Phone → S-33, Notification Preferences → S-34, Billing History → S-25, My Disputes → S-35, Help & Support (external)
- "Sign Out" button (bottom, `AppColors.error`)
  - Confirmation dialog
  - `POST /auth/logout` → clear tokens → `/auth`
- **API**: `GET /auth/me`

### S-32: Edit Profile (route TBD — pushed)
- Full Name field (required)
- Email field (optional; "Verified ✓" or "Unverified — resend" badge)
- **API**: `PATCH /auth/me { name?, email? }`

### S-33: Change Phone (route TBD — pushed)
- Step 1: New phone number input (E.164, country picker)
- "Send OTP" → `POST /auth/phone/change { newPhone }`
- Step 2: OtpInputSheet appears for new number verification
- `POST /auth/verify/otp` → success toast

### S-34: Notification Preferences (route TBD — pushed)
**All toggles on one screen:**
- Channels section: Push / Email / SMS / In-App (last always on, greyed)
- "When to notify" section: Booking confirmations / reminders / Session ending soon / Credit updates / New campaigns / Dispute updates
- Every toggle change → `PATCH /notifications/preferences` (debounced 1s)
- Push toggle ON → request OS permission → `PATCH /auth/me/device { fcmToken, platform }`
- **API**: `GET /notifications/preferences`, `PATCH /notifications/preferences`, `PATCH /auth/me/device`

### S-35: Disputes List (route TBD — pushed)
- "File a New Dispute" button → S-37
- Disputes list: session ref, date, disputed amount, status badge
- Status: Open (warning) / Under Review (primary) / Resolved (success) / Withdrawn (muted)
- **API**: `GET /stores/:storeId/disputes/my`

### S-36: Dispute Detail (route TBD — pushed)
**All on one scroll:**
- Status banner (colored)
- Session: ID, date, store, system
- Disputed amount: original charge + disputed portion
- Player's submitted description
- Resolution (if resolved): type + admin notes
- Timeline: status history with timestamps
- "Withdraw Dispute" button (only if `open`) + confirmation dialog
- **API**: `GET /stores/:storeId/disputes/:id`, `POST /stores/:storeId/disputes/:id/withdraw`

### S-37: Create Dispute (modal or pushed)
- Session selector (pre-filled if coming from S-24)
- Reason field (required, max 500 chars)
- Disputed amount (optional)
- Additional notes (optional)
- **API**: `POST /stores/:storeId/disputes { sessionId, reason, disputedAmount? }`
- Success → S-36 + success toast

---

## GLOBAL OVERLAYS (4 components — no routes)

### O-38: Notification Center (full-screen modal or slide-in)
- "Mark all as read" button
- Notification list: type icon, title, body preview, relative time, unread dot
- Tap → O-39
- Unread badge on bell icon (real-time via WebSocket)
- **API**: `GET /notifications` (paginated), `POST /notifications/read-all`
- **WebSocket**: `notification.new` → prepend + increment badge

### O-39: Notification Detail Sheet (bottom sheet)
- Full title + body
- Timestamp
- Deep-link action button (e.g., "View Booking" → S-20)
- Auto-marks as read on open
- **API**: `PATCH /notifications/:id/read`

### O-40: Store Selector Sheet (bottom sheet)
- Search bar
- Stores user has interacted with (history)
- All active stores
- Tap store → updates `activeStoreIdProvider` + `TokenStorage.saveActiveStoreId()` → dismisses + refreshes screen
- **API**: `GET /stores`

### OTP Input Sheet (reusable bottom sheet)
- Reused across: Register phone verify, Change Phone, any re-auth
- Same behavior as S-05 presented as dismissible sheet

---

## COMPLETE SCREEN INVENTORY

| # | Screen | Route (current) | Tab | Shell | APIs |
|---|---|---|---|---|---|
| S-01 | Splash | `/` | — | None | GET /auth/me, POST /auth/refresh |
| S-02 | Onboarding | `/onboarding` | — | None | None |
| S-03 | Auth Landing | `/auth` | — | None | POST /auth/login/otp, POST /auth/login/oauth/:provider |
| S-04 | Register | `/auth/register` | — | None | POST /auth/register |
| S-05 | OTP Verification | `/auth/otp` | — | None | POST /auth/verify/otp, POST /auth/login/otp |
| S-06 | Email Login | `/auth/email-login` | — | None | POST /auth/login/email |
| S-07 | OAuth Handler | `/auth/oauth-handler` | — | None | POST /auth/login/oauth/:provider |
| S-08 | Forgot Password | `/auth/forgot-password` | — | None | POST /auth/password/reset/request |
| S-09 | Reset Password | `/auth/reset-password` | — | None | POST /auth/password/reset/confirm |
| S-10 | Email Verify Pending | `/auth/email-verification-pending` | — | None | GET /auth/me |
| S-11 | Home Feed | `/home` | Home | BottomNav | GET /stores |
| S-12 | Store Search | `/home/search` | Home | None | GET /stores |
| S-13 | Store Detail | `/home/store/:slug` | Home | None | GET /stores/:slug, GET campaigns |
| S-14 | Systems Browser | `/book` | Book | BottomNav | GET systems/available |
| S-15 | Availability Calendar | TBD | Book | None | GET bookings/availability |
| S-16 | System Picker | `/book/systems` | Book | None | GET systems/available |
| S-17 | Booking Summary | `/book/summary` | Book | None | GET campaigns, GET credits, POST bookings |
| S-18 | Booking Confirmation | `/book/success` | Book | None | None |
| S-19 | Activity Hub | `/sessions` | Sessions | BottomNav | GET bookings/my, GET sessions/my |
| S-20 | Booking Detail | TBD | Sessions | None | GET bookings/:id, POST cancel |
| S-21 | Payment | TBD | Sessions | None | POST bookings/:id/pay |
| S-22 | Check-In | TBD | Sessions | None | POST bookings/:id/check-in |
| S-23 | Active Session | TBD | Sessions | None | GET sessions/:id + WebSocket |
| S-24 | Session History Detail | TBD | Sessions | None | GET sessions/:id |
| S-25 | Billing History | TBD | Sessions | None | GET billing/my |
| S-26 | Wallet Home | `/wallet` | Wallet | BottomNav | GET credits/balance, transactions, campaigns |
| S-27 | Credit Tx History | TBD | Wallet | None | GET credits/transactions |
| S-28 | Redeem Credits | TBD | Wallet | None | POST credits/redeem |
| S-29 | Campaigns List | TBD | Wallet | None | GET campaigns/active |
| S-30 | Campaign Detail | TBD | Wallet | None | POST campaigns/:id/redeem |
| S-31 | Profile Home | `/profile` | Profile | BottomNav | GET /auth/me |
| S-32 | Edit Profile | TBD | Profile | None | PATCH /auth/me |
| S-33 | Change Phone | TBD | Profile | None | POST /auth/phone/change, POST /auth/verify/otp |
| S-34 | Notification Prefs | TBD | Profile | None | GET/PATCH notifications/preferences, PATCH /auth/me/device |
| S-35 | Disputes List | TBD | Profile | None | GET disputes/my |
| S-36 | Dispute Detail | TBD | Profile | None | GET disputes/:id, POST withdraw |
| S-37 | Create Dispute | TBD | Profile | None | POST disputes |
| O-38 | Notification Center | overlay | — | None | GET notifications, POST read-all |
| O-39 | Notification Detail | overlay | — | None | PATCH notifications/:id/read |
| O-40 | Store Selector | overlay | — | None | GET /stores |

**Total: 40 screens (37 routes + 3 overlays)**

---

## BUILD ORDER (Recommended)

```
BLOCK 1 — Foundation
  S-01 Splash, S-02 Onboarding, S-03 Auth Landing, S-04 Register
  S-05 OTP, S-06 Email Login, S-08 Forgot Password

BLOCK 2 — Core Data Layer
  AppException, ApiClient, ConnectivityService/NetworkChecker
  AuthService, AuthRepository, AuthNotifier ← already implemented
  TokenStorage, accessTokenProvider, activeStoreIdProvider ← already implemented

BLOCK 3 — Home + Store
  S-11 Home Feed, S-12 Store Search, S-13 Store Detail

BLOCK 4 — Booking Flow
  S-14 Systems Browser, S-15 Availability Calendar
  S-16 System Picker, S-17 Booking Summary, S-18 Confirmation

BLOCK 5 — Sessions / My Games
  S-19 Activity Hub, S-20 Booking Detail
  S-21 Payment, S-22 Check-In
  Player WebSocket Manager → S-23 Active Session, S-24 Session History, S-25 Billing

BLOCK 6 — Wallet
  S-26 Wallet Home, S-27 Tx History, S-28 Redeem
  S-29 Campaigns List, S-30 Campaign Detail

BLOCK 7 — Profile + Settings
  S-31 Profile Home, S-32 Edit Profile, S-33 Change Phone
  S-34 Notification Prefs, S-35–37 Disputes

BLOCK 8 — Overlays
  O-38 Notification Center, O-39 Detail Sheet, O-40 Store Selector
  OTP Input Sheet (reusable)

BLOCK 9 — Auth edge cases
  S-07 OAuth Handler, S-09 Reset Password, S-10 Email Verify Pending
```
