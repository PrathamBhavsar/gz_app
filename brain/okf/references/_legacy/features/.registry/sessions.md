# Sessions Feature Registry
> IMPLEMENTED — Phase 4 player Sessions/Billing wiring is live.

## Reality Check
Existing files:
- `lib/features/sessions/data/repositories/*.dart`
- `lib/features/sessions/application/*.dart`
- `lib/features/sessions/presentation/screens/*.dart`
- `lib/features/sessions/presentation/providers/session_runtime_providers.dart`

`session_runtime_providers.dart` is now a compatibility export surface over the real application-layer providers.

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/sessions/data/repositories/sessions_repository.dart` | Active/history session fetches | Yes |
| `lib/features/sessions/data/repositories/bookings_repository.dart` | Player booking detail, cancel, check-in, payment | Yes |
| `lib/features/sessions/data/repositories/billing_repository.dart` | Billing history and ledger rows | Yes |
| `lib/features/sessions/application/activity_hub_notifier.dart` | `/sessions` aggregate state | Yes |
| `lib/features/sessions/application/booking_detail_notifier.dart` | Booking detail by id | Yes |
| `lib/features/sessions/application/active_session_notifier.dart` | Live active session poller | Yes |
| `lib/features/sessions/application/session_detail_notifier.dart` | Session detail/history by id | Yes |
| `lib/features/sessions/application/billing_notifier.dart` | Billing history | Yes |
| `lib/features/sessions/application/payment_notifier.dart` | Payment action flow | Yes |

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
- `MainPage` now dispatches `PlayerWsService` session events into the Sessions providers.
- WP2 closes the remaining player logs parity gap: `GET /stores/:storeId/sessions/:id/logs` is now owner-scoped on the backend, the app parses the backend's camelCase log payload, and `session_logs_screen.dart` now renders loading/error/empty/data states without adding a new widget.
