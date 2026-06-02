# GZ Design — Missing Screens Master Spec

**Purpose:** One-shot prompt for adding all screens present in the Flutter app but absent from the design canvas.
Follow every section in order. Reuse existing shared components (`Phone`, `TopBar`, `BottomNav`, `Scroll`, `Tag`, `Chip`, `Button`, `Avatar`, `MetaRow`, `Collapse`, `I` icons — all exposed on `window`). Match the existing visual language exactly: warm-paper background `#F1F1EF`, white cards, mint tint for active states, black pill CTAs.

---

## 0. Prerequisite — Add one token to `src/tokens.css`

Append inside `:root`:

```css
/* admin accent — maps to AppColors.rose = AppColors.err */
--gz-rose:    #9A2A1F;
--gz-rose-bg: #F2DAD5;
```

The admin sub-app uses this rose/red throughout (FABs, live badges, active filter chips, danger actions). The player sub-app does not use it.

---

## 1. Fixes to existing artboards in `index.html` (do first, no new files)

| Artboard `id` | Current label | Fix label to |
|---|---|---|
| `activity` | `Activity hub` | `Sessions` |
| `confirmation` | `Booking confirmation` | `Booking success` |
| `systems` | `Systems → calendar` | `Systems browser / availability` |
| `system-picker` | `System picker` | `Booking — System type` |

No JSX changes needed — just update the `label=` prop on each `<DCArtboard>`.

---

## 2. New sections to add to `index.html`

Append these `<DCSection>` blocks **inside `<DesignCanvas>`**, after the existing `screens11` section. Also add a `<script>` tag for each new JSX file.

### Script tags to add (in `<head>`, after the existing script tags):

```html
<script type="text/babel" src="src/screen-register.jsx"></script>
<script type="text/babel" src="src/screen-book-systems.jsx"></script>
<script type="text/babel" src="src/screen-active-session-detail.jsx"></script>
<script type="text/babel" src="src/screen-admin-login.jsx"></script>
<script type="text/babel" src="src/screen-admin-password-reset.jsx"></script>
<script type="text/babel" src="src/screen-admin-dashboard.jsx"></script>
<script type="text/babel" src="src/screen-admin-session-mgmt.jsx"></script>
<script type="text/babel" src="src/screen-admin-walk-in.jsx"></script>
<script type="text/babel" src="src/screen-admin-bookings.jsx"></script>
<script type="text/babel" src="src/screen-admin-analytics.jsx"></script>
<script type="text/babel" src="src/screen-admin-revenue.jsx"></script>
<script type="text/babel" src="src/screen-admin-utilization.jsx"></script>
<script type="text/babel" src="src/screen-admin-session-stats.jsx"></script>
<script type="text/babel" src="src/screen-admin-players.jsx"></script>
<script type="text/babel" src="src/screen-admin-system-perf.jsx"></script>
<script type="text/babel" src="src/screen-admin-management.jsx"></script>
<script type="text/babel" src="src/screen-admin-pricing.jsx"></script>
<script type="text/babel" src="src/screen-admin-billing.jsx"></script>
<script type="text/babel" src="src/screen-admin-campaigns.jsx"></script>
<script type="text/babel" src="src/screen-admin-credits.jsx"></script>
<script type="text/babel" src="src/screen-admin-disputes.jsx"></script>
<script type="text/babel" src="src/screen-admin-store.jsx"></script>
<script type="text/babel" src="src/screen-admin-staff.jsx"></script>
<script type="text/babel" src="src/screen-admin-config.jsx"></script>
<script type="text/babel" src="src/screen-admin-notifications.jsx"></script>
```

### DCSection blocks to add inside `<DesignCanvas>`:

```jsx
<DCSection id="screens-player-extra" title="13 · Player — missing screens"
  subtitle="Register, book-tab systems browser, active session detail">
  <DCArtboard id="register"              label="Register"                width={PHONE_W} height={PHONE_H}>
    <RegisterScreen />
  </DCArtboard>
  <DCArtboard id="book-systems"          label="Book — Systems browser"  width={PHONE_W} height={PHONE_H}>
    <BookSystemsScreen />
  </DCArtboard>
  <DCArtboard id="active-session-detail" label="Active session detail"   width={PHONE_W} height={PHONE_H}>
    <ActiveSessionDetailScreen />
  </DCArtboard>
</DCSection>

<DCSection id="screens-admin-auth" title="14 · Admin — Auth"
  subtitle="Admin login and password reset">
  <DCArtboard id="admin-login"    label="Admin login"          width={PHONE_W} height={PHONE_H}>
    <AdminLoginScreen />
  </DCArtboard>
  <DCArtboard id="admin-pw-reset" label="Admin password reset" width={PHONE_W} height={PHONE_H}>
    <AdminPasswordResetScreen />
  </DCArtboard>
</DCSection>

<DCSection id="screens-admin-ops" title="15 · Admin — Operations"
  subtitle="Real-time floor map, session control, walk-in, bookings">
  <DCArtboard id="admin-dashboard"    label="Admin dashboard (floor map)"  width={PHONE_W} height={PHONE_H}>
    <AdminDashboardScreen />
  </DCArtboard>
  <DCArtboard id="admin-session-mgmt" label="Session management"           width={PHONE_W} height={PHONE_H}>
    <AdminSessionMgmtScreen />
  </DCArtboard>
  <DCArtboard id="admin-walk-in"      label="Walk-in booking"              width={PHONE_W} height={PHONE_H}>
    <AdminWalkInScreen />
  </DCArtboard>
  <DCArtboard id="admin-bookings"     label="Booking management"           width={PHONE_W} height={PHONE_H}>
    <AdminBookingsScreen />
  </DCArtboard>
</DCSection>

<DCSection id="screens-admin-analytics" title="16 · Admin — Analytics"
  subtitle="Dashboard KPIs, revenue, utilization heatmap, session stats, players, system perf">
  <DCArtboard id="admin-analytics"     label="Analytics hub"           width={PHONE_W} height={PHONE_H}>
    <AdminAnalyticsScreen />
  </DCArtboard>
  <DCArtboard id="admin-revenue"       label="Revenue breakdown"       width={PHONE_W} height={PHONE_H}>
    <AdminRevenueScreen />
  </DCArtboard>
  <DCArtboard id="admin-utilization"   label="Utilization heatmap"     width={PHONE_W} height={PHONE_H}>
    <AdminUtilizationScreen />
  </DCArtboard>
  <DCArtboard id="admin-session-stats" label="Session statistics"      width={PHONE_W} height={PHONE_H}>
    <AdminSessionStatsScreen />
  </DCArtboard>
  <DCArtboard id="admin-players"       label="Player analytics"        width={PHONE_W} height={PHONE_H}>
    <AdminPlayersScreen />
  </DCArtboard>
  <DCArtboard id="admin-system-perf"   label="System performance"      width={PHONE_W} height={PHONE_H}>
    <AdminSystemPerfScreen />
  </DCArtboard>
</DCSection>

<DCSection id="screens-admin-management" title="17 · Admin — Management"
  subtitle="Hub, pricing rules, billing, campaigns, credits, dispute resolution">
  <DCArtboard id="admin-management" label="Management hub"       width={PHONE_W} height={PHONE_H}>
    <AdminManagementScreen />
  </DCArtboard>
  <DCArtboard id="admin-pricing"    label="Pricing rules"        width={PHONE_W} height={PHONE_H}>
    <AdminPricingScreen />
  </DCArtboard>
  <DCArtboard id="admin-billing"    label="Billing & payments"   width={PHONE_W} height={PHONE_H}>
    <AdminBillingScreen />
  </DCArtboard>
  <DCArtboard id="admin-campaigns"  label="Campaign management"  width={PHONE_W} height={PHONE_H}>
    <AdminCampaignsScreen />
  </DCArtboard>
  <DCArtboard id="admin-credits"    label="Credits management"   width={PHONE_W} height={PHONE_H}>
    <AdminCreditsScreen />
  </DCArtboard>
  <DCArtboard id="admin-disputes"   label="Dispute resolution"   width={PHONE_W} height={PHONE_H}>
    <AdminDisputesScreen />
  </DCArtboard>
</DCSection>

<DCSection id="screens-admin-store" title="18 · Admin — Store"
  subtitle="Store hub, staff, config, notifications broadcast">
  <DCArtboard id="admin-store"         label="Store hub"            width={PHONE_W} height={PHONE_H}>
    <AdminStoreScreen />
  </DCArtboard>
  <DCArtboard id="admin-staff"         label="Staff management"     width={PHONE_W} height={PHONE_H}>
    <AdminStaffScreen />
  </DCArtboard>
  <DCArtboard id="admin-config"        label="Store config"         width={PHONE_W} height={PHONE_H}>
    <AdminConfigScreen />
  </DCArtboard>
  <DCArtboard id="admin-notifications" label="Notification broadcast" width={PHONE_W} height={PHONE_H}>
    <AdminNotificationsScreen />
  </DCArtboard>
</DCSection>
```

---

## 3. Shared admin component — `AdminBottomNav`

Add this to `src/components.jsx` (or inline at the top of the first admin JSX file and re-export via `Object.assign(window, {...})`):

```jsx
// Admin bottom nav — 4 tabs: Dashboard, Sessions, Management, Store
// Active tab uses --gz-rose accent; inactive uses --gz-fg-4
function AdminBottomNav({ active = 'dashboard' }) {
  const tabs = [
    { id: 'dashboard',  icon: I.home,   label: 'Floor' },
    { id: 'sessions',   icon: I.clock,  label: 'Sessions' },
    { id: 'management', icon: I.scale,  label: 'Manage' },
    { id: 'store',      icon: I.pc,     label: 'Store' },
  ];
  return (
    <div className="gz-bottomnav" style={{ flexShrink: 0 }}>
      {tabs.map(t => (
        <button key={t.id} data-active={active === t.id}
          style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
            color: active === t.id ? 'var(--gz-rose)' : 'var(--gz-fg-4)' }}>
          {React.cloneElement(t.icon, { style: { width: 20, height: 20 } })}
          <span style={{ fontSize: 10, fontWeight: 600 }}>{t.label}</span>
        </button>
      ))}
    </div>
  );
}

// Admin TopBar — title on the left (not centered), optional back button
function AdminTopBar({ title, subtitle, onBack, trailing }) {
  return (
    <div style={{ padding: '10px 16px 10px', display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0 }}>
      {onBack && (
        <button onClick={onBack} style={{ width: 36, height: 36, border: 0, background: 'transparent',
          color: 'var(--gz-fg)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 0 }}>
          {I.back}
        </button>
      )}
      <div style={{ flex: 1 }}>
        <div className="gz-h2">{title}</div>
        {subtitle && <div className="gz-small" style={{ marginTop: 1 }}>{subtitle}</div>}
      </div>
      {trailing && <div>{trailing}</div>}
    </div>
  );
}

// KPI card used across admin analytics screens
function AdminKpiCard({ label, value, icon, accentColor = 'var(--gz-fg-3)' }) {
  return (
    <div className="gz-card" style={{ flex: 1, padding: 14 }}>
      <div style={{ color: accentColor, marginBottom: 6 }}>
        {React.cloneElement(icon, { style: { width: 18, height: 18 } })}
      </div>
      <div className="gz-h2" style={{ fontFamily: 'var(--gz-mono)' }}>{value}</div>
      <div className="gz-small">{label}</div>
    </div>
  );
}

// Rose filter chip — used in admin filter rows
function AdminChip({ label, active, onClick }) {
  return (
    <button onClick={onClick} style={{
      height: 30, padding: '0 12px', border: 0, borderRadius: 'var(--gz-r-chip)',
      background: active ? 'var(--gz-rose)' : 'var(--gz-card)',
      color: active ? '#fff' : 'var(--gz-fg-2)',
      fontSize: 13, fontWeight: 600, fontFamily: 'inherit',
      boxShadow: active ? 'none' : 'inset 0 0 0 1px var(--gz-rule)',
    }}>{label}</button>
  );
}

// Expose to window
Object.assign(window, { AdminBottomNav, AdminTopBar, AdminKpiCard, AdminChip });
```

---

## 4. Screen-by-screen specs

---

### Screen 1 — Register (`src/screen-register.jsx`)

**Route:** `/auth/register` — comes after Auth Landing when user taps "Create account"
**Component name:** `RegisterScreen`

**Layout:**
```
Phone
  StatusBar
  [Back arrow top-left, transparent AppBar — no title]
  Scroll (pad=true)
    "Create an account"  → gz-h1, mt 12
    [spacer 28px]
    [4 input fields, 16px gap between each]:
      - "Full Name"               → required
      - "Phone Number"            → suffix label "(Optional)"
      - "Email Address"           → suffix label "(Optional)"
      - "Password"                → suffix label "(Optional)", eye toggle icon trailing
    [spacer fills remaining space — use flex: 1]
    Button primary "Register →"  → sticks to bottom above safe area
    [spacer 32px]
```

**Input field style:** Reuse the same input appearance as `EmailLoginScreen` — `background: var(--gz-pill-bg)`, `border-radius: var(--gz-r-inner)`, `border: none`, `padding: 14px 16px`, `font-size: 14px`. Show a focused ring on the "Full Name" field to indicate it's active.

**Bottom CTA:** Black pill button (standard `Button` component, `variant="primary"`) with label `Register`.

**No BottomNav** — this is an auth screen.

**State to show:** Full Name field is focused (simulated with a subtle inset ring `box-shadow: inset 0 0 0 1.5px var(--gz-fg)`).

---

### Screen 2 — Book — Systems Browser (`src/screen-book-systems.jsx`)

**Route:** `/book` (the Book tab root) → this is the starting point of the booking flow when the player taps the Book tab.
**Component name:** `BookSystemsScreen`

**Layout:**
```
Phone
  StatusBar
  [No TopBar — this is a shell tab root]
  [Header row, horizontal, padding 16px top/sides]:
    "Book a System"  → gz-h1, flex: 1
    [Store pill — small rounded badge right-aligned]:
      "GameZone Koramangala ▾"  → background var(--gz-pill-bg), border-radius 999px,
      padding 6px 12px, font-size 13px, font-weight 600
  [Filter chip row — horizontal scrollable, 38px height, gap 8px, px 16px]:
    All (active/filled), PC, PS5, Xbox, VR, Other
  [Divider 1px var(--gz-rule)]
  Scroll (pad=false)
    [Systems list — verticalList, px 16px, pt 12px, gap 10px]:
      5 system cards (mix of statuses):
        Card 1: "PC Station 01", "Seat 1", platform icon PC,  tag ok "Available"
        Card 2: "PC Station 02", "Seat 2", platform icon PC,  tag mute "Booked"
        Card 3: "PS5 Console 01","Seat 3", platform icon PS,  tag ok "Available"
        Card 4: "Xbox Series X", "Seat 4", platform icon xbox,tag mute "Booked"
        Card 5: "VR Pod 01",    "Seat 5", platform icon vr,   tag ok "Available"
  [Bottom bar — background var(--gz-bg), px 16px, pb 16px, pt 8px]:
    Button primary "Check Availability →"
  BottomNav active="book"
```

**System card structure:**
```
[White card, border-radius 16px, padding 14px, flex row]:
  [Platform avatar — 40×40, border-radius 10px, background var(--gz-pill-bg)]:
    Icon (I.pc / I.ps / I.xbox / I.vr) in var(--gz-fg-3)
  [spacer 14px]
  [Column, flex 1]:
    System name  → gz-h3
    "Seat N"     → gz-small
  [Tag ok/mute]
```

**"All" chip is active (filled).** Active chip: `background: var(--gz-btn)`, `color: #fff`. Inactive: `background: var(--gz-card)`, boxShadow inset rule.

---

### Screen 3 — Active Session Detail (`src/screen-active-session-detail.jsx`)

**Route:** `/sessions/active/:id` — drilled into from the Active Session screen when a specific live session is tapped
**Component name:** `ActiveSessionDetailScreen`

**Layout:**
```
Phone
  StatusBar
  TopBar title="Live session" subtitle="GameZone Koramangala" [no trailing]
  Scroll (pad=false, custom padding 16px)
    [Hero timer card — background var(--gz-card-tint), border-radius 20px, padding 24px]:
      "TIME REMAINING"  → gz-meta, text-center, color var(--gz-fg-3)
      [spacer 14px]
      "01:22:38"        → gz-hero (56px mono), text-center, color var(--gz-fg)
      [spacer 6px]
      "37:22 elapsed"   → gz-body, text-center, color var(--gz-fg-2)
      [spacer 18px]
      [Progress bar — full width, 6px height, border-radius 999px]:
        Track: var(--gz-rule)
        Fill: 30% filled, background var(--gz-btn)
      [spacer 14px]
      [Row space-between]:
        "30% elapsed"   → gz-small
        "ID: a3f9b2c1"  → gz-small gz-num
    [spacer 12px]
    [Session details card — white card, border-radius 16px, padding 16px]:
      [Row, align-center]:
        [42×42 icon tile, border-radius 10px, background var(--gz-btn)]:
          I.pc icon, color #fff, 20px
        [spacer 14px]
        [Column, flex 1]:
          "PC Station 03"  → gz-h3
          "GameZone Koramangala"  → gz-small
        Tag ok "Active"
    [spacer 12px]
    [Events log card — white card, border-radius 16px]:
      [Tappable header row, padding 16px, flex space-between]:
        [Row gap 10px]:
          I.list icon, 18px, var(--gz-fg)
          "Session events"  → gz-body semibold
        I.chevDn icon, var(--gz-fg-3) [collapsed state — show chevUp for open]
      [Divider + expanded content when open — show open state]:
        [Event row — padding 12px 16px, border-top 1px var(--gz-rule)]:
          [Row]:
            "09:41"  → gz-small gz-num, width 64px
            "Session started"  → gz-body
        [Event row]:
          "—"  → gz-small gz-num, width 64px
          "Live session in progress"  → gz-body
    [spacer 12px]
    [Live indicator card — white card, border-radius 16px, padding 16px]:
      [Row gap 10px]:
        LiveDot (pulsing green dot)
        "Session is live"  → gz-body semibold, color var(--gz-ok)
```

**No BottomNav** — this is a pushed detail screen with TopBar back navigation.

---

## 5. Admin screens — visual language notes

All admin screens share:
- **No player BottomNav** — use `AdminBottomNav` instead on the 4 hub/tab screens (Dashboard, Sessions hub, Management hub, Store hub)
- **Pushed sub-screens** (pricing, billing, etc.) have no BottomNav at all — just `AdminTopBar` with back arrow
- **Accent color:** `var(--gz-rose)` (`#9A2A1F`) for FABs, active filter chips, live badges, danger buttons, progress fills
- **Same card/background tokens** as player — same `var(--gz-bg)`, `var(--gz-card)`, `var(--gz-rule)`, etc.
- **AppBar style:** Left-aligned title (use `AdminTopBar`), logout icon on Dashboard only

---

### Screen 4 — Admin Login (`src/screen-admin-login.jsx`)

**Route:** `/auth/admin-login`
**Component name:** `AdminLoginScreen`

**Layout:**
```
Phone
  StatusBar
  [Back arrow top-left → returns to Auth Landing]
  Scroll (pad=true)
    [spacer 8px]
    "Admin Portal"      → gz-h1
    [spacer 4px]
    "Sign in to manage your store"  → gz-body-r
    [spacer 36px]
    [Email input field — same style as EmailLoginScreen]:
      label "Email address"
    [spacer 14px]
    [Password input field]:
      label "Password"
      trailing eye-toggle icon (I.user reuse or use a filled circle for hide)
    [spacer 8px]
    [Forgot password link — right-aligned]:
      "Forgot password?"  → gz-small, color var(--gz-fg-2), text-align right
    [spacer 32px]
    Button primary "Sign in"
    [spacer 24px]
    [Centered small text]:
      "Staff access · GameZone Operator"  → gz-small, color var(--gz-fg-3), text-align center
```

**Error state to show in a second artboard variant:** Red banner below the password field — `background: var(--gz-err-bg)`, `color: var(--gz-err)`, `border-radius: 10px`, `padding: 10px 14px`, text "Invalid email or password".

**No BottomNav.**

---

### Screen 5 — Admin Password Reset (`src/screen-admin-password-reset.jsx`)

**Route:** `/auth/admin-password-reset`
**Component name:** `AdminPasswordResetScreen`

**Layout:**
```
Phone
  StatusBar
  [Back arrow → returns to Admin Login]
  Scroll (pad=true)
    "Reset password"    → gz-h1
    [spacer 4px]
    "Enter your admin email and we'll send a reset link."  → gz-body-r
    [spacer 32px]
    [Email input field]:
      label "Admin email address"
    [spacer 24px]
    Button primary "Send reset link"
    [spacer 20px]
    [Success state — show this variant]:
      [Green banner card — background var(--gz-ok-bg), border-radius 14px, padding 16px]:
        [Row gap 10px]:
          I.check icon, color var(--gz-ok), 20px
          "If an account exists with this email, a reset link has been sent."  → gz-body, color var(--gz-ok)
```

**No BottomNav.**

---

### Screen 6 — Admin Dashboard (`src/screen-admin-dashboard.jsx`)

**Route:** `/admin/dashboard` — the Operations tab (Tab 1 of admin shell)
**Component name:** `AdminDashboardScreen`

**Layout:**
```
Phone
  StatusBar
  [Left-aligned AppBar — no back arrow]:
    [Column, flex 1]:
      "Gaming Zone"         → gz-h2
      [Row gap 8px]:
        "Operations · Admin"  → gz-small
        [Live pill badge]:
          [6px green dot] + "Live"  → background var(--gz-ok-bg), color var(--gz-ok),
          border-radius 999px, padding 2px 8px, font-size 11px
    [Logout icon trailing — I.bin styled as logout, var(--gz-fg-3)]
  [spacer 12px]
  [KPI ribbon — 3 cards in a Row, gap 8px, px 16px]:
    AdminKpiCard label="Occupancy" value="8/12"  icon=I.seat  accentColor=var(--gz-rose)
    AdminKpiCard label="Sessions"  value="8"     icon=I.clock accentColor=var(--gz-ok)
    AdminKpiCard label="Available" value="4"     icon=I.games accentColor=var(--gz-fg-3)
  [spacer 14px]
  [Filter chip row — horizontal scroll, px 16px, gap 8px]:
    All (active/rose), PC, Console, VR, Maintenance
  [spacer 12px]
  [Systems grid — 2-column, gap 10px, px 16px]:
    12 system tiles (mix of statuses):
      4 available (green border), 6 in-use (info-blue border), 1 maintenance (warn border), 1 offline (err border)
  AdminBottomNav active="dashboard"
  [FAB — rose circle, bottom-right, position absolute, 56×56px, border-radius 999px]:
    background var(--gz-rose), color #fff, I.plus icon 24px
```

**System tile structure (each tile ~170px tall):**
```
[White card, border-radius 14px, padding 12px, border 2px solid statusColor]:
  [Row space-between]:
    "PC Station 01"  → gz-body semibold, overflow ellipsis
    [8px dot — statusColor filled circle]
  "PC"  → gz-small, color var(--gz-fg-3), mt 4px
  [flex spacer]
  [Bottom content — depends on status]:
    if available: "Available"  → gz-small, color var(--gz-ok)
    if in_use: 
      "Rahul M."    → gz-small
      "1h 22m"      → gz-small, color var(--gz-fg-3)
      [if endingSoon]: "Ending soon" badge → background var(--gz-rose-bg), color var(--gz-rose), font-size 10px
    if maintenance:
      [Row]: I.warnT 14px + "Maintenance" → gz-small, color var(--gz-fg-3)
    if offline:
      "Offline"  → gz-small, color var(--gz-err)
```

**Status colors:**
- available: `var(--gz-ok)` border
- in_use: `var(--gz-info)` border  
- maintenance: `var(--gz-warn)` border
- offline: `var(--gz-err)` border

---

### Screen 7 — Admin Session Management (`src/screen-admin-session-mgmt.jsx`)

**Route:** `/admin/sessions` — drilled into from dashboard by tapping a system tile
**Component name:** `AdminSessionMgmtScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar]:
    title="PC Station 03"
    trailing=[Live badge — green dot + "Live", var(--gz-ok-bg) bg]
    [back arrow → admin dashboard]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [System info bar — white card, border-radius 14px, padding 16px]:
      [Row gap 14px]:
        I.pc icon, 32px, color var(--gz-rose)
        [Column]:
          "PC Station 03"  → gz-h2
          "PC Gaming Rig"  → gz-small
    [spacer 16px]
    [Live timer card — white card, border-radius 14px, padding 24px]:
      "01:22:38"  → gz-hero (44px mono), text-center
      [spacer 10px]
      [Progress bar — 6px, fill 65%, color var(--gz-ok)]:
        Track var(--gz-rule)
      [spacer 8px]
      "57 min remaining"  → gz-small, text-center, color var(--gz-fg-3)
    [spacer 16px]
    [Player info card — white card, border-radius 14px, padding 16px]:
      [Row gap 14px]:
        I.staff icon, 32px, color var(--gz-fg-3)
        [Column]:
          "Rahul Mehra"    → gz-body semibold
          "Walk-in"        → gz-small
    [spacer 16px]
    [Actions section]:
      "Actions"  → gz-small, color var(--gz-fg-3), mb 12px
      [Row gap 10px]:
        [Action tile — white card, border-radius 12px, padding 12px 8px, flex 1, text-center]:
          I.clock icon 20px + "Pause" → gz-small, mt 4px
        [Action tile same]:
          I.spark icon 20px + "Resume"
        [Action tile — background var(--gz-rose), color #fff, border-radius 12px]:
          I.x icon 20px + "End"  → gz-small white
        [Action tile — white card]:
          I.up icon 20px + "Extend"
    [spacer 40px]
```

**No BottomNav** — pushed sub-screen.

---

### Screen 8 — Admin Walk-in Booking (`src/screen-admin-walk-in.jsx`)

**Route:** `/admin/walk-in` — accessed via FAB on dashboard
**Component name:** `AdminWalkInScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Walk-in Booking" onBack=dashboard]
  [Step indicator — 3 dots with connecting line, px 24px, py 12px]:
    Step 1 "Customer" — filled circle var(--gz-fg) (active)
    ──── line ────
    Step 2 "System"   — outlined circle
    ──── line ────
    Step 3 "Payment"  — outlined circle
  Scroll (pad=false, px 16px)
    [spacer 8px]
    [Step 1 content — Customer]:
      [Search bar — white card-inset, border-radius 12px, row]:
        I.search icon + "Search by phone, name, or email…" placeholder → gz-body-r
      [spacer 12px]
      "— or —"  → gz-small, text-center, color var(--gz-fg-3)
      [spacer 12px]
      [New customer card — white card, border-radius 16px, padding 16px]:
        "New customer"  → gz-h3, mb 12px
        [Name input field]
        [spacer 10px]
        [Phone input field]
      [spacer 12px]
      [Existing customer result row — white card, padding 14px, border-radius 12px]:
        [Row gap 12px]:
          Avatar size="md" children="R" index=0
          [Column]:
            "Rahul Mehra"   → gz-body semibold
            "+91 98765 43210"  → gz-small
          I.chev icon trailing
  [Bottom bar — white card border-top, px 16px, py 12px]:
    Button primary "Next: Select System →"
  [No BottomNav]
```

**Show Step 1 (Customer) as the default displayed state.**

---

### Screen 9 — Admin Booking Management (`src/screen-admin-bookings.jsx`)

**Route:** `/admin/bookings`
**Component name:** `AdminBookingsScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Bookings" onBack=dashboard]
  [Date strip — horizontal scroll row, px 16px, py 10px, gap 8px]:
    5 date pills: "Mon 2", "Tue 3", "Wed 4" (active—rose), "Thu 5", "Fri 6"
    Active date pill: background var(--gz-rose), color #fff, border-radius 999px, px 14px py 6px
    Inactive: background var(--gz-pill-bg), color var(--gz-fg-2)
  [Status filter chips — horizontal scroll, px 16px, gap 8px, height 32px]:
    All (active), Unpaid, Paid, Checked In, No Show, Cancelled
  [Divider]
  Scroll (pad=false, px 16px)
    [spacer 8px]
    [Booking cards — 4 rows, gap 10px]:
      Card 1: "Rahul M.", "09:00 – 11:00", "PC Station 01", tag ok "Paid", [Check In button]
      Card 2: "Priya S.", "10:00 – 12:00", "PS5 Console 01", tag warn "Unpaid", [Check In button]
      Card 3: "Amit K.", "11:00 – 13:00", "Xbox S X", tag mute "Checked In"
      Card 4: "Neha R.", "14:00 – 16:00", "VR Pod 01", tag err "No Show"
    [spacer 24px]
```

**Booking card structure:**
```
[White card, border-radius 14px, padding 14px]:
  [Row space-between, align-center]:
    [Column]:
      [Row gap 8px]:
        "Rahul M."    → gz-h3
        Tag (status)
      [spacer 2px]
      "09:00 – 11:00 · PC Station 01"  → gz-small
    [If unpaid/paid]: Button ghost "Check In" → height 32px, font-size 12px, width auto, padding 0 12px
```

**No BottomNav** — pushed sub-screen (from the Sessions tab or directly from Dashboard).

---

### Screen 10 — Admin Analytics Hub (`src/screen-admin-analytics.jsx`)

**Route:** `/admin/analytics` — Analytics tab root (Tab 2 of admin shell)
**Component name:** `AdminAnalyticsScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Analytics" trailing=[I.up icon → revenue drill-down]]
  [Date range chips — px 16px, gap 8px]:
    Today (active/rose), 7 Days, Custom
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [KPI row — 2×2 grid, gap 10px]:
      AdminKpiCard label="Revenue"    value="₹18,420" icon=I.coin accentColor=var(--gz-ok)
      AdminKpiCard label="Sessions"   value="142"     icon=I.clock accentColor=var(--gz-info)
      AdminKpiCard label="Avg. Duration" value="87m"  icon=I.cal  accentColor=var(--gz-fg-3)
      AdminKpiCard label="Walk-ins"   value="34"      icon=I.seat accentColor=var(--gz-rose)
    [spacer 14px]
    [Quick-nav card row — horizontal scroll, gap 10px]:
      [5 small cards — white card, border-radius 14px, padding 12px, width 120px]:
        Card 1: I.coin icon + "Revenue"      → title + gz-small
        Card 2: I.cal icon  + "Utilization"  → gz-small
        Card 3: I.clock icon + "Sessions"    → gz-small
        Card 4: I.staff icon + "Players"     → gz-small
        Card 5: I.pc icon   + "Systems"      → gz-small
    [spacer 14px]
    [Revenue chart placeholder card — white card, border-radius 16px, padding 16px]:
      "Today's revenue"  → gz-h3, mb 12px
      [Bar chart mockup — 7 bars in a row, heights vary]:
        Bars: background var(--gz-card-tint), last bar background var(--gz-btn)
        Each bar: width ~28px, border-radius top 4px
        Below bars: day labels Mon–Sun → gz-small color var(--gz-fg-3)
      [Row space-between, mt 12px]:
        "Total: ₹18,420"  → gz-body semibold
        "vs ₹15,200 yesterday ↑"  → gz-small color var(--gz-ok)
    [spacer 24px]
  AdminBottomNav active="sessions"
```

---

### Screen 11 — Admin Revenue Analytics (`src/screen-admin-revenue.jsx`)

**Route:** `/admin/analytics/revenue` — drilled into from analytics hub
**Component name:** `AdminRevenueScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Revenue" onBack=analytics]
  [Group-by chips — px 16px, gap 8px]:
    Daily (active/rose), Weekly, Monthly
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [Summary card — white card, border-radius 16px, padding 20px]:
      "Total Revenue"  → gz-meta, mb 6px
      "₹1,84,200"      → gz-hero-md (44px mono)
      [spacer 6px]
      "Last 30 days"   → gz-small
    [spacer 12px]
    [Payment breakdown card — white card, border-radius 16px, padding 16px]:
      "Payment breakdown"  → gz-h3, mb 14px
      [3 rows with MetaRow]:
        MetaRow label="Cash"      value="₹72,400"
        MetaRow label="UPI"       value="₹89,200"
        MetaRow label="Credits"   value="₹22,600"
      [Divider]
      MetaRow label="Total" value="₹1,84,200" valueClass="gz-body" (semibold)
    [spacer 12px]
    [Revenue table — white card, border-radius 16px, padding 16px]:
      "Daily breakdown"  → gz-h3, mb 12px
      [Table header row — gz-meta, color var(--gz-fg-3)]:
        "DATE" | "SESSIONS" | "REVENUE"  → spaced flex
      [6 data rows]:
        "Jun 01" | "28" | "₹8,400"
        "Jun 02" | "31" | "₹9,300"
        "Jun 03" | "25" | "₹7,500"
        "Jun 04" | "29" | "₹8,700"
        "Jun 05" | "33" | "₹9,900"
        "Jun 06" | "34" | "₹10,200"
    [spacer 24px]
  [No BottomNav — pushed sub-screen]
```

---

### Screen 12 — Admin Utilization Heatmap (`src/screen-admin-utilization.jsx`)

**Route:** `/admin/analytics/utilization`
**Component name:** `AdminUtilizationScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Utilization" onBack=analytics]
  [View mode chips — Day (active/rose), Week]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [Peak hours card — white card, border-radius 16px, padding 16px]:
      "Peak hour: 7 PM – 9 PM"  → gz-h3
      [spacer 4px]
      "89% average occupancy"   → gz-small, color var(--gz-ok)
    [spacer 12px]
    [Heatmap grid card — white card, border-radius 16px, padding 16px]:
      "Hourly occupancy"  → gz-h3, mb 14px
      [Time label row — 24 columns (10am–12am), small hour labels]:
        "10" "11" "12" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" → gz-meta
      [Grid — 12 rows (systems) × 14 columns (hours)]:
        Each cell: 18×18px square, border-radius 3px, gap 2px
        Color intensity: white (0%) → var(--gz-card-tint) (50%) → var(--gz-btn) (100%)
        Show realistic pattern: morning low, afternoon medium, evening peak (cols 7-9 are darkest)
      [Legend row, mt 8px]:
        "0%" [white box] → [mint box] → [black box] "100%" → gz-small
    [spacer 12px]
    [Summary stats card — white card, border-radius 16px, padding 16px]:
      [3 MetaRows]:
        MetaRow label="Avg occupancy" value="67%"
        MetaRow label="Peak time"     value="7:00 PM"
        MetaRow label="Quietest"      value="11:00 AM"
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 13 — Admin Session Statistics (`src/screen-admin-session-stats.jsx`)

**Route:** `/admin/analytics/sessions`
**Component name:** `AdminSessionStatsScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Session Stats" onBack=analytics]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [4 stat cards in 2×2 grid, gap 10px]:
      AdminKpiCard label="Avg Duration"   value="87 min"  icon=I.clock accentColor=var(--gz-info)
      AdminKpiCard label="Completion"     value="94%"     icon=I.check accentColor=var(--gz-ok)
      AdminKpiCard label="Walk-ins"       value="34"      icon=I.seat  accentColor=var(--gz-rose)
      AdminKpiCard label="Bookings"       value="108"     icon=I.cal   accentColor=var(--gz-fg-3)
    [spacer 14px]
    [Session type breakdown card — white card, border-radius 16px, padding 16px]:
      "Session types"  → gz-h3, mb 14px
      [Row space-between, mb 8px]:
        "Walk-in"   → gz-body
        [Row gap 8px]:
          [Progress bar — 100px wide, 6px, filled 24%, var(--gz-rose)]
          "24%"  → gz-small gz-num
      [Row space-between]:
        "Booking"   → gz-body
        [Row gap 8px]:
          [Progress bar — 76% fill, var(--gz-info)]
          "76%"  → gz-small gz-num
    [spacer 12px]
    [Recent sessions list — white card, border-radius 16px, padding 16px]:
      "Recent sessions"  → gz-h3, mb 12px
      [4 session rows, each with border-top 1px var(--gz-rule) except first]:
        Row 1: "Rahul M. · PC Station 01" + "2h 10m" + Tag ok "Completed"
        Row 2: "Priya S. · PS5 Console"   + "1h 30m" + Tag ok "Completed"
        Row 3: "Amit K. · Xbox Series X"  + "0h 45m" + Tag warn "Early end"
        Row 4: "Neha R. · VR Pod 01"      + "2h 00m" + Tag ok "Completed"
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 14 — Admin Player Analytics (`src/screen-admin-players.jsx`)

**Route:** `/admin/analytics/players`
**Component name:** `AdminPlayersScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Players" onBack=analytics]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [Segment breakdown card — white card, border-radius 16px, padding 16px]:
      "Player segments"  → gz-h3, mb 14px
      [2 large stats in a Row, gap 12px]:
        [Column, flex 1, center-text]:
          "68"   → gz-h1 gz-num
          "New"  → gz-small
        [Vertical rule 1px var(--gz-rule)]
        [Column, flex 1, center-text]:
          "74"       → gz-h1 gz-num
          "Returning"  → gz-small
    [spacer 12px]
    [Top players card — white card, border-radius 16px, padding 16px]:
      "Top players · minutes"  → gz-h3, mb 12px
      [5 player rows, gap: border-top 1px var(--gz-rule) between]:
        Row with: rank number + avatar + name + minutes played + I.chev
        1. Avatar "R" + "Rahul Mehra"  + "420 min"
        2. Avatar "P" + "Priya Singh"  + "380 min"
        3. Avatar "A" + "Amit Kumar"   + "310 min"
        4. Avatar "N" + "Neha Reddy"   + "290 min"
        5. Avatar "S" + "Suresh V."    + "245 min"
    [spacer 12px]
    [Summary stats — white card, border-radius 16px, padding 16px]:
      MetaRow label="Total players" value="142"
      MetaRow label="Active today"  value="28"
      MetaRow label="Avg sessions/player" value="2.3"
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 15 — Admin System Performance (`src/screen-admin-system-perf.jsx`)

**Route:** `/admin/analytics/systems`
**Component name:** `AdminSystemPerfScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="System Performance" onBack=analytics]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [Per-system list — one card per system, gap 10px]:
      6 cards, each:
        [White card, border-radius 14px, padding 14px]:
          [Row space-between, mb 10px]:
            [Row gap 10px]:
              [Platform icon tile — 36×36, border-radius 8px, var(--gz-pill-bg)]:
                I.pc / I.ps / I.xbox / I.vr icon, 18px, var(--gz-fg-3)
              [Column]:
                "PC Station 01"  → gz-h3
                "PC Gaming Rig"  → gz-small
            [Column, align-end]:
              "₹12,400"   → gz-body semibold gz-num
              "revenue"   → gz-small
          [Utilization bar row]:
            "Utilization: 78%"  → gz-small, mb 4px
            [Progress bar — 6px, 78% fill, var(--gz-card-tint)]
          [If low usage — warning badge]:
            [Warn badge — background var(--gz-warn-bg), color var(--gz-warn), border-radius 8px, padding 4px 8px, mt 8px]:
              I.warnT 12px + "Low usage — consider promotion"  → font-size 11px
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 16 — Admin Management Hub (`src/screen-admin-management.jsx`)

**Route:** `/admin/management` — Management tab root (Tab 3 of admin shell)
**Component name:** `AdminManagementScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Management" — no back arrow (tab root)]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [5 nav tiles — white cards, border-radius 14px, padding 16px, gap 10px]:
      Tile 1: [I.scale icon 22px var(--gz-rose)] + "Pricing Rules"    + I.chev trailing
      Tile 2: [I.coin icon 22px var(--gz-info)]  + "Billing & Payments" + I.chev
      Tile 3: [I.gift icon 22px var(--gz-ok)]    + "Campaigns"          + I.chev
      Tile 4: [I.star icon 22px var(--gz-warn)]  + "Credits"            + I.chev
      Tile 5: [I.sos icon 22px var(--gz-err)]    + "Disputes"           + I.chev
    [spacer 24px]
  AdminBottomNav active="management"
```

**Each tile structure:**
```
[White card, border-radius 14px, padding 16px]:
  [Row, align-center, gap 14px]:
    [36×36 tile, border-radius 10px, background = icon-color at 12% opacity]:
      icon in iconColor
    [Column, flex 1]:
      "Pricing Rules"  → gz-h3
    I.chev → var(--gz-fg-3)
```

---

### Screen 17 — Admin Pricing Rules (`src/screen-admin-pricing.jsx`)

**Route:** `/admin/pricing`
**Component name:** `AdminPricingScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Pricing Rules" onBack=management trailing=[I.plus icon — add rule]]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [4 pricing rule cards, gap 10px]:
      Each card:
        [White card, border-radius 14px, padding 16px]:
          [Row space-between, align-center]:
            [Column]:
              "Standard Rate"        → gz-h3
              "₹80/hour · All day"   → gz-small, mt 2px
            [Toggle — pill shape]:
              Active toggle: background var(--gz-ok), white thumb
              Inactive toggle: background var(--gz-rule), grey thumb
          [Row mt 10px, gap 6px]:
            Tag mute "PC"
            Tag mute "All hours"
      Cards: 
        1. "Standard Rate" ₹80/hr, active toggle, tags [PC] [All hours]
        2. "Peak Hour"     ₹120/hr "6 PM–10 PM", active toggle, tags [All] [Evening]
        3. "Weekend Rate"  ₹100/hr "Sat–Sun", active toggle, tags [All] [Weekend]
        4. "VR Premium"    ₹150/hr, inactive toggle, tags [VR] [All hours]
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 18 — Admin Billing & Payments (`src/screen-admin-billing.jsx`)

**Route:** `/admin/billing`
**Component name:** `AdminBillingScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Billing" onBack=management]
  [Status filter chips — px 16px, gap 8px, horizontal scroll]:
    All (active/rose), Unpaid, Paid, Overridden
  Scroll (pad=false, px 16px)
    [spacer 8px]
    [4 billing record cards, gap 10px]:
      Each card:
        [White card, border-radius 14px, padding 14px]:
          [Row space-between, align-center, mb 6px]:
            "Rahul Mehra"    → gz-h3
            Tag (status-based)
          "PC Station 01 · 2h 10m"  → gz-small
          [Row space-between, mt 8px]:
            "₹1,740"  → gz-body semibold gz-num
            [If unpaid and super_admin]: Button ghost "Override" → sm variant, width auto
      Cards:
        1. "Rahul Mehra",  "PC Station 01 · 2h 10m", "₹1,740", tag ok "Paid"
        2. "Priya Singh",  "PS5 Console · 1h 30m",   "₹1,200", tag warn "Unpaid", "Override" btn
        3. "Amit Kumar",   "Xbox Series X · 45m",     "₹600",   tag mute "Overridden"
        4. "Neha Reddy",   "VR Pod 01 · 2h 00m",     "₹3,000", tag ok "Paid"
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 19 — Admin Campaign Management (`src/screen-admin-campaigns.jsx`)

**Route:** `/admin/campaigns`
**Component name:** `AdminCampaignsScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Campaigns" onBack=management]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [3 campaign cards, gap 12px]:
      Each card:
        [White card, border-radius 16px, padding 16px]:
          [Row space-between, align-center, mb 6px]:
            "Welcome Bonus"    → gz-h3
            Tag ok/err/mute (status)
          "Earn 2× credits on first booking"  → gz-small, mb 10px
          [MetaRow label="Redemptions" value="142"]
          [MetaRow label="Expires"     value="Dec 31, 2025"]
          [Row mt 12px, gap 8px]:
            Button ghost "Pause"  → sm variant, flex 1
            Button ghost "Edit"   → sm variant, flex 1
      Cards:
        1. "Welcome Bonus"     "2× credits · first booking"  redemptions=142, tag ok "Active"
        2. "Happy Hours"       "50% off 2–5 PM Mon–Thu"      redemptions=89,  tag ok "Active"
        3. "Summer Blast"      "Free hour with 2-hour booking" redemptions=234, tag mute "Paused"
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 20 — Admin Credits Management (`src/screen-admin-credits.jsx`)

**Route:** `/admin/credits`
**Component name:** `AdminCreditsScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Credits" onBack=management]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [Search bar — white card inset, border-radius 12px, px 12px]:
      [Row gap 8px]:
        I.search icon 18px var(--gz-fg-3)
        "Search by phone, email, or name…"  → gz-body-r placeholder text
    [spacer 14px]
    [Player result card — white card, border-radius 16px, padding 16px]:
      [Row gap 12px, mb 14px]:
        Avatar size="lg" children="R" index=0
        [Column]:
          "Rahul Mehra"       → gz-h3
          "+91 98765 43210"   → gz-small
      [Balance highlight — background var(--gz-card-tint), border-radius 12px, padding 14px, text-center]:
        "CREDIT BALANCE"  → gz-meta, mb 4px
        "850"             → gz-hero-md (44px mono)
        "credits"         → gz-small
      [spacer 14px]
      [Transaction history header row space-between]:
        "Recent transactions"  → gz-h3
        "See all →"  → gz-small, color var(--gz-fg-2)
      [3 transaction rows, border-top 1px var(--gz-rule)]:
        Row: "Booking credit"   "+200"  gz-num color var(--gz-ok)   · "Jun 02"
        Row: "Session deduct"   "−150"  gz-num color var(--gz-err)  · "Jun 01"
        Row: "Welcome bonus"    "+500"  gz-num color var(--gz-ok)   · "May 28"
      [spacer 14px, if canAdjust]:
        [Row gap 10px]:
          Button ghost "Deduct credits" → flex 1
          Button primary "Add credits"  → flex 1
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 21 — Admin Dispute Resolution (`src/screen-admin-disputes.jsx`)

**Route:** `/admin/disputes`
**Component name:** `AdminDisputesScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Disputes" onBack=management]
  [Status filter chips — px 16px, gap 8px]:
    All (active/rose), Open, In Review, Resolved
  Scroll (pad=false, px 16px)
    [spacer 8px]
    [4 dispute cards, gap 10px]:
      Each card:
        [White card, border-radius 14px, padding 14px]:
          [Row space-between, align-center, mb 4px]:
            "Rahul Mehra"  → gz-h3
            Tag err/warn/ok (status)
          "Overcharged for session duration"  → gz-small, mb 8px
          [Row space-between]:
            "Jun 02, 2025"  → gz-small
            [If open/in_review]: Button ghost "Resolve →" → sm, width auto
      Cards:
        1. "Rahul Mehra",  "Overcharged for session",    tag err "Open",      "Resolve →"
        2. "Priya Singh",  "Credits not applied",        tag warn "In Review", "Resolve →"
        3. "Amit Kumar",   "System not working properly", tag ok "Resolved"
        4. "Neha Reddy",   "Booking cancelled, no refund", tag err "Open",    "Resolve →"
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 22 — Admin Store Hub (`src/screen-admin-store.jsx`)

**Route:** `/admin/systems` — Store tab root (Tab 4 of admin shell)
**Component name:** `AdminStoreScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Store" — no back arrow (tab root)]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [4 nav tiles — white cards, border-radius 14px, padding 16px, gap 10px]:
      Tile 1: [I.pc icon 22px var(--gz-info)] + "System Management" + I.chev
      Tile 2: [I.staff icon 22px var(--gz-purple)] + "Staff Management" + I.chev
      Tile 3: [I.filter icon 22px var(--gz-fg-3)] + "Store Config" + I.chev
      Tile 4: [I.bell icon 22px var(--gz-warn)] + "Notifications" + I.chev
    [spacer 24px]
  AdminBottomNav active="store"
```

---

### Screen 23 — Admin Staff Management (`src/screen-admin-staff.jsx`)

**Route:** `/admin/staff`
**Component name:** `AdminStaffScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Staff" onBack=store trailing=[I.plus icon — super_admin only]]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [Role legend row — px 0, mb 12px]:
      Tag purple "Super Admin" · Tag info "Admin" · Tag mute "Staff"  → spaced with gap 6px
    [4 staff member cards, gap 10px]:
      Each card:
        [White card, border-radius 14px, padding 14px]:
          [Row gap 12px, align-center]:
            Avatar size="lg" index={i}
            [Column, flex 1]:
              "Raj Kumar"    → gz-h3
              "raj@store.in" → gz-small
            Tag purple/info/mute (role)
            [If super_admin: trash icon button — I.bin, color var(--gz-err), 18px]
      Cards:
        1. "Raj Kumar",     "raj@store.in",    tag purple "Super Admin"
        2. "Meera Nair",    "meera@store.in",  tag info "Admin"
        3. "Suresh Verma",  "suresh@store.in", tag mute "Staff"
        4. "Ananya Das",    "ananya@store.in", tag mute "Staff"
    [spacer 24px]
  [No BottomNav]
```

---

### Screen 24 — Admin Store Config (`src/screen-admin-config.jsx`)

**Route:** `/admin/config` — Super Admin only
**Component name:** `AdminConfigScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Store Config" onBack=store trailing=[Button ghost "Save" sm]]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [Settings section — white card, border-radius 16px, padding 16px, mb 12px]:
      "Booking settings"  → gz-h3, mb 14px
      [Input row — label above, input below, mb 12px]:
        "Booking window (minutes)"  → gz-meta, mb 4px
        [Input field — pillBg, border-radius 10px, padding 10px 12px]: "1440"
      [Input row]:
        "Payment window (minutes)"  → gz-meta, mb 4px
        [Input field]: "30"
      [Input row]:
        "No-show grace (minutes)"   → gz-meta, mb 4px
        [Input field]: "10"
      [Input row]:
        "Max booking duration (min)"  → gz-meta, mb 4px
        [Input field]: "240"
    [Settings section — white card, border-radius 16px, padding 16px, mb 12px]:
      "Operating hours"  → gz-h3, mb 14px
      [Row gap 10px]:
        [Column, flex 1]:
          "Opens"  → gz-meta, mb 4px
          [Input]: "10:00"
        [Column, flex 1]:
          "Closes"  → gz-meta, mb 4px
          [Input]: "23:00"
    [Settings section — white card, border-radius 16px, padding 16px]:
      "Operations"  → gz-h3, mb 14px
      [Toggle row — Row space-between, align-center, mb 12px]:
        [Column]:
          "Allow walk-ins"  → gz-body semibold
          "Accept on-site bookings"  → gz-small
        [Toggle — active, var(--gz-ok)]
      [Toggle row]:
        [Column]:
          "Auto-start on check-in"  → gz-body semibold
          "Begin session immediately on check-in"  → gz-small
        [Toggle — active, var(--gz-ok)]
    [spacer 24px]
  [No BottomNav]
```

**Toggle style:** pill-shaped, 44×24px. Active: `background: var(--gz-ok)` with white circle thumb on right. Inactive: `background: var(--gz-rule)` with grey thumb on left.

---

### Screen 25 — Admin Notifications Broadcast (`src/screen-admin-notifications.jsx`)

**Route:** `/admin/notifications`
**Component name:** `AdminNotificationsScreen`

**Layout:**
```
Phone
  StatusBar
  [AdminTopBar title="Notifications" onBack=store]
  Scroll (pad=false, px 16px)
    [spacer 12px]
    [Channel selector — white card, border-radius 16px, padding 16px, mb 12px]:
      "Broadcast channel"  → gz-h3, mb 12px
      [3-button row, gap 8px]:
        AdminChip label="Push"  active=true
        AdminChip label="Email" active=false
        AdminChip label="SMS"   active=false
    [Target selector — white card, border-radius 16px, padding 16px, mb 12px]:
      "Audience"  → gz-h3, mb 12px
      [2-button row, gap 8px]:
        AdminChip label="All Players" active=true
        AdminChip label="Active Now"  active=false
    [Message compose — white card, border-radius 16px, padding 16px]:
      "Compose"  → gz-h3, mb 14px
      [Title input]:
        "Notification title"  → gz-meta, mb 4px
        [Input field — pillBg, border-radius 10px, padding 12px 14px]:
          "Happy Hours start at 2 PM!" (placeholder value)
      [spacer 10px]
      [Body input]:
        "Message body"  → gz-meta, mb 4px
        [Textarea — pillBg, border-radius 10px, padding 12px 14px, min-height 80px]:
          "Get 50% off all systems from 2 PM to 5 PM today." (placeholder)
    [spacer 16px]
    [Preview card — background var(--gz-info-bg), border-radius 14px, padding 14px]:
      "Preview"  → gz-meta, mb 8px
      [Row gap 10px]:
        [40×40 app icon placeholder — rounded rect, background var(--gz-btn)]:
          "GZ" letters white
        [Column]:
          "GZ Gaming Zone"              → gz-small semibold
          "Happy Hours start at 2 PM!"  → gz-body
    [spacer 16px]
    Button primary "Send notification"
    [spacer 24px]
  [No BottomNav]
```

---

## 6. Summary checklist

| # | File to create | Component exported | Section |
|---|---|---|---|
| 1 | `src/screen-register.jsx` | `RegisterScreen` | 13 |
| 2 | `src/screen-book-systems.jsx` | `BookSystemsScreen` | 13 |
| 3 | `src/screen-active-session-detail.jsx` | `ActiveSessionDetailScreen` | 13 |
| 4 | `src/screen-admin-login.jsx` | `AdminLoginScreen` | 14 |
| 5 | `src/screen-admin-password-reset.jsx` | `AdminPasswordResetScreen` | 14 |
| 6 | `src/screen-admin-dashboard.jsx` | `AdminDashboardScreen` | 15 |
| 7 | `src/screen-admin-session-mgmt.jsx` | `AdminSessionMgmtScreen` | 15 |
| 8 | `src/screen-admin-walk-in.jsx` | `AdminWalkInScreen` | 15 |
| 9 | `src/screen-admin-bookings.jsx` | `AdminBookingsScreen` | 15 |
| 10 | `src/screen-admin-analytics.jsx` | `AdminAnalyticsScreen` | 16 |
| 11 | `src/screen-admin-revenue.jsx` | `AdminRevenueScreen` | 16 |
| 12 | `src/screen-admin-utilization.jsx` | `AdminUtilizationScreen` | 16 |
| 13 | `src/screen-admin-session-stats.jsx` | `AdminSessionStatsScreen` | 16 |
| 14 | `src/screen-admin-players.jsx` | `AdminPlayersScreen` | 16 |
| 15 | `src/screen-admin-system-perf.jsx` | `AdminSystemPerfScreen` | 16 |
| 16 | `src/screen-admin-management.jsx` | `AdminManagementScreen` | 17 |
| 17 | `src/screen-admin-pricing.jsx` | `AdminPricingScreen` | 17 |
| 18 | `src/screen-admin-billing.jsx` | `AdminBillingScreen` | 17 |
| 19 | `src/screen-admin-campaigns.jsx` | `AdminCampaignsScreen` | 17 |
| 20 | `src/screen-admin-credits.jsx` | `AdminCreditsScreen` | 17 |
| 21 | `src/screen-admin-disputes.jsx` | `AdminDisputesScreen` | 17 |
| 22 | `src/screen-admin-store.jsx` | `AdminStoreScreen` | 18 |
| 23 | `src/screen-admin-staff.jsx` | `AdminStaffScreen` | 18 |
| 24 | `src/screen-admin-config.jsx` | `AdminConfigScreen` | 18 |
| 25 | `src/screen-admin-notifications.jsx` | `AdminNotificationsScreen` | 18 |

**Also update `src/components.jsx`** — append `AdminBottomNav`, `AdminTopBar`, `AdminKpiCard`, `AdminChip` and add them to the `Object.assign(window, {...})` call.

**Also update `src/tokens.css`** — append `--gz-rose` and `--gz-rose-bg` inside `:root`.

**Also update `index.html`** — add 4 artboard label fixes (Section 1) and the 6 new DCSection blocks with 25 artboards (Section 2), plus all 25 `<script>` tags in `<head>`.
