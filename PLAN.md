# Cleanup & Compliance Plan
> Goal: remove unused code/files and make every feature comply with `brain/rules/*.md`. Loop until clean.

## Status legend
- `[ ]` not started
- `[~]` in progress
- `[x]` done

---

## Findings (initial scan — 2026-05-16)

### flutter analyze
Clean — no analyzer issues.

### Unused / dead files
| File | Reason |
|---|---|
| `lib/shared/widgets/gz_button.dart` | Replaced by `em_button.dart`; class never referenced. |
| `lib/shared/widgets/gz_chip.dart` | Replaced by `em_chip.dart`. |
| `lib/shared/widgets/gz_live_dot.dart` | Replaced by `em_live_dot.dart`. |
| `lib/shared/widgets/gz_meta_row.dart` | Replaced by `em_meta_row.dart`. |
| `lib/shared/widgets/gz_progress_bar.dart` | Replaced by `em_progress_bar.dart`. |
| `lib/shared/widgets/gz_tag.dart` | Replaced by `em_tag.dart`. |
| `lib/shared/widgets/gz_top_bar.dart` | Replaced by `em_top_bar.dart`. |
| `lib/shared/widgets/em_collapse.dart` | Never referenced. |
| `lib/features/home/presentation/providers/active_store_notifier.dart` | Superseded by `activeStoreIdProvider` in `core/auth`. |
| `lib/features/wallet/presentation/providers/wallet_ui_notifier.dart` | Never referenced. |
| `lib/features/booking/presentation/screens/booking_screen.dart` | Placeholder "Coming Soon" screen, not routed. |
| `lib/features/admin/presentation/screens/store/system_management_screen.dart` | Defined but route `adminSystemsMgmt` builds `AdminStoreScreen`; orphan. |
| `lib/core/network/player_ws_service.dart` | Defined but provider not wired (Phase pending per brain). Keep if tracked as scaffolding, otherwise delete. |

### Critical rule violations
| # | Violation | Locations |
|---|---|---|
| V1 | Raw `Color(0xFF…)` outside `app_colors.dart` | ~40 in admin screens + `em_avatar.dart` palette + `em_bottom_nav.dart` shadow + `dispute_detail_mobile_layout.dart:398` |
| V2 | `Navigator.push/pop` (use `context.*`) | All admin dialog confirms + `payment_sheet.dart`, `profile_mobile_layout.dart`, `redeem_credits_sheet.dart`, `notification_detail_sheet.dart`, `otp_input_sheet.dart`, `em_top_bar.dart`, `store_selector_sheet.dart` |
| V3 | `Icon(Icons.*)` instead of `HugeIcon` | 20+ admin screens (back arrow, chevron, add, check) + `email_verification_pending_mobile_layout.dart` |
| V4 | Eager `ListView(children:)` for dynamic lists | `home_tablet_layout`, `booking_summary_mobile_layout`, `dispute_detail_mobile_layout`, `create_dispute_mobile_layout`, `billing_history_mobile_layout`, `sessions_mobile_layout`, `active_session_mobile_layout`, `active_session_detail_mobile_layout`, `profile_tablet_layout`, `store_selector_sheet` |
| V5 | Hardcoded route strings in `context.go/push` | `home_tablet_layout`, `store_search_*`, `booking_*_mobile_layout`, `create_dispute_mobile_layout`, `main_*_layout`, `sessions_mobile_layout`, `profile_tablet_layout`, `disputes_list_mobile_layout` |
| V6 | `setState()` in feature screens | `email_login_mobile_layout`, `onboarding_*_layout`, `booking_availability_mobile_layout`, `create_dispute_mobile_layout`, many admin screens (pricing_rules, credits_management, dispute_resolution, billing_payments, system_management, admin_login, admin_password_reset, admin_analytics, walk_in_booking, booking_management) |
| V7 | Local `Widget _buildX` helpers | 124 instances across auth/home/admin/disputes/sessions widgets |
| V8 | Raw `TextStyle(...)` | `dispute_detail_mobile_layout.dart:533` |
| V9 | `ValueNotifier` in app code | `lib/core/navigation/app_router.dart:79` (auth refreshListenable) |

Notes:
- `breakpoints.dart` uses `MediaQuery.of(context).size.width` — permitted (it's the canonical helper).
- `setState` in onboarding mobile/tablet is for PageController index; could remain via NotifierProvider, but pragmatically these are UI-only; we still need to comply.
- Admin "Store" tab routing: `AppRoutes.adminSystemsMgmt = '/admin/systems'` is currently bound to `AdminStoreScreen`. The unused `SystemManagementScreen` is the original target. Decision in Phase 1: delete `SystemManagementScreen` and keep `AdminStoreScreen` as the Store hub (matches `layout_engine.md` line 97), OR re-wire `adminSystemsMgmt` to the System Management screen and add a new route for the Store hub. Default: **delete** to match brain spec.

---

## Phase 1 — Delete unused files
- [ ] Delete `lib/shared/widgets/gz_*.dart` (7 files)
- [ ] Delete `lib/shared/widgets/em_collapse.dart`
- [ ] Delete `lib/features/home/presentation/providers/active_store_notifier.dart`
- [ ] Delete `lib/features/wallet/presentation/providers/wallet_ui_notifier.dart`
- [ ] Delete `lib/features/booking/presentation/screens/booking_screen.dart`
- [ ] Delete `lib/features/admin/presentation/screens/store/system_management_screen.dart`
- [ ] Decide `player_ws_service.dart`: keep as scaffolding (still pending impl per brain) or delete. **Action:** keep — it is scaffolding the brain explicitly marks pending; do NOT delete.
- [ ] `flutter analyze`

## Phase 2 — Raw color → `AppColors.*`
- [ ] Extend `AppColors` with `statusActive` (#4CAF50), `statusInfo` (#2196F3), `statusWarning` (#FFC107), `statusOrange` (#FF9800) — these are widely repeated.
- [ ] Sweep admin screens, `dispute_detail_mobile_layout.dart`, `em_bottom_nav.dart` shadow.
- [ ] Move `em_avatar` palette to `AppColors` as a `static const List<({Color bg, Color fg})> avatarPalette` (or keep as private const in `em_avatar.dart` flagged as design data — brain only forbids raw colors for theming).
- [ ] `flutter analyze`

## Phase 3 — `Navigator` → `context.*`
- [ ] Admin screen dialogs: `Navigator.pop(ctx, false/true)` → `context.pop(false/true)`.
- [ ] Sheets and shared widgets: `Navigator.of(ctx).pop()` → `context.pop()`.
- [ ] `em_top_bar.dart`: `Navigator.of(context).maybePop()` → `Navigator.maybePop(context)` (no `context.maybePop`) — see exception below.
- [ ] `flutter analyze`

## Phase 4 — `Icon` → `HugeIcon`
- [ ] Back-arrow buttons in 13+ admin screens → `HugeIcons.strokeRoundedArrowLeft01`.
- [ ] Chevrons → `HugeIcons.strokeRoundedArrowRight01`.
- [ ] Add → `HugeIcons.strokeRoundedAdd01`. Check → `HugeIcons.strokeRoundedTick01`.
- [ ] Email verification mark → `HugeIcons.strokeRoundedMail01`.
- [ ] `flutter analyze`

## Phase 5 — `ListView` → `ListView.builder`
- [ ] Convert all eager `ListView(children: ...)` to `ListView.builder` where children come from a list. Keep eager only when children are a small fixed set (≤4) of distinct widgets.
- [ ] `flutter analyze`

## Phase 6 — Hardcoded routes → `AppRoutes.*`
- [ ] Add helpers in `routes.dart`: `storeDetailPath(slug)`, `bookingDetailPath(id)`, `disputeDetailPath(id)`, `activeSessionDetailPath(id)`, etc.
- [ ] Sweep call sites.
- [ ] Fix typo `context.go('/auth_landing')` in `profile_tablet_layout.dart` → `AppRoutes.authLanding`.
- [ ] `flutter analyze`

## Phase 7 — Remove forbidden `setState`
- [ ] For each affected screen, classify the state: (a) form fields → notifier; (b) toggles (password visible, current page, filter chips) → notifier or `StateProvider`.
- [ ] Order: simplest first (toggles), then forms, then admin.
- [ ] `flutter analyze` after each file.

## Phase 8 — `_buildX` helpers → classes
- [ ] Per file, extract helpers > ~20 lines into top-level `class` widgets in the same file (or a sibling file when widget reuse is clear).
- [ ] Skip 1–3 line helpers (low value, churn high).
- [ ] `flutter analyze`

## Phase 9 — Misc
- [ ] `dispute_detail_mobile_layout.dart:533` raw `TextStyle` → `AppTypography.*`.
- [ ] `app_router.dart` `ValueNotifier<int>` → a `Listenable` derived from the auth notifier directly (use `ProviderSubscription` + `ChangeNotifier`-free pattern) **or** keep but accept this is allowed for router refresh — re-read the rule.

Brain rule prohibits `ChangeNotifier` / `ValueNotifier` "in app code". `app_router.dart` is core infra; a single `ValueNotifier<int>` exists purely as `refreshListenable` for go_router. The cleanest alternative is a private `_RouterRefreshListenable extends ChangeNotifier`. That's still `ChangeNotifier`. Pragmatic interpretation: this is a router-internal Listenable adapter and not "app code state". Document the exception in a comment so future readers know it is intentional.

## Phase 10 — Final verification
- [ ] Re-run `flutter analyze`
- [ ] Re-grep all forbidden patterns
- [ ] Update this `PLAN.md` with results
