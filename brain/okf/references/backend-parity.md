---
type: Reference
title: Backend Parity
description: Known frontend↔backend gaps and the WP fixes that closed most of them.
resource: file://references/_legacy/BACKEND_PARITY_AUDIT.md
tags: [parity, backend, audit]
timestamp: 2026-07-04
---

The app was built UI-first, then wired to the backend across API phases 1–13. Parity work packages closed
the known gaps (from the old `BACKEND_PARITY_AUDIT.md`, folded to [_legacy](legacy.md)):

* **WP1** — corrected admin-only wrong paths/auth: notifications send, billing override, admin booking detail, admin dispute detail.
* **WP2** — added/aligned decision-flow endpoints: player logout, phone-change OTP verify, owner-scoped player session logs (+ empty-logs state).
* **WP3** — wired previously-unreachable admin endpoints: system key regeneration, billing ledger detail, payment detail, bill generation; end-session now finalizes billing via the backend route.
* **WP4** — auth/profile coverage: `PATCH /auth/me` aligned to the backend's name-only contract; profile verification/member-since surfaced from `GET /auth/me`.

# Still worth watching
* `enums.dart` `AuthMethod` omits `discord_oauth` though Discord login works; `TransactionType` is app-only (see [Enums](../data/enums.md)).
* Backend `users` module route group is unmounted; the app uses `GET /auth/me` for profile (see backend `modules/users.md`).
* Always re-verify a screen's endpoint against `gz_ideation/src` before trusting older docs — see [Backend Brain Link](backend-brain-link.md).
</content>
