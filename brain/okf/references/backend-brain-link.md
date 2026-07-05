---
type: Reference
title: Backend Brain Link
description: The paired backend OKF bundle — the source of truth for the API this app consumes.
resource: file://../../../gz_ideation/brain/okf/index.md
tags: [backend, cross-project, contract]
timestamp: 2026-07-04
---

The backend is **`gz_ideation`** (Elysia/Bun). Its brain is an OKF bundle at
`gz_ideation/brain/okf/` using the **same taxonomy** as this one, so pages line up 1:1:

| This app | Backend brain |
| --- | --- |
| [modules/auth](../modules/auth.md) | `modules/auth.md` (OTP, email, OAuth, admin) |
| [modules/home](../modules/home.md) | `modules/stores.md` |
| [modules/booking](../modules/booking.md) | `modules/bookings.md` + `modules/systems.md` + `modules/pricing.md` |
| [modules/sessions](../modules/sessions.md) | `modules/sessions.md` + `modules/billing.md` |
| [modules/wallet](../modules/wallet.md) | `modules/credits.md` + `modules/campaigns.md` |
| [modules/notifications](../modules/notifications.md) | `modules/notifications.md` |
| [modules/disputes](../modules/disputes.md) | `modules/disputes.md` |
| [modules/admin](../modules/admin.md) | all admin route groups + `modules/analytics.md` + `modules/store-admins.md` |

Backend truth: `gz_ideation/src/modules/*/index.ts` (routes), `service.ts` (logic), `model.ts`
(validation), `schema.ts` (tables); interactive Swagger at `/docs`. For exact request/response shapes,
prefer the backend brain and source over any stale API doc. Contract summary: [Backend Contract](../systems/backend-contract.md).

> When the two repos are placed under a common `/gz` workspace, a top-level `brain/` will host the
> reconciled cross-project glossary + contract map (phase 2).
</content>
