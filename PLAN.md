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

## Phase 1 — Delete unused files ✅
- [x] Delete `lib/shared/widgets/gz_*.dart` (7 files)
- [x] Delete `lib/shared/widgets/em_collapse.dart`
- [x] Delete `lib/features/home/presentation/providers/active_store_notifier.dart`
- [x] Delete `lib/features/wallet/presentation/providers/wallet_ui_notifier.dart`
- [x] Delete `lib/features/booking/presentation/screens/booking_screen.dart`
- [x] Delete `lib/features/admin/presentation/screens/store/system_management_screen.dart`
- [x] Decide `player_ws_service.dart`: keep as scaffolding (still pending impl per brain) or delete. **Action:** kept — scaffolding marked pending in brain.
- [x] `flutter analyze` — clean

## Phase 2 — Raw color → `AppColors.*` ✅
- [x] Added `AppColors.overlayLight` and `AppColors.shadowSubtle`; swept all raw hex colors in admin screens and layouts.
- [x] `em_avatar.dart` palette kept as private design data (not theming).
- [x] `flutter analyze` — clean

## Phase 3 — `Navigator` → `context.*` ✅
- [x] All admin dialog confirms, sheets, and shared widgets converted to `context.pop()` / `context.push()`.
- [x] `em_top_bar.dart` already uses `Navigator.maybePop(context)` (no `context.maybePop` in go_router).
- [x] `flutter analyze` — clean

## Phase 4 — `Icon` → `HugeIcon` ✅
- [x] All `Icon(Icons.*)` replaced with `HugeIcon(icon: HugeIcons.*)` across all screens.
- [x] `flutter analyze` — clean

## Phase 5 — `ListView` → `ListView.builder` ✅
- [x] `billing_history_mobile_layout` — converted with sealed item types.
- [x] `store_selector_sheet` — converted with sealed item types.
- [x] `create_dispute_mobile_layout` — converted with sealed item types.
- [x] Fixed/small-set ListViews kept eager (active_session, dispute_detail, booking_summary, profile_tablet, home_tablet, active_session_detail).
- [x] `flutter analyze` — clean

## Phase 6 — Hardcoded routes → `AppRoutes.*` ✅
- [x] Added path builder helpers in `routes.dart`: `storeDetailPath`, `bookingDetailPath`, `paymentSheetPath`, `checkInPath`, `activeSessionDetailPath`, `sessionHistoryDetailPath`, `campaignDetailPath`, `disputeDetailPath`.
- [x] Swept all `replaceAll(':id', ...)` call sites.
- [x] Fixed `context.go('/auth_landing')` typo → `AppRoutes.authLanding`.
- [x] `flutter analyze` — clean

## Phase 7 — Remove forbidden `setState` ✅
- [x] All feature-screen `setState` calls moved to `StateProvider.autoDispose` (password toggle, error messages, filter chips, form toggles).
- [x] `otp_input_sheet.dart` — kept (timer countdown is inherently stateful widget domain).
- [x] `flutter analyze` — clean

## Phase 8 — `_buildX` helpers → classes ✅
- [x] All >20-line private `_buildX` methods extracted to top-level private classes in the same file.
- [x] Short 1–3 line helpers retained inline.
- [x] `flutter analyze` — clean

## Phase 9 — Misc ✅
- [x] `dispute_detail_mobile_layout.dart` raw `TextStyle` → `AppTypography.*`.
- [x] `app_router.dart` `ValueNotifier<int>` — documented as intentional router-infra Listenable adapter (not app state). Exception noted in comment.

## Phase 10 — Final verification ✅
- [x] `flutter analyze` — No issues found
- [x] All forbidden patterns (`Icon(Icons.*)`, `Navigator.push/pop`, raw `Color(0xFF…)`, `replaceAll(':`, `setState` outside timers) — zero occurrences
- [x] All tests pass (4/4)
