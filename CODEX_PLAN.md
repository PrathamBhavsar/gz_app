# GZ App — Codex UI Rebuild Plan

Design-driven full UI rewrite. Every screen is rebuilt from the design artboards in `../design/index.html`.
No backend integration. All screens use static hardcoded data matching the design.

---

## Ground Rules (read before every phase)

1. **Design is the source of truth.** Open `../design/index.html` in a browser to see every artboard. Each artboard maps to exactly one screen.
2. **Static data only.** No providers, no repositories, no services. Screens are `StatelessWidget` (or `StatefulWidget` only when the design shows interactive UI state like tabs, toggles, collapsibles, step indicators).
3. **One file per screen.** No `_mobile_layout` / `_tablet_layout` splits. Single dart file per route.
4. **Use `gz_*` widgets only** (created in Phase 0). Never import `em_*` widgets.
5. **Keep intact:** `lib/core/navigation/routes.dart`, `lib/core/navigation/app_router.dart`, `lib/core/theme/app_colors.dart`, `lib/core/theme/app_typography.dart`, `lib/core/theme/app_spacing.dart`, `main.dart`.
6. **Delete cleanly.** When a phase says delete a directory, delete the whole directory — do not leave orphaned files.
7. **`flutter analyze` must show 0 errors before committing.** Warnings are acceptable, errors are not.
8. **Commit after each phase** using the exact message specified at the end of each phase section.

---

## Design Artboard → Route → File Map (master reference)

| Artboard ID | Artboard label | Route | Screen file |
|---|---|---|---|
| `splash` | Splash screen | `/` | `splash_screen.dart` |
| `onboarding` | Onboarding | `/onboarding` | `onboarding_screen.dart` |
| `auth` | Auth landing | `/auth` | `auth_landing_screen.dart` |
| `register` | Register | `/auth/register` | `register_screen.dart` |
| `otp` | OTP verification | `/auth/otp` | `otp_verification_screen.dart` |
| `email-login` | Email login | `/auth/email-login` | `email_login_screen.dart` |
| `oauth-handler` | OAuth handler | `/auth/oauth-handler` | `oauth_handler_screen.dart` |
| `forgot` | Forgot password | `/auth/forgot-password` | `forgot_password_screen.dart` |
| `reset-password` | Reset password | `/auth/reset-password` | `reset_password_screen.dart` |
| `verify-pending` | Verify pending | `/auth/email-verification-pending` | `email_verification_pending_screen.dart` |
| `email-verify-success` | Email verify success | `/auth/email-verified` *(add this route)* | `email_verify_success_screen.dart` |
| `admin-login` | Admin login | `/auth/admin-login` | `admin_login_screen.dart` |
| `admin-pw-reset` | Admin password reset | `/auth/admin-password-reset` | `admin_password_reset_screen.dart` |
| `home` | Home feed | `/home` | `home_screen.dart` |
| `storesearch` | Store search | `/home/search` | `store_search_screen.dart` |
| `store` | Store detail | `/home/store/:slug` | `store_detail_screen.dart` |
| `book-systems` | Book — Systems browser | `/book` | `booking_slot_selection_screen.dart` |
| `systems` | Systems browser / availability | `/book/availability` | `booking_availability_screen.dart` |
| `system-picker` | Booking — System type | `/book/systems` | `booking_system_selection_screen.dart` |
| `booking` | Booking summary | `/book/summary` | `booking_summary_screen.dart` |
| `confirmation` | Booking success | `/book/success` | `booking_success_screen.dart` |
| `activity` | Sessions | `/sessions` | `sessions_screen.dart` |
| `session` | Active session | `/sessions/active` | `active_session_screen.dart` |
| `active-session-detail` | Active session detail | `/sessions/active/:id` | `active_session_detail_screen.dart` |
| `booking-detail` | Booking detail | `/sessions/booking/:id` | `booking_detail_screen.dart` |
| `checkin` | Check-in | `/sessions/booking/:id/check-in` | `check_in_screen.dart` |
| `payment` | Complete payment | `/sessions/booking/:id/pay` | `payment_screen.dart` |
| `history` | Session receipt | `/sessions/history/:id` | `session_history_detail_screen.dart` |
| `billing` | Billing history | `/sessions/billing` | `billing_history_screen.dart` |
| `wallet` | Wallet home | `/wallet` | `wallet_screen.dart` |
| `credits` | Credit transactions | `/wallet/transactions` | `credit_history_screen.dart` |
| `campaigns` | Campaigns list | `/wallet/campaigns` | `campaigns_screen.dart` |
| `campaign` | Campaign detail | `/wallet/campaigns/:id` | `campaign_detail_screen.dart` |
| `redeem` | Redeem credits | *(modal sheet)* | `redeem_credits_sheet.dart` |
| `profilehome` | Profile hub | `/profile` | `profile_screen.dart` |
| `profile` | Edit profile | `/profile/edit` | `edit_profile_screen.dart` |
| `change-phone` | Change phone | `/profile/change-phone` | `change_phone_screen.dart` |
| `notif-prefs-default` | Notification prefs | `/profile/notifications` | `notif_prefs_screen.dart` |
| `disputes-list` | My disputes | `/profile/disputes` | `disputes_list_screen.dart` |
| `dispute-create` | File dispute | `/profile/disputes/create` | `create_dispute_screen.dart` |
| `dispute-detail` | Dispute detail | `/profile/disputes/:id` | `dispute_detail_screen.dart` |
| `notifications` | Notification center | `/notifications` | `notifications_screen.dart` |
| `store-selector` | Store selector sheet | *(modal)* | `store_selector_sheet.dart` |
| `admin-dashboard` | Admin dashboard | `/admin/dashboard` | `admin_dashboard_screen.dart` |
| `admin-session-mgmt` | Session management | `/admin/sessions` | `session_management_screen.dart` |
| `admin-walk-in` | Walk-in booking | `/admin/walk-in` | `walk_in_booking_screen.dart` |
| `admin-bookings` | Booking management | `/admin/bookings` | `booking_management_screen.dart` |
| `admin-analytics` | Analytics hub | `/admin/analytics` | `admin_analytics_screen.dart` |
| `admin-revenue` | Revenue breakdown | `/admin/analytics/revenue` | `revenue_analytics_screen.dart` |
| `admin-utilization` | Utilization heatmap | `/admin/analytics/utilization` | `utilization_heatmap_screen.dart` |
| `admin-session-stats` | Session statistics | `/admin/analytics/sessions` | `session_statistics_screen.dart` |
| `admin-players` | Player analytics | `/admin/analytics/players` | `player_analytics_screen.dart` |
| `admin-system-perf` | System performance | `/admin/analytics/systems` | `system_performance_screen.dart` |
| `admin-management` | Management hub | `/admin/management` | `admin_management_screen.dart` |
| `admin-pricing` | Pricing rules | `/admin/pricing` | `pricing_rules_screen.dart` |
| `admin-billing` | Billing & payments | `/admin/billing` | `billing_payments_screen.dart` |
| `admin-campaigns` | Campaign management | `/admin/campaigns` | `campaign_management_screen.dart` |
| `admin-credits` | Credits management | `/admin/credits` | `credits_management_screen.dart` |
| `admin-disputes` | Dispute resolution | `/admin/disputes` | `dispute_resolution_screen.dart` |
| `admin-store` | Store hub | `/admin/systems` | `admin_store_screen.dart` |
| `admin-staff` | Staff management | `/admin/staff` | `staff_management_screen.dart` |
| `admin-config` | Store config | `/admin/config` | `store_config_screen.dart` |
| `admin-notifications` | Notification broadcast | `/admin/notifications` | `admin_notifications_screen.dart` |

---

## Phase 0 — Widget Library + Route Fixes

**Goal:** Replace all 15 `em_*` shared widgets with 11 `gz_*` widgets that exactly match the design component library. Add 1 missing route.

### Step 1 — Add missing route

In `lib/core/navigation/routes.dart`, add inside the auth block:
```dart
static const emailVerified = '/auth/email-verified';
```

In `lib/core/navigation/app_router.dart`, add a `GoRoute` for `AppRoutes.emailVerified` pointing to a placeholder `EmailVerifySuccessScreen` (the real screen is built in Phase 1). For now, just `Scaffold(body: Center(child: Text('Email verified')))`.

### Step 2 — Delete all em_* widget files

Delete every file in `lib/shared/widgets/` that starts with `em_`:
```
em_avatar.dart
em_bottom_nav.dart
em_button.dart
em_card.dart
em_chip.dart
em_gz_logo.dart
em_icon_btn.dart
em_live_dot.dart
em_meta_row.dart
em_progress_bar.dart
em_scroll_content.dart
em_section_head.dart
em_store_selector_pill.dart
em_tag.dart
em_top_bar.dart
```

### Step 3 — Create gz_* widget files

Create each file below in `lib/shared/widgets/`. All consume tokens from `AppColors` and `AppTypography`.

---

#### `gz_top_bar.dart`
Replaces: `EmTopBar`
Design component: `TopBar` in `src/components.jsx`

```dart
// GzTopBar — centered title, back arrow left, optional trailing right
// Matches design TopBar exactly: 40px back button, centered gz-h2 title,
// optional gz-small subtitle below title, 40px trailing slot.
class GzTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GzTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.disableBack = false,
  });
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool disableBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  // Layout: 3-column grid — [back 40px] [title+subtitle center] [trailing 40px]
  // Title: AppTypography.h2 (18px semibold)
  // Subtitle: AppTypography.small (12px, AppColors.textTertiary)
  // Back button: HugeIcon ArrowLeft01, AppColors.textPrimary
  // Background: transparent (Scaffold handles background)
}
```

---

#### `gz_admin_top_bar.dart`
Design component: `AdminTopBar` in design spec

```dart
// GzAdminTopBar — LEFT-aligned title (not centered), optional back button,
// optional trailing widget. Used only in admin screens.
// Title: AppTypography.h2
// Subtitle: AppTypography.small, AppColors.textTertiary
// No centering — title fills flex space to the right of the back button.
class GzAdminTopBar extends StatelessWidget implements PreferredSizeWidget { ... }
```

---

#### `gz_bottom_nav.dart`
Replaces: `EmBottomNav`
Design component: `BottomNav` in `src/components.jsx` — 5 tabs

```dart
// GzBottomNav — 5 player tabs: Home, Book, Sessions, Wallet, Profile
// Active tab: AppColors.textPrimary (black)
// Inactive tab: AppColors.textMuted (#B5B5AF)
// Background: AppColors.surface (white card)
// Border-radius top: 28px
// Padding: 14px top, 22px bottom (safe area aware)
// Tab icons (HugeIcons): Home, Book, GameController, Wallet, User
// No labels — icon-only matching design
enum GzTab { home, book, sessions, wallet, profile }

class GzBottomNav extends StatelessWidget {
  const GzBottomNav({super.key, required this.currentTab, required this.onTap});
  final GzTab currentTab;
  final ValueChanged<GzTab> onTap;
}
```

---

#### `gz_admin_bottom_nav.dart`
Design component: `AdminBottomNav` in design spec

```dart
// GzAdminBottomNav — 4 admin tabs: Floor, Sessions, Manage, Store
// Active tab: AppColors.rose (#9A2A1F)
// Inactive: AppColors.textMuted
// Shows icon + label text (10px, bold) unlike player nav which is icon-only
// Tab icons: Home (floor), Clock (sessions), Scale (manage), Monitor (store)
enum GzAdminTab { dashboard, sessions, management, store }

class GzAdminBottomNav extends StatelessWidget {
  const GzAdminBottomNav({super.key, required this.currentTab, required this.onTap});
  final GzAdminTab currentTab;
  final ValueChanged<GzAdminTab> onTap;
}
```

---

#### `gz_button.dart`
Replaces: `EmButton`, `EmButtonFull`
Design component: `Button` in `src/components.jsx`

```dart
// GzButton — full-width by default (matches design .gz-btn)
// Variants: primary (black bg, white text), ghost (pill-bg, rule border),
//           dangerOutline (transparent, err text+border), sm (38px height)
// Height: 56px primary/ghost, 38px sm
// Border-radius: 12px (var(--gz-r-inner))
// Font: 15px/600 primary, 13px sm
// Disabled: opacity 0.4
enum GzButtonVariant { primary, ghost, dangerOutline }

class GzButton extends StatelessWidget {
  const GzButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GzButtonVariant.primary,
    this.small = false,
    this.icon,          // optional leading icon widget
    this.loading = false,
  });
}
```

---

#### `gz_tag.dart`
Replaces: `EmTag`
Design component: `Tag` in `src/components.jsx`

```dart
// GzTag — small status pill, 22px height, 8px h-padding, 999px radius
// Kinds: ok, warn, err, info, mute, purple
// Font: 11px/600
// Colors pulled from AppColors (okBg/ok, warnBg/warn, errBg/err, infoBg/info, pillBg/fg-2, purpleBg/purple)
enum GzTagKind { ok, warn, err, info, mute, purple }

class GzTag extends StatelessWidget {
  const GzTag({super.key, required this.kind, required this.label});
}
```

---

#### `gz_chip.dart`
Replaces: `EmChip`
Design component: `Chip` in `src/components.jsx`

```dart
// GzChip — 30px height, 12px h-padding, 10px radius (var(--gz-r-chip))
// Variants: ghost (white bg, rule border) and filled (black bg, white text)
// Used in filter rows: a horizontal ListView.builder of GzChip widgets
// Optional key prefix (the .gz-chip__k pattern — muted color prefix label)
class GzChip extends StatelessWidget {
  const GzChip({
    super.key,
    required this.label,
    this.keyPrefix,      // optional muted prefix text
    this.active = false,
    this.onTap,
  });
}
```

---

#### `gz_avatar.dart`
Replaces: `EmAvatar`
Design component: `Avatar` in `src/components.jsx`

```dart
// GzAvatar — circular avatar with Walle palette (7 muted bg/fg pairs)
// Sizes: sm=32, md=34, lg=40, xl=56
// Shows either an icon OR a single letter (children string)
// Color selected by: index param OR first char of letter string (hash)
// Walle palette (bg → fg):
//   0: #EAD5C8 → #5C4A40  (peachy beige)
//   1: #D4E4D8 → #3D5A45  (sage green)
//   2: #DFD4E8 → #534968  (lavender)
//   3: #E8D4D4 → #685454  (rose)
//   4: #D4E0E8 → #40536B  (slate blue)
//   5: #E8E4D4 → #6B6340  (wheat)
//   6: #E4D8D4 → #6B5954  (terracotta)
enum GzAvatarSize { sm, md, lg, xl }

class GzAvatar extends StatelessWidget {
  const GzAvatar({
    super.key,
    this.letter,         // single character to display
    this.icon,           // HugeIcon alternative
    this.size = GzAvatarSize.md,
    this.index,          // force palette index
  });
}
```

---

#### `gz_meta_row.dart`
Replaces: `EmMetaRow`
Design component: `MetaRow` in `src/components.jsx`

```dart
// GzMetaRow — horizontal row: left label (body-r, fg-2) and right value (body mono)
// 6px vertical padding, space-between alignment
// Optional valueBold for emphasis
class GzMetaRow extends StatelessWidget {
  const GzMetaRow({
    super.key,
    required this.label,
    required this.value,
    this.valueBold = false,
  });
}
```

---

#### `gz_collapse.dart`
Design component: `Collapse` in `src/components.jsx`

```dart
// GzCollapse — white card with tappable header that toggles content
// Header: title (h2 left) + optional right widget + chevron (rotates 180° when open)
// When open: content shown below with 0 16px 16px padding
// Card border-radius: var(--gz-r-card) = 26px
class GzCollapse extends StatefulWidget {
  const GzCollapse({
    super.key,
    required this.title,
    required this.child,
    this.initiallyOpen = false,
    this.trailing,       // widget shown left of the chevron
  });
}
```

---

#### `gz_live_dot.dart`
Replaces: `EmLiveDot`
Design component: `LiveDot` in `src/components.jsx`

```dart
// GzLiveDot — 8px circle, AppColors.ok green, pulsing ring animation
// Animation: scale pulse 0→8px ring, 1.6s ease-out infinite
// Used inline: Row(children: [GzLiveDot(), SizedBox(width:8), Text('Live')])
class GzLiveDot extends StatefulWidget { ... }
```

---

### Step 4 — Verify

```bash
flutter analyze    # must show 0 errors
```

Fix any import errors caused by deleting em_* files in non-screen files (connectivity_banner.dart, page_error_display.dart, store_selector_sheet.dart — update their imports to gz_*).

### Step 5 — Commit

```
git commit -m "phase 0: replace em_* widget library with gz_* design-faithful components"
```

---

## Phase 1 — Auth + Onboarding (13 screens)

**Goal:** Rebuild all auth and onboarding screens from design artboards. No BottomNav on any of these screens.

**Artboards to implement:** `splash`, `onboarding`, `auth`, `register`, `otp`, `email-login`, `oauth-handler`, `forgot`, `reset-password`, `verify-pending`, `email-verify-success`, `admin-login`, `admin-pw-reset`

### Step 1 — Delete

```
lib/features/auth/presentation/           (entire directory)
lib/features/admin/presentation/screens/admin_login_screen.dart
lib/features/admin/presentation/screens/admin_password_reset_screen.dart
```

### Step 2 — Create screens

All screens live in their existing route-mapped paths. Recreate each as a single self-contained file.

**`lib/features/auth/presentation/screens/splash/splash_screen.dart`**
- Artboard: `splash`
- Full-screen, `AppColors.background` scaffold, no AppBar, no BottomNav
- Centered: GZ logo mark (can be a styled Text "GZ" in Geist Mono 48px bold, or a simple geometric shape) + below it "Gaming Zone" in `AppTypography.h2`
- Auto-navigation simulated: after 2s delay (use `Timer` in `initState`) navigate to `/onboarding`

**`lib/features/auth/presentation/screens/onboarding/onboarding_screen.dart`**
- Artboard: `onboarding`
- 3-slide PageView. Show slide 1 as the active state.
- Each slide: large illustration placeholder (colored rounded rect 280×280, `AppColors.surfaceTint`), title, subtitle
- Slide data:
  - 1: title "Book your station", subtitle "Reserve a gaming system at your favourite zone in seconds."
  - 2: title "Play without limits", subtitle "Track your sessions, credits and history all in one place."
  - 3: title "Powered by GZ", subtitle "The fastest way to game on demand."
- Bottom: page dot indicators + "Get started" `GzButton` (primary) that navigates to `/auth`
- "Skip" text link top-right

**`lib/features/auth/presentation/screens/auth_landing/auth_landing_screen.dart`**
- Artboard: `auth` (the "Auth landing → register" artboard)
- No AppBar
- Top: GZ wordmark
- Middle: "Welcome back" headline (gz-h1), subtitle "Sign in to continue"
- Social buttons (ghost GzButton, full width, with icon prefix):
  - "Continue with Google"
  - "Continue with Apple"
- Divider row: "— or —"
- "Continue with email" (ghost GzButton) → navigates to `/auth/email-login`
- Bottom: "New here? Create account →" text that navigates to `/auth/register`
- Tertiary link: "Admin? Sign in →" navigates to `/auth/admin-login`

**`lib/features/auth/presentation/screens/register/register_screen.dart`**
- Artboard: `register`
- Back arrow AppBar (transparent), no title
- Title: "Create an account" (gz-h1), top of scroll
- 4 input fields (TextField, `AppColors.pillBg` fill, no border, `borderRadius` 12):
  - "Full Name" (focused — show focus ring `AppColors.textPrimary` 1.5px)
  - "Phone Number" with suffix hint "(Optional)"
  - "Email Address" with suffix hint "(Optional)"
  - "Password" with suffix hint "(Optional)" + eye icon trailing
- Spacer + `GzButton` primary "Register" at bottom

**`lib/features/auth/presentation/screens/otp/otp_verification_screen.dart`**
- Artboard: `otp`
- Back arrow AppBar
- "Verify your number" (gz-h1)
- Subtitle: "We sent a 6-digit code to +91 98765 43210"
- 6-box OTP input row (each box: 48×56px, `AppColors.surface` bg, `AppColors.rule` border, 12px radius; active box has `AppColors.textPrimary` border)
- Show boxes 1-4 filled (digits "4 2 1 8"), box 5 active (cursor), box 6 empty
- "Resend code" text link below (muted, "Resend in 0:42")
- `GzButton` primary "Verify" at bottom

**`lib/features/auth/presentation/screens/email_login/email_login_screen.dart`**
- Artboard: `email-login`
- Back arrow AppBar, title "Email login" (centered, gz-h2)
- Email input field: "Email address"
- Password input field: "Password" + eye toggle trailing
- "Forgot password?" right-aligned text link → `/auth/forgot-password`
- `GzButton` primary "Sign in"
- Below: "Don't have an account? Register →" → `/auth/register`

**`lib/features/auth/presentation/screens/oauth_handler/oauth_handler_screen.dart`**
- Artboard: `oauth-handler`
- Full-screen centered, no AppBar
- Circular progress indicator (`AppColors.textPrimary`)
- "Signing you in…" (gz-body, `AppColors.textSecondary`)
- "GZ" logo above

**`lib/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart`**
- Artboard: `forgot`
- Back arrow AppBar, title "Forgot password"
- "We'll send a reset link to your email." subtitle
- Email input field
- `GzButton` primary "Send reset link"
- Show success state: green banner `AppColors.okBg` with check icon + "Reset link sent. Check your inbox." `AppColors.ok`

**`lib/features/auth/presentation/screens/reset_password/reset_password_screen.dart`**
- Artboard: `reset-password`
- Back arrow AppBar, title "Reset password"
- New password input (obscure, eye toggle)
- Confirm password input (obscure, eye toggle)
- `GzButton` primary "Set new password"

**`lib/features/auth/presentation/screens/email_verification_pending/email_verification_pending_screen.dart`**
- Artboard: `verify-pending`
- No AppBar
- Centered: envelope icon (HugeIcons email/mail), large
- "Check your inbox" (gz-h1)
- "We sent a verification link to rahul@example.com"
- `GzButton` ghost "Resend email"
- Text link "Wrong email? Go back"

**`lib/features/auth/presentation/screens/email_verify_success/email_verify_success_screen.dart`** *(new file)*
- Artboard: `email-verify-success`
- No AppBar, full-screen centered
- Large check circle icon (`AppColors.ok`)
- "Email verified!" (gz-h1)
- "Redirecting you in 4…" countdown (use `StatefulWidget` + `Timer`)
- `GzButton` primary "Continue to app" → navigates to `/home`

**`lib/features/admin/presentation/screens/admin_login_screen.dart`**
- Artboard: `admin-login`
- Back arrow → `/auth`
- "Admin Portal" (gz-h1), subtitle "Sign in to manage your store" (body-r)
- Email input field
- Password input field with eye toggle
- "Forgot password?" right-aligned → `/auth/admin-password-reset`
- `GzButton` primary "Sign in"
- "Staff access · GameZone Operator" centered small text below

**`lib/features/admin/presentation/screens/admin_password_reset_screen.dart`**
- Artboard: `admin-pw-reset`
- Back arrow → `/auth/admin-login`
- "Reset password" (gz-h1)
- "Enter your admin email and we'll send a reset link." (body-r)
- Email input field
- `GzButton` primary "Send reset link"
- Show success banner (same green banner pattern as forgot password screen)

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 1: auth + onboarding screens rebuilt from design (13 screens)"
```

---

## Phase 2 — Player Shell + Home + Discovery (4 screens + shell)

**Goal:** Player shell with `GzBottomNav`, home feed, store search, store detail.

**Artboards:** `home`, `storesearch`, `store`

### Step 1 — Delete

```
lib/features/home/presentation/           (entire directory)
lib/features/main_shell/presentation/     (entire directory)
```

### Step 2 — Create screens

**`lib/features/main_shell/presentation/screens/main_page.dart`**
- The player shell scaffold. Uses `GzBottomNav`.
- `currentTab` tracked in local `StatefulWidget` state (no Riverpod).
- Tapping a tab navigates with `context.go(route)` using `GoRouter`.
- The shell wraps all 5 player tabs via the existing `ShellRoute` in `app_router.dart` — update `app_router.dart` to use a `GzBottomNav` in the shell's `builder`.

**`lib/features/home/presentation/screens/home_screen.dart`**
- Artboard: `home`
- No AppBar (custom header inside Scroll)
- Header row: "Hey, Rahul 👋" (gz-h1) + bell icon button trailing (→ `/notifications`)
- Store selector pill ("GameZone Koramangala ▾") as a tappable row that calls `showStoreSelectorSheet`
- Section "Nearby stores" — horizontal scroll of 3 store cards
  - Each store card: 200×140px white card, store name (gz-h3), "2.4 km · 8 systems", rating "4.8 ⭐", available/busy tag
  - Store data: "GameZone Koramangala" (available), "GameZone Indiranagar" (busy), "GameZone Whitefield" (available)
- Section "Your recent" — 2 recent session row items
  - Row: store name + system + date + duration
- Section "Active campaigns" — horizontal scroll of 2 campaign pills
  - "Welcome Bonus · 2× credits" (ok tag), "Happy Hours · 50% off" (info tag)

**`lib/features/home/presentation/screens/store_search/store_search_screen.dart`**
- Artboard: `storesearch`
- `GzTopBar` title "Find a store", no trailing
- Search bar (pillBg bg, search icon, "Search by name or area…" hint)
- Filter chips row: "All", "Open now", "Nearby", "PC", "VR"
- Results list: 4 store cards, each:
  - White card, padding 14px, store name (gz-h3) + distance + system count + open/closed tag
  - Stores: "GameZone Koramangala · 2.4 km · 12 systems" (ok "Open"), "GameZone Indiranagar · 3.1 km · 8 systems" (ok "Open"), "GameZone Whitefield · 5.8 km · 16 systems" (mute "Closed"), "GameZone HSR · 4.2 km · 6 systems" (ok "Open")

**`lib/features/home/presentation/screens/store_detail/store_detail_screen.dart`**
- Artboard: `store`
- `GzTopBar` title "GameZone Koramangala", trailing: share icon
- Hero image placeholder: 390×200px `AppColors.surfaceTint` rect
- Store name (gz-h1), rating row "4.8 ⭐ · 142 reviews", "Open · 10:00 AM – 11:00 PM"
- Section "Systems" — 3 system chips: "10 PC", "2 PS5", "1 VR"
- Section "Pricing": MetaRow "Standard rate" "₹80/hr", MetaRow "Peak (6–10 PM)" "₹120/hr"
- Map placeholder: 390×150px pillBg rect with pin icon centered
- `GzButton` primary "Book a system" at bottom (→ `/book`)

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 2: player shell (GzBottomNav) + home + store search + store detail"
```

---

## Phase 3 — Booking Flow (5 screens)

**Artboards:** `book-systems`, `systems`, `system-picker`, `booking`, `confirmation`

### Step 1 — Delete

```
lib/features/booking/presentation/    (entire directory)
```

### Step 2 — Create screens

**`lib/features/booking/presentation/screens/slot_selection/booking_slot_selection_screen.dart`**
- Artboard: `book-systems` (Book tab root `/book`)
- No AppBar — custom header in body
- Header row: "Book a System" (gz-h1) + store selector pill ("GameZone Koramangala ▾")
- Horizontal filter chips: All (active), PC, PS5, Xbox, VR, Other
- Divider 1px
- Systems list (5 cards):
  - PC Station 01 / Seat 1 / pc icon / tag ok "Available"
  - PC Station 02 / Seat 2 / pc icon / tag mute "Booked"
  - PS5 Console 01 / Seat 3 / ps icon / tag ok "Available"
  - Xbox Series X / Seat 4 / xbox icon / tag mute "Booked"
  - VR Pod 01 / Seat 5 / vr icon / tag ok "Available"
- Sticky bottom: `GzButton` primary "Check Availability" → `/book/availability`

**`lib/features/booking/presentation/screens/availability/booking_availability_screen.dart`**
- Artboard: `systems` (the calendar/slot step)
- `GzTopBar` title "Pick a time", subtitle "RTX 4090 · Seat 3"
- Date strip: horizontal scroll of 7 days (Mon–Sun), "Wed 4" active (black pill)
- Time slot grid: 30-min slots from 10 AM – 11 PM in a wrapping chip grid
  - Available slots: white card, border `AppColors.rule`
  - Booked slots: `AppColors.pillBg` bg, muted text
  - Selected slot: `AppColors.textPrimary` bg, white text
  - Show "6:00 PM" as selected
- `GzButton` primary "Select system →" → `/book/systems`

**`lib/features/booking/presentation/screens/system_selection/booking_system_selection_screen.dart`**
- Artboard: `system-picker` (exact system selection step 3)
- `GzTopBar` title "Pick your system", subtitle "Wed 4 · 6:00 PM – 8:00 PM"
- Sort chips: Recommended (active), Price ↑, Price ↓, Availability
- Systems list (5 items):
  - RTX 4090 Gaming PC / Seat 3 / "RTX 4090 · 32GB · 240Hz · 4K" / ₹80/hr / tag ok "Available" / "Recommended" badge (`AppColors.surfaceTint`)
  - RTX 3080 Gaming PC / Seat 7 / "RTX 3080 · 16GB · 165Hz" / ₹70/hr / tag ok "Available"
  - RTX 3070 Gaming PC / Seat 1 / tag info "In use · free 5:30 PM"
  - RTX 3060 Gaming PC / Seat 9 / ₹55/hr / tag ok "Available"
  - i9 High Perf PC / Seat 2 / ₹90/hr / tag mute "Unavailable"
- Tapping a card selects it (StatefulWidget, border highlights)
- `GzButton` primary "Continue to summary" → `/book/summary`

**`lib/features/booking/presentation/screens/summary/booking_summary_screen.dart`**
- Artboard: `booking`
- `GzTopBar` title "Booking summary"
- Card: system info — "RTX 4090 Gaming PC" (gz-h2), "Seat 3", "GameZone Koramangala"
- Card: session details with MetaRows:
  - Date: "Wed, 4 Jun"
  - Time: "6:00 PM – 8:00 PM"
  - Duration: "2 hours"
  - Rate: "₹80/hr"
- Card: cost breakdown:
  - MetaRow "Session": "₹160"
  - MetaRow "Convenience fee": "₹0"
  - Divider
  - MetaRow "Total" (bold): "₹160"
- `GzButton` primary "Confirm booking" → `/book/success`

**`lib/features/booking/presentation/screens/success/booking_success_screen.dart`**
- Artboard: `confirmation`
- No AppBar, full-screen centered
- Large check circle (`AppColors.ok`, 72px)
- "Booking confirmed!" (gz-h1)
- "Booking ID: GZ-2406-4891" (gz-small mono)
- Card: summary — "RTX 4090 · Wed 4 Jun · 6:00 PM" + GzTag ok "Confirmed"
- Two buttons: `GzButton` primary "View booking" → `/sessions/booking/GZ-2406-4891`, `GzButton` ghost "Back to home" → `/home`

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 3: booking flow (5 screens) rebuilt from design"
```

---

## Phase 4 — Sessions (8 screens)

**Artboards:** `activity`, `session`, `active-session-detail`, `booking-detail`, `checkin`, `payment`, `history`, `billing`

### Step 1 — Delete

```
lib/features/sessions/presentation/    (entire directory)
```

### Step 2 — Create screens

**`sessions_screen.dart`** (artboard: `activity` "Sessions")
- No custom AppBar — custom header
- Header: "Sessions" (gz-h1) + filter chips: All / Upcoming / Active / Past
- Active session banner (if any): tinted `AppColors.surfaceTint` card with `GzLiveDot` + "PC Station 03 · Live · 1:22:38 remaining" + "View →" chevron → `/sessions/active/sess-001`
- Upcoming bookings list (2 items):
  - "PC Station 01 · Wed 4 Jun · 6:00 PM" + tag ok "Confirmed" + "Check in" button
  - "PS5 Console · Thu 5 Jun · 4:00 PM" + tag warn "Unpaid" + "Pay" button
- Past sessions list (3 items):
  - Row: store name + system + date + duration + "₹160" (right-aligned)

**`active_session_screen.dart`** (artboard: `session`)
- Full-screen, no BottomNav
- Large tinted card (`AppColors.surfaceTint`): "TIME REMAINING" meta + "01:22:38" gz-hero + progress bar 30% + "37:22 elapsed"
- System info card: "PC Station 03" + "GameZone Koramangala" + `GzTag` ok "Live"
- `GzLiveDot` + "Session is live" row
- `GzButton` dangerOutline "End session early" at bottom

**`active_session_detail_screen.dart`** (artboards: `active-session-detail` + embedded `session-logs`)
- `GzTopBar` title "Live session", subtitle "GameZone Koramangala"
- Hero timer card (`AppColors.surfaceTint`): "TIME REMAINING" + "01:22:38" gz-hero + "37:22 elapsed" + progress bar 30% + "30% elapsed" / "ID: a3f9b2c1"
- System details card: PC icon tile + "PC Station 03" + "GameZone Koramangala" + `GzTag` ok "Active"
- Session events `GzCollapse` (initially open):
  - Filter chips inside: All (active), System, Alerts, Activity
  - Event rows: "09:41 · Session started", "09:41 · System online", "09:45 · Player connected"
- Live indicator card: `GzLiveDot` + "Session is live" (`AppColors.ok`)

**`booking_detail_screen.dart`** (artboard: `booking-detail`)
- `GzTopBar` title "Booking"
- Status card: `GzTag` ok "Confirmed" + "GZ-2406-4891" booking ID mono
- System card: MetaRows — System "PC Station 01", Seat "Seat 3", Store "GameZone Koramangala"
- Timing card: MetaRows — Date "Wed, 4 Jun", Time "6:00 PM – 8:00 PM", Duration "2 hours"
- Payment card: MetaRows — Total "₹160", Status "Unpaid"
- Two action buttons: `GzButton` primary "Check in" → `/sessions/booking/id/check-in`, `GzButton` ghost "Cancel booking"

**`check_in_screen.dart`** (artboard: `checkin`)
- `GzTopBar` title "Check in"
- QR code placeholder: 200×200 white card with a grid pattern (10×10 of small black squares)
- "Show this to staff" (gz-body, centered, `AppColors.textSecondary`)
- Booking info card: "PC Station 01 · 6:00 PM · 2 hours"
- `GzButton` primary "Scan to check in" (disabled — staff action)
- `GzButton` ghost "Manual check in" at bottom

**`payment_screen.dart`** (artboard: `payment` — full screen, not modal)
- `GzTopBar` title "Complete payment"
- Amount card: "₹160" gz-hero-md centered + "Due by 11:00 PM tonight" small
- Payment method cards (selectable, `StatefulWidget`):
  - Cash (cash icon, selected — black border 2px)
  - UPI (upi icon) — tapping expands UPI ID field
  - Card (card icon) — tapping expands card details
- `GzButton` primary "Pay ₹160"

**`session_history_detail_screen.dart`** (artboard: `history` "Session receipt")
- `GzTopBar` title "Session receipt"
- Receipt card: "GZ-2406-4891" ID mono, `GzTag` ok "Completed"
- System: "PC Station 03 · GameZone Koramangala"
- Duration: MetaRows — Started "09:41", Ended "11:48", Duration "2h 07m"
- Cost: MetaRows — Rate "₹80/hr", Total "₹1,740"
- Payment: MetaRows — Method "Cash", Status "Paid"
- Events `GzCollapse`: "09:41 Session started", "11:48 Session ended"

**`billing_history_screen.dart`** (artboard: `billing`)
- `GzTopBar` title "Billing history"
- Filter chips: All (active), Paid, Unpaid, Overdue
- List of 5 billing rows:
  - "GameZone Koramangala · 4 Jun · 2h 07m" + "₹1,740" + `GzTag` ok "Paid"
  - "GameZone Indiranagar · 28 May · 1h 30m" + "₹1,200" + `GzTag` ok "Paid"
  - "GameZone Koramangala · 20 May · 3h 00m" + "₹2,400" + `GzTag` warn "Unpaid"
  - "GameZone Whitefield · 15 May · 2h 00m" + "₹1,600" + `GzTag` ok "Paid"
  - "GameZone HSR · 10 May · 1h 00m" + "₹800" + `GzTag` ok "Paid"

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 4: sessions (8 screens) rebuilt from design"
```

---

## Phase 5 — Wallet (4 screens + 1 modal)

**Artboards:** `wallet`, `credits`, `campaigns`, `campaign`, `redeem`

### Step 1 — Delete

```
lib/features/wallet/presentation/    (entire directory)
```

### Step 2 — Create screens

**`wallet_screen.dart`** (artboard: `wallet`)
- No custom AppBar — "Wallet" gz-h1 header
- Balance hero card (`AppColors.surfaceTint`): "CREDIT BALANCE" meta + "850" gz-hero + "credits" small + "≈ ₹85.00 today" body-r
- Row of 2 action buttons: `GzButton` ghost "Add credits", `GzButton` primary "Redeem" (triggers `RedeemCreditsSheet`)
- Section "Transactions": 3 recent rows
  - "Booking credit +200" ok green / "Jun 02"
  - "Session deduct −150" err red / "Jun 01"
  - "Welcome bonus +500" ok green / "May 28"
- "See all →" text link → `/wallet/transactions`
- Section "Active campaigns": 2 campaign cards (horizontal scroll)

**`credit_history_screen.dart`** (artboard: `credits`)
- `GzTopBar` title "Credit history"
- Filter chips: All (active), Earned, Spent
- List of 6 transaction rows with dividers:
  - "+200 · Booking credit · Jun 02" (ok green)
  - "−150 · Session deduct · Jun 01" (err red)
  - "+500 · Welcome bonus · May 28" (ok green)
  - "−80 · Redemption · May 20" (err red)
  - "+300 · Referral bonus · May 15" (ok green)
  - "−200 · Session deduct · May 10" (err red)

**`campaigns_screen.dart`** (artboard: `campaigns`)
- `GzTopBar` title "Campaigns"
- Filter chips: All (active), Active, Expired
- List of 3 campaign cards:
  - "Welcome Bonus" / "Earn 2× credits on your first booking" / `GzTag` ok "Active" / "Expires Dec 31, 2025"
  - "Happy Hours" / "50% off all systems 2 PM – 5 PM Mon–Thu" / `GzTag` ok "Active" / "Ongoing"
  - "Summer Blast" / "Free hour with any 2-hour booking" / `GzTag` mute "Expired" / "Ended May 1"

**`campaign_detail_screen.dart`** (artboard: `campaign`)
- `GzTopBar` title "Campaign detail"
- Hero card (`AppColors.surfaceTint`): campaign icon (gift) + "Welcome Bonus" gz-h1 + `GzTag` ok "Active"
- Details card: MetaRows — Valid "Until Dec 31, 2025", Redeemed "142 times", Min. booking "1 hour"
- How it works section: numbered steps card
- `GzButton` primary "Apply to next booking"

**`redeem_credits_sheet.dart`** (artboard: `redeem` — modal bottom sheet)
- A bottom sheet (call via `showModalBottomSheet`) not a navigable route
- Grab bar + "Redeem credits" gz-h1
- "10 credits = ₹1" subtitle
- Balance display: "850 credits available" in tinted card
- Slider (StatefulWidget): 0–850, default 300
- Shows: "Redeem: 300 credits = ₹30.00", "Remaining: 550 credits"
- `GzButton` primary "Redeem 300 credits"
- Confirmation state: shows a green success banner

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 5: wallet (4 screens + redeem sheet) rebuilt from design"
```

---

## Phase 6 — Profile + Disputes (7 screens)

**Artboards:** `profilehome`, `profile`, `change-phone`, `notif-prefs-default`, `disputes-list`, `dispute-create`, `dispute-detail`

### Step 1 — Delete

```
lib/features/profile/presentation/     (entire directory)
lib/features/disputes/presentation/    (entire directory)
```

### Step 2 — Create screens

**`profile_screen.dart`** (artboard: `profilehome`)
- No AppBar — "Profile" gz-h1 header
- Profile header card: `GzAvatar` xl letter "R" + "Rahul Mehra" gz-h2 + "rahul@example.com" small + "Edit profile →" link → `/profile/edit`
- Navigation tiles list (each a white card row with icon + label + chevron):
  - Sessions → `/sessions`
  - Wallet → `/wallet`
  - Disputes → `/profile/disputes`
  - Notification preferences → `/profile/notifications`
  - Change phone → `/profile/change-phone`
- `GzButton` dangerOutline "Sign out" at bottom

**`edit_profile_screen.dart`** (artboard: `profile`)
- `GzTopBar` title "Edit profile", trailing "Save" text button
- `GzAvatar` xl "R" centered + "Change photo" link
- Form fields: Full Name ("Rahul Mehra" pre-filled), Email ("rahul@example.com"), Phone ("+91 98765 43210")
- All fields editable

**`change_phone_screen.dart`** (artboard: `change-phone`)
- `GzTopBar` title "Change phone"
- "Current number: +91 98765 43210" (body-r)
- New phone input field + country code picker (+91)
- `GzButton` primary "Send OTP"

**`notif_prefs_screen.dart`** (artboard: `notif-prefs-default`)
- `GzTopBar` title "Notifications"
- "Push notifications" toggle row — master toggle (on by default)
- Section "Channels" — 3 toggle rows: Booking updates (on), Session alerts (on), Promotions (off)
- Section "Topics" — 3 toggle rows: New campaigns (on), System availability (off), Credit expiry (on)
- All toggles are `StatefulWidget` state — tapping toggles the visual state

**`disputes_list_screen.dart`** (artboard: `disputes-list`)
- `GzTopBar` title "My disputes", trailing "+" icon → `/profile/disputes/create`
- Filter chips: All (active), Open, In Review, Resolved
- List of 3 disputes:
  - "Overcharged for session" / "GameZone Koramangala · Jun 02" / `GzTag` err "Open" / chevron → detail
  - "Credits not applied" / "GameZone Indiranagar · May 28" / `GzTag` warn "In Review" / chevron
  - "System not working" / "GameZone Whitefield · May 15" / `GzTag` ok "Resolved" / chevron

**`create_dispute_screen.dart`** (artboard: `dispute-create`)
- `GzTopBar` title "File a dispute"
- Session picker (white card, dropdown-style): "PC Station 03 · Jun 02 · 2h 07m"
- Dispute type chips: Overcharge (selected), Tech issue, Credits, Other
- Issue description textarea (pillBg, 120px height, "Describe the issue…")
- `GzButton` primary "Submit dispute"

**`dispute_detail_screen.dart`** (artboard: `dispute-detail`)
- `GzTopBar` title "Dispute #DIS-001"
- Status card: `GzTag` err "Open" + "Overcharged for session duration"
- Timeline `GzCollapse` (open):
  - "Jun 02 09:41 · Dispute filed"
  - "Jun 02 11:00 · Under review"
- Session reference: MetaRow "Session" "GZ-2406-4891", MetaRow "Amount" "₹1,740"
- `GzButton` ghost "Add comment"

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 6: profile + disputes (7 screens) rebuilt from design"
```

---

## Phase 7 — Notifications + Overlays (1 screen + 2 updated sheets)

**Artboards:** `notifications`, `store-selector`

### Step 1 — Delete

```
lib/features/notifications/presentation/    (entire directory)
```

### Step 2 — Create/update

**`notifications_screen.dart`** (artboard: `notifications`)
- `GzTopBar` title "Notifications", trailing "Mark all read" text
- Filter chips: All (active), Unread, Bookings, Sessions, Promo
- List of 5 notification rows:
  - Unread (left accent bar `AppColors.textPrimary`): "Booking confirmed · PC Station 01 · Just now"
  - Unread: "Session ending in 10 min · 2:38 PM"
  - Read: "Welcome Bonus campaign applied · Yesterday"
  - Read: "Session receipt ready · GZ-2406-4891 · 3 Jun"
  - Read: "New campaign: Happy Hours · 2 Jun"
- Each row: notification icon tile (36×36) + title + subtitle + time

**`store_selector_sheet.dart`** (update existing file to use `gz_*` widgets)
- Grab bar + "Select store" gz-h1
- Search bar (pillBg)
- List of 3 stores with a check mark on active one:
  - "GameZone Koramangala · 2.4 km" ✓ (selected)
  - "GameZone Indiranagar · 3.1 km"
  - "GameZone Whitefield · 5.8 km"

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 7: notifications screen + overlay sheets rebuilt from design"
```

---

## Phase 8 — Admin Shell + Operations (4 screens + shell)

**Artboards:** `admin-dashboard`, `admin-session-mgmt`, `admin-walk-in`, `admin-bookings`

### Step 1 — Delete

```
lib/features/admin/presentation/screens/operations/    (entire directory)
```

### Step 2 — Update admin ShellRoute

In `app_router.dart`, update the admin `ShellRoute` builder to use a `StatefulWidget` admin shell scaffold with `GzAdminBottomNav`. The 4 admin tabs are: Dashboard (`/admin/dashboard`), Sessions (`/admin/sessions`), Management (`/admin/management`), Store (`/admin/systems`).

**`admin_dashboard_screen.dart`** (artboard: `admin-dashboard`)
- `GzAdminTopBar` title "Gaming Zone", subtitle "Operations · Admin" + live pill (`GzLiveDot` + "Live" in okBg)
- Trailing: logout icon
- KPI ribbon (3 equal cards, Row): "8/12 Occupancy", "8 Sessions", "4 Available"
  - Each card: HugeIcon + value (gz-h2 mono) + label (small)
- Filter chips: All (active/rose), PC, Console, VR, Maintenance
- 2-column grid of 12 system tiles (mix of statuses):
  - Available (ok green border): "PC Station 01 · PC · Available"
  - In use (info blue border): "PC Station 02 · PC · Rahul M. · 1h 22m"
  - In use with "Ending soon" rose badge
  - Maintenance (warn border): "VR Pod 02 · VR · 🔧 Maintenance"
  - Offline (err border): "Xbox 01 · Xbox · Offline"
- FAB (rose circle, bottom-right, `AppColors.rose`, `+` icon) → `/admin/walk-in`
- `GzAdminBottomNav` active=dashboard

**`session_management_screen.dart`** (artboard: `admin-session-mgmt`)
- `GzAdminTopBar` title "PC Station 03", back → dashboard, trailing live badge
- System info card: pc icon (rose) + "PC Station 03" + "PC Gaming Rig"
- Timer card: "01:22:38" gz-hero (44px mono) + progress bar 65% + "57 min remaining"
- Player card: user icon + "Rahul Mehra" + "Walk-in"
- Actions label "Actions" (small, muted)
- 4 action tiles Row: Pause / Resume / End (rose bg) / Extend

**`walk_in_booking_screen.dart`** (artboard: `admin-walk-in`)
- `GzAdminTopBar` title "Walk-in Booking", back → dashboard
- Step indicator: 3 steps (User / System / Payment) with connecting lines
- Step 1 content (visible):
  - Search bar "Search by phone, name, or email…"
  - "— or —" divider
  - New customer card: "New customer" heading + Name field + Phone field
  - Existing customer result: `GzAvatar` "R" + "Rahul Mehra" + "+91 98765 43210"
- Bottom bar: `GzButton` primary "Next: Select System →"

**`booking_management_screen.dart`** (artboard: `admin-bookings`)
- `GzAdminTopBar` title "Bookings", back → dashboard
- Date strip (horizontal scroll): Mon 2 / Tue 3 / Wed 4 (active/rose) / Thu 5 / Fri 6
- Status chips: All (active/rose), Unpaid, Paid, Checked In, No Show, Cancelled
- 4 booking cards:
  - "Rahul M. · 09:00–11:00 · PC Station 01" + `GzTag` ok "Paid" + "Check In" ghost button
  - "Priya S. · 10:00–12:00 · PS5 Console" + `GzTag` warn "Unpaid" + "Check In" ghost button
  - "Amit K. · 11:00–13:00 · Xbox Series X" + `GzTag` mute "Checked In"
  - "Neha R. · 14:00–16:00 · VR Pod 01" + `GzTag` err "No Show"

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 8: admin shell (GzAdminBottomNav) + operations (4 screens) rebuilt from design"
```

---

## Phase 9 — Admin Analytics (6 screens)

**Artboards:** `admin-analytics`, `admin-revenue`, `admin-utilization`, `admin-session-stats`, `admin-players`, `admin-system-perf`

### Step 1 — Delete

```
lib/features/admin/presentation/screens/analytics/    (entire directory)
```

### Step 2 — Create screens

All admin analytics screens share:
- `GzAdminTopBar` (with back → analytics hub except hub itself)
- Static hardcoded data matching design artboards
- `GzAdminBottomNav` active=sessions on the hub only (sub-screens have no BottomNav)

**`admin_analytics_screen.dart`** (artboard: `admin-analytics`, tab root)
- `GzAdminTopBar` title "Analytics"
- Date chips (rose active): Today / 7 Days / Custom
- 2×2 KPI grid: Revenue "₹18,420" / Sessions "142" / Avg. Duration "87m" / Walk-ins "34"
- Quick-nav horizontal scroll: Revenue / Utilization / Sessions / Players / Systems (5 tappable cards)
- Revenue chart placeholder: 7 bars with varying heights, last bar filled black, labels Mon–Sun
- Total row: "Total: ₹18,420 · vs ₹15,200 yesterday ↑"
- `GzAdminBottomNav` active=sessions

**`revenue_analytics_screen.dart`** (artboard: `admin-revenue`)
- Group-by chips: Daily (active/rose) / Weekly / Monthly
- Summary card: "Total Revenue" meta + "₹1,84,200" gz-hero-md + "Last 30 days" small
- Payment breakdown card: MetaRows Cash "₹72,400" / UPI "₹89,200" / Credits "₹22,600" / Total "₹1,84,200"
- Daily table: 6 rows (date / sessions / revenue)

**`utilization_heatmap_screen.dart`** (artboard: `admin-utilization`)
- View mode chips: Day (rose) / Week
- Peak hours card: "Peak hour: 7 PM – 9 PM" + "89% average occupancy" (ok green)
- Heatmap grid: 12 rows × 14 cols of 18×18px colored squares (white→mint→black intensity)
- Legend row: 0% → 100%
- Summary MetaRows: Avg occupancy "67%" / Peak time "7:00 PM" / Quietest "11:00 AM"

**`session_statistics_screen.dart`** (artboard: `admin-session-stats`)
- 2×2 KPI grid: Avg Duration "87 min" / Completion "94%" / Walk-ins "34" / Bookings "108"
- Session types breakdown: Walk-in 24% (rose bar) / Booking 76% (info bar)
- Recent sessions list: 4 rows with session info + duration + tag

**`player_analytics_screen.dart`** (artboard: `admin-players`)
- Segment card: "68 New" | "74 Returning" (side by side with vertical rule)
- Top players list: 5 rows (rank + avatar + name + minutes)
- Summary MetaRows: Total "142" / Active today "28" / Avg sessions "2.3"

**`system_performance_screen.dart`** (artboard: `admin-system-perf`)
- List of 6 system performance cards:
  - Each: platform icon + system name + revenue (right) + utilization bar + optional low-usage warning badge

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 9: admin analytics (6 screens) rebuilt from design"
```

---

## Phase 10 — Admin Management (6 screens)

**Artboards:** `admin-management`, `admin-pricing`, `admin-billing`, `admin-campaigns`, `admin-credits`, `admin-disputes`

### Step 1 — Delete

```
lib/features/admin/presentation/screens/management/    (entire directory)
```

### Step 2 — Create screens

**`admin_management_screen.dart`** (artboard: `admin-management`, tab root)
- `GzAdminTopBar` title "Management" (no back — tab root)
- 5 nav tiles with colored icon tiles + chevrons:
  - Pricing Rules (rose icon, scale)
  - Billing & Payments (info icon, coin)
  - Campaigns (ok icon, gift)
  - Credits (warn icon, star)
  - Disputes (err icon, sos/scale)
- `GzAdminBottomNav` active=management

**`pricing_rules_screen.dart`** (artboard: `admin-pricing`)
- `GzAdminTopBar` title "Pricing Rules", trailing "+" icon
- 4 pricing rule cards: name + rate + active toggle + filter tags
  - Standard Rate ₹80/hr (toggle on), Peak Hour ₹120/hr (toggle on), Weekend Rate ₹100/hr (toggle on), VR Premium ₹150/hr (toggle off)

**`billing_payments_screen.dart`** (artboard: `admin-billing`)
- Status chips: All / Unpaid / Paid / Overridden
- 4 billing rows: name + session + amount + tag + optional "Override" ghost button

**`campaign_management_screen.dart`** (artboard: `admin-campaigns`)
- 3 campaign cards: name + description + redemptions MetaRow + expires MetaRow + Pause + Edit buttons

**`credits_management_screen.dart`** (artboard: `admin-credits`)
- Search bar (pillBg)
- Player result card: `GzAvatar` lg "R" + "Rahul Mehra" + "+91 98765 43210"
- Balance tinted card: "CREDIT BALANCE" + "850" gz-hero-md
- 3 recent transaction rows
- Row of 2 buttons: "Deduct credits" ghost + "Add credits" primary

**`dispute_resolution_screen.dart`** (artboard: `admin-disputes`)
- Status chips: All / Open / In Review / Resolved
- 4 dispute cards: name + issue + date + tag + "Resolve →" ghost button (for open/in-review)

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 10: admin management (6 screens) rebuilt from design"
```

---

## Phase 11 — Admin Store (4 screens)

**Artboards:** `admin-store`, `admin-staff`, `admin-config`, `admin-notifications`

### Step 1 — Delete

```
lib/features/admin/presentation/screens/store/    (entire directory)
```

### Step 2 — Create screens

**`admin_store_screen.dart`** (artboard: `admin-store`, tab root `/admin/systems`)
- `GzAdminTopBar` title "Store" (no back)
- 4 nav tiles: System Management (info icon) / Staff Management (purple icon) / Store Config (mute icon) / Notifications (warn icon)
- `GzAdminBottomNav` active=store

**`staff_management_screen.dart`** (artboard: `admin-staff`)
- `GzAdminTopBar` title "Staff", back → store, trailing "+" icon
- Role legend chips: `GzTag` purple "Super Admin" / `GzTag` info "Admin" / `GzTag` mute "Staff"
- 4 staff cards: `GzAvatar` + name + email + role tag + optional trash icon

**`store_config_screen.dart`** (artboard: `admin-config`)
- `GzAdminTopBar` title "Store Config", back → store, trailing "Save" ghost button small
- Booking settings section (white card): 4 input fields (booking window 1440, payment window 30, no-show grace 10, max duration 240)
- Operating hours section: Opens "10:00" / Closes "23:00" (two side-by-side inputs)
- Operations section: 2 toggle rows (Allow walk-ins ON, Auto-start on check-in ON)

**`admin_notifications_screen.dart`** (artboard: `admin-notifications`)
- `GzAdminTopBar` title "Notifications", back → store
- Channel selector card: 3 `GzAdminChip`s — Push (active) / Email / SMS
- Audience card: 2 chips — All Players (active) / Active Now
- Compose card: Title input + Body textarea (both with pillBg)
- Preview card (infoBg): app icon + title + body preview
- `GzButton` primary "Send notification"

### Step 3 — Verify

```bash
flutter analyze
```

### Step 4 — Commit

```
git commit -m "phase 11: admin store (4 screens) rebuilt from design"
```

---

## Phase 12 — Cleanup + Final Audit

**Goal:** Delete all orphaned files, fix all remaining analyze errors, verify every route renders.

### Step 1 — Delete orphaned directories

```bash
# Delete all feature data layers (providers, repositories, services - no longer used)
find lib/features -type d -name "providers" -exec rm -rf {} + 2>/dev/null || true
find lib/features -type d -name "repositories" -exec rm -rf {} + 2>/dev/null || true
find lib/features -type d -name "data" -exec rm -rf {} + 2>/dev/null || true
find lib/features -type d -name "widgets" -exec rm -rf {} + 2>/dev/null || true
# Delete unused model files if no screen imports them
# Delete connectivity_banner.dart if no screen imports it
```

Run `flutter analyze` after each deletion to catch any remaining imports.

### Step 2 — Route audit

For every route in `routes.dart`, confirm a screen file exists and is wired in `app_router.dart`. Cross-check against the master map at the top of this document.

### Step 3 — Verify

```bash
flutter analyze    # 0 errors
```

### Step 4 — Commit

```
git commit -m "phase 12: cleanup orphaned files + final route audit"
```

---

## Quick reference: all phase commits

| Phase | Commit message |
|---|---|
| 0 | `phase 0: replace em_* widget library with gz_* design-faithful components` |
| 1 | `phase 1: auth + onboarding screens rebuilt from design (13 screens)` |
| 2 | `phase 2: player shell (GzBottomNav) + home + store search + store detail` |
| 3 | `phase 3: booking flow (5 screens) rebuilt from design` |
| 4 | `phase 4: sessions (8 screens) rebuilt from design` |
| 5 | `phase 5: wallet (4 screens + redeem sheet) rebuilt from design` |
| 6 | `phase 6: profile + disputes (7 screens) rebuilt from design` |
| 7 | `phase 7: notifications screen + overlay sheets rebuilt from design` |
| 8 | `phase 8: admin shell (GzAdminBottomNav) + operations (4 screens) rebuilt from design` |
| 9 | `phase 9: admin analytics (6 screens) rebuilt from design` |
| 10 | `phase 10: admin management (6 screens) rebuilt from design` |
| 11 | `phase 11: admin store (4 screens) rebuilt from design` |
| 12 | `phase 12: cleanup orphaned files + final route audit` |
