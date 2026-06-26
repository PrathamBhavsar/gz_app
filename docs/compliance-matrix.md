# Three-Way Screen/Feature Compliance Matrix

> Generated 2026-06-15. Compares the three sources of truth for the screen/feature inventory.

## Sources

- **BRAIN** — `brain/features/ux_flow.md`, the canonical inventory of **72 numbered screens** (sheets/overlays tracked separately in `brain/features/.registry/overlays.md`).
- **APP** — `lib/features/**/presentation/screens/*.dart` + routes in `lib/core/navigation/routes.dart` / `app_router.dart`.
- **DESIGN** — `design/src/screen-*.jsx` (66 files) + `design/*.html` (4 numbered: 26–29).

## Headline verdict

| Metric | Result |
|---|---|
| Brain screens implemented in **APP** | **72 / 72 — 100%** |
| Brain screens present in **DESIGN** | **62 / 72 — ~86%** |
| Fully compliant (Brain + App + Design) | **62 screens** |
| Gap location | Entirely **DESIGN**, missing admin create/edit/detail sub-flows |

The app is the most complete artifact (implements every brain screen). Design is the laggard — it lacks the admin create/edit/detail screens that both brain and app define.

---

## Fully compliant — present in all 3 sources (62)

### Player (38 of 40)

Splash(1), Onboarding(2), AuthLanding(3), Register(4), OTP(5), EmailLogin(6), OAuthHandler(7), ForgotPassword(8), ResetPassword(9), EmailVerifyPending(10), EmailVerifySuccess(11), Home(12), StoreSearch(13), StoreDetail(14), BookingSlotSelection(15), BookingAvailability(16 → `screen-systems`), BookingSystemSelection(17), BookingSuccess(19), Sessions(20 → `screen-activity`), ActiveSession(21), BookingDetail(22), CheckIn(23), Payment(24), ActiveSessionDetail(25), SessionHistoryDetail(26), BillingHistory(27), SessionLogs(28), Wallet(29), CreditHistory(30), Campaigns(31), CampaignDetail(32), Notifications(33), Profile(34 → `screen-profile-home`), EditProfile(35 → `screen-profile`), ChangePhone(36), NotifPrefs(37), DisputesList(38), CreateDispute(39), DisputeDetail(40)

### Admin (24 of 32)

AdminLogin(41), AdminPasswordReset(42), AdminDashboard(43), SessionManagement(44), WalkInBooking(45), BookingManagement(46), AdminAnalytics(48), RevenueAnalytics(49), UtilizationHeatmap(50), SessionStatistics(51), PlayerAnalytics(52), SystemPerformance(53), AdminManagement(54), PricingRules(55), BillingPayments(58), CampaignManagement(59), CreditsManagement(62), DisputeResolution(63), AdminStore(65 → `screen-admin-store`), SystemManagement(66 → `screen-systems`/admin), StaffManagement(69), StoreConfig(71), AdminNotifications(72)

---

## NON-COMPLIANT — in BRAIN + APP, MISSING in DESIGN

Verified by keyword search across all `design/src/*.jsx`. These are the only true presence gaps.

| # | Screen | Brain | App (dart) | Design |
|---|---|---|---|---|
| 18 | **BookingSummary** | yes | `booking_summary_screen.dart` | **Partial** — no dedicated file; promo/duration UI folded into `screen-booking.jsx` |
| 47 | **AdminBookingDetail** | `/admin/bookings/:id` | `admin_booking_detail_screen.dart` | **Missing** |
| 56 | **CreatePricingRule** | `/admin/pricing/create` | `create_pricing_rule_screen.dart` | **Missing** |
| 57 | **EditPricingRule** | `/admin/pricing/:id/edit` | `edit_pricing_rule_screen.dart` | **Missing** |
| 60 | **CreateCampaign** | `/admin/campaigns/create` | `create_campaign_screen.dart` | **Missing** |
| 61 | **EditCampaign** | `/admin/campaigns/:id/edit` | `edit_campaign_screen.dart` | **Missing** |
| 64 | **AdminDisputeDetail** | `/admin/disputes/:id` | `admin_dispute_detail_screen.dart` | **Missing** (player `screen-dispute-detail` exists; admin variant does not) |
| 67 | **AddEditSystem** | `/admin/systems/add`, `/edit/:id` | `add_edit_system_screen.dart` | **Missing** |
| 68 | **SystemDetail** | `/admin/systems/:id` | `system_detail_screen.dart` | **Missing** |
| 70 | **InviteStaff** | `/admin/staff/invite` | `invite_staff_screen.dart` | **Missing** |

**Pattern:** every admin create / edit / detail sub-flow is undesigned. Design only covers admin list/dashboard screens.

---

## Overlays / sheets (tracked separately from the 72)

Documented in `brain/features/.registry/overlays.md`, not in `ux_flow.md`.

| Overlay | Brain | App (sheet) | Design |
|---|---|---|---|
| Store selector | yes | `store_selector_sheet.dart` | `screen-store-selector` + `29-*.html` |
| Notification detail | yes (O-39) | `notification_detail_sheet.dart` | in `screen-sheet-overlays` |
| Notification center | — | `notification_center_sheet.dart` | also full `screen-notifications` |
| OTP input | yes | `otp_input_sheet.dart` | in `screen-sheet-overlays` |
| Redeem credits | not in numbered/overlay list | `redeem_credits_sheet.dart` | `screen-redeem-credits` |
| Player cancel booking | — | `cancel_booking_sheet.dart` | in `screen-sheet-overlays` |
| Admin: adjust credits / billing override / end session / extend session / cancel booking / edit staff | partial in registries | 6 sheets | not individually designed |

---

## DESIGN-only — no brain number / no distinct app screen

| Design file | Status |
|---|---|
| `screen-app-flow-demo.jsx` | Prototype/demo navigation harness — intentional, no product screen |
| `screen-system-picker.jsx` | Booking system-picker overlay — app folds into `booking_system_selection_screen.dart` |
| `screen-systems.jsx` | Overlaps brain #16 availability + #17 systems (design booking flow uses 4 screens vs brain's 15–18 split) |
| `screen-sheet-overlays.jsx` | Catalog of multiple sheets in one file (makes 1:1 mapping fuzzy) |

---

## Internal inconsistencies (taxonomy, not presence)

1. ~~**Brain route collision:** `ux_flow.md` assigned both AdminManagement(#54) and AdminStore(#65) to `/admin/management`.~~ **Fixed 2026-06-15** — #65 now correctly documents `/admin/systems`; #66 SystemManagement now `/admin/systems/list` (matching `app_router.dart`).
2. **Booking-flow naming drift:** brain {slot/availability/systems/summary}, app adds `success`, design uses {booking/book-systems/systems/system-picker}. Coverage is fine, taxonomy does not map 1:1 across any two sources.
3. **Notifications double-implemented in app** as a full screen and two sheets; design only has the full screen.

---

## Recommendation to reach 100% compliance

The only substantive work is in **design**. Add the 9 missing design screens (10 with BookingSummary), using the app screens as the spec:
admin booking-detail, create/edit pricing rule, create/edit campaign, admin dispute-detail, add/edit system, system-detail, invite-staff, and a dedicated booking-summary.
