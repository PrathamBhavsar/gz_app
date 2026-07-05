---
type: Flow
title: Wallet & Credits
description: Viewing loyalty balance/history and redeeming campaigns.
tags: [flow, wallet, credits, campaigns]
timestamp: 2026-07-04
---

```
Wallet (/wallet) ─▶ CreditHistory (/wallet/transactions)
   GET credits/balance + transactions + campaigns/active
      │
      └▶ Campaigns (/wallet/campaigns) ─▶ CampaignDetail (/wallet/campaigns/:id)
              GET campaigns/active            POST campaigns/:id/redeem
```

1. [Wallet](../modules/wallet.md) shows the (backend-derived) credit balance, recent transactions, and active campaigns.
2. Redeeming a campaign (`POST /campaigns/:id/redeem`) applies a discount or awards bonus credits; the balance/history refresh.
3. Credits can settle a bill (`method=credits`) during [payment](check-in-active-session.md).

Mirrors backend [credits-ledger](../references/backend-brain-link.md) + [campaign-redemption](../references/backend-brain-link.md).
</content>
