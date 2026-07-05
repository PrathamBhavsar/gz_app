# Phase 5 — Wallet, Credits & Campaigns — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)

## Missing / renamed endpoints or constants
- No new endpoint constants were required. Phase 5 uses:
  - `ApiConstants.playerCreditsBalance`
  - `ApiConstants.playerCreditsTransactions`
  - `ApiConstants.playerCreditsRedeem`
  - `ApiConstants.playerCampaignsActive`
  - `ApiConstants.playerCampaignRedeem`

## Model ↔ JSON field mismatches (nullable, casing, types)
- Pagination is not fully normalized across docs and code. `WalletRepository` accepts both `pagination` and `meta` envelopes when loading credit history.

## Registry ↔ code drift fixed
- `brain/features/.registry/wallet.md` updated to reflect the new repository, notifiers, and UI-model file as implemented.
- `brain/code_map.md` updated so the wallet feature no longer shows as presentation-only.

## Dummy data removed (file:line)
- `lib/features/wallet/presentation/screens/wallet_screen.dart:25`
- `lib/features/wallet/presentation/screens/credit_history_screen.dart:15`
- `lib/features/wallet/presentation/screens/campaigns_screen.dart:21`
- `lib/features/wallet/presentation/screens/campaign_detail_screen.dart:20`
- `lib/features/wallet/presentation/screens/redeem_credits_sheet.dart:23`

## Open TODOs / deferred
- Campaign detail currently resolves from the active-campaign list, then redeems by id. If the backend later exposes a dedicated player detail endpoint, wire it into `WalletRepository.fetchCampaignById()`.
- Credit history pagination is implemented with a manual `Load more` CTA rather than infinite scroll.

## Pass 2 review notes
- Fixed campaign redeem success flow to return from detail after success instead of leaving the user on stale detail state.
- Guarded wallet and campaigns list navigation so cards with missing campaign ids do not push invalid detail routes.
