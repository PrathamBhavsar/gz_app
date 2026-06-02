# GZ App — Phase Prompt Template

Copy this entire prompt at the start of each new conversation. Replace `[N]` and `[NAME]` with the current phase number and name.

---

## PROMPT (copy from here)

You are implementing **Phase [N] — [NAME]** of the GZ App UI rebuild.

### Project context

- Flutter app at `/Users/pratham/code/gz_app`
- Two sub-apps in one codebase: Player (consumer) + Admin (store operator)
- Router: `go_router` — routes defined in `lib/core/navigation/routes.dart`, wired in `lib/core/navigation/app_router.dart`
- Theme: `lib/core/theme/app_colors.dart`, `app_typography.dart`, `app_spacing.dart` — do NOT modify these

### What this rebuild is

The entire presentation layer is being rewritten from the design artboards in `../design/index.html`.
Every screen uses **static hardcoded data** — no providers, no repositories, no API calls.
One dart file per screen. No `_mobile_layout` / `_tablet_layout` splits.

### Non-negotiable rules

1. **Only use `gz_*` widgets** from `lib/shared/widgets/`. Never import `em_*` widgets — they are deleted.
2. **No backend integration.** Screens are pure UI with hardcoded data matching the design artboards.
3. **Keep intact:** `lib/core/navigation/routes.dart`, `lib/core/navigation/app_router.dart`, `lib/core/theme/`, `main.dart`, `pubspec.yaml`.
4. **One file per screen.** No layout subclasses.
5. **No test files.** Do not create or modify anything in `test/`.
6. **`flutter analyze` must show 0 errors before committing.**

### Your task for Phase [N]

Read **`CODEX_PLAN.md`** at the project root. Find the section `## Phase [N] — [NAME]`. Execute every step in order:

1. **Step 1 — Delete** the listed files/directories
2. **Step 2 — Create** the listed screen files with the specified content
3. **Step 3 — Verify:**
   ```bash
   flutter analyze
   ```
   Fix any errors before proceeding.
4. **Step 4 — Commit** using the exact message from the plan:
   ```
   git commit -m "[exact commit message from CODEX_PLAN.md Phase [N]]"
   ```

### Design reference

The design artboards live at `../design/index.html`. Each artboard has an `id` that matches the "Artboard ID" column in the master map table at the top of `CODEX_PLAN.md`. When building a screen, look at the artboard with the matching ID to know exactly what to render: layout, content, spacing, components, mock data.

The shared design components (`GzTopBar`, `GzButton`, `GzTag`, etc.) are already implemented in `lib/shared/widgets/gz_*.dart` (Phase 0 is always done first).

### What good output looks like

- Every screen file builds without errors
- Every screen shows the content described in the artboard (correct titles, buttons, list items, mock data)
- `flutter analyze` 0 errors
- One commit with the exact message from the plan

### What to do if you hit a problem

- If a `gz_*` widget is missing: check if it should have been created in Phase 0 — if so, create it now and note it in the commit message
- If a route is missing from `app_router.dart`: add the `GoRoute` entry pointing to the new screen
- If `flutter analyze` shows an error in a file you didn't touch: fix the import (likely an old `em_*` import that slipped through)

---

## Phase reference card

| Phase | Name | Screens | Key artboards |
|---|---|---|---|
| 0 | Widget Library | 11 gz_* widgets | components.jsx |
| 1 | Auth + Onboarding | 13 | splash, onboarding, auth, register, otp, email-login, oauth-handler, forgot, reset-password, verify-pending, email-verify-success, admin-login, admin-pw-reset |
| 2 | Player Shell + Home | 4 + shell | home, storesearch, store |
| 3 | Booking Flow | 5 | book-systems, systems, system-picker, booking, confirmation |
| 4 | Sessions | 8 | activity, session, active-session-detail, booking-detail, checkin, payment, history, billing |
| 5 | Wallet | 4 + modal | wallet, credits, campaigns, campaign, redeem |
| 6 | Profile + Disputes | 7 | profilehome, profile, change-phone, notif-prefs-default, disputes-list, dispute-create, dispute-detail |
| 7 | Notifications + Overlays | 1 + sheets | notifications, store-selector |
| 8 | Admin Ops | 4 + shell | admin-dashboard, admin-session-mgmt, admin-walk-in, admin-bookings |
| 9 | Admin Analytics | 6 | admin-analytics, admin-revenue, admin-utilization, admin-session-stats, admin-players, admin-system-perf |
| 10 | Admin Management | 6 | admin-management, admin-pricing, admin-billing, admin-campaigns, admin-credits, admin-disputes |
| 11 | Admin Store | 4 | admin-store, admin-staff, admin-config, admin-notifications |
| 12 | Cleanup | — | orphan deletion, route audit |