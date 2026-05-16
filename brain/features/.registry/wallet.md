# Wallet Feature Registry
> Phase 6 — built 2026-05-16

## Screens

| Screen | Route | File |
|--------|-------|------|
| S-26 Wallet Home | `/wallet` | `lib/features/wallet/presentation/screens/wallet_screen.dart` |
| S-27 Credit History | `/wallet/transactions` | `lib/features/wallet/presentation/screens/credit_history_screen.dart` |
| S-28 Redeem Credits | bottom sheet | `lib/features/wallet/presentation/widgets/redeem_credits_sheet.dart` |
| S-29 Campaigns List | `/wallet/campaigns` | `lib/features/wallet/presentation/screens/campaigns_screen.dart` |
| S-30 Campaign Detail | `/wallet/campaigns/:id` | `lib/features/wallet/presentation/screens/campaign_detail_screen.dart` |

## Layouts

| Layout | File |
|--------|------|
| `WalletMobileLayout` | `lib/features/wallet/presentation/widgets/wallet_mobile_layout.dart` |
| `WalletTabletLayout` | `lib/features/wallet/presentation/widgets/wallet_tablet_layout.dart` (delegates to mobile) |
| `CreditHistoryMobileLayout` | `lib/features/wallet/presentation/widgets/credit_history_mobile_layout.dart` |
| `CampaignsMobileLayout` | `lib/features/wallet/presentation/widgets/campaigns_mobile_layout.dart` |
| `CampaignDetailMobileLayout` | `lib/features/wallet/presentation/widgets/campaign_detail_mobile_layout.dart` |

## Providers

| Provider | Type | File |
|----------|------|------|
| `walletNotifierProvider` | `NotifierProvider<WalletNotifier, AsyncValue<WalletData>>` | `wallet_notifier.dart` |
| `creditHistoryNotifierProvider` | `NotifierProvider<CreditHistoryNotifier, CreditHistoryState>` | `credit_history_notifier.dart` |
| `redeemCreditsNotifierProvider` | `NotifierProvider<RedeemCreditsNotifier, RedeemCreditsState>` | `redeem_credits_notifier.dart` |
| `campaignsNotifierProvider` | `NotifierProvider<CampaignsNotifier, CampaignsState>` | `campaigns_notifier.dart` |
| `campaignDetailNotifierProvider` | `NotifierProvider.family<CampaignDetailNotifier, CampaignDetailState, String>` | `campaign_detail_notifier.dart` |

## Data Layer

| Class | File |
|-------|------|
| `WalletService` | `lib/features/wallet/data/services/wallet_service.dart` |
| `WalletRepository` | `lib/features/wallet/data/repositories/wallet_repository.dart` |

## Key Models (in `lib/models/domain_loyalty.dart`)

- `CreditBalanceModel` — `balance`, `storeId`, `userId`
- `CreditLedgerModel` — `id`, `transactionType` (CreditTransactionType), `amount`, `description`, `createdAt`
- `CampaignModel` — `id`, `name`, `campaignType`, `value`, `validFrom`, `validUntil`, `maxRedemptions`, `currentRedemptions`, `minTier`, `maxPerUser`, `description`, `terms`, `applicableSystemTypes`

## State Classes

### `WalletData`
```dart
class WalletData {
  final CreditBalanceModel balance;
  final List<CreditLedgerModel> recentTransactions;
  final List<CampaignModel> campaigns;
}
```

### `CreditHistoryState`
```dart
class CreditHistoryState {
  final List<CreditLedgerModel> items;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;
}
```

### `RedeemCreditsState` (sealed)
- `RedeemCreditsIdle` — initial
- `RedeemCreditsConfirming(double amount)` — awaiting user confirm
- `RedeemCreditsLoading` — API in-flight
- `RedeemCreditsSuccess` — redeemed OK
- `RedeemCreditsError(String message)` — API error

### `CampaignsState`
```dart
class CampaignsState {
  final AsyncValue<List<CampaignModel>> data;
  final CampaignType? selectedFilter;
  List<CampaignModel> get filtered { ... }
}
```

### `CampaignDetailState` (sealed)
- `CampaignDetailIdle`
- `CampaignDetailLoading`
- `CampaignDetailSuccess`
- `CampaignDetailError(String message)`

## Route Constants (in `AppRoutes`)

```dart
static const creditHistory  = '/wallet/transactions';
static const campaigns      = '/wallet/campaigns';
static const campaignDetail = '/wallet/campaigns/:id';
```

## API Endpoints Used

| Endpoint | Constant |
|----------|----------|
| `GET /stores/{storeId}/credits/balance` | `ApiConstants.playerCreditsBalance` |
| `GET /stores/{storeId}/credits/transactions` | `ApiConstants.playerCreditsTransactions` |
| `POST /stores/{storeId}/credits/redeem` | `ApiConstants.playerCreditsRedeem` |
| `GET /stores/{storeId}/campaigns/active` | `ApiConstants.playerCampaignsActive` |
| `POST /stores/{storeId}/campaigns/{id}/redeem` | `ApiConstants.playerCampaignRedeem` |

## Navigation Patterns

- Wallet tab → `context.go(AppRoutes.wallet)` (shell tab)
- Redeem credits → `showRedeemCreditsSheet(context, balance)` (bottom sheet, not a route)
- Credit history → `context.push(AppRoutes.creditHistory)`
- Campaigns list → `context.push(AppRoutes.campaigns)`
- Campaign detail → `context.push(AppRoutes.campaignDetail.replaceAll(':id', id), extra: campaign)` — passes `CampaignModel?` as extra to avoid redundant fetch
