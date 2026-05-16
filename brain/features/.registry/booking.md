# Feature Registry: Booking Flow
> Phase 4 — Completed 2026-05-16

---

## Screens

| ID | Route | Screen file | Layout file(s) |
|----|-------|-------------|----------------|
| S-14 | `/book` (shell tab) | `booking_slot_selection_screen.dart` | `booking_slot_selection_mobile_layout.dart` |
| S-15 | `/book/availability` | `booking_availability_screen.dart` | `booking_availability_mobile_layout.dart` |
| S-16 | `/book/systems` | `booking_system_selection_screen.dart` | `booking_system_selection_mobile_layout.dart` |
| S-17 | `/book/summary` | `booking_summary_screen.dart` | `booking_summary_mobile_layout.dart` |
| S-18 | `/book/success` | `booking_success_screen.dart` | `booking_success_mobile_layout.dart` |

---

## Data Layer

### Services
| File | Class | Endpoints |
|------|-------|-----------|
| `booking/data/services/booking_service.dart` | `BookingService` | `GET /stores/:storeId/bookings/availability`, `GET /stores/:storeId/bookings/my`, `GET /stores/:storeId/bookings/:id`, `POST /stores/:storeId/bookings`, `POST .../:id/pay`, `POST .../:id/cancel`, `POST .../:id/check-in` |
| `booking/data/services/systems_service.dart` | `SystemsService` | `GET /stores/:storeId/systems/available` |

### Repositories
| File | Class | Provider |
|------|-------|----------|
| `booking/data/repositories/booking_repository.dart` | `BookingRepository` | `bookingRepositoryProvider` |
| `booking/data/repositories/systems_repository.dart` | `SystemsRepository` | `systemsRepositoryProvider` |

---

## Providers

| Provider | Notifier | State type | Notes |
|----------|----------|------------|-------|
| `systemsNotifierProvider` | `SystemsNotifier` | `AsyncValue<List<SystemModel>>` | Auto-refresh every 30s; watches `activeStoreIdProvider` |
| `systemsFilterProvider` | `StateProvider<String>` | `String` | 'all' \| 'pc' \| 'ps5' \| 'xbox' \| 'vr' \| 'other' |
| `availabilityNotifierProvider` | `AvailabilityNotifier` | `AsyncValue<AvailabilityData>` | Stores selected date + slot |
| `bookingFormNotifierProvider` | `BookingFormNotifier` | `BookingFormState` (sealed) | Initial→Loading→Success/Error |
| `bookingNotifierProvider` | `BookingNotifier` | `BookingState` | Flow accumulation: date, slot, system, typeFilter |
| `bookingSummaryUiProvider` | `BookingSummaryUiNotifier` | `BookingSummaryUiState` | UI-only: campaign, credits, payMethod, collapse state |

### Sealed State: `BookingFormState`
```
BookingFormInitial
BookingFormLoading
BookingFormSuccess(booking: BookingModel)
BookingFormError(message: String)
```

---

## Key Flows

### Booking Flow
```
S-14 Systems Browser → "Check Availability"
  → S-15 Availability Calendar (select date + slot)
  → "Select System"
  → S-16 System Picker (select specific system)
  → S-17 Booking Summary (review, apply campaign/credits, pick payment)
  → BookingFormNotifier.submit()
  → S-18 Booking Confirmation
  → context.go('/sessions')
```

### State Accumulation
- `BookingNotifier.selectedTypeFilter` — set in S-14
- `BookingNotifier.selectedSlotStart/End` — set in S-15 (via `selectSlot()`)
- `BookingNotifier.selectedSystem` — set in S-16 (via `selectSystem()`)
- `BookingSummaryUiNotifier` — campaign, credits, payMethod set in S-17
- `BookingFormNotifier.submit()` reads all of the above — called from S-17 CTA

---

## Models Used
- `SystemModel` — `lib/models/domain_systems.dart`
- `BookingModel` — `lib/models/domain_systems.dart`
- `AvailabilitySlot` — `lib/models/api_responses.dart`
- `AvailabilityData` — `booking/presentation/providers/availability_notifier.dart`

---

## Deferred
- Real campaign/credit data in S-17 (currently hardcoded prototype UI; real data deferred to Phase 6 wallet integration)
- Check-in screen (S-22) — Phase 5
- Booking detail screen (S-20) — Phase 5
