# Wallet Feature Registry
> TARGET SPEC — not yet implemented

## Reality Check
Only presentation screens exist today:
- `lib/features/wallet/presentation/screens/wallet_screen.dart`
- `lib/features/wallet/presentation/screens/credit_history_screen.dart`
- `lib/features/wallet/presentation/screens/campaigns_screen.dart`
- `lib/features/wallet/presentation/screens/campaign_detail_screen.dart`
- `lib/features/wallet/presentation/screens/redeem_credits_sheet.dart`

No `data/` or `application/` folders exist under `lib/features/wallet/`.

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/wallet/data/repositories/wallet_repository.dart` | Credits balance, ledger, campaigns, redemptions | No |
| `lib/features/wallet/application/wallet_notifier.dart` | Wallet dashboard aggregate state | No |
| `lib/features/wallet/application/credit_history_notifier.dart` | Paginated credit ledger | No |
| `lib/features/wallet/application/redeem_credits_notifier.dart` | Redeem action state | No |
| `lib/features/wallet/application/campaigns_notifier.dart` | Campaign list and filters | No |
| `lib/features/wallet/application/campaign_detail_notifier.dart` | Campaign detail and redeem action | No |

## Planned Endpoints
- `GET /stores/:storeId/credits/balance`
- `GET /stores/:storeId/credits/transactions`
- `POST /stores/:storeId/credits/redeem`
- `GET /stores/:storeId/campaigns/active`
- `POST /stores/:storeId/campaigns/:id/redeem`

## Notes
- `wallet_screen.dart` currently contains inline dummy content and is a known Phase 5 cleanup target.
- Do not mark this implemented until the dummy transactions/campaigns are removed and notifier-driven UI states are in place.
