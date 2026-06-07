# Phase Audit — Inconsistencies (commit 47ba3f6 → HEAD `bfed57d`)

Audited the gz_* UI rebuild (CODEX_PLAN.md Phases 0–12) against the actual
codebase. **Overall: ~95% complete.** All 43 screens in the master map exist,
every route in `routes.dart` is wired in `app_router.dart`, all `em_*` widgets
are deleted, and `flutter analyze` reports **0 issues**.

The remaining gaps all stem from **Phase 12, Step 1 (cleanup) being only
partially executed** — the old Riverpod auth layer was never removed, so 6
screens + the router still violate the plan's "static data only / no providers"
rule.

---

## ❌ Inconsistency 1 — Leftover provider files (Phase 12 Step 1 not run)

Phase 12 Step 1 says:
```bash
find lib/features -type d -name "providers" -exec rm -rf {} +
```
These directories still exist:

| File | Status |
|---|---|
| `lib/features/auth/presentation/providers/auth_notifier.dart` | should be deleted |
| `lib/features/auth/presentation/providers/auth_state.dart` | should be deleted |
| `lib/features/admin/presentation/providers/admin_auth_provider.dart` | should be deleted |
| `lib/features/admin/presentation/providers/admin_auth_state.dart` | should be deleted |

They cannot be deleted as-is because screens + the router still import them
(see #2, #3). They are demo stubs (`auth_notifier.dart` just sets a hardcoded
`AuthAuthenticated(UserModel(...))` — no real backend), so removing them is
purely a refactor, not a feature loss.

---

## ❌ Inconsistency 2 — Auth screens still use Riverpod (Phase 1 rule violation)

Phase 1/Ground-Rule 2: screens must be `StatelessWidget`/`StatefulWidget` with
**static data only, no providers**. These 4 are `ConsumerWidget`/
`ConsumerStatefulWidget` and call `ref.read(authNotifierProvider.notifier)`:

| Screen | Provider call |
|---|---|
| `auth/.../register/register_screen.dart` | `register(...)` |
| `auth/.../otp/otp_verification_screen.dart` | `submitOtp(...)` |
| `auth/.../email_login/email_login_screen.dart` | `loginWithEmail(...)` |
| `auth/.../email_verify_success/email_verify_success_screen.dart` | `signInDemo()` |

**Fix:** convert to plain `StatefulWidget`/`StatelessWidget`; replace each
provider call with a direct `context.go(...)` navigation.

---

## ❌ Inconsistency 3 — Admin screens still use Riverpod (Phase 8 rule violation)

| Screen | Provider call |
|---|---|
| `admin/.../admin_login_screen.dart` | `ref.read(adminAuthNotifierProvider.notifier).login(...)` |
| `admin/.../operations/admin_dashboard_screen.dart` | `ref.read(adminAuthNotifierProvider.notifier).logout()` |

**Fix:** same as #2 — convert to plain widgets, replace login/logout with
`context.go(AppRoutes.adminDashboard)` / `context.go(AppRoutes.adminLogin)`.

---

## ❌ Inconsistency 4 — Router still wires the auth guard / refreshListenable

`lib/core/navigation/app_router.dart` still has:
```dart
ref.listen<AuthState>(authNotifierProvider, (_, _) => listenable.value++);
ref.listen<AdminAuthState>(adminAuthNotifierProvider, ...);  // ~line 84–87
```
plus `import`s of `auth_notifier.dart` and `admin_auth_provider.dart`.

This is the blocker for deleting the provider files in #1. Decide:
- **(A) Strict to plan:** remove the `ref.listen` redirect/guard logic and the
  provider imports, then delete the 4 provider files. Screens navigate freely.
- **(B) Keep a demo guard:** leave it, and instead **document an exception** in
  CODEX_PLAN.md (a minimal demo auth provider is intentionally retained to drive
  `refreshListenable`). Then #1–#3 become "won't fix" by design.

Recommend **(A)** for consistency with the stated rules, unless the demo
auth/redirect behaviour is wanted.

---

## ⚠️ Inconsistency 5 — Plan vs. reality conflict: `widgets/` dir

Phase 12 Step 1 also says `find ... -name "widgets" -exec rm -rf`. But
`lib/features/admin/presentation/widgets/admin_shell.dart` is **required** — it's
the admin `ShellRoute` builder (created in Phase 8) and is imported by
`app_router.dart`. **Do not delete it.** This is a plan error, not a code error;
note it so the cleanup command isn't run blindly.

---

## ✅ Verified complete (no action needed)

- **All 43 master-map screens exist** at their mapped paths (auth ×13, home ×3,
  booking ×5, sessions ×8, wallet ×4 + redeem sheet, profile/disputes ×7,
  notifications ×1, admin ops ×4, analytics ×6, management ×6, store ×4).
- **All `em_*` widgets deleted**; `gz_*` library present (the 11 from Phase 0
  plus the extra replacements `gz_card`, `gz_logo`, `gz_icon_btn`,
  `gz_progress_bar`, `gz_scroll_content`, `gz_section_head`,
  `gz_store_selector_pill`, `gz_admin_chip` — Phase 0's "11" undercounted).
- **Every route constant in `routes.dart` is wired** in `app_router.dart`
  (player shell, admin shell, all sub-routes, path builders).
- **`flutter analyze` → "No issues found!"** (0 errors, 0 warnings).
- `store_selector_sheet.dart` + `redeem_credits_sheet.dart` present as sheets.

---

## Suggested fix order (when implementing later)

1. Pick option **(A)** or **(B)** for #4.
2. If (A): strip provider `ref.listen` + imports from `app_router.dart`.
3. Convert the 6 screens (#2, #3) to plain widgets with `context.go` navigation.
4. `rm -rf lib/features/auth/presentation/providers
   lib/features/admin/presentation/providers`.
5. **Keep** `lib/features/admin/presentation/widgets/admin_shell.dart` (#5).
6. `flutter analyze` → expect 0 errors.
7. Commit: `fix: complete phase 12 cleanup — remove residual auth providers`.
