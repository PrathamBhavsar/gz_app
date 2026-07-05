---
type: Module
title: Wallet (Credits & Campaigns)
description: Player loyalty — credit balance/history and browsing/redeeming campaigns.
resource: file://lib/features/wallet
tags: [wallet, credits, campaigns, loyalty]
timestamp: 2026-07-04
---

# Responsibilities
Show credit balance + transaction history and let the player browse/redeem campaigns. Notifiers:
`wallet_notifier`, `credit_history_notifier`, `redeem_credits_notifier`, `campaigns_notifier`,
`campaign_detail_notifier`. Repository: `wallet_repository.dart`. Backend: [credits](../references/backend-brain-link.md) + [campaigns](../references/backend-brain-link.md).

# Screens

| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 29 | WalletScreen | `/wallet` (tab) | `GET /stores/:storeId/credits/balance`, `.../credits/transactions`, `.../campaigns/active` |
| 30 | CreditHistoryScreen | `/wallet/transactions` | `GET /stores/:storeId/credits/transactions` |
| 31 | CampaignsScreen | `/wallet/campaigns` | `GET /stores/:storeId/campaigns/active` |
| 32 | CampaignDetailScreen | `/wallet/campaigns/:id` | `POST /stores/:storeId/campaigns/:id/redeem` |

# Notes
Credits are ledger-derived on the backend; the app just displays balance + history. Redeeming applies a
discount or awards bonus credits. See [Wallet & Credits flow](../flows/wallet-credits.md).
</content>
