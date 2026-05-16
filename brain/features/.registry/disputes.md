# Disputes Feature Registry
> Phase 7 — built 2026-05-16

## Screens

| Screen | Route | File |
|--------|-------|------|
| S-35 Disputes List | `/profile/disputes` | `lib/features/profile/presentation/screens/disputes_list_screen.dart` |
| S-36 Create Dispute | `/profile/disputes/create` | `lib/features/disputes/presentation/screens/create_dispute_screen.dart` |
| S-37 Dispute Detail | `/profile/disputes/:id` | `lib/features/disputes/presentation/screens/dispute_detail_screen.dart` |

## Layouts

| Layout | File |
|--------|------|
| `DisputesListMobileLayout` | `lib/features/profile/presentation/widgets/disputes_list_mobile_layout.dart` |
| `CreateDisputeMobileLayout` | `lib/features/disputes/presentation/widgets/create_dispute_mobile_layout.dart` |
| `DisputeDetailMobileLayout` | `lib/features/disputes/presentation/widgets/dispute_detail_mobile_layout.dart` |

## Providers

| Provider | Type | File |
|----------|------|------|
| `disputesListProvider` | `NotifierProvider<DisputesListNotifier, AsyncValue<List<BillingDisputeModel>>>` | `lib/features/disputes/presentation/providers/disputes_list_notifier.dart` |
| `disputeDetailProvider` | `NotifierProviderFamily<DisputeDetailNotifier, DisputeDetailState, String>` | `lib/features/disputes/presentation/providers/dispute_detail_notifier.dart` |
| `createDisputeProvider` | `NotifierProvider<CreateDisputeNotifier, CreateDisputeState>` | `lib/features/disputes/presentation/providers/create_dispute_notifier.dart` |

## Data Layer

| Class | File |
|-------|------|
| `DisputeService` | `lib/features/disputes/data/services/dispute_service.dart` |
| `DisputeRepository` | `lib/features/disputes/data/repositories/dispute_repository.dart` |
| `disputeRepositoryProvider` | same file as repository |

## Notes

- Routes moved from `/disputes/*` to `/profile/disputes/*` in Phase 7 — route constants in `AppRoutes` updated
- `BillingDisputeModel` from `lib/models/domain_billing.dart` is the canonical dispute model
- `DisputeStatus` enum from `lib/models/enums.dart`: `open, underReview, resolved, withdrawn`
- `DisputeDetailNotifier` is a `FamilyNotifier` parameterized by dispute ID (String)
- `CreateDisputeMobileLayout` uses `ConsumerStatefulWidget` to manage local form state; `createDisputeProvider` handles submission only
- `DisputesListNotifier` returns `AsyncData([])` when `activeStoreIdProvider` is null
- Withdraw flow: confirm dialog overlay → `disputeDetailProvider(id).notifier.withdraw(id)`
