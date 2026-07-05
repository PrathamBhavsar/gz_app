# Disputes Feature Registry
> IMPLEMENTED — Phase 8 player disputes wiring is live.

## Reality Check
Live files now:
- `lib/features/profile/presentation/screens/disputes_list_screen.dart`
- `lib/features/disputes/presentation/screens/create_dispute_screen.dart`
- `lib/features/disputes/presentation/screens/dispute_detail_screen.dart`
- `lib/features/disputes/data/repositories/disputes_repository.dart`
- `lib/features/disputes/application/my_disputes_notifier.dart`
- `lib/features/disputes/application/dispute_detail_notifier.dart`
- `lib/features/disputes/application/create_dispute_notifier.dart`

## Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/disputes/data/repositories/disputes_repository.dart` | Player dispute list, create, detail, withdraw | Yes |
| `lib/features/disputes/application/my_disputes_notifier.dart` | `/profile/disputes` list state | Yes |
| `lib/features/disputes/application/dispute_detail_notifier.dart` | Dispute detail by id + withdraw command state | Yes |
| `lib/features/disputes/application/create_dispute_notifier.dart` | Create dispute action state | Yes |

## Screens
| Screen | Route | File |
|---|---|---|
| S-35 Disputes List | `/profile/disputes` | `lib/features/profile/presentation/screens/disputes_list_screen.dart` |
| S-36 Create Dispute | `/profile/disputes/create` | `lib/features/disputes/presentation/screens/create_dispute_screen.dart` |
| S-37 Dispute Detail | `/profile/disputes/:id` | `lib/features/disputes/presentation/screens/dispute_detail_screen.dart` |

## Endpoints In Use
- `GET /stores/:storeId/disputes/my`
- `POST /stores/:storeId/disputes`
- `GET /stores/:storeId/disputes/:id`
- `POST /stores/:storeId/disputes/:id/withdraw`

## Notes
- The list screen lives under the profile feature, but the data and application layers remain disputes-owned.
- Create-dispute can now be opened directly from billing history via `/profile/disputes/create?billingId=...`.
- Detail pages enrich dispute metadata with the matching billing row when one is available locally.
