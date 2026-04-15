# Gaming Zone — Player Mobile App: Complete UX Design
**Version**: 1.0 | **Target**: iOS & Android | **API Version**: 2.0.0

> This document defines every screen, navigation flow, and API integration for the Player Mobile App. It covers all player-accessible endpoints from the Gaming Zone SaaS API.

---

## 1. Overview

The mobile app serves **Players only** — the people who walk into or pre-book gaming sessions at physical gaming venues. It is one of three API consumers (the others are the Admin Dashboard and the System Agent desktop app).

### What the app enables
- Discover and explore gaming stores
- Browse available gaming systems (PCs, PS5s, VR rigs, etc.)
- Check slot availability and make bookings
- Pay for bookings and check in
- View active session status in real-time
- Manage store-specific loyalty credits
- Browse and redeem promotional campaigns
- View full play history and billing records
- File and track billing disputes
- Manage account, notification preferences, and device registration

### Total Screen Count: **40 screens**

---

## 2. Navigation Architecture

```
App
├── Auth Stack (Unauthenticated)
│   ├── Splash
│   ├── Onboarding
│   ├── Auth Landing
│   ├── Register
│   ├── OTP Verification
│   ├── Email Login
│   ├── OAuth Handler (deep link)
│   ├── Forgot Password
│   ├── Reset Password
│   └── Email Verification Pending
│
└── Main App (Authenticated) — Bottom Tab Navigator
    ├── Tab 1: Home
    │   ├── Home Feed
    │   ├── Store Search
    │   └── Store Detail
    │
    ├── Tab 2: Book
    │   ├── Systems Browser
    │   ├── Availability Calendar
    │   ├── System Picker
    │   ├── Booking Summary
    │   └── Booking Confirmation
    │
    ├── Tab 3: My Games
    │   ├── Activity Hub (top-tab: Upcoming | Sessions | History)
    │   ├── Booking Detail
    │   ├── Payment Screen
    │   ├── Check-In Screen
    │   ├── Active Session Screen
    │   ├── Session History Detail
    │   └── Billing History
    │
    ├── Tab 4: Wallet
    │   ├── Wallet Home
    │   ├── Credit Transaction History
    │   ├── Redeem Credits
    │   ├── Campaigns List
    │   └── Campaign Detail
    │
    └── Tab 5: Profile
        ├── Profile Home
        ├── Edit Profile
        ├── Change Phone
        ├── Notification Preferences
        ├── Disputes List
        ├── Dispute Detail
        └── Create Dispute
│
└── Global Overlays (accessible anywhere)
    ├── Notification Center (bell icon in header)
    ├── Notification Detail Sheet
    ├── Store Selector Sheet
    └── OTP Input Sheet (reusable)
```

---

## 3. Auth Stack — Unauthenticated Screens

### Screen 01 — Splash Screen
**Access**: App launch, before auth check  
**Purpose**: Brand intro while token validation runs in background

- Displays logo + animation (~1.5s)
- Silently validates stored access token (call `GET /auth/me`)
  - If valid → Navigate to Main App (Home tab)
  - If expired → Try `POST /auth/refresh` with stored refresh token
    - If refresh succeeds → Navigate to Main App
    - If refresh fails → Navigate to Auth Landing
  - If no token → Navigate to Onboarding (first launch) or Auth Landing

**API calls**: `GET /auth/me`, `POST /auth/refresh`

---

### Screen 02 — Onboarding Screen
**Access**: First launch only (tracked via local flag)  
**Purpose**: Feature highlights before sign-up

- 3–4 swipeable cards: "Book Gaming Slots", "Track Your Sessions", "Earn Credits & Rewards", "Real-Time Notifications"
- "Get Started" CTA on last card → Auth Landing
- "Skip" link on all cards → Auth Landing

**API calls**: None

---

### Screen 03 — Auth Landing Screen
**Access**: From Splash (unauthenticated) or Onboarding  
**Purpose**: Central login/register hub

- **Phone OTP** button → OTP Verification Screen (sends OTP first)
- **Continue with Email** button → Email Login Screen
- **Continue with Google** button → OAuth flow
- **Continue with Apple** button → OAuth flow
- **Create an account** link → Register Screen

When "Phone OTP" is tapped:
- Bottom sheet appears: "Enter your phone number" (E.164 format input)
- On submit → `POST /auth/login/otp { phone }` → Navigate to OTP Verification Screen

**API calls**: `POST /auth/login/otp`, `POST /auth/login/oauth/:provider`

---

### Screen 04 — Register Screen
**Access**: From Auth Landing ("Create an account")  
**Purpose**: New account creation

**Form fields:**
- Full Name (required, 2–100 chars)
- Phone number (optional, E.164, with country picker)
- Email address (optional)
- Password (optional, min 8 chars, shown if email provided)

**Logic:**
- At least one of phone or email required
- On submit → `POST /auth/register { name, email?, phone?, password? }`
- If phone provided → Redirect to OTP Verification Screen
- If email provided → Redirect to Email Verification Pending Screen
- Success with neither needing verification (edge case) → Main App

**Validation**: Real-time field validation matching API constraints  
**API calls**: `POST /auth/register`

---

### Screen 05 — OTP Verification Screen
**Access**: From Auth Landing (phone OTP flow) or Register (if phone provided)  
**Purpose**: Verify 6-digit OTP sent via SMS

**UI elements:**
- Phone number display (masked: +91 ••••• 67890)
- 6-box OTP input (auto-focuses, auto-submits on last digit)
- Countdown timer "Resend in 0:45"
- "Resend OTP" link (active after countdown; triggers `POST /auth/login/otp`)
- OTP attempt counter (show warning after 3 failures: "2 attempts remaining")

**Logic:**
- Auto-submit when all 6 digits entered
- `POST /auth/verify/otp { phone, code }`
- On success → Store `accessToken` + `refreshToken` → Navigate to Main App (Home tab)
- On `OTP_INVALID` → Shake animation, show inline error
- On `OTP_MAX_ATTEMPTS` → Disable input, show "Too many attempts. Request a new OTP." + Resend button
- On `OTP_EXPIRED` → Show expiry message + Resend button

**API calls**: `POST /auth/verify/otp`, `POST /auth/login/otp` (resend)

---

### Screen 06 — Email Login Screen
**Access**: From Auth Landing ("Continue with Email")  
**Purpose**: Email + password authentication

**Form fields:**
- Email address
- Password (with show/hide toggle)
- "Forgot password?" link → Forgot Password Screen

**Logic:**
- `POST /auth/login/email { email, password }`
- On success → Store tokens → Main App
- On `EMAIL_NOT_VERIFIED` → Show banner: "Please verify your email first. [Resend verification]"
- On `INVALID_CREDENTIALS` → Inline error

**API calls**: `POST /auth/login/email`

---

### Screen 07 — OAuth Handler Screen
**Access**: Deep link callback from Google/Apple OAuth redirect  
**Purpose**: Process OAuth token exchange

- Displays loading spinner ("Signing you in...")
- Receives `code` + `state` from OAuth redirect URI
- `POST /auth/login/oauth/:provider { code, state }`
- On success → Store tokens → Navigate to Main App
- On `OAUTH_FAILED` → Navigate back to Auth Landing with error toast

**API calls**: `POST /auth/login/oauth/:provider`

---

### Screen 08 — Forgot Password Screen
**Access**: From Email Login Screen  
**Purpose**: Initiate password reset via email

**Form fields:**
- Email address

**Logic:**
- `POST /auth/password/reset/request { email }`
- Always shows success message regardless of whether email exists (security: don't leak existence)
- Shows: "If that email is registered, a reset link has been sent."
- "Back to Login" button

**API calls**: `POST /auth/password/reset/request`

---

### Screen 09 — Reset Password Screen
**Access**: Deep link from password reset email (`/reset-password?token=...`)  
**Purpose**: Set a new password using the reset token

**Form fields:**
- New Password (min 8 chars, strength indicator)
- Confirm New Password

**Logic:**
- Extracts `token` from deep link URL
- `POST /auth/password/reset/confirm { token, newPassword }`
- On success → "Password updated successfully" → Navigate to Auth Landing
- On `TOKEN_EXPIRED` → "This reset link has expired. Request a new one." + link to Forgot Password
- On `NOT_FOUND` → Same expired message (don't differentiate)

**API calls**: `POST /auth/password/reset/confirm`

---

### Screen 10 — Email Verification Pending Screen
**Access**: After Register with email, or from Email Login with `EMAIL_NOT_VERIFIED`  
**Purpose**: Inform user to check their email

- Animated envelope illustration
- "Check your inbox" headline
- Email address shown
- "Resend verification email" button (rate-limited: disabled for 60s after send)
- "I've verified, continue" button → Attempts `GET /auth/me` to confirm verification status

**API calls**: `GET /auth/me` (to check verification)

---

## 4. Main App — Tab Navigator

After authentication, the app uses a **5-tab bottom navigation bar**. A **store context** must be selected before accessing store-scoped features (bookings, credits, campaigns, disputes). A persistent "active store" is stored in app state (last visited store becomes default).

---

## 5. Tab 1: Home

### Screen 11 — Home Feed
**Tab**: Home  
**Access**: Tab bar, default landing after login

**Sections:**
1. **Header**: App logo + greeting ("Hey, Pratham 👾") + bell icon (Notification Center)
2. **Search bar** → Store Search Screen
3. **Nearby / Featured Stores** — Horizontal scroll card list
   - Card: Store name, location, system count, rating, "Open now" badge
   - Tap → Store Detail Screen
4. **"New in your city"** — Recently added stores
5. **Quick actions** (if user has a recent store):
   - "Resume" last visited store
   - "My upcoming booking" quick card → Booking Detail

**API calls**: `GET /stores` (with filters for active, paginated)  
**Refresh**: Pull-to-refresh, re-fetches store list

---

### Screen 12 — Store Search Screen
**Tab**: Home (pushed)  
**Access**: Search bar on Home Feed

**UI elements:**
- Full-width search input (auto-focused)
- Filter chips: Platform (PC / PS5 / VR / Xbox), Open Now
- Search results list (same card format as Home Feed)
- Empty state: "No stores found for '{query}'"

**API calls**: `GET /stores` (with search/filter query params)  
**Behavior**: Debounced search (300ms), minimum 2 chars

---

### Screen 13 — Store Detail Screen
**Tab**: Home (pushed) | also accessible from Tab 2 store selection  
**Access**: Tap any store card

**Sections:**
1. **Hero image** (store photos carousel)
2. **Store name, address, hours, contact**
3. **System type chips** (PC Gaming, PS5, VR, Xbox Series X) with count per type
4. **Active Campaigns banner** — Horizontal scroll, tap → Campaign Detail
5. **"Book Now" CTA** — Sets this store as active store context → Navigate to Tab 2 (Systems Browser)
6. **"View Slots"** shortcut → Availability Calendar with this store pre-selected

**API calls**: `GET /stores/:slug`, `GET /stores/:storeId/campaigns/active`

---

## 6. Tab 2: Book

All screens in this tab share a store context (shown in header as "Booking at: {Store Name}" with a change button).

### Screen 14 — Systems Browser
**Tab**: Book (root)  
**Access**: Tab 2, or "Book Now" from Store Detail

**Purpose**: Show available gaming systems grouped by type

**UI:**
- Store context banner at top with "Change store" link
- Filter: System Type tabs (All / PC / PS5 / Xbox / VR / Other)
- Grid or list of available systems
  - System card: name, type icon, "Available" badge, price/hr
- "Check Availability" CTA at bottom → Availability Calendar

**API calls**: `GET /stores/:storeId/systems/available`  
**Refresh**: Pull-to-refresh + auto-refresh every 30s (systems change status frequently)

---

### Screen 15 — Availability Calendar
**Tab**: Book (pushed)  
**Access**: From Systems Browser or "View Slots" on Store Detail

**Purpose**: Pick a date and time slot

**UI:**
- Date picker: Horizontal scrollable date strip (next 7 days, within store's `booking_window_minutes`)
- Time grid: 30-min or 1-hr slots displayed in a scrollable list
  - Slot states: Available (green) | Booked (grey, disabled) | Walk-in only (orange)
- System type filter (carry-over from Systems Browser)
- Selected slot highlights in blue
- "Select System" CTA → System Picker

**API calls**: `GET /stores/:storeId/bookings/availability` (with `date`, `systemTypeId`, `duration` params)  
**Note**: The store's booking config (`booking_window_minutes`, `check_in_early_minutes`) controls which dates are selectable.

---

### Screen 16 — System Picker
**Tab**: Book (pushed)  
**Access**: From Availability Calendar after selecting a slot

**Purpose**: Choose the specific gaming system for the selected time slot

**UI:**
- Selected date/time shown at top (e.g., "Sat, Apr 18 · 4:00 PM – 5:00 PM")
- List of available systems for that slot, filtered by type
  - System card: seat number, specs (e.g., "RTX 4090, 240Hz"), image
- "Select" button on each card

**API calls**: `GET /stores/:storeId/systems/available` (filtered by slot time)

---

### Screen 17 — Booking Summary Screen
**Tab**: Book (pushed)  
**Access**: From System Picker after selecting a system

**Purpose**: Review booking details before confirming; apply credits/campaigns

**Sections:**
1. **Booking summary card**:
   - Store name
   - System name + type
   - Date & time
   - Duration
2. **Base price breakdown**:
   - Rate × Duration = Subtotal
   - Any peak/off-peak multiplier shown
3. **Apply Campaign** (collapsible section):
   - List of active campaigns → `GET /stores/:storeId/campaigns/active`
   - Select campaign to apply discount/bonus
4. **Use Credits** (collapsible section):
   - Current balance: X credits at this store → `GET /stores/:storeId/credits/balance`
   - Slider or input for credits to redeem
   - Equivalent discount shown
5. **Total** (after discounts)
6. **Payment method selector**: Cash / Card / UPI / Wallet / Credits
7. **"Confirm Booking"** button

**API calls**:
- `GET /stores/:storeId/campaigns/active`
- `GET /stores/:storeId/credits/balance`
- `POST /stores/:storeId/bookings { systemId, startTime, endTime, systemTypeId, campaignId?, creditsToRedeem?, paymentMethod }`

**Business rules**:
- Server re-calculates price — client-provided prices are never trusted
- Booking mutex acquired server-side to prevent double booking
- Within `booking_window_minutes` window only

---

### Screen 18 — Booking Confirmation Screen
**Tab**: Book (pushed, replaces stack on success)  
**Access**: After successful booking creation

**UI:**
- Large success checkmark animation
- Booking reference ID (short code)
- System name, date, time
- "Add to calendar" button
- **Payment status badge**:
  - If paid upfront → "Payment confirmed"
  - If pay-at-store → "Pay at store before {payment_window deadline}"
- Countdown: "Check-in opens in X hours Y min"
- Two CTAs:
  - "View Booking" → Booking Detail Screen
  - "Back to Home" → Tab 1

**API calls**: None (data passed from previous screen)

---

## 7. Tab 3: My Games

### Screen 19 — Activity Hub
**Tab**: My Games (root)  
**Access**: Tab bar

**Purpose**: Central view for all user activity across stores

**Top-tab navigator (3 tabs):**

#### Tab A: Upcoming
- Bookings with status: `pending`, `confirmed`, `checked_in`
- Cards show: Store, system, date/time, status badge, countdown
- Tap → Booking Detail Screen
- Empty state: "No upcoming bookings. [Book a slot →]"
- **API**: `GET /stores/:storeId/bookings/my?status=upcoming` — note: requires iterating across stores the user has bookings in, or a global `/bookings/my` endpoint

#### Tab B: Active Session
- If user has an active session (`in_progress`) — prominent live card at top
  - System name, store, live timer (synced from API), "View Session" → Active Session Screen
  - WebSocket keeps this real-time
- Below: any checked-in bookings awaiting session start
- Empty state: "No active session right now"
- **API**: `GET /stores/:storeId/sessions/my?status=in_progress`

#### Tab C: History
- All past bookings (cancelled, no_show, completed) and ended sessions
- Grouped by month
- Tap booking → Booking Detail; tap session → Session History Detail
- **API**: `GET /stores/:storeId/bookings/my?status=past`, `GET /stores/:storeId/sessions/my?status=completed`

---

### Screen 20 — Booking Detail Screen
**Tab**: My Games (pushed)  
**Access**: Tap any booking in Activity Hub

**Sections:**
1. **Status badge** (large, colored): Pending / Confirmed / Checked In / Cancelled / No Show
2. **Store + system info**: Store name, system name, seat number, type icon
3. **Booking time**: Date, start–end time, duration
4. **Pricing**: Base price, any discounts applied, total
5. **Payment info**: Method, status (pending/paid/refunded)
6. **Action buttons** (contextual based on status + timing):

| Status | Available Actions |
|--------|------------------|
| `pending` | Pay Now, Cancel Booking |
| `confirmed` (before check-in window) | Cancel Booking |
| `confirmed` (within check-in window) | Check In, Cancel Booking |
| `checked_in` | View Active Session |
| `cancelled` | (none — read only) |
| `no_show` | File Dispute |

**API calls**:
- `GET /stores/:storeId/bookings/:id`
- Action buttons trigger: Payment Screen, Check-In Screen, or Active Session Screen

---

### Screen 21 — Payment Screen
**Tab**: My Games (modal/sheet)  
**Access**: "Pay Now" on Booking Detail (when booking is pending and within payment window)

**UI:**
- Booking summary at top
- Amount due
- Payment method selector:
  - Cash (pay at store)
  - UPI (with UPI ID input or QR)
  - Card
  - Credits (shows available balance)
- "Confirm Payment" button

**API calls**: `POST /stores/:storeId/bookings/:id/pay { paymentMethod, idempotencyKey }`  
**Note**: `idempotencyKey` is generated client-side (UUID) to prevent duplicate payments on retry.

---

### Screen 22 — Check-In Screen
**Tab**: My Games (pushed)  
**Access**: "Check In" on Booking Detail (within check-in window: `check_in_early_minutes` before slot)

**UI:**
- Large animated QR code (booking ID encoded) for staff to scan
- "OR" divider
- "Tap to Check In" button (for self-service terminals)
- Countdown showing how long check-in window is open

**Logic**:
- `POST /stores/:storeId/bookings/:id/check-in`
- On success → Navigate to Active Session Screen (if session has started) or Booking Detail (checked_in status)

**API calls**: `POST /stores/:storeId/bookings/:id/check-in`

---

### Screen 23 — Active Session Screen
**Tab**: My Games (pushed) | also surfaced in Activity Hub Tab B  
**Access**: Active session card in Activity Hub, or from Booking Detail post-check-in

**Purpose**: Real-time session monitor — the most time-critical screen in the app

**Sections:**
1. **Live timer**: Large countdown (time remaining) + elapsed time
   - Timer syncs via WebSocket `ws/users/:userId/notify` — `session.extended` / `session.ended` events
   - Fallback: poll `GET /stores/:storeId/sessions/:id` every 30s
2. **System info**: System name, seat, platform icon
3. **Store name**
4. **Session status indicator**: In Progress (pulsing green dot)
5. **Estimated cost so far**: Calculated from rate × elapsed minutes (server-authoritative at billing)
6. **"Need more time?" CTA**: Informs player to request extension at the counter (walk up to admin) — does not call extend API (that's admin-only)
7. **Session logs teaser**: "3 events logged" (informational)

**API calls**: `GET /stores/:storeId/sessions/:id`  
**WebSocket**: Listens on `/ws/users/:userId/notify?token=` for `session.ended`, `session.extended`, `notification.new`

---

### Screen 24 — Session History Detail Screen
**Tab**: My Games (pushed)  
**Access**: Tap a completed session in Activity Hub History tab

**Sections:**
1. **Session summary**: Store, system, platform, date
2. **Time**: Start → End, total duration
3. **Billing summary**: Base rate, multiplier, total charged
4. **Payment**: Method, status
5. **Credits earned**: If any credits were awarded for this session
6. **"File a Dispute"** button (visible for a configurable period after session end)
7. **"View Billing Record"** link → scrolls to relevant entry in Billing History

**API calls**: `GET /stores/:storeId/sessions/:id`

---

### Screen 25 — Billing History Screen
**Tab**: My Games (pushed)  
**Access**: "Billing" link in Profile, or from Session Detail

**UI:**
- Grouped by month
- Each row: store name, date, duration, amount charged, payment method, status chip
- Total month spend shown as section header
- Tap row → (inline expansion or separate detail view showing breakdown)

**API calls**: `GET /stores/:storeId/billing/my` (paginated)  
**Store filter**: Dropdown to switch between stores (if user has history across multiple stores)

---

## 8. Tab 4: Wallet

The wallet is store-scoped. A store selector is shown at the top; switching store loads data for that store.

### Screen 26 — Wallet Home
**Tab**: Wallet (root)  
**Access**: Tab bar

**Sections:**
1. **Store selector** (prominent, pill-shaped): "Store: {name} ▼" → Store Selector Sheet
2. **Credit balance card**: Large credit amount with store logo
   - "Earn more" tooltip (shows how credits are earned)
3. **Quick actions row**: [Redeem Credits] [View History] [Campaigns]
4. **Recent transactions** (last 5): Amount, type (earned/redeemed/bonus), date
   - Tap "See all" → Credit Transaction History Screen
5. **Active Campaigns section**: Horizontal scroll of available campaigns → Campaign Detail

**API calls**:
- `GET /stores/:storeId/credits/balance`
- `GET /stores/:storeId/credits/transactions?limit=5`
- `GET /stores/:storeId/campaigns/active`

---

### Screen 27 — Credit Transaction History Screen
**Tab**: Wallet (pushed)  
**Access**: "See all" from Wallet Home, or "View History" quick action

**UI:**
- Grouped by month
- Each row: transaction type icon, description, amount (+/-), date
- Transaction types with icons: Earned (star), Redeemed (arrow up), Bonus (gift), Admin Adjust (wrench), Expired (clock), Refund (undo)
- Running balance shown on each row (optional)

**API calls**: `GET /stores/:storeId/credits/transactions` (paginated, 20/page)

---

### Screen 28 — Redeem Credits Screen
**Tab**: Wallet (modal sheet)  
**Access**: "Redeem Credits" on Wallet Home

**UI:**
- Current balance shown at top
- Amount input (with max button = full balance)
- Equivalent value display ("500 credits = ₹50 off your next session")
- "Where can I use this?" info link
- "Redeem" button
- Confirmation step: "Are you sure? This will apply credits to your next booking."

**Logic:**
- `POST /stores/:storeId/credits/redeem { amount }`
- On `INSUFFICIENT_CREDITS` → inline error
- On `CREDITS_EXPIRED` → banner warning
- On success → Update balance, show success toast

**API calls**: `POST /stores/:storeId/credits/redeem`  
**Note**: Credits are store-specific — prominently labelled "Credits valid at {Store Name} only"

---

### Screen 29 — Campaigns List Screen
**Tab**: Wallet (pushed)  
**Access**: "Campaigns" quick action on Wallet Home, or from Store Detail

**UI:**
- Filter tabs: All / Discounts / Bonus Credits / Happy Hour / First Visit
- Campaign cards:
  - Campaign name, type badge (e.g., "20% Off"), validity period
  - "Eligible for you" badge (based on tier/conditions)
  - Progress bar for limited campaigns (e.g., "47 / 100 redeemed")
  - "Redeem" CTA → Campaign Detail Screen

**API calls**: `GET /stores/:storeId/campaigns/active`

---

### Screen 30 — Campaign Detail Screen
**Tab**: Wallet (pushed)  
**Access**: Tap any campaign card

**Sections:**
1. **Campaign banner image** (if available)
2. **Campaign name and type** (e.g., "Happy Hour — 30% Off")
3. **Description and terms**
4. **Validity**: Start date → End date, time restrictions (e.g., "Mon–Fri 10am–2pm only")
5. **Eligibility**: Tier requirement, usage limits ("Max 2 uses per user")
6. **Benefit summary**: "Save ₹100" or "Get 200 bonus credits"
7. **"Redeem Now"** button
   - Can be redeemed standalone (credits/benefit applied) OR during booking flow
   - `POST /stores/:storeId/campaigns/:id/redeem`
8. **Redemption history** (if already redeemed): "Redeemed 1 time"

**API calls**:
- Campaign data from previous screen (passed as params)
- `POST /stores/:storeId/campaigns/:id/redeem`

---

## 9. Tab 5: Profile

### Screen 31 — Profile Home
**Tab**: Profile (root)  
**Access**: Tab bar

**Sections:**
1. **User card**: Avatar (initials-based), Name, email/phone, member since date
2. **Stats row**: Total sessions played, Hours played, Stores visited
3. **Menu items** (list):
   - Edit Profile → Screen 32
   - Change Phone → Screen 33
   - Notification Preferences → Screen 34
   - Billing History → Screen 25
   - My Disputes → Screen 35
   - Help & Support (external link or in-app FAQ)
4. **"Sign Out"** button (bottom, red text)
   - Confirmation dialog: "Sign out of this device?"
   - `POST /auth/logout` → Clear tokens → Navigate to Auth Landing

**API calls**: `GET /auth/me`

---

### Screen 32 — Edit Profile Screen
**Tab**: Profile (pushed)  
**Access**: From Profile Home

**Form fields:**
- Full Name (required)
- Email address (optional; shows "Verified" ✓ or "Unverified — resend" badge)
- Profile picture (future — upload not in current API scope)

**Logic:**
- `PATCH /auth/me { name?, email? }`
- On success → Toast "Profile updated" + update local state
- If email changed → Show Email Verification Pending notice

**API calls**: `PATCH /auth/me`

---

### Screen 33 — Change Phone Screen
**Tab**: Profile (pushed)  
**Access**: From Profile Home

**Steps:**
1. Enter new phone number (E.164, with country picker)
2. Tap "Send OTP" → `POST /auth/phone/change { newPhone }`
3. → OTP Input Sheet appears for verification of new number
4. After OTP verified → phone updated, success toast

**API calls**: `POST /auth/phone/change`, `POST /auth/verify/otp` (for new phone)

---

### Screen 34 — Notification Preferences Screen
**Tab**: Profile (pushed)  
**Access**: From Profile Home

**UI:**
- Section: "Channels"
  - Push Notifications: toggle (system permission prompt if first time)
  - Email Notifications: toggle
  - SMS Notifications: toggle
  - In-App Notifications: toggle (always on, grayed out — informational)
- Section: "When to notify me"
  - Booking confirmations: toggle
  - Booking reminders: toggle
  - Session ending soon: toggle
  - Credit balance updates: toggle
  - New campaigns: toggle
  - Dispute status updates: toggle

**Logic:**
- Load: `GET /notifications/preferences`
- Every toggle change → `PATCH /notifications/preferences` (debounced 1s)
- Also handles FCM token registration: on push toggle ON, request OS permission, then `PATCH /auth/me/device { fcmToken, platform }`

**API calls**:
- `GET /notifications/preferences`
- `PATCH /notifications/preferences`
- `PATCH /auth/me/device { fcmToken, platform }` (when enabling push)

---

### Screen 35 — Disputes List Screen
**Tab**: Profile (pushed)  
**Access**: "My Disputes" from Profile Home

**UI:**
- "File a New Dispute" button at top → Create Dispute Screen
- List of disputes:
  - Session reference, date, disputed amount
  - Status badge: Open (yellow) / Under Review (blue) / Resolved (green) / Withdrawn (grey)
  - Resolution shown for resolved: "Full Refund Issued" / "Partial Refund" / "Credit Issued" / "Upheld"
- Empty state: "No disputes filed"

**API calls**: `GET /stores/:storeId/disputes/my`  
**Store filter**: If user has disputes across multiple stores, show store filter at top

---

### Screen 36 — Dispute Detail Screen
**Tab**: Profile (pushed)  
**Access**: Tap dispute in Disputes List

**Sections:**
1. **Status banner** (colored): Open / Under Review / Resolved / Withdrawn
2. **Session reference**: Session ID, date, store, system
3. **Disputed amount**: Original charge, amount disputed
4. **User's description**: What the player submitted
5. **Resolution** (if resolved):
   - Resolution type
   - Admin notes/explanation
6. **Timeline**: Status change history (opened, review started, resolved)
7. **"Withdraw Dispute"** button (only if status = `open`)
   - Confirmation: "Are you sure? This cannot be undone."
   - `POST /stores/:storeId/disputes/:id/withdraw`

**API calls**: `GET /stores/:storeId/disputes/:id`, `POST /stores/:storeId/disputes/:id/withdraw`

---

### Screen 37 — Create Dispute Screen
**Tab**: Profile (pushed/modal)  
**Access**: "File a New Dispute" on Disputes List, or "File a Dispute" on Session Detail

**Form:**
- **Select session** (if not pre-filled): Search/picker from session history
- **Reason**: Short text description (required, max 500 chars)
- **Disputed amount** (optional): How much they believe was incorrectly charged
- **Supporting detail** (optional): Any additional notes

**Logic:**
- `POST /stores/:storeId/disputes { sessionId, reason, disputedAmount? }`
- On success → Navigate to Dispute Detail, show success toast

**API calls**: `POST /stores/:storeId/disputes`

---

## 10. Global Overlays

### Screen 38 — Notification Center
**Access**: Bell icon in header (all main app screens)  
**Style**: Full-screen modal or slide-in drawer

**UI:**
- "Mark all as read" button at top
- Notification list:
  - Unread items highlighted with dot badge
  - Notification type icon (booking, session, credit, campaign, dispute)
  - Title, body preview, relative time ("2h ago")
  - Tap → Notification Detail Sheet
- Unread count badge on bell icon (updated via WebSocket)

**API calls**:
- `GET /notifications` (paginated)
- `POST /notifications/read-all`
- Real-time: WebSocket `ws/users/:userId/notify?token=` → `notification.new` events push new items in

---

### Screen 39 — Notification Detail Sheet
**Access**: Tap notification in Notification Center  
**Style**: Bottom sheet or full-screen push

**UI:**
- Full notification title and body
- Timestamp
- Deep-link action button (e.g., "View Booking" → Booking Detail, "View Session" → Session Detail)
- Automatically marks as read on open: `PATCH /notifications/:id/read`

**API calls**: `PATCH /notifications/:id/read`

---

### Screen 40 — Store Selector Sheet
**Access**: "Change store" button anywhere store context is shown (Wallet, Book tab header)  
**Style**: Bottom sheet

**UI:**
- Search bar at top
- List of stores the user has interacted with (from history) + all active stores
- "Nearby" section (if location permission granted)
- Tap store → Updates active store context in app state, dismisses sheet, refreshes current screen

**API calls**: `GET /stores` (all active stores for list)

---

## 11. OTP Input Sheet (Reusable Component)
**Access**: Phone change flow, any re-authentication trigger  
**Style**: Bottom sheet

- Reused across: Register phone verify, Change Phone, any step requiring re-auth OTP
- Same behavior as Screen 05 (OTP Verification Screen), presented as a dismissible sheet

---

## 12. Full API Coverage Map

| API Endpoint | Screen(s) |
|---|---|
| `POST /auth/register` | 04 — Register |
| `POST /auth/login/otp` | 03 — Auth Landing, 05 — OTP Verify (resend) |
| `POST /auth/login/email` | 06 — Email Login |
| `POST /auth/login/oauth/:provider` | 07 — OAuth Handler |
| `POST /auth/verify/otp` | 05 — OTP Verification, 33 — Change Phone |
| `POST /auth/verify/email` | 10 — Email Verification Pending (via deep link) |
| `POST /auth/refresh` | 01 — Splash (silent refresh) |
| `POST /auth/logout` | 31 — Profile (sign out) |
| `POST /auth/password/reset/request` | 08 — Forgot Password |
| `POST /auth/password/reset/confirm` | 09 — Reset Password |
| `POST /auth/phone/change` | 33 — Change Phone |
| `GET /auth/me` | 01 — Splash, 10 — Email Verify Pending, 31 — Profile |
| `PATCH /auth/me` | 32 — Edit Profile |
| `PATCH /auth/me/device` | 34 — Notification Preferences (FCM token reg) |
| `GET /stores` | 11 — Home Feed, 12 — Store Search, 40 — Store Selector |
| `GET /stores/:slug` | 13 — Store Detail |
| `GET /stores/:storeId/systems/available` | 14 — Systems Browser, 16 — System Picker |
| `GET /stores/:storeId/bookings/availability` | 15 — Availability Calendar |
| `GET /stores/:storeId/bookings/my` | 19 — Activity Hub (Upcoming, History) |
| `GET /stores/:storeId/bookings/:id` | 20 — Booking Detail |
| `POST /stores/:storeId/bookings` | 17 — Booking Summary |
| `POST /stores/:storeId/bookings/:id/pay` | 21 — Payment Screen |
| `POST /stores/:storeId/bookings/:id/cancel` | 20 — Booking Detail |
| `POST /stores/:storeId/bookings/:id/check-in` | 22 — Check-In Screen |
| `GET /stores/:storeId/sessions/my` | 19 — Activity Hub (Active, History) |
| `GET /stores/:storeId/sessions/:id` | 23 — Active Session, 24 — Session History Detail |
| `GET /stores/:storeId/billing/my` | 25 — Billing History |
| `GET /stores/:storeId/credits/balance` | 17 — Booking Summary, 26 — Wallet Home |
| `GET /stores/:storeId/credits/transactions` | 26 — Wallet Home (preview), 27 — Full History |
| `POST /stores/:storeId/credits/redeem` | 28 — Redeem Credits |
| `GET /stores/:storeId/campaigns/active` | 13 — Store Detail, 17 — Booking Summary, 26 — Wallet Home, 29 — Campaigns List |
| `POST /stores/:storeId/campaigns/:id/redeem` | 30 — Campaign Detail |
| `GET /notifications` | 38 — Notification Center |
| `PATCH /notifications/:id/read` | 39 — Notification Detail |
| `POST /notifications/read-all` | 38 — Notification Center |
| `GET /notifications/preferences` | 34 — Notification Preferences |
| `PATCH /notifications/preferences` | 34 — Notification Preferences |
| `GET /stores/:storeId/disputes/my` | 35 — Disputes List |
| `GET /stores/:storeId/disputes/:id` | 36 — Dispute Detail |
| `POST /stores/:storeId/disputes` | 37 — Create Dispute |
| `POST /stores/:storeId/disputes/:id/withdraw` | 36 — Dispute Detail |
| `WS /ws/users/:userId/notify?token=` | 23 — Active Session, 38 — Notification Center |

**Total API endpoints covered: 43 player-accessible endpoints (100% coverage)**

---

## 13. Real-Time Strategy

### WebSocket Usage (`ws/users/:userId/notify`)
Connect on app foreground when user is authenticated. Reconnect with exponential backoff on disconnect.

| WS Event | Handler |
|---|---|
| `notification.new` | Increment bell badge, prepend to Notification Center list |
| `session.started` | Update Activity Hub Tab B to show active session card |
| `session.ended` | Navigate away from Active Session Screen, show completion toast |
| `session.extended` | Update Active Session timer display |
| `booking.checked_in` | Update booking status in Activity Hub |

### Polling Fallback
If WebSocket is unavailable (e.g., poor network), fall back to:
- Active Session Screen: poll `GET /stores/:storeId/sessions/:id` every 30 seconds
- Activity Hub: pull-to-refresh for manual updates
- Home Feed: auto-refresh store availability every 60 seconds

---

## 14. State Management Design

### Persistent State (encrypted local storage)
- `accessToken` — JWT, refreshed automatically
- `refreshToken` — JWT, used to get new access token
- `userId` — for WebSocket connection
- `activeStoreId` — last selected store (Wallet/Book context)
- `hasSeenOnboarding` — boolean flag

### In-Memory App State
- `currentUser` — profile from `GET /auth/me`, refreshed on app foreground
- `notifications` — list + unread count, updated via WebSocket
- `activeStoreId` — shared across tabs, synced with persistent storage

### Token Lifecycle
- Access token (15 min TTL): stored in memory only during session; refreshed silently on 401 response
- Refresh token (7 days): stored in encrypted secure storage
- On logout: `POST /auth/logout` + clear all stored tokens + clear in-memory state

---

## 15. Multi-Store UX Patterns

Since credits and bookings are store-scoped, the app needs clear context switching:

1. **Default store**: Last visited/booked store becomes the active context
2. **Store selector**: Accessible via pill button at top of Wallet and Book tabs
3. **Cross-store history**: Billing History and Disputes List include a store filter dropdown
4. **Credit isolation**: Wallet tab prominently labels "Credits at {Store Name}" — a visual reminder that credits don't transfer
5. **My Games tab**: Shows all bookings/sessions across all stores, grouped by store with store name labels

---

## 16. Deep Link Map

| URL Pattern | Screen |
|---|---|
| `gzapp://reset-password?token={token}` | 09 — Reset Password |
| `gzapp://verify-email?token={token}` | Deep link triggers `POST /auth/verify/email` then → Home |
| `gzapp://stores/{slug}` | 13 — Store Detail |
| `gzapp://bookings/{bookingId}` | 20 — Booking Detail (with store resolved from booking data) |
| `gzapp://sessions/{sessionId}` | 23 or 24 — Active Session or History Detail |
| `gzapp://notifications` | 38 — Notification Center |

---

## 17. Key UX Decisions & Rationale

| Decision | Rationale |
|---|---|
| Phone OTP as primary auth | Lowest friction for gaming venue demographics; no password to remember |
| Store context persisted in app state | Players typically return to the same store; reduces friction on repeat visits |
| Credits balance prominently displayed in Wallet | Credits drive retention; surfacing balance increases redemption rates |
| WebSocket for session screen | Session timer must be accurate — polling every 30s is too slow for a live timer |
| Booking mutex handled server-side only | Client has no control over mutex; just show "Slot unavailable" on conflict response |
| Idempotency key generated client-side for payments | Prevents duplicate charges on network retry without server-side coordination |
| Admin extend = walk up to counter | Session extension is an admin-only action; app directs user to staff rather than exposing a broken UX |
| Campaign redemption both standalone and embedded in booking flow | Flexibility: some campaigns are credit bonuses (standalone), others are booking discounts (embedded) |
| Dispute flow requires session reference | Disputes always tie to a specific billing event — prevents vague complaints and aids admin resolution |
