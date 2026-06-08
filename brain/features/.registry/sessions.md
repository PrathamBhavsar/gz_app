# Sessions Feature Registry — Phase 5

## Providers

| Provider | File | Type | Purpose |
|---|---|---|---|
| `sessionsHubProvider` | `presentation/providers/session_runtime_providers.dart` | `@riverpod` keepAlive notifier | Runtime session-hub state used by `SessionsScreen`, updated by WS `session.started`, `session.ended`, and `booking.checked_in` |
| `bookingDetailStateNotifierProvider(id)` | `presentation/providers/session_runtime_providers.dart` | `@riverpod` keepAlive family notifier | Runtime booking-detail state used by `BookingDetailScreen`, updated by WS `booking.checked_in` |
| `activeSessionDetailStateNotifierProvider(id)` | `presentation/providers/session_runtime_providers.dart` | `@riverpod` keepAlive family notifier | Runtime active-session detail state used by `ActiveSessionDetailScreen`, updated by WS `session.extended` |

## Services

| Service | File | Methods |
|---|---|---|
| `SessionsService` | `data/services/sessions_service.dart` | `getSessions(storeId, {status, page, limit})`, `getSession(storeId, sessionId)` |
| `BillingService` | `data/services/billing_service.dart` | `getMyBilling(storeId, {page, limit})` |

## Repositories

| Repository | File | Methods |
|---|---|---|
| `SessionsRepository` | `data/repositories/sessions_repository.dart` | `fetchSessions(storeId, {status, page, limit})`, `fetchSession(storeId, sessionId)` |
| `BillingRepository` | `data/repositories/billing_repository.dart` | `fetchMyBilling(storeId, {page, limit})` |

## Screens

| Screen | Route | File |
|---|---|---|
| Sessions Hub | `/sessions` | `screens/sessions_screen.dart` |
| Booking Detail (S-20) | `/sessions/booking/:id` | `screens/booking_detail_screen.dart` |
| Check In (S-22) | `/sessions/booking/:id/check-in` | `screens/check_in_screen.dart` |
| Active Session Detail (S-23) | `/sessions/active/:id` | `screens/active_session_detail_screen.dart` |
| Session History Detail (S-24) | `/sessions/history/:id` | `screens/session_history_detail_screen.dart` |
| Billing History (S-25) | `/sessions/billing` | `screens/billing_history_screen.dart` |
| Legacy Active Session | `/sessions/active` | `screens/active_session_screen.dart` |

## Widgets

| Widget | File | Notes |
|---|---|---|
| `SessionsMobileLayout` | `widgets/sessions_mobile_layout.dart` | Wired to `activityHubProvider` real data |
| `BookingDetailMobileLayout` | `widgets/booking_detail_mobile_layout.dart` | Status-contextual CTA bottom bar |
| `PaymentSheet` | `widgets/payment_sheet.dart` | Function `showPaymentSheet(context, ref, bookingId)` |
| `CheckInMobileLayout` | `widgets/check_in_mobile_layout.dart` | QR placeholder + tap check-in |
| `ActiveSessionDetailMobileLayout` | `widgets/active_session_detail_mobile_layout.dart` | Wired to `activeSessionNotifierProvider` with Timer countdown |
| `SessionHistoryDetailMobileLayout` | `widgets/session_history_detail_mobile_layout.dart` | Wired to `sessionDetailNotifierProvider` |
| `BillingHistoryMobileLayout` | `widgets/billing_history_mobile_layout.dart` | Grouped by month |

## Phase 12 Runtime Note

- This workspace revision does not contain the richer Phase 5 notifier/data layer described in earlier planning (`activityHubProvider`, `activeSessionNotifierProvider`, `bookingDetailNotifierProvider`).
- Phase 12 therefore lands on `session_runtime_providers.dart` as the real WS event-dispatch target in the current codebase.

## Network

| Service | File | Notes |
|---|---|---|
| `PlayerWsService` | `lib/core/network/player_ws_service.dart` | WS `/ws/users/:userId/notify?token=`, exponential backoff |
| `playerWsServiceProvider` | same file | Provider with `ref.onDispose` |

## Models Added

| Model | File | Notes |
|---|---|---|
| `BillingRow` | `lib/models/api_responses.dart` | Player billing row (id, storeId, sessionId, storeName, systemName, date, durationMinutes, amount, method, status) |
| `PaginatedBillingResponse` | `lib/models/api_responses.dart` | Paginated wrapper for BillingRow |
| `ActivityHubData` | `activity_hub_notifier.dart` | upcomingBookings, activeBooking, activeSession, history |

## API Constants Added

```dart
static const String sessionsMy    = '/stores/{storeId}/sessions/my';
static const String bookingsMyList = '/stores/{storeId}/bookings/my';
static const String billingMy     = '/stores/{storeId}/billing/my';
static const String bookingPayment = '/stores/{storeId}/bookings/{id}/payment';
static const String wsPlayerNotify = '/ws/users/{userId}/notify';
```
