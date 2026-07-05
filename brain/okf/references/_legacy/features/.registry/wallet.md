# Wallet Feature Registry
> IMPLEMENTED — Phase 5 wallet, credits, and campaigns integration is in place.

## Reality Check
Phase 5 now includes repository, application, and presentation layers:
- `lib/features/wallet/data/repositories/wallet_repository.dart`
- `lib/features/wallet/application/wallet_ui_models.dart`
- `lib/features/wallet/application/wallet_notifier.dart`
- `lib/features/wallet/application/credit_history_notifier.dart`
- `lib/features/wallet/application/redeem_credits_notifier.dart`
- `lib/features/wallet/application/campaigns_notifier.dart`
- `lib/features/wallet/application/campaign_detail_notifier.dart`
- `lib/features/wallet/presentation/screens/wallet_screen.dart`
- `lib/features/wallet/presentation/screens/credit_history_screen.dart`
- `lib/features/wallet/presentation/screens/campaigns_screen.dart`
- `lib/features/wallet/presentation/screens/campaign_detail_screen.dart`
- `lib/features/wallet/presentation/screens/redeem_credits_sheet.dart`

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/wallet/data/repositories/wallet_repository.dart` | Credits balance, ledger, campaigns, redemptions | Yes |
| `lib/features/wallet/application/wallet_notifier.dart` | Wallet dashboard aggregate state | Yes |
| `lib/features/wallet/application/credit_history_notifier.dart` | Paginated credit ledger | Yes |
| `lib/features/wallet/application/redeem_credits_notifier.dart` | Redeem action state | Yes |
| `lib/features/wallet/application/campaigns_notifier.dart` | Campaign list and filters | Yes |
| `lib/features/wallet/application/campaign_detail_notifier.dart` | Campaign detail and redeem action | Yes |
| `lib/features/wallet/application/wallet_ui_models.dart` | Wallet display mapping + formatting helpers | Yes |

## Planned Endpoints
- `GET /stores/:storeId/credits/balance`
- `GET /stores/:storeId/credits/transactions`
- `POST /stores/:storeId/credits/redeem`
- `GET /stores/:storeId/campaigns/active`
- `POST /stores/:storeId/campaigns/:id/redeem`

## Notes
- `wallet_screen.dart`, `credit_history_screen.dart`, `campaigns_screen.dart`, `campaign_detail_screen.dart`, and `redeem_credits_sheet.dart` are now notifier-driven and no longer contain inline wallet/campaign mock data.
- `WalletRepository` uses the player endpoints from `ApiConstants` and supports paginated transaction loading plus redemption mutations.
