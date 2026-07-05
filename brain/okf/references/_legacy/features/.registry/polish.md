# Registry: Polish (Phase 10)
> TARGET SPEC — not yet implemented

## Reality Check
This registry outlines pull-to-refresh, empty states, and accessibility enhancements that are targets for the finalized screen implementations. Since the features themselves are currently presentation-only (no data repositories/notifiers wired up), these polish items will be verified and completed as each feature phase finishes.


## Empty States

| Screen | File | Status |
|--------|------|--------|
| S-11 Home (no stores) | `features/home/presentation/widgets/home_mobile_layout.dart` | ✓ EmCard + EmAvatar icon + h2 + bodyR + Refresh CTA |
| S-12 Store Search | `features/home/presentation/widgets/store_search_mobile_layout.dart` | ✓ EmCard + icon container + h2 + bodyR |
| S-19 Activity — Upcoming | `features/sessions/presentation/widgets/sessions_mobile_layout.dart` | ✓ EmCard + icon + h2 + bodyR + Book CTA |
| S-19 Activity — Active | `features/sessions/presentation/widgets/sessions_mobile_layout.dart` | ✓ EmCard + icon + h2 + bodyR |
| S-19 Activity — History | `features/sessions/presentation/widgets/sessions_mobile_layout.dart` | ✓ EmCard + icon + h2 + bodyR |
| S-25 Billing History | `features/sessions/presentation/widgets/billing_history_mobile_layout.dart` | ✓ EmCard + icon + h2 + bodyR |
| S-27 Credit Tx History | `features/wallet/presentation/widgets/credit_history_mobile_layout.dart` | ✓ Already done Phase 6 |
| S-29 Campaigns | `features/wallet/presentation/widgets/campaigns_mobile_layout.dart` | ✓ Already done Phase 6 |
| S-35 Disputes | `features/profile/presentation/widgets/disputes_list_mobile_layout.dart` | ✓ Already done Phase 7 |
| O-38 Notifications | `features/notifications/presentation/widgets/notification_center_sheet.dart` | ✓ Already done Phase 8 |

## Error Surfaces

All AsyncValue.error states use `PageErrorDisplay(error: AppPageError.from(e), onRetry: ...)`.

- S-12 Store Search: upgraded from raw EmCard text to `PageErrorDisplay` ✓

## Pull-to-Refresh

| Screen | File | Status |
|--------|------|--------|
| S-11 Home | `home_mobile_layout.dart` | ✓ Added RefreshIndicator (replaces EmScrollContent) |
| S-14 Systems | `booking_slot_selection_mobile_layout.dart` | ✓ Already done Phase 4 |
| S-19 Activity Hub | `sessions_mobile_layout.dart` | ✓ Added RefreshIndicator on ListView |
| S-26 Wallet | `wallet_mobile_layout.dart` | ✓ Already done Phase 6 |
| S-27 Credit Tx | `credit_history_mobile_layout.dart` | ✓ Already done Phase 6 |
| S-29 Campaigns | `campaigns_mobile_layout.dart` | ✓ Already done Phase 6 |
| S-35 Disputes | `disputes_list_mobile_layout.dart` | ✓ Added RefreshIndicator |

## Connectivity Banner

**Widget**: `lib/shared/widgets/connectivity_banner.dart` — `ConnectivityBanner`

Added to:
- S-11 Home (`home_mobile_layout.dart`)
- S-14 Systems Browser (`booking_slot_selection_mobile_layout.dart`)
- S-19 Activity Hub (`sessions_mobile_layout.dart`)
- S-26 Wallet (`wallet_mobile_layout.dart`)

## Entrance Animations

`.animate(delay: (i * 60).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0, duration: 220.ms)`

Added to list items in:
- S-11 Home: _StoreCardLg (slideX), _NewStoreRow (slideY)
- S-12 Store Search: results ListView items
- S-19 Sessions: upcoming booking cards
- S-25 Billing: _BillingRowWidget items per group
- S-27 Credit Tx: group columns + tx rows (fadeIn only)
- S-29 Campaigns: CampaignCard items
- O-38 Notifications: NotifRow items (40ms stagger)

## Accessibility

- `EmIconBtn` tooltip param: all usages verified
  - Home bell: `tooltip: 'Notifications'` ✓
  - Wallet bell: `tooltip: 'Notifications'` ✓ (added Phase 10)
  - Sessions filter: `tooltip: 'Filter'` ✓ (added Phase 10)
  - Sessions bell: `tooltip: 'Notifications'` ✓ (added Phase 10)
- Search bar `Semantics(label: 'Search gaming stores', button: true)` ✓
- `_IconBtn` in sessions: added `tooltip` param ✓
