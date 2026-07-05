---
type: Flow
title: Disputes (Player)
description: Challenging a billing charge and tracking its resolution.
tags: [flow, disputes, billing]
timestamp: 2026-07-04
---

```
BillingHistory (/sessions/billing) ─▶ CreateDispute (/profile/disputes/create?billingId=)
   GET billing/my                        POST disputes
      │
DisputesList (/profile/disputes) ─▶ DisputeDetail (/profile/disputes/:id)
   GET disputes/my                     GET disputes/:id + POST :id/withdraw
```

1. From a charge in [billing history](../modules/sessions.md), the player opens **CreateDispute** with a prefilled `billingId`.
2. `POST /disputes` files it (one active per bill; amount ≤ net billed).
3. [DisputesList](../modules/profile.md) + [DisputeDetail](../modules/disputes.md) track status; an open dispute can be withdrawn.
4. Resolution (admin side) may issue credit or a refund — reflected in the detail + [wallet](wallet-credits.md).

Mirrors backend [dispute-resolution](../references/backend-brain-link.md).
</content>
