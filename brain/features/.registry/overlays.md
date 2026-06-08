# Overlays Feature Registry — Phase 8
> TARGET SPEC — not yet implemented

## Reality Check
Only presentation overlays exist today:
- `lib/features/notifications/presentation/screens/notification_center_sheet.dart`
- `lib/features/notifications/presentation/widgets/notification_detail_sheet.dart`
- `lib/shared/widgets/store_selector_sheet.dart`
- `lib/shared/widgets/otp_input_sheet.dart`

No data or application logic notifiers (like `NotificationsNotifier`, `StoreSelectorNotifier`, `ChangePhoneNotifier`) are implemented yet.

## Global Overlays (Modal Bottom Sheets — not routes)

All four overlays are invoked via standalone functions. They are NOT registered as GoRoutes.

---

## O-38 Notification Center

| Item | Detail |
|---|---|
| Function | `showNotificationCenter(BuildContext context)` |
| File | `lib/features/notifications/presentation/screens/notification_center_sheet.dart` |
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
| State | `homeNotifierProvider` + `activeStoreNotifierProvider` |
| State file | `lib/features/home/application/home_notifier.dart`, `lib/features/home/application/active_store_notifier.dart` |
| On select | Updates `activeStoreIdProvider` + persists via `TokenStorage.saveActiveStoreId` |
| Wired in | `HomeScreen`, `BookingSlotSelectionMobileLayout` (+ `_NoStoreMessage`) |

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

### Store Selector State

`StoreSelectorSheet` now reuses the Phase 2 home providers instead of owning a separate notifier:
- `homeNotifierProvider` provides the live store list
- `activeStoreNotifierProvider.selectStore(store)` persists and exposes the selected store

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
- Notification deep links now resolve into this overlay instead of the full-screen notifications route.
