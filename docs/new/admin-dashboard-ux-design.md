# Gaming Zone — Admin Dashboard: Complete UX Design
**Version**: 1.0 | **Target**: iOS & Android (Unified App) | **API Version**: 2.0.0

> This document defines the admin-facing screens integrated into the Gaming Zone mobile app. It enables store owners and staff to manage live operations, billing, and analytics. Admin screens are numbered starting from Screen 41 (following the Player App's 40 screens).

---

## 1. Overview

The Admin Dashboard is integrated into the same mobile application as the Player App. Access is granted only to users with the `admin` account type. Upon logging in via the Admin Login flow, the app switches to the Admin interface, which uses a separate navigation stack focused on store operations.

### What the admin interface enables
- **Live Monitoring**: Real-time floor map and system status overview.
- **Session Control**: Start, end, pause, resume, and extend gaming sessions.
- **Walk-in Management**: Rapidly create sessions for players physically present at the store.
- **Analytics & Revenue**: Track store performance, occupancy, and financial health.
- **Pricing & Campaigns**: Manage dynamic pricing rules and promotional offers.
- **Billing & Disputes**: Resolve billing issues and manage the append-only ledger.
- **Staff & Store Config**: Manage administrative access and store-wide settings.

### Total Admin Screen Count: **20 screens (41–60)**

---

## 2. Navigation Architecture

```
Admin Interface
├── Auth Stack (Admin)
│   ├── Admin Login (Screen 41)
│   ├── Admin Password Reset Request
│   └── Admin Password Reset Confirm
│
└── Main Admin App — Bottom Tab Navigator
    ├── Tab 1: Operations (The Floor)
    │   ├── Admin Dashboard / Floor Map (Screen 42)
    │   ├── Session Management (Screen 43)
    │   ├── Walk-in Booking (Screen 44)
    │   └── Booking Management (Screen 45)
    │
    ├── Tab 2: Analytics
    │   ├── Analytics Dashboard (Screen 46)
    │   ├── Revenue Analytics (Screen 47)
    │   ├── Utilization Heatmap (Screen 48)
    │   ├── Session Statistics (Screen 49)
    │   ├── Player Analytics (Screen 50)
    │   └── System Performance (Screen 51)
    │
    ├── Tab 3: Management
    │   ├── Pricing Rules (Screen 52)
    │   ├── Billing & Payments (Screen 53)
    │   ├── Campaign Management (Screen 54)
    │   ├── Credits Management (Screen 55)
    │   └── Dispute Resolution (Screen 56)
    │
    ├── Tab 4: Store
    │   ├── System Management (Screen 57)
    │   ├── Staff Management (Screen 58)
    │   ├── Store Config (Screen 59)
    │   └── Admin Notifications (Screen 60)
    │
    └── Tab 5: Admin Profile
        ├── Profile Overview
        ├── Security Settings
        └── Sign Out
```

---

## 4. Tab 1: Operations — Live Management

### Screen 42 — Admin Dashboard (Floor Map)
**Access**: Tab 1, default landing after admin login.  
**Purpose**: Real-time visualization of the gaming floor and system availability.

- **UI Sections**:
  - **Header**: Store name (e.g., "Gaming Zone — Indiranagar") + Live status pill.
  - **KPI Ribbon**:
    - **Live Occupancy**: `X/Y` systems in use (gauge).
    - **Active Sessions**: Count of current `in_progress` sessions.
    - **Next 1h**: Count of upcoming bookings.
  - **Floor Map Grid**:
    - Interactive tiles representing each system (`system_id`).
    - **Tile States**:
      - **Green (Available)**: Shows system name and type (e.g., "PC-01 [Pro]").
      - **Blue (In Use)**: Shows player name, time elapsed, and "Ending soon" warning if <10 min left.
      - **Yellow (Maintenance)**: Grayed out with wrench icon.
      - **Red (Offline)**: Agent heartbeat missing for >2 min.
    - Long-press on tile → Quick action menu (Start/End/Restart Agent).
    - Tap tile → Navigate to Screen 43 (Session Management).
- **API Calls**: `GET /stores/:storeId/systems/live`
- **Business Logic**:
  - Color codes are derived from `system_status` enum.
  - Heartbeat status is calculated client-side by comparing `lastHeartbeatAt` to current time.
- **Real-time**: WebSocket listener for `system.status_change`, `session.started`, `session.ended`, and `agent.heartbeat`.

---

### Screen 43 — Session Management
**Access**: From Screen 42 by tapping any system tile.  
**Purpose**: Granular control over an individual system and its active session.

- **UI Sections**:
  - **System Overview**: Large image of system, specs (e.g., "RTX 4090, i9-13900K"), and platform icon.
  - **Live Timer Card** (if active):
    - Large digital clock showing elapsed and remaining time.
    - Progress bar (visual).
    - Current estimated bill (calculated: `rate * minutes`).
  - **Player Info**: Name, tier, credits balance, and booking source (Online/Walk-in).
  - **Action Toolbar**:
    - [Pause Session]: Stops timer and sends lock command to Agent.
    - [Resume Session]: Re-starts timer and sends unlock command.
    - [End Session]: Forces session completion and triggers billing.
    - [Extend Session] (Button): Opens extension sheet.
  - **Extension Sheet**:
    - Pre-defined intervals: +15m, +30m, +1h, +2h.
    - Availability check: "Slot is available for the next 4 hours."
- **API Calls**:
  - `GET /stores/:storeId/sessions/:id`
  - `POST /stores/:storeId/sessions/:id/pause`
  - `POST /stores/:storeId/sessions/:id/resume`
  - `POST /stores/:storeId/sessions/:id/end`
  - `POST /stores/:storeId/sessions/:id/extend { extraMinutes }`
- **Business Logic**:
  - `staff` role can only use Start/End.
  - `admin` role can pause/resume and extend.
  - Extension is blocked if there's a P1 (paid) booking starting within the requested extension window.
- **Real-time**: Updates on `session.paused`, `session.resumed`, `session.extended`.

---

### Screen 44 — Walk-in Booking
**Access**: "+" FAB (Floating Action Button) on Admin Dashboard.  
**Purpose**: Rapidly initiate a session for a customer physically standing at the counter.

- **UI Sections**:
  - **User Search/Identification**:
    - Input for Phone/Email with auto-complete from existing users.
    - [New User] button: Opens mini-form (Name, Phone).
  - **System Picker**:
    - List of currently `available` systems, filtered by type (PC/Console/VR).
  - **Duration/Pricing**:
    - Duration slider (15m to 8h).
    - Auto-calculated price display based on active `pricing_rules`.
  - **Billing Option**:
    - Toggle: [Pay Upfront] vs [Pay at End].
  - **Primary CTA**: [Start Session Now].
- **API Calls**:
  - `GET /stores/:storeId/systems/available`
  - `POST /stores/:storeId/bookings/walk-in { userId, systemId, duration, paymentMethod? }`
- **Business Logic**:
  - Combines `create_booking`, `check_in`, and `start_session` into a single atomic action.
  - If [Pay Upfront] is selected, must specify `paymentMethod` (Cash/UPI/Card).

---

### Screen 45 — Booking Management
**Access**: "Bookings" icon in Operations tab bottom bar.  
**Purpose**: Centralized view of all scheduled reservations, including check-in status.

- **UI Sections**:
  - **Calendar View**: Horizontal date strip (7 days).
  - **Booking List**:
    - Filter chips: [All] [Unpaid] [Paid] [Checked-in] [No-show].
    - Card: Player name, System ID, Start Time, Duration, Status Pill.
    - Quick actions on card swipe: [Check-in], [Cancel].
  - **Empty State**: "No bookings for today. Start a walk-in?"
- **API Calls**:
  - `GET /stores/:storeId/bookings` (filtered by date and status).
  - `POST /stores/:storeId/bookings/:id/check-in`.
  - `POST /stores/:storeId/bookings/:id/cancel { reason }`.
- **Business Logic**:
  - Only `admin`+ can cancel a booking with "Admin Override" as the reason.
  - `no_show` status is automatically applied by cron but can be manually triggered.

---


## 4. Analytics — Tab 2: Performance Tracking

### Screen 46 — Analytics Dashboard
**Tab**: Analytics (Root)  
**Access**: Visible to `admin` and `super_admin`. `staff` see restricted "View only" summary.  
**Purpose**: High-level store health overview.

- **UI Sections**:
  - **Date Range Picker**: [Today] [Last 7 Days] [Custom].
  - **KPI Cards**: Total Revenue, Net Revenue, Occupancy Rate, Total Sessions.
  - **Growth Indicators**: New vs. Returning Players.
  - **Quick Charts**: Revenue trend (7-day line chart).
- **API Calls**: `GET /stores/:storeId/analytics/dashboard`
- **Business Logic**: Data source indicates if from `summary` (cached) or `live` (calculated).

---

### Screen 47 — Revenue Analytics
**Tab**: Analytics (Pushed)  
**Access**: Admin+  
**Purpose**: Detailed financial breakdown.

- **UI Sections**:
  - **Revenue Table**: Date, Base Revenue, Discounts, Net Revenue.
  - **Payment Breakdown**: UPI vs. Cash vs. Card distribution (Pie chart).
  - **Export Button**: Send CSV to admin email.
- **API Calls**: `GET /stores/:storeId/analytics/revenue`

---

### Screen 48 — Utilization Heatmap
**Tab**: Analytics (Pushed)  
**Access**: Admin+  
**Purpose**: Visualizing peak hours and system popularity.

- **UI Sections**:
  - **Hourly Heatmap**: 24-hour grid showing occupancy density across the week.
  - **Peak Hour Indicator**: "Your store is busiest at 7 PM on Fridays."
- **API Calls**: `GET /stores/:storeId/analytics/utilization`

---

### Screen 49 — Session Statistics
**Tab**: Analytics (Pushed)  
**Access**: Admin+  
**Purpose**: Analyzing player behavior and session lengths.

- **UI Sections**:
  - **Summary**: Avg Duration, Completion Rate, Walk-in vs. Booking ratio.
  - **Duration Distribution**: Bar chart showing common session lengths (e.g., 1h vs 4h).
- **API Calls**: `GET /stores/:storeId/analytics/sessions/stats`

---

### Screen 50 — Player Analytics
**Tab**: Analytics (Pushed)  
**Access**: Admin+  
**Purpose**: Player retention and top user tracking.

- **UI Sections**:
  - **Player Segments**: New, Returning, and Churn risk.
  - **Leaderboard**: Top 10 players by total minutes/revenue.
- **API Calls**: `GET /stores/:storeId/analytics/players`

---

### Screen 51 — System Performance
**Tab**: Analytics (Pushed)  
**Access**: Admin+  
**Purpose**: Identifying underperforming or overused hardware.

- **UI Sections**:
  - **System List**: Each system's utilization rate, total revenue generated, and total minutes.
  - **Alerts**: "PC-12 utilization is 40% lower than average."
- **API Calls**: `GET /stores/:storeId/analytics/systems/performance`

---

## 6. Tab 3: Management — Finance & Rules

### Screen 52 — Pricing Rules
**Access**: Tab 3 root.  
**Purpose**: Management of dynamic hourly rates and automated pricing logic.

- **UI Sections**:
  - **Rule List**: 
    - Card: Rule Name (e.g., "Weekend Peak"), Type (Peak/Off-Peak), Rate Multiplier, Time Range.
    - Active status toggle.
  - **Add Rule Modal**:
    - Select System Type (PC/PS5/VR).
    - Set Start/End times and applicable days of the week.
    - Set Base Rate or Multiplier.
  - **Price Calculator Tool**: 
    - Input: [System Type] + [Duration] + [Start Time].
    - Output: Breakdown of which rules applied and total estimated cost.
- **API Calls**: 
  - `GET /stores/:storeId/pricing/rules`
  - `POST /stores/:storeId/pricing/rules`
  - `PATCH /stores/:storeId/pricing/rules/:id`
  - `POST /stores/:storeId/pricing/calculate`
- **Business Logic**: 
  - Rules are snapshotted when a session starts; changes only apply to future sessions.
  - Overlapping rules are resolved by priority: `custom` > `peak/off_peak` > `base`.
- **Role Restrictions**: Only `admin` and `super_admin` can modify rules.

---

### Screen 53 — Billing & Payments
**Access**: Tab 3 sub-navigation.  
**Purpose**: Oversight of all financial transactions and manual billing adjustments.

- **UI Sections**:
  - **Ledger List**:
    - Each row: Billing ID, Session ID, User, Amount, Status (Unpaid/Paid/Partial).
    - Status badges: [Bill Generated] [Payment Verified] [Overridden].
  - **Override Panel** (Super Admin only):
    - "Manual Adjustment" input.
    - Mandatory [Reason for Override] text field.
  - **Payment Action Sheet**:
    - Record manual cash payment.
    - Process partial refund (if payment was digital).
- **API Calls**: 
  - `GET /stores/:storeId/billing/ledger`
  - `POST /stores/:storeId/billing/:id/override { reason, amount }`
  - `POST /stores/:storeId/payments/:id/refund`
- **Business Logic**: 
  - Revenue analytics always sum from `billing_ledger`, not the `payments` table.
  - Every override creates a new record in `admin_overrides` for audit purposes.

---

### Screen 54 — Campaign Management
**Access**: Tab 3 sub-navigation.  
**Purpose**: Designing and monitoring promotional offers to drive traffic.

- **UI Sections**:
  - **Campaign Grid**:
    - Status badges: [Draft] [Scheduled] [Active] [Paused] [Expired].
  - **Redemption Stats**:
    - Total redemptions, total discount cost, net revenue impact.
  - **Form Builder**:
    - Type selector: Percentage Off, Fixed Amount, Bonus Credits, Happy Hour.
    - Target: [All Users] or specific [Tier].
- **API Calls**: 
  - `GET /stores/:storeId/campaigns`
  - `POST /stores/:storeId/campaigns`
  - `POST /stores/:storeId/campaigns/:id/pause`
  - `POST /stores/:storeId/campaigns/:id/resume`
- **Business Logic**: 
  - A user can only redeem a campaign if they meet all criteria (min duration, tier, etc.).
  - `staff` can view active campaigns but cannot create or pause them.

---

### Screen 55 — Credits Management
**Access**: Tab 3 sub-navigation.  
**Purpose**: Managing store-specific loyalty credits for individual players.

- **UI Sections**:
  - **Player Search Bar**: Find user by phone, email, or name.
  - **Player Credit Card**:
    - Current balance at this store.
    - Member Tier (Silver/Gold/Platinum).
    - [Adjust Balance] button.
  - **Transaction History**:
    - List of credit events: [Earned from Session] [Redeemed for Booking] [Admin Bonus].
- **API Calls**: 
  - `GET /stores/:storeId/credits/balance/:userId`
  - `GET /stores/:storeId/credits/transactions/:userId`
  - `POST /stores/:storeId/credits/adjust { userId, amount, reason }`
- **Business Logic**: Credits are strictly store-scoped; balances from Store A never show in Store B.

---

### Screen 56 — Dispute Resolution
**Access**: Tab 3 sub-navigation.  
**Purpose**: Managing and resolving complaints filed by players regarding billing.

- **UI Sections**:
  - **Dispute Inbox**:
    - Sorted by urgency and date.
    - Card: User, Disputed Amount, Session Date, Reason Code.
  - **Investigation Workspace**:
    - Side-by-side view: User's complaint vs. Session Event Logs.
    - [Timeline] view of the disputed session (locks, unlocks, agent heartbeats).
  - **Resolution Selector**:
    - [Upheld]: No refund, close dispute.
    - [Partial Refund]: Issue credits or digital refund for X amount.
    - [Full Refund]: Void session and refund total.
- **API Calls**: 
  - `GET /stores/:storeId/disputes`
  - `POST /stores/:storeId/disputes/:id/review`
  - `POST /stores/:storeId/disputes/:id/resolve { resolution, notes }`
- **Business Logic**: Resolution status is sent to player via push notification immediately.

---


### Screen 53 — Billing & Payments
**Tab**: Management (Pushed)  
**Access**: `super_admin` for overrides/refunds; `admin` for viewing.  
**Purpose**: Audit trail and ledger management.

- **UI Sections**:
  - **Billing Ledger**: Searchable list of all generated bills.
  - **Override Panel** (Super Admin only): Change amount, add reason.
  - **Refund Action**: Refund a payment to original method.
- **API Calls**: 
  - `GET /stores/:storeId/billing/ledger`
  - `POST /stores/:storeId/billing/:id/override { reason, amount }`
  - `POST /stores/:storeId/payments/:id/refund`
- **Business Logic**: Ledgers are append-only. Overrides create a new ledger entry with reference.

---

### Screen 54 — Campaign Management
**Tab**: Management (Pushed)  
**Access**: Admin+  
**Purpose**: Create and monitor promotions.

- **UI Sections**:
  - **Campaign List**: Active, Paused, Scheduled, and Expired campaigns.
  - **Stats**: "Redeemed 45 times, Total discount ₹4,500."
  - **Actions**: [Pause] [Resume] [Edit].
- **API Calls**: 
  - `GET /stores/:storeId/campaigns`
  - `POST /stores/:storeId/campaigns`
  - `POST /stores/:storeId/campaigns/:id/pause`

---

### Screen 55 — Credits Management
**Tab**: Management (Pushed)  
**Access**: Admin+  
**Purpose**: Manual credit adjustments for customer loyalty.

- **UI Sections**:
  - **User Search**: Find player by phone.
  - **Balance Detail**: Current store-specific balance.
  - **Adjust Form**: Add/Subtract amount + Reason (e.g., "Comp for PC crash").
- **API Calls**: 
  - `GET /stores/:storeId/credits/balance/:userId`
  - `POST /stores/:storeId/credits/adjust { userId, amount, reason }`

---

### Screen 56 — Dispute Resolution
**Tab**: Management (Pushed)  
**Access**: Admin+  
**Purpose**: Review and resolve player-filed billing disputes.

- **UI Sections**:
  - **Dispute List**: Filter by [Open] [In Review] [Resolved].
  - **Resolution Detail**: Original session data, player's complaint, admin notes.
  - **Resolve Actions**: [Upheld] [Full Refund] [Partial Refund] [Credit Issued].
- **API Calls**: 
  - `GET /stores/:storeId/disputes`
  - `POST /stores/:storeId/disputes/:id/review`
  - `POST /stores/:storeId/disputes/:id/resolve { resolution, notes }`

---

## 7. Tab 4: Store — Configuration & Staff

### Screen 57 — System Management
**Access**: Tab 4 root.  
**Purpose**: Inventory management of physical hardware and category setup.

- **UI Sections**:
  - **System Types Tab**: 
    - CRUD for categories (e.g., "Pro PC Zone", "VIP PS5 Lounge").
    - Manage features per type (RTX 4080, 240Hz, etc.).
  - **Inventory List**:
    - List of all physical systems.
    - [Add System] modal: Assign Name, Seat Number, and System Type.
    - [Key Management]: View/Reset Agent API keys for each system.
- **API Calls**: 
  - `GET /stores/:storeId/systems`
  - `POST /stores/:storeId/systems`
  - `PATCH /stores/:storeId/systems/:id`
  - `GET /stores/:storeId/system-types`
- **Business Logic**: 
  - Deactivating a system makes it invisible to players in the Book tab.
  - API keys are required for the Desktop Agent to link with the server.

---

### Screen 58 — Staff Management
**Access**: Tab 4 sub-navigation. **Super Admin only**.  
**Purpose**: Managing administrative access and role-based permissions.

- **UI Sections**:
  - **Employee Directory**:
    - List: Name, Email, Role (Super Admin/Admin/Staff), Last Login date.
  - **Access Control Form**:
    - Add new employee by email.
    - Assign role from `admin_role` enum.
    - [Revoke Access] button for deactivated staff.
  - **Permissions Matrix (Visual)**: Informational table showing what each role can do.
- **API Calls**: 
  - `GET /stores/:storeId/admins`
  - `POST /stores/:storeId/admins`
  - `DELETE /stores/:storeId/admins/:id`
- **Business Logic**: 
  - A Super Admin cannot delete themselves if they are the only Super Admin.
  - Deactivating a staff member immediately revokes their JWT validity in Redis.

---

### Screen 59 — Store Config
**Access**: Tab 4 sub-navigation. **Super Admin only**.  
**Purpose**: Global operational settings that define the store's booking behavior.

- **UI Sections**:
  - **Operational Settings**:
    - `booking_window_minutes`: How far in advance players can book.
    - `payment_window_minutes`: Deadline to pay after booking.
    - `no_show_grace_minutes`: When to auto-cancel a reservation.
  - **Store Profile**:
    - Physical address, contact phone, operating hours.
  - **External Links**: Google Maps link, Instagram handle.
- **API Calls**: 
  - `GET /stores/:id/config`
  - `PATCH /stores/:id/config`
- **Business Logic**: Changes apply globally to the store and affect the Player App's availability logic.

---

### Screen 60 — Admin Notifications
**Access**: Tab 4 sub-navigation.  
**Purpose**: Internal and external communication portal.

- **UI Sections**:
  - **Broadcast Console**:
    - Title and Body inputs.
    - Channel selector: [Push] [Email] [In-App].
    - Target: [All Registered Users] [Current Players (On-floor)].
  - **Drafts & History**:
    - Previously sent broadcasts with engagement stats (Open Rate).
  - **Internal Notice Board**: Staff-only notes visible on Screen 42 header.
- **API Calls**: 
  - `POST /notifications/admin/send`
  - `POST /notifications/admin/send/topic`
- **Business Logic**: 
  - Uses FCM topics for broad push notification delivery.
  - `staff` can view previous notifications but cannot send new broadcasts.

---


## 7. Real-Time Strategy

The Admin Dashboard relies on a WebSocket connection to the Store Live Feed:
`/ws/stores/:storeId/live?token={adminToken}`

| WS Event | Effect on Dashboard |
|---|---|
| `system.status_change` | Updates system color/badge on Floor Map (Screen 42). |
| `session.started` | Adds active timer to system tile; updates occupancy stats. |
| `session.ended` | Resets system tile to `available`; updates revenue stats. |
| `booking.new` | Shows toast notification; updates check-in counts. |
| `agent.heartbeat` | Updates "Last seen" timestamp in System Detail (Screen 43). |

---

## 8. Role Permission Matrix (Detailed)

This matrix defines the exact access levels for each administrative role within the store context.

| Feature Area | Permission | Super Admin | Admin | Staff |
|---|---|:---:|:---:|:---:|
| **Operations** | Start/End Sessions | ✅ | ✅ | ✅ |
| | Pause/Resume Sessions | ✅ | ✅ | ❌ |
| | Extend Sessions | ✅ | ✅ | ❌ |
| | Manual System Override | ✅ | ✅ | ❌ |
| **Bookings** | View Schedule | ✅ | ✅ | ✅ |
| | Check-in Player | ✅ | ✅ | ✅ |
| | Cancel Booking | ✅ | ✅ | ❌ |
| **Analytics** | View Revenue Totals | ✅ | ✅ | ❌ |
| | View Occupancy Stats | ✅ | ✅ | ✅ |
| | Export Financial Reports | ✅ | ✅ | ❌ |
| **Finance** | Apply Billing Override | ✅ | ❌ | ❌ |
| | Process Refunds | ✅ | ❌ | ❌ |
| | Manage Pricing Rules | ✅ | ✅ | ❌ |
| **Loyalty** | View User Credits | ✅ | ✅ | ✅ |
| | Adjust Credit Balance | ✅ | ✅ | ❌ |
| | Resolve Disputes | ✅ | ✅ | ❌ |
| **Config** | Manage Staff | ✅ | ❌ | ❌ |
| | Update Store Config | ✅ | ❌ | ❌ |
| | Send Global Notifications | ✅ | ✅ | ❌ |

---

## 9. API Coverage Map (Admin)

Comprehensive mapping of all admin-facing endpoints to their respective UI screens.

| API Endpoint | Category | Screen(s) |
|---|---|---|
| `POST /auth/admin/login` | Auth | 41 — Admin Login |
| `GET /stores/:id/config` | Config | 59 — Store Config |
| `PATCH /stores/:id/config` | Config | 59 — Store Config |
| `GET /stores/:storeId/system-types` | Systems | 57 — System Management |
| `POST /stores/:storeId/system-types` | Systems | 57 — System Management |
| `GET /stores/:storeId/systems` | Systems | 42, 57 — System Management |
| `POST /stores/:storeId/systems` | Systems | 57 — System Management |
| `PATCH /stores/:storeId/systems/:id` | Systems | 57 — System Management |
| `GET /stores/:storeId/systems/live` | Systems | 42 — Admin Dashboard |
| `GET /stores/:storeId/systems/available` | Bookings | 44 — Walk-in Booking |
| `GET /stores/:storeId/bookings` | Bookings | 45 — Booking Management |
| `POST /stores/:storeId/bookings/walk-in` | Bookings | 44 — Walk-in Booking |
| `POST /stores/:storeId/bookings/:id/check-in` | Bookings | 45 — Booking Management |
| `POST /stores/:storeId/bookings/:id/cancel` | Bookings | 45 — Booking Management |
| `GET /stores/:storeId/sessions` | Sessions | 45, 49 — Stats |
| `GET /stores/:storeId/sessions/active` | Sessions | 42 — Dashboard |
| `GET /stores/:storeId/sessions/:id` | Sessions | 43 — Session Management |
| `POST /stores/:storeId/sessions/:id/pause` | Sessions | 43 — Session Management |
| `POST /stores/:storeId/sessions/:id/resume` | Sessions | 43 — Session Management |
| `POST /stores/:storeId/sessions/:id/end` | Sessions | 43 — Session Management |
| `POST /stores/:storeId/sessions/:id/extend` | Sessions | 43 — Session Management |
| `GET /stores/:storeId/pricing/rules` | Pricing | 52 — Pricing Rules |
| `POST /stores/:storeId/pricing/rules` | Pricing | 52 — Pricing Rules |
| `POST /stores/:storeId/pricing/calculate` | Pricing | 52, 44 — Walk-in |
| `GET /stores/:storeId/billing/ledger` | Billing | 53 — Billing & Payments |
| `POST /stores/:storeId/billing/:id/override` | Billing | 53 — Billing & Payments |
| `POST /stores/:storeId/payments/:id/refund` | Payments | 53 — Billing & Payments |
| `GET /stores/:storeId/credits/balance/:userId` | Credits | 55 — Credits Management |
| `POST /stores/:storeId/credits/adjust` | Credits | 55 — Credits Management |
| `GET /stores/:storeId/campaigns` | Campaigns | 54 — Campaign Management |
| `POST /stores/:storeId/campaigns` | Campaigns | 54 — Campaign Management |
| `POST /stores/:storeId/campaigns/:id/pause` | Campaigns | 54 — Campaign Management |
| `GET /stores/:storeId/disputes` | Disputes | 56 — Dispute Resolution |
| `POST /stores/:storeId/disputes/:id/review` | Disputes | 56 — Dispute Resolution |
| `POST /stores/:storeId/disputes/:id/resolve` | Disputes | 56 — Dispute Resolution |
| `GET /stores/:storeId/admins` | Staff | 58 — Staff Management |
| `POST /stores/:storeId/admins` | Staff | 58 — Staff Management |
| `POST /notifications/admin/send` | Notify | 60 — Admin Notifications |
| `POST /notifications/admin/send/topic` | Notify | 60 — Admin Notifications |
| `WS /ws/stores/:storeId/live?token=` | Real-time | 42, 43 — Operational Updates |

**Total Admin API endpoints covered: 40 endpoints (100% of admin-specific catalog)**

---

## 10. Admin State Management Design

Effective state management is critical for a real-time dashboard. The app uses a reactive store (e.g., Redux, MobX, or Pinia) to handle the following domains:

### 10.1 Authentication & Profile State
- `adminToken`: The active JWT for API authentication.
- `role`: The logged-in admin's role (`super_admin`, `admin`, `staff`).
- `storeId`: The specific tenant ID this admin is managing.
- `permissions`: A derived set of flags (e.g., `canOverrideBills`) used for UI masking.

### 10.2 Operational State (Floor Map)
- `systemsRegistry`: A dictionary of all systems in the store.
- `liveStatus`: Real-time status map (available, in-use, etc.) synced via WebSocket.
- `activeTimers`: Client-side countdown timers for `in_progress` sessions, periodically synced with server.

### 10.3 Analytics Cache
- `dashboardSummary`: Cached results from `/analytics/dashboard` to ensure instant tab switching.
- `cacheExpiry`: TTL for analytics data (typically 5 minutes).

---

## 11. Multi-Tenant Admin UX Patterns

As a SaaS platform, the dashboard must handle multi-tenancy gracefully, even if an admin only manages one store.

1. **Context Isolation**: Every API request must include the `storeId` in the path. The UI should never "leak" data from other stores.
2. **Branding Context**: The store's logo and name should be persistent in the header to remind staff which venue they are currently managing.
3. **Optimistic UI**: When an admin clicks "Unlock PC," the UI should immediately show a "Sending..." state to the system tile to provide instant feedback.
4. **Audit Awareness**: Every action that affects billing (extensions, overrides, refunds) must clearly state that "This action is being logged under your name."

---

## 12. Key UX Decisions & Rationale (Admin)

| Decision | Rationale |
|---|---|
| Floor Map as Primary Landing | Operational efficiency: admins need to see the floor status at a glance upon opening the app. |
| Role-Based UI Masking | Security and clarity: Staff shouldn't be overwhelmed or tempted by billing override buttons they can't use. |
| Mandatory Reasons for Overrides | Audit compliance: preventing revenue leakage by ensuring all price changes are justified. |
| Extension Availability Check | Friction reduction: prevent admins from extending a session into a time slot already paid for by another player. |
| Integrated Dispute Resolution | Operational speed: allows admins to resolve player complaints directly from their mobile device on the floor. |
| WebSocket for Floor Status | Accuracy: in a busy gaming zone, system status changes every few seconds; polling is too slow. |
| Append-Only Ledgers | Financial integrity: ensuring that the revenue history is immutable and errors are corrected with new records. |
| Walk-in Quick User Flow | Throughput: Reduces the time spent at the counter for new customers, improving the overall experience. |

---

## 14. Detailed Screen Specifications (Admin)

### Screen 41 — Admin Login (Expanded)
- **UI Details**:
  - Branding: Large SVG logo of Gaming Zone.
  - Form: Floating label inputs for `Email` and `Password`.
  - Security: CAPTCHA triggered after 3 failed attempts.
- **API Call**: `POST /auth/admin/login`
- **Logic**:
  - Validates `admin` scope.
  - Redirects to MFA (Multi-Factor Authentication) if enabled for the store.
- **State**: Persists `admin` object and `accessToken` in SecureStorage.

### Screen 42 — Admin Dashboard / Floor Map (Expanded)
- **Layout**:
  - Responsive grid: 2-column on small screens, 4-column on large tablets.
  - Quick Filter Chips: [All] [PC] [Console] [VR] [Maintenance].
- **Live Counters**:
  - `total_active_sessions`: Direct from `/ws/stores/:storeId/live`.
  - `occupancy_gauge`: Real-time percentage.
- **Component**: `SystemTile`
  - Props: `systemId`, `status`, `timeRemaining`, `playerName`.
  - Event: `onTap` → Navigate to Screen 43.
  - Event: `onLongPress` → Context menu: [Force Logout], [Send Message], [Unlock Manually].
- **API**: `GET /stores/:storeId/systems/live`
- **Real-time**: `system.status_updated`, `heartbeat.received`.

### Screen 43 — Session Management (Expanded)
- **Header**: Sticky system info bar with "Live" badge.
- **Main View**:
  - Left Column (or Top): Active Session Card with big timer.
  - Right Column (or Bottom): Action List.
- **Modal**: `ExtendSessionSheet`
  - Fetches `/pricing/calculate` as user slides the duration bar.
  - Shows [Potential Conflict] warning if another booking exists.
- **API**: `GET /stores/:storeId/sessions/:id/logs`
- **Logic**: Prevents [End Session] if there is an unhandled billing dispute on the same user.

### Screen 44 — Walk-in Booking (Expanded)
- **Step 1: User Discovery**
  - Search field with QR scanner icon (scan player's app ID).
  - List of 3 "Recent Walk-ins" for quick re-selection.
- **Step 2: System & Time**
  - Grid of available system numbers.
  - Horizontal scroll for duration presets (30m, 1h, 2h, 4h).
- **Step 3: Payment**
  - Multi-select: [Cash] [UPI] [Card] [Store Credits].
  - Summary: Subtotal + Tax - Discount = Total.
- **API**: `POST /stores/:storeId/bookings/walk-in`

### Screen 45 — Booking Management (Expanded)
- **Search**: Fuzzy search by name, booking ID, or phone.
- **Tabs**: 
  - `Pending`: Requires check-in.
  - `Active`: Currently on-floor.
  - `No-Show`: Past the grace period.
- **Detail View**: 
  - Player history summary (e.g., "3rd visit this week").
  - [Override System] button to move a player to a different PC.

### Screen 46 — Analytics Dashboard (Expanded)
- **Widgets**:
  - `RevenueWidget`: Today's revenue vs. same day last week.
  - `OccupancyWidget`: Real-time gauge.
  - `RetentionWidget`: New vs. returning players ratio.
- **Interactivity**: Tap any widget to navigate to the full detail screen (47-51).
- **API**: `GET /stores/:storeId/analytics/dashboard`

### Screen 47 — Revenue Analytics (Expanded)
- **Filters**: [Gross Revenue] [Net Revenue] [Discounts] [Credits Redeemed].
- **Chart**: Multi-series line chart showing daily peaks.
- **Table**: Exportable grid with sortable columns.

### Screen 48 — Utilization Heatmap (Expanded)
- **Visualization**: D3-based heatmap grid.
- **Controls**: [Day View] [Week View] [Month View].
- **Context**: "Typical Saturday: 80% full from 2 PM onwards."

### Screen 49 — Session Statistics (Expanded)
- **Metric Tiles**: 
  - `AvgTime`: Average session duration.
  - `Conversion`: Booking to check-in rate.
  - `Churn`: Users who haven't returned in 7 days.
- **Chart**: Session length buckets.

### Screen 50 — Player Analytics (Expanded)
- **Profile Explorer**: Click any "Top Player" to view their full activity history.
- **Demographics**: (Optional) Age/Gender if collected during registration.
- **Tier Tracking**: Number of users in each loyalty tier.

### Screen 51 — System Performance (Expanded)
- **Status List**: Sorted by ROI (Revenue per System).
- **Maintenance Log**: History of "Offline" events per unit.
- **Agent Version**: Tracking which PCs need software updates.

### Screen 52 — Pricing Rules (Expanded)
- **Rule Editor**: 
  - Visual time picker for Happy Hour rules.
  - Multiplier slider (0.5x to 3.0x).
- **Validation**: Prevents creating two "Base" rules for the same system type.

### Screen 53 — Billing & Payments (Expanded)
- **Audit View**: Shows original price vs. overridden price with the admin's name attached.
- **Receipts**: [Send Email Receipt] action.
- **Payment Reconciliation**: Total collected vs. total expected from sessions.

### Screen 54 — Campaign Management (Expanded)
- **Templates**: [Welcome Bonus] [Flash Sale] [Happy Hour] [Tier Upgrade].
- **Conditions Builder**: "Min duration > 120 mins AND Tier = Gold".

### Screen 55 — Credits Management (Expanded)
- **Ledger View**: Immutable list of credit transactions.
- **Admin Action**: [Give Comp Credits] requires a reason from a dropdown.

### Screen 56 — Dispute Resolution (Expanded)
- **Split Screen**: 
  - Left: User's complaint + image attachments.
  - Right: System logs (Agent heartbeats, session start/stop times).
- **Quick Resolve**: [Refund 50%] [Refund 100%] [Deny].

### Screen 57 — System Management (Expanded)
- **Inventory View**: Tabbed by platform (PC/PS5/VR).
- **Configuration**: Edit system specs (CPU, GPU, RAM) for the Player App's detail view.

### Screen 58 — Staff Management (Expanded)
- **Role Manager**: Edit what "Staff" can see (e.g., hide revenue).
- **History**: Log of all admin actions (extensions, overrides).

### Screen 59 — Store Config (Expanded)
- **Operational Policies**: 
  - No-show grace period (minutes).
  - Minimum booking duration.
  - Auto-end sessions at store closing time.

### Screen 60 — Admin Notifications (Expanded)
- **Composer**: Rich text editor for announcements.
- **Scheduling**: Send now or at a future date (e.g., before a tournament).

---

## 15. Deep Link Map (Admin)

| URL Pattern | Target Screen |
|---|---|
| `gzapp://admin/dashboard` | Screen 42 |
| `gzapp://admin/sessions/{id}` | Screen 43 |
| `gzapp://admin/bookings` | Screen 45 |
| `gzapp://admin/disputes/{id}` | Screen 56 |
| `gzapp://admin/analytics` | Screen 46 |

*(See §9 for the full API Coverage Map.)*
