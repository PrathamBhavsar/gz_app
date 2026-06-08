# Disputes Feature Registry
> TARGET SPEC — not yet implemented

## Reality Check
Existing files today:
- `lib/features/profile/presentation/screens/disputes_list_screen.dart`
- `lib/features/disputes/presentation/screens/create_dispute_screen.dart`
- `lib/features/disputes/presentation/screens/dispute_detail_screen.dart`

Missing today:
- `lib/features/disputes/data/`
- `lib/features/disputes/application/`
- Any disputes-specific providers, repositories, or services

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/disputes/data/repositories/disputes_repository.dart` | Player dispute list, create, detail, withdraw | No |
| `lib/features/disputes/application/my_disputes_notifier.dart` | `/profile/disputes` list state | No |
| `lib/features/disputes/application/dispute_detail_notifier.dart` | Dispute detail by id | No |
| `lib/features/disputes/application/create_dispute_notifier.dart` | Create dispute action state | No |

## Planned Screens
| Screen | Route | File |
|---|---|---|
| S-35 Disputes List | `/profile/disputes` | `lib/features/profile/presentation/screens/disputes_list_screen.dart` |
| S-36 Create Dispute | `/profile/disputes/create` | `lib/features/disputes/presentation/screens/create_dispute_screen.dart` |
| S-37 Dispute Detail | `/profile/disputes/:id` | `lib/features/disputes/presentation/screens/dispute_detail_screen.dart` |

## Planned Endpoints
- `GET /stores/:storeId/disputes/my`
- `POST /stores/:storeId/disputes`
- `GET /stores/:storeId/disputes/:id`
- `POST /stores/:storeId/disputes/:id/withdraw`

## Notes
- This registry is a Phase 8 target from `brain/API_INTEGRATION_PLAN.md`, not an implementation record.
- The list screen lives under the profile feature, but the API/data layer should remain disputes-owned.
