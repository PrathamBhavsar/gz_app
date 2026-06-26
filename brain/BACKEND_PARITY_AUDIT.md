# Backend ↔ App Parity Audit
> Generated 2026-06-25. Source of truth = live backend source in `gz_ideation/src/modules/*/index.ts`
> (NOT `docs/api-overview.md`, which is dated 2026-04-02 and stale in several places).
> Cross-referenced against `lib/core/api/api_constants.dart` + every `data/repositories/*.dart`.

## Scope checked
- 17 backend modules (`analytics, auth, billing, bookings, campaigns, credits, disputes,
  notifications, payments, pricing, sessions, store-admins, stores, system-types, systems, users`)
  → ~95 HTTP routes + 3 WebSocket channels.
- All 28 app repositories + `ApiConstants`.

**Headline:** the app is feature-complete and now fully wired for all currently identified
app-relevant backend routes (Phases 1–13 all landed; no real dummy data remains). After WP5,
**0 endpoint mismatches remain open** and **0 app-relevant backend endpoints remain unreachable**.

---

## A. BROKEN — endpoint is called but path/auth is wrong (runtime 4xx)

| Status | # | App call | App path | Actual backend route | Effect |
|---|---|---|---|---|---|
| [x] | 1 | `admin_notify_send_repository` → `storeNotifyAdminSend` / `…Topic` | `/stores/{storeId}/notifications/admin/send[/topic]` | `/stores/:storeId/notifications/admin/send[/topic]` (store-scoped, adminAuth) | Fixed in WP1 |
| [x] | 2 | `admin_billing_repository.overrideBilling` → `billingOverride` | `/stores/{storeId}/billing/ledger/{id}/override` | `/stores/:storeId/billing/ledger/:id/override` | Fixed in WP1 |
| [x] | 3 | `admin_bookings_repository.fetchBookingDetail` → `adminBookingDetail` | `/stores/{storeId}/bookings/admin/{id}` | `/stores/:storeId/bookings/admin/:id` (adminAuth) | Fixed in WP1 |
| [x] | 4 | `admin_disputes_repository.fetchDisputeDetail` → `adminDisputeDetail` | `/stores/{storeId}/disputes/admin/{id}` | `/stores/:storeId/disputes/admin/:id` (adminAuth) | Fixed in WP1 |
| [x] | 5 | `sessions_repository.fetchSessionLogs` (player) → `playerSessionLogs` | `/stores/{storeId}/sessions/{id}/logs` | `GET /stores/:storeId/sessions/:id/logs` now exists under `sessionUserRoutes` with ownership checks | Fixed in WP2 |
| [x] | 6 | `auth_repository` logout → `authLogout` | `/auth/logout` | `POST /auth/logout` now exists under `userRoutes` and revokes the refresh session | Fixed in WP2 |
| [x] | 7 | `auth_repository` phone-change verify → `authPhoneChangeVerify` | `/auth/phone/change/verify` | `POST /auth/phone/change/verify` now confirms OTP and updates the user phone number | Fixed in WP2 |

### Fix sketch (api_constants.dart unless noted)
1. Done in WP1: store-scoped admin notify constants `/stores/{storeId}/notifications/admin/send[/topic]` now route through `adminStorePath`.
2. Done in WP1: `billingOverride = '/stores/{storeId}/billing/ledger/{id}/override'`.
3. Done in WP1: `adminBookingDetail = '/stores/{storeId}/bookings/admin/{id}'` is used in `admin_bookings_repository`.
4. Done in WP1: `adminDisputeDetail = '/stores/{storeId}/disputes/admin/{id}'` is used in `admin_disputes_repository`.
5. Done in WP2: add owner-scoped `GET /stores/:storeId/sessions/:id/logs` under `sessionUserRoutes`; app log parsing now accepts the backend's camelCase log payload.
6. Done in WP2: add `POST /auth/logout` under `userRoutes` with the existing logout request body.
7. Done in WP2: add `POST /auth/phone/change/verify`; app keeps the two-step OTP flow and backend now applies the phone update after verification.

---

## B. NOT REACHABLE — backend endpoint exists, app has no constant/repo

App-relevant (worth wiring):
| Status | Endpoint | Module | Notes |
|---|---|---|---|
| [x] | `POST /stores/:storeId/systems/:id/regenerate-key` | systems | Fixed in WP3 via `systems_admin_repository` + system-detail action sheet |
| [x] | `GET /stores/:storeId/billing/ledger/:id` | billing | Fixed in WP3 via billing row drill-down |
| [x] | `GET /stores/:storeId/payments/:id` | payments | Fixed in WP3 via billing screen payment detail drill-down |
| [x] | `POST /stores/:storeId/billing/:sessionId/bill` | billing | Fixed in WP3 by chaining bill generation from end-session flow |

Intentionally N/A for this app (no action):
- `POST /stores`, `PATCH /stores/:id` — platform super-admin store onboarding (not a tenant-admin screen).
- `GET /users/profile` — duplicate of `/auth/me`.
- All agent routes: `POST /systems/:id/heartbeat`, `POST /sessions/agent/sync`, `POST /sessions/agent/:id/end`, and the `/ws/stores/:storeId/agent/:systemId` channel — these belong to the desktop System Agent, not Player/Admin.

---

## C. WebSockets — status
All app-relevant WS channels ARE connected AND consumed (not just opened):
- **Player notify** `/ws/users/:userId/notify` — `PlayerWsService` connected in `main_page.dart`;
  events routed to `notificationsNotifier` (new notification badge) + `sessionsHub` /
  `activeSessionDetail` notifiers (session started/ended/extended, booking checked-in). ✅
- **Admin live** `/ws/stores/:storeId/live` — `adminLiveEventsProvider` listened in
  `admin_dashboard_screen` + `session_management_screen`. ✅
- **Agent link** — N/A (desktop agent only).

No missing WS wiring on the app side.

---

## D. Display / dummy-data scan
- [x] Auth/profile coverage pass: player `GET /auth/me` fields are now surfaced meaningfully in the app (`email`, `phone`, `isVerified`, `createdAt`), and `PATCH /auth/me` is aligned to the backend's name-only request body.
- `grep` for `static const _… / _mock / sampleData / hardcoded` across `lib/features` → only
  **legitimate UI constants** (filter chips, month/weekday labels, onboarding slides, country list,
  pricing day/time options, extend-duration options). No data literals standing in for API data.
- [x] WP5 removed the demo login artifact from the player email-login flow; `credential_chips.dart`
  is gone and no auth screen renders hardcoded player/admin/staff credentials.
- A field-by-field "is every response field shown" pass was NOT exhaustively done here — that's a
  separate per-screen deep audit. The structural gaps above (B + ledger/payment detail) are the
  concrete "detail not shown" items found.

---

## E. Doc drift (in gz_ideation, FYI — not an app bug)
`gz_ideation/docs/api-overview.md` is stale vs source:
- Lists admin login/password-reset under `/stores/:storeId/admins/*`; actually they live under
  `/auth/admin/*` (the app's `authAdminLogin` is correct — the doc was wrong).
- Lists notifications admin send as global `/notifications/admin/send`; actually store-scoped.
- Lists billing override as `/:billingId/override`; actually `/ledger/:id/override`.
- Omits `users` module, `systems/:id/regenerate-key`, and the `/bookings/admin/:id` /
  `/disputes/admin/:id` admin-detail split.
Treat module `index.ts` files as truth, not this doc.
