# Remediation Plan — 100% Backend↔App Parity
> Companion to `brain/BACKEND_PARITY_AUDIT.md` (2026-06-25). Built to be executed as independent
> **work packages**, one (or a few) per conversation. Each WP is self-contained and ends green.

## Decisions locked (2026-06-25)
- **Cross-repo scope = BOTH repos.** WP2 adds the missing backend routes (it does NOT remove app flows).
- **Stale docs = REGENERATE, don't delete.** `gz_ideation/docs/api-overview.md` is rebuilt from final
  source in WP5 (after WP1–WP3 land), so it reflects post-remediation truth. Until then it stays stale
  and every WP treats backend module source as the only truth.

---

## 0. Ground rules — apply to EVERY work package

**Truth & context (read before writing, in this order):**
1. `brain/.ai_index.md`
2. `brain/code_map.md`
3. `brain/BACKEND_PARITY_AUDIT.md`
4. this file
5. the `brain/features/.registry/<feature>.md` for any feature you touch
6. the matching backend source `../gz_ideation/src/modules/<module>/{index,service,model}.ts`
   — **backend source is the only truth.** `gz_ideation/docs/api-overview.md` is stale; do not trust it.

**Engineering bar (senior, product-complete):**
- **Reuse first.** Before creating any screen/widget, search `lib/shared/widgets/` and the feature's
  `presentation/` for something that fits (`gz_meta_row`, `gz_tag`, `page_error_display`,
  `gz_loading_view`, sheets, `store_selector_sheet`, etc.). A new widget is allowed **only** when no
  existing one fits — and you must justify it in the registry entry.
- **Tokens only.** Spacing from `app_spacing`, colors from `app_colors`, type from `app_typography`.
  No magic numbers, no inline hex. **Think twice before hardcoding anything** — strings, sizes, URLs,
  enums all belong in their proper home.
- **Models.** Extend the manual `lib/models/*` `fromJson` when a response field is missing. No codegen,
  no freezed. Match the backend `model.ts` shape exactly (casing, nullability).
- **Four states.** Every data-bound screen renders loading / error(+retry) / empty / data. Errors are
  typed `AppException` → `PageErrorDisplay` (read) or snackbar via `error_snackbar` (action).
- **Flow.** `Widget → Notifier → Repository → ApiClient → API`. No HTTP in the UI; no business logic
  in controllers.
- **State sync (same change).** Update `code_map.md` + the registry, and tick the item in
  `BACKEND_PARITY_AUDIT.md`.
- **Verify.** `flutter analyze` clean. Re-check each touched endpoint against backend source. If the
  backend was changed, run its lint/tests too.

---

## WP1 — Path / auth parity fixes  (app-only, mechanical, no decisions)
Fixes audit items A1–A4. Files: `lib/core/api/api_constants.dart` + 4 repositories.
1. **Admin notify send** — add `storeNotifyAdminSend = '/stores/{storeId}/notifications/admin/send'`
   and `…/topic`; route `admin_notify_send_repository` through `adminStorePath`. Remove the old
   unscoped constants if unused.
2. **Billing override** — `billingOverride = '/stores/{storeId}/billing/ledger/{id}/override'`.
3. **Admin booking detail** — add `adminBookingDetail = '/stores/{storeId}/bookings/admin/{id}'`;
   use it in `admin_bookings_repository.fetchBookingDetail`.
4. **Admin dispute detail** — add `adminDisputeDetail = '/stores/{storeId}/disputes/admin/{id}'`;
   use it in `admin_disputes_repository.fetchDisputeDetail`.
**DoD:** each path verified against the module `index.ts`; admin detail screens load with an admin JWT.

## WP2 — Decision flows  (logout / phone-change / player session logs)  — DECIDED: BOTH repos
Audit items A5–A7. Add the backend routes in `gz_ideation`, keep the existing app flows.
- **User logout (A6):** add `POST /auth/logout` (userAuth) → revoke the refresh session in Redis;
  keep the app's `authLogout` call (it then also wipes local tokens + redirects).
- **Phone change (A7):** add `POST /auth/phone/change/verify` (OTP confirm) so the app's 2-step
  change-phone UI works end-to-end; keep `POST /auth/phone/change` as the initiate step.
- **Player session logs (A5):** add owner-scoped `GET /stores/:storeId/sessions/:id/logs` under
  `sessionUserRoutes` (userAuth, must verify the session belongs to the caller) so the existing
  player logs screen loads.
Backend DoD: each new route uses `t` schemas, `sendSuccess`/`sendError`, respects multi-tenancy +
ownership, has a bun:test, passes `bun run lint`. App side: remove the dead-route assumptions.

## WP3 — Wire unreachable admin endpoints  (+ UI / models)
Audit section B. Each needs a small amount of new UI — reuse aggressively.
1. **Regenerate agent key** — `POST /systems/:id/regenerate-key`. Add to `systems_admin_repository`;
   action on `system_detail_screen` (reuse a confirm sheet) → reveal/copy new key (reuse an existing
   dialog + copy affordance). Model: key-response object.
2. **Billing ledger record detail** — `GET /billing/ledger/:id`. Add constant + repo method + detail
   view; reuse existing detail-screen layout + `gz_meta_row`. Entry point: ledger row tap.
3. **Payment detail** — `GET /payments/:id`. Add constant + repo method; surface from
   `billing_payments_screen` row tap.
4. **Generate bill** — `POST /billing/:sessionId/bill`. Confirm whether the admin end-session flow
   should trigger it; wire into `end_session_sheet` if so.

## WP4 — Display / field-coverage pass  ("details not shown" audit)
For each feature: diff every response model field in `lib/models/*` against what the screen renders.
Surface each meaningful field (reuse `gz_meta_row`, `gz_tag`, existing cards) or deliberately omit it
with a one-line reason in the registry. Order: player features first, then admin.

## WP5 — Hygiene & docs
- Remove or debug-gate `auth/.../credential_chips.dart` demo logins.
- **Regenerate** `gz_ideation/docs/api-overview.md` from the final module source (do NOT delete) so it
  matches post-WP1–WP3 reality — fix the known drift: admin auth lives under `/auth/admin/*`,
  notifications admin send is store-scoped, billing override is `/ledger/:id/override`, add the `users`
  module, `systems/:id/regenerate-key`, and the `/bookings/admin/:id` & `/disputes/admin/:id` split.
- Refresh `brain/API_INTEGRATION_PLAN.md` status (Phases 1–13 complete).
- Flip registries to **Implemented**; tick all `BACKEND_PARITY_AUDIT.md` checkboxes; final
  `flutter analyze` + backend `bun run lint` / `bun test`.

---

## Suggested conversation order
WP1 → WP2 → WP3 → WP4 → WP5. WP1 and WP3 are independent and can run in parallel conversations.
