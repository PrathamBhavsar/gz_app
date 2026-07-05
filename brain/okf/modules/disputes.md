---
type: Module
title: Disputes (Player)
description: File and track billing disputes.
resource: file://lib/features/disputes
tags: [disputes, billing, refund]
timestamp: 2026-07-04
---

# Responsibilities
Create a dispute against a billing row and track it. Notifiers: `create_dispute_notifier`,
`my_disputes_notifier`, `dispute_detail_notifier`. Repository: `disputes_repository.dart`. Backend:
[disputes](../references/backend-brain-link.md). The list screen is in [profile](profile.md) (DisputesList).

# Screens

| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 39 | CreateDisputeScreen | `/profile/disputes/create?billingId=` | `POST /stores/:storeId/disputes` |
| 40 | DisputeDetailScreen | `/profile/disputes/:id` | `GET /stores/:storeId/disputes/:id`, `POST .../:id/withdraw` |

# Notes
Reachable from [BillingHistory](sessions.md) with a prefilled `billingId`. One active dispute per bill;
amount ≤ net billed. See [Disputes flow](../flows/disputes.md).
</content>
