# Overlays Feature Registry — Phase 8

## Global Overlays (Modal Bottom Sheets — not routes)

All four overlays are invoked via standalone functions. They are NOT registered as GoRoutes.

---

## O-38 Notification Center

| Item | Detail |
|---|---|
| Function | `showNotificationCenter(BuildContext context)` |
| File | `lib/features/notifications/presentation/widgets/notification_center_sheet.dart` |
| Widget | `NotificationCenterContent` (ConsumerWidget — also reused by `NotificationsMobileLayout`) |
| State | `notificationsNotifierProvider` — `AsyncValue<NotificationsData>` |
| Behaviour | Full-screen modal sheet; lists all notifications; "Mark all read" header action; tapping a row → O-39 |
| Bell icon wiring | `HomeMobileLayout`, `SessionsMobileLayout`, `WalletMobileLayout` |

## O-39 Notification Detail

| Item | Detail |
|---|---|
| Function | `showNotificationDetail(BuildContext context, WidgetRef ref, NotificationModel notification)` |
| File | `lib/features/notifications/presentation/widgets/notification_detail_sheet.dart` |
| Widget | `NotificationDetailSheet` (StatelessWidget) |
| Auto-read | Marks notification as read on open via `notificationsNotifierProvider.notifier.markRead(id)` |
| Deep link CTA | Action button label derived from `referenceType`; currently pops sheet (deep-link wiring Phase 9) |

## O-40 Store Selector

| Item | Detail |
|---|---|
| Function | `showStoreSelectorSheet(BuildContext context)` |
| File | `lib/shared/widgets/store_selector_sheet.dart` |
| Widget | `StoreSelectorSheet` (ConsumerStatefulWidget — has search TextField) |
| State | `storeSelectorNotifierProvider` — `AsyncValue<List<StoreModel>>` |
| State file | `lib/features/home/presentation/providers/store_selector_notifier.dart` |
| On select | Updates `activeStoreIdProvider` + persists via `TokenStorage.saveActiveStoreId` |
| Wired in | `WalletMobileLayout`, `BookingSlotSelectionMobileLayout` (+ `_NoStoreMessage`) |

## OTP Input Sheet

| Item | Detail |
|---|---|
| Function | `showOtpInputSheet(context, phone, onVerify, onResend)` |
| File | `lib/shared/widgets/otp_input_sheet.dart` |
| Widget | `OtpInputSheet` (StatefulWidget — has 6 TextEditingControllers + Timer) |
| Behaviour | 6-box auto-advance input; auto-submits on last digit; 45s countdown; resend after countdown |
| Error handling | Shows inline error after failed verify; clears fields on each attempt; warns after 3 fails |
| Wired in | `ChangePhoneMobileLayout` (ref.listen on `ChangePhoneOtpSent`) |

---

## State Layer

### NotificationsNotifier

```dart
// lib/features/notifications/presentation/providers/notifications_notifier.dart
class NotificationsData {
  final List<NotificationModel> items;
  final int unreadCount;
  bool get hasUnread => unreadCount > 0;
  // copyWithMarkRead / copyWithAllRead / copyWithPrepended
}

class NotificationsNotifier extends Notifier<AsyncValue<NotificationsData>> { ... }
final notificationsNotifierProvider = NotifierProvider<...>(...);
```

Key methods:
- `refresh()` — re-fetches from API
- `markRead(String id)` — optimistic update + API call
- `markAllRead()` — optimistic update + POST /notifications/read-all
- `prependNew(NotificationModel)` — called by WS events (Phase 5 wire-up pending Phase 9)

### StoreSelectorNotifier

```dart
// lib/features/home/presentation/providers/store_selector_notifier.dart
class StoreSelectorNotifier extends Notifier<AsyncValue<List<StoreModel>>> { ... }
final storeSelectorNotifierProvider = NotifierProvider<...>(...);
```

Key methods:
- `search(String query)` — debounced 300ms, calls StoreRepository.fetchStores
- `refresh()` — re-fetch without search

---

## ChangePhoneNotifier — New Method

`verifyOtp(String otp)` added to `ChangePhoneNotifier`:
- Calls `AuthRepository.verifyPhoneChange(phone, otp)`
- Propagates exceptions to OTP sheet's error display
- Also added: `AuthService.verifyPhoneChange(newPhone, otp)` → `POST /auth/phone/change/verify`
- Also added: `ApiConstants.authPhoneChangeVerify = '/auth/phone/change/verify'`

---

## Phase 12 Updates

- Notification bell unread dot is now rendered in the player headers for Home, Sessions, and Wallet.
- Notification detail actions now close via `go_router` (`context.pop()`) before pushing target routes.
- WS `notification.new` is now wired at the player-shell level through `MainPage`.
