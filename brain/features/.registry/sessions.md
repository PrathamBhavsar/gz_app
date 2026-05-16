# Sessions Feature Registry — Phase 5

## Providers

| Provider | File | Type | Purpose |
|---|---|---|---|
| `activityHubProvider` | `presentation/providers/activity_hub_notifier.dart` | `NotifierProvider<ActivityHubNotifier, ActivityHubState>` | Aggregated data (bookings + sessions) + UI tab/expand state |
| `bookingDetailNotifierProvider(id)` | `presentation/providers/booking_detail_notifier.dart` | `NotifierProviderFamily<BookingDetailNotifier, AsyncValue<BookingModel>, String>` | Single booking detail by ID |
| `paymentNotifierProvider` | `presentation/providers/payment_notifier.dart` | `NotifierProvider<PaymentNotifier, PaymentState>` | Sealed payment state (Initial/Loading/Success/Error) |
| `activeSessionNotifierProvider(id)` | `presentation/providers/active_session_notifier.dart` | `NotifierProviderFamily<ActiveSessionNotifier, AsyncValue<SessionModel>, String>` | Live session with 30s polling |
| `sessionDetailNotifierProvider(id)` | `presentation/providers/session_detail_notifier.dart` | `NotifierProviderFamily<SessionDetailNotifier, AsyncValue<SessionModel>, String>` | Session history detail (no polling) |
| `billingNotifierProvider` | `presentation/providers/billing_notifier.dart` | `NotifierProvider<BillingNotifier, AsyncValue<List<BillingRow>>>` | Player billing history |

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
