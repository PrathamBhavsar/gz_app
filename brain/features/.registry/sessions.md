# Sessions Feature Registry
> TARGET SPEC — not yet implemented

## Reality Check
Existing files:
- `lib/features/sessions/presentation/screens/*.dart`
- `lib/features/sessions/presentation/providers/session_runtime_providers.dart`

Missing today:
- `lib/features/sessions/data/`
- `lib/features/sessions/application/`

`session_runtime_providers.dart` is not the full repository/notifier stack described in earlier planning. Treat it as an isolated current-state helper, not proof that Phase 4 is complete.

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/sessions/data/repositories/sessions_repository.dart` | Active/history session fetches | No |
| `lib/features/sessions/data/repositories/bookings_repository.dart` | Player booking detail, cancel, check-in, payment | No |
| `lib/features/sessions/data/repositories/billing_repository.dart` | Billing history and ledger rows | No |
| `lib/features/sessions/application/activity_hub_notifier.dart` | `/sessions` aggregate state | No |
| `lib/features/sessions/application/booking_detail_notifier.dart` | Booking detail by id | No |
| `lib/features/sessions/application/active_session_notifier.dart` | Live active session poller | No |
| `lib/features/sessions/application/session_detail_notifier.dart` | Session detail/history by id | No |
| `lib/features/sessions/application/billing_notifier.dart` | Billing history | No |
| `lib/features/sessions/application/payment_notifier.dart` | Payment action flow | No |

## Planned Endpoints
- `GET /stores/:storeId/sessions/my`
- `GET /stores/:storeId/bookings/my`
- `GET /stores/:storeId/bookings/:id`
- `POST /stores/:storeId/bookings/:id/cancel`
- `POST /stores/:storeId/bookings/:id/check-in`
- `POST /stores/:storeId/bookings/:id/pay`
- `GET /stores/:storeId/sessions/:id`
- `GET /stores/:storeId/billing/my`
- `GET /stores/:storeId/sessions/:id/logs`

## Notes
- Phase 4 should also wire `PlayerWsService` for live session and notification events.
- Keep the target notifier layer separate from any presentation-only runtime helpers that already exist.
