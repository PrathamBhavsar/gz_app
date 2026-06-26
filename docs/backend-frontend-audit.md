# Backend → Frontend Implementation Audit

> Generated 2026-06-15. Measures how much of the backend API is correctly wired into the Flutter app, and what is needed to fully implement it.

## Sources

- **Backend** — `/Users/pratham/code/gz_ideation` (`gz_ideation`): Bun + ElysiaJS, 17 modules in `src/modules/*/index.ts`, ~116 app-relevant HTTP endpoints (+3 WebSocket channels). Routes are the source of truth — not `docs/api-overview.md`.
- **Frontend** — this repo (`gz_app`): paths centralized in `lib/core/api/api_constants.dart`, consumed by `lib/features/*/data/repositories/*.dart`.

## Method (repeatable pipeline)

1. **Extract backend truth** — parse every `src/modules/*/index.ts` for the Elysia group `prefix` + each `.get/.post/.patch/.delete/.ws` route → assemble full endpoint paths.
2. **Extract frontend calls** — pull every path string from `api_constants.dart`; grep repositories for how they assemble paths (some append `/$id` inline).
3. **Diff path-by-path** per module, normalizing `:param` ↔ `{param}`.
4. **Verify suspects in code** — for each mismatch, confirm whether the constant is actually invoked (a 404 only matters if it's called).
5. **Trace wiring depth** — repo → notifier → screen → route, separating "endpoint exists" from "screen actually uses it."

---

## Coverage scorecard (endpoint level)

| Module | Backend | Wired in FE | Status |
|---|---|---|---|
| auth | 18 | 18 | OK + 2 phantom FE calls (see below) |
| analytics | 6 | 6 | OK |
| credits | 6 | 6 | OK |
| campaigns | 9 | 9 | OK |
| sessions | 10 | 10 | OK |
| store-admins | 4 | 4 | OK |
| system-types | 5 | 5 | OK |
| pricing | 5 | 5 | OK (`/rules/:id` built inline — verified) |
| bookings | 11 | 10 | admin detail uses wrong route |
| disputes | 8 | 7 | admin detail uses wrong route |
| billing | 6 | 3 | override path bug + 2 missing |
| notifications | 8 | 8 | admin-send path bug (not store-scoped) |
| payments | 5 | 4 | payment-detail missing |
| systems | 8 | 7 | regenerate-key missing |
| stores | 6 | 4 | create/update store missing (likely out of scope) |
| users | 1 | 0 | `/users/profile` unused (redundant with `/auth/me`) |

**~90% of endpoints correctly wired.** Remaining ~10% = 4 correctness bugs + 2 phantom calls + ~6 unimplemented endpoints.

WebSocket channels: `store-live` (admin) → `admin_live_service.dart` OK; `player-notify` → `player_ws_service.dart` OK; `agent-link` → N/A (desktop agent app, not this client).

---

## Confirmed correctness bugs (silent 404 / 403)

Constants are actively called but do not match the backend:

1. **Billing override** — FE `/stores/{storeId}/billing/{id}/override`; backend `/stores/{storeId}/billing/ledger/{id}/override`. Missing `/ledger/` segment → 404.
   - FE: `lib/core/api/api_constants.dart:98`, used by `admin_billing_repository.dart`.
2. **Admin notification send** — FE global `/notifications/admin/send` (+ `/topic`); backend store-scoped `/stores/{storeId}/notifications/admin/send`.
   - FE: `api_constants.dart:132-134`.
3. **Admin booking detail** — `admin_bookings_repository.dart:47` calls player `GET /bookings/{id}` (userAuth) with an admin token; backend has dedicated `GET /bookings/admin/{id}` (adminAuth) → wrong scope / 403.
4. **Admin dispute detail** — `admin_disputes_repository.dart:33` calls `GET /disputes/{id}` instead of `GET /disputes/admin/{id}`. Same scope mismatch.

## Phantom frontend calls (no backend endpoint exists)

5. **Player logout** — `auth_repository.dart:261` calls `/auth/logout`; backend only has `/auth/admin/logout` → 404 on player sign-out.
6. **Phone change verify** — `auth_repository.dart:221` calls `/auth/phone/change/verify`; backend has `/phone/change` only (no verify step) → 404.

## Backend endpoints with no frontend implementation

7. `POST /stores/{storeId}/billing/{sessionId}/bill` — generate a bill (admin).
8. `GET /stores/{storeId}/billing/ledger/{id}` — single ledger entry.
9. `GET /stores/{storeId}/payments/{id}` — payment detail.
10. `POST /stores/{storeId}/systems/{id}/regenerate-key` — rotate agent API key (admin system mgmt gap).
11. `POST /stores`, `PATCH /stores/{storeId}` — create/update store (probably intentional: no super-admin UI).

---

## Beyond endpoints: "present, accessible, works"

Endpoint coverage is necessary but not sufficient for the stated goal.

- **Present** — proven: all 72 screens exist as Dart files with notifiers + repositories (see `docs/compliance-matrix.md`).
- **Accessible** — each screen needs a reachable `GoRoute` AND a navigation entry point (button/tab/deep link). Audit: cross-check each screen against `app_router.dart` routes and grep for a `context.go/push` that reaches it. Orphan routes (registered, never pushed) are the common failure.
- **Works as intended** — per repo, confirm: (a) correct path/scope (above), (b) request body matches backend `model.ts` TypeBox schema, (c) response parsing matches `{success,data,meta}` envelope and `snake_case` enums, (d) screen renders loading/error/empty/data states. Git history is at "phase 13" of API integration; cleanest finish is to diff each module's `model.ts` against the matching `lib/models/*.dart` parser.

---

## Plan to reach 100%

**Phase A — fix the 4 live bugs + 2 phantom calls** (small, high-impact):
- Correct billing-override path (add `/ledger/`).
- Store-scope admin notification-send paths.
- Point admin booking/dispute detail at the `/admin/:id` routes.
- Resolve phantom auth calls: add backend `/auth/logout` + phone-verify, or remove the FE calls.

**Phase B — implement the 4 missing app-relevant endpoints:**
generate-bill, payment detail, ledger-entry detail, regenerate-agent-key — wire into existing billing/payments/system-detail screens.

**Phase C — request/response contract pass:**
per module, diff backend `model.ts` ↔ frontend model parsers; verify the 4 UI states on each API-bound screen.

Start with Phase A — those are confirmed-broken in code today.
