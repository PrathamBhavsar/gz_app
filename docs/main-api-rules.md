# Gaming Zone — Mobile App: Complete API Calling Guide
**Version**: 1.0 | **For**: Frontend AI Agent | **API Version**: 2.0.0

> Feed this doc to the frontend AI **before** building any screen. Every screen has phases, exact API calls, request shapes, validation rules, and error handlers. No guessing.

---

## 0. Global Conventions

### Base URL
```
BASE_URL = https://api.gamingzone.app   (env: EXPO_PUBLIC_API_URL)
```

### Auth Header (every authenticated call)
```
Authorization: Bearer {accessToken}
```

### Token Storage
| Token | Storage | Notes |
|-------|---------|-------|
| `accessToken` | In-memory only (Zustand store) | 15 min TTL |
| `refreshToken` | `expo-secure-store` (encrypted) | 7 day TTL |
| `userId` | `expo-secure-store` | For WS connection |
| `activeStoreId` | `AsyncStorage` | Last selected store |
| `hasSeenOnboarding` | `AsyncStorage` | Boolean flag |

### Silent Token Refresh (Interceptor)
On any `401` response:
1. Call `POST /auth/refresh { refreshToken }`
2. If success → swap `accessToken` in memory → retry original request once
3. If refresh fails → clear all tokens → navigate to Auth Landing

```typescript
// Axios/fetch interceptor pseudocode
if (response.status === 401 && !isRetry) {
  const { accessToken } = await refreshTokens();
  retryWithNewToken(accessToken);
} else if (response.status === 401 && isRetry) {
  logout(); // clear all, navigate to auth
}
```

### Error Response Shape
```typescript
{ error: string, message: string, field?: string }
```

### Idempotency Key (payments only)
```typescript
import { randomUUID } from 'expo-crypto';
const idempotencyKey = randomUUID(); // generate once per payment attempt, persist through retries
```

### WebSocket Connection
```
WS_URL = wss://api.gamingzone.app/ws/users/{userId}/notify?token={accessToken}
```
Connect on app foreground. Reconnect: exponential backoff (1s → 2s → 4s → max 30s).

---

## 1. API Module Reference

All 43 player-accessible endpoints grouped by module.

### AUTH MODULE — `/auth`
| # | Method | Path | Auth | Body | Returns |
|---|--------|------|------|------|---------|
| 1 | POST | `/auth/register` | Public | `{ name, phone?, email?, password? }` | `{ user }` 201 |
| 2 | POST | `/auth/login/otp` | Public | `{ phone }` | `{ message }` 200 |
| 3 | POST | `/auth/login/email` | Public | `{ email, password }` | `{ accessToken, refreshToken, user }` |
| 4 | POST | `/auth/login/oauth/:provider` | Public | `{ code, state }` | `{ accessToken, refreshToken, user }` |
| 5 | POST | `/auth/verify/otp` | Public | `{ phone, code }` | `{ accessToken, refreshToken, user }` |
| 6 | POST | `/auth/verify/email` | Public | `{ token }` | `{ message }` |
| 7 | POST | `/auth/refresh` | Refresh token in body | `{ refreshToken }` | `{ accessToken, refreshToken? }` |
| 8 | POST | `/auth/logout` | Bearer | — | `{ message }` |
| 9 | POST | `/auth/password/reset/request` | Public | `{ email }` | `{ message }` (always 200) |
| 10 | POST | `/auth/password/reset/confirm` | Public | `{ token, newPassword }` | `{ message }` |
| 11 | POST | `/auth/phone/change` | Bearer | `{ newPhone }` | `{ message }` |
| 12 | GET | `/auth/me` | Bearer | — | `{ id, name, email, phone, isEmailVerified, isPhoneVerified, createdAt }` |
| 13 | PATCH | `/auth/me` | Bearer | `{ name?, email? }` | `{ user }` |
| 14 | PATCH | `/auth/me/device` | Bearer | `{ fcmToken, platform }` | `{ message }` |

### STORES MODULE — `/stores`
| # | Method | Path | Auth | Query Params | Returns |
|---|--------|------|------|-------------|---------|
| 15 | GET | `/stores` | Public | `search?, platform?, isOpen?, page?, limit?` | `{ stores[], total, page }` |
| 16 | GET | `/stores/:slug` | Public | — | `{ id, name, slug, address, hours, contact, systemTypes[], isActive }` |

### SYSTEMS MODULE — `/stores/:storeId/systems`
| # | Method | Path | Auth | Query Params | Returns |
|---|--------|------|------|-------------|---------|
| 17 | GET | `/stores/:storeId/systems/available` | Bearer | `systemTypeId?, startTime?, endTime?` | `{ systems[] }` |

### BOOKINGS MODULE — `/stores/:storeId/bookings`
| # | Method | Path | Auth | Body/Query | Returns |
|---|--------|------|------|-----------|---------|
| 18 | GET | `/stores/:storeId/bookings/availability` | Bearer | `date, systemTypeId?, duration?` | `{ slots[] }` |
| 19 | GET | `/stores/:storeId/bookings/my` | Bearer | `status? (upcoming\|past), page?, limit?` | `{ bookings[], total }` |
| 20 | GET | `/stores/:storeId/bookings/:id` | Bearer | — | `{ booking }` |
| 21 | POST | `/stores/:storeId/bookings` | Bearer | `{ systemId, startTime, endTime, systemTypeId, campaignId?, creditsToRedeem?, paymentMethod }` | `{ booking }` 201 |
| 22 | POST | `/stores/:storeId/bookings/:id/pay` | Bearer | `{ paymentMethod, idempotencyKey }` | `{ payment }` |
| 23 | POST | `/stores/:storeId/bookings/:id/cancel` | Bearer | — | `{ booking }` |
| 24 | POST | `/stores/:storeId/bookings/:id/check-in` | Bearer | — | `{ booking, session? }` |

### SESSIONS MODULE — `/stores/:storeId/sessions`
| # | Method | Path | Auth | Query Params | Returns |
|---|--------|------|------|-------------|---------|
| 25 | GET | `/stores/:storeId/sessions/my` | Bearer | `status? (in_progress\|completed), page?, limit?` | `{ sessions[] }` |
| 26 | GET | `/stores/:storeId/sessions/:id` | Bearer | — | `{ id, systemId, startTime, endTime?, status, billedAmount?, sessionLogs[] }` |

### BILLING MODULE — `/stores/:storeId/billing`
| # | Method | Path | Auth | Query Params | Returns |
|---|--------|------|------|-------------|---------|
| 27 | GET | `/stores/:storeId/billing/my` | Bearer | `page?, limit?, month?` | `{ records[], total }` |

### CREDITS MODULE — `/stores/:storeId/credits`
| # | Method | Path | Auth | Body/Query | Returns |
|---|--------|------|------|-----------|---------|
| 28 | GET | `/stores/:storeId/credits/balance` | Bearer | — | `{ balance, storeId, storeName }` |
| 29 | GET | `/stores/:storeId/credits/transactions` | Bearer | `page?, limit?` | `{ transactions[], total }` |
| 30 | POST | `/stores/:storeId/credits/redeem` | Bearer | `{ amount }` | `{ newBalance, transaction }` |

### CAMPAIGNS MODULE — `/stores/:storeId/campaigns`
| # | Method | Path | Auth | Returns |
|---|--------|------|------|---------|
| 31 | GET | `/stores/:storeId/campaigns/active` | Bearer | `{ campaigns[] }` |
| 32 | POST | `/stores/:storeId/campaigns/:id/redeem` | Bearer | `{ redemption, creditsAwarded? }` |

### NOTIFICATIONS MODULE — `/notifications`
| # | Method | Path | Auth | Body/Query | Returns |
|---|--------|------|------|-----------|---------|
| 33 | GET | `/notifications` | Bearer | `page?, limit?` | `{ notifications[], unreadCount }` |
| 34 | PATCH | `/notifications/:id/read` | Bearer | — | `{ notification }` |
| 35 | POST | `/notifications/read-all` | Bearer | — | `{ message }` |
| 36 | GET | `/notifications/preferences` | Bearer | — | `{ push, email, sms, inApp, bookingConfirm, bookingReminder, sessionEndingSoon, creditUpdates, newCampaigns, disputeUpdates }` |
| 37 | PATCH | `/notifications/preferences` | Bearer | `{ push?, email?, sms?, bookingConfirm?, ... }` | `{ preferences }` |

### DISPUTES MODULE — `/stores/:storeId/disputes`
| # | Method | Path | Auth | Body | Returns |
|---|--------|------|------|------|---------|
| 38 | GET | `/stores/:storeId/disputes/my` | Bearer | — | `{ disputes[] }` |
| 39 | GET | `/stores/:storeId/disputes/:id` | Bearer | — | `{ dispute }` |
| 40 | POST | `/stores/:storeId/disputes` | Bearer | `{ sessionId, reason, disputedAmount? }` | `{ dispute }` 201 |
| 41 | POST | `/stores/:storeId/disputes/:id/withdraw` | Bearer | — | `{ dispute }` |

### WEBSOCKET
| # | Path | Auth | Events |
|---|------|------|--------|
| 42 | `WS /ws/users/:userId/notify?token=` | JWT query param | `notification.new`, `session.started`, `session.ended`, `session.extended`, `booking.checked_in` |

---

## 2. Screen-by-Screen API Guide

---

### SCREEN 01 — Splash Screen

**Goal**: Silent auth check before routing user.

#### Phase 1 — Check stored tokens
```typescript
const accessToken = getFromMemory('accessToken');
const refreshToken = await SecureStore.getItemAsync('refreshToken');

if (!accessToken && !refreshToken) {
  // No session
  const seen = await AsyncStorage.getItem('hasSeenOnboarding');
  navigate(seen ? 'AuthLanding' : 'Onboarding');
  return;
}
```

#### Phase 2 — Validate access token
```
GET /auth/me
Headers: Authorization: Bearer {accessToken}
```
- ✅ 200 → store `currentUser` in memory → navigate `Home`
- ❌ 401 → go to Phase 3

#### Phase 3 — Try refresh
```
POST /auth/refresh
Body: { refreshToken }
```
- ✅ 200 → store new `accessToken` in memory → retry `GET /auth/me` → navigate `Home`
- ❌ 401/403 → clear all tokens → navigate `AuthLanding`

**Frontend validations**: None (no user input)

---

### SCREEN 02 — Onboarding Screen

**Goal**: Feature showcase. No API calls.

#### Phase 1 — Check first-launch flag
```typescript
const seen = await AsyncStorage.getItem('hasSeenOnboarding');
if (seen) navigate('AuthLanding'); // skip if already seen
```

#### Phase 2 — On CTA / Skip
```typescript
await AsyncStorage.setItem('hasSeenOnboarding', 'true');
navigate('AuthLanding');
```

**Frontend validations**: None

---

### SCREEN 03 — Auth Landing Screen

**Goal**: Route user to correct auth method.

#### Phase 1 — Phone OTP button tap
Show bottom sheet with phone input. On submit:

**Validate before API call:**
- Phone non-empty
- E.164 format: `/^\+[1-9]\d{6,14}$/`

```
POST /auth/login/otp
Body: { phone: "+919876543210" }
```
- ✅ 200 → navigate `OTPVerification` with `{ phone }`
- ❌ 429 `OTP_RATE_LIMITED` → show "Too many requests. Try again in X minutes."
- ❌ 400 → show inline error

#### Phase 2 — Other methods
- Email → navigate `EmailLogin`
- Google/Apple → launch OAuth flow → `POST /auth/login/oauth/:provider { code, state }`

**Frontend validations**:
| Field | Rule |
|-------|------|
| Phone | Required, E.164 format |

---

### SCREEN 04 — Register Screen

**Goal**: Create new account.

#### Phase 1 — Real-time validation
Validate as user types (on blur):
| Field | Rule |
|-------|------|
| Full Name | Required, 2–100 chars, no special chars |
| Phone | Optional, E.164 if provided |
| Email | Optional, valid email format if provided |
| Password | Optional. If email provided → required, min 8 chars. Show strength meter |
| At least one | Phone or email must be provided |

#### Phase 2 — Submit
```
POST /auth/register
Body: { name, phone?, email?, password? }
```
- ✅ 201 + phone provided → navigate `OTPVerification` with `{ phone }`
- ✅ 201 + email only → navigate `EmailVerificationPending` with `{ email }`
- ❌ 409 `PHONE_TAKEN` → "Phone already registered. [Try logging in]"
- ❌ 409 `EMAIL_TAKEN` → "Email already registered. [Try logging in]"
- ❌ 422 validation → map `field` from response to inline errors

**Frontend validations**:
```typescript
const isValidE164 = (phone: string) => /^\+[1-9]\d{6,14}$/.test(phone);
const isValidEmail = (email: string) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
const isStrongPassword = (pw: string) => pw.length >= 8;
```

---

### SCREEN 05 — OTP Verification Screen

**Goal**: Verify SMS OTP. Critical auth step.

#### Phase 1 — Display
- Mask phone: `+91 ••••• ${phone.slice(-5)}`
- Start 45s countdown timer
- 6-box input, auto-focus first box

#### Phase 2 — Auto-submit on 6th digit
```
POST /auth/verify/otp
Body: { phone: "+91...", code: "123456" }
```
- ✅ 200 → store tokens → navigate `Home`
- ❌ `OTP_INVALID` → shake animation, increment local attempt counter
    - After 3 fails → show "X attempts remaining" warning
- ❌ `OTP_MAX_ATTEMPTS` → disable input, show "Too many attempts. Request new OTP." + Resend
- ❌ `OTP_EXPIRED` → show "OTP expired." + Resend

#### Phase 3 — Resend (after countdown expires)
```
POST /auth/login/otp
Body: { phone }
```
- ✅ → restart countdown, clear input boxes, show "OTP resent"
- ❌ 429 → show "Too many OTP requests. Wait X min."

**Tokens on success**:
```typescript
// Store immediately on success
accessToken → in-memory Zustand
refreshToken → await SecureStore.setItemAsync('refreshToken', token)
userId → await SecureStore.setItemAsync('userId', user.id)
```

---

### SCREEN 06 — Email Login Screen

**Goal**: Email + password login.

#### Phase 1 — Validate before submit
| Field | Rule |
|-------|------|
| Email | Required, valid format |
| Password | Required, non-empty |

#### Phase 2 — Submit
```
POST /auth/login/email
Body: { email, password }
```
- ✅ 200 → store tokens → navigate `Home`
- ❌ `INVALID_CREDENTIALS` → "Incorrect email or password" (don't specify which)
- ❌ `EMAIL_NOT_VERIFIED` → show banner "Verify your email. [Resend verification]"
    - Resend tap: there's no direct resend endpoint — show "Check your inbox or register again"
- ❌ 429 → "Too many login attempts. Try again later."

---

### SCREEN 07 — OAuth Handler Screen

**Goal**: Handle OAuth redirect deep link. Loading-only screen.

#### Phase 1 — Extract params from deep link
```typescript
// On mount, read URL params from deep link
const { code, state, provider } = parseDeepLink(url);
```

#### Phase 2 — Exchange code
```
POST /auth/login/oauth/:provider
Body: { code, state }
```
- ✅ 200 → store tokens → navigate `Home`
- ❌ `OAUTH_FAILED` → navigate back to `AuthLanding` + error toast "Sign-in failed. Try again."
- ❌ Network error → same fallback

**Note**: `provider` = `google` or `apple`. Read from the route/state from which OAuth was initiated.

---

### SCREEN 08 — Forgot Password Screen

**Goal**: Initiate password reset.

#### Phase 1 — Validate
| Field | Rule |
|-------|------|
| Email | Required, valid format |

#### Phase 2 — Submit
```
POST /auth/password/reset/request
Body: { email }
```
- ✅ Always show: "If that email is registered, a reset link has been sent." (even on 404)
- ❌ Never show different messages — security policy

---

### SCREEN 09 — Reset Password Screen

**Goal**: Set new password via deep link token.

#### Phase 1 — Extract token from deep link
```typescript
// deep link: gzapp://reset-password?token=abc123
const { token } = parseDeepLink(url);
if (!token) navigate('AuthLanding');
```

#### Phase 2 — Validate
| Field | Rule |
|-------|------|
| New Password | Required, min 8 chars, show strength indicator |
| Confirm Password | Must match new password |

#### Phase 3 — Submit
```
POST /auth/password/reset/confirm
Body: { token, newPassword }
```
- ✅ 200 → show "Password updated!" toast → navigate `AuthLanding`
- ❌ `TOKEN_EXPIRED` → "This reset link has expired. [Request new one]" → link to `ForgotPassword`
- ❌ `NOT_FOUND` → same expired message (don't differentiate)

---

### SCREEN 10 — Email Verification Pending Screen

**Goal**: Prompt user to verify email.

#### Phase 1 — Display
Show email address. Start 60s timer for resend button.

#### Phase 2 — "I've verified" button
```
GET /auth/me
Headers: Authorization: Bearer {accessToken}
```
- ✅ `isEmailVerified: true` → navigate `Home`
- ✅ `isEmailVerified: false` → show "Email not verified yet. Check inbox."

#### Phase 3 — Resend verification
No direct API endpoint for resend. Direct user: "Didn't receive? Check spam or re-register."

---

### SCREEN 11 — Home Feed

**Goal**: Show stores, quick actions, user greeting.

#### Phase 1 — Mount
Fetch user (if not in memory):
```
GET /auth/me
```

Fetch stores list:
```
GET /stores?isActive=true&page=1&limit=20
```
- ✅ Render store cards
- ❌ Network error → show cached stores if available, else empty state with retry

#### Phase 2 — Pull-to-refresh
Re-fetch `GET /stores` (same params). Update list.

#### Phase 3 — Auto-refresh
Poll `GET /stores` every 60s while screen focused.

**Frontend validations**: None (read-only screen)

**State to derive**:
- `recentStore` = `activeStoreId` from AsyncStorage → show "Resume" card
- Greeting: get `currentUser.name` from memory

---

### SCREEN 12 — Store Search Screen

**Goal**: Search + filter stores.

#### Phase 1 — Mount
Auto-focus search input.

#### Phase 2 — Search (debounced 300ms, min 2 chars)
```
GET /stores?search={query}&platform={platform?}&isOpen={isOpen?}&page=1&limit=20
```
| Query Param | Type | Notes |
|------------|------|-------|
| `search` | string | Min 2 chars |
| `platform` | `pc\|ps5\|vr\|xbox` | Optional filter chip |
| `isOpen` | boolean | "Open Now" filter |

- ✅ Update results list
- Empty results → "No stores found for '{query}'"

**Frontend validations**:
- Min 2 chars before calling (show "Type at least 2 characters" otherwise)
- Debounce 300ms

---

### SCREEN 13 — Store Detail Screen

**Goal**: Show store info, systems, active campaigns. Set store context.

#### Phase 1 — Mount (parallel calls)
```
GET /stores/:slug
GET /stores/:storeId/campaigns/active
```
- Need `storeId` from the first call for the second call
- Can sequence: first get store, then get campaigns; or pass `storeId` from previous navigation params

#### Phase 2 — "Book Now" tap
```typescript
await AsyncStorage.setItem('activeStoreId', store.id);
setActiveStore(store.id); // Zustand
navigate('SystemsBrowser');
```

**Frontend validations**: None (read-only)

---

### SCREEN 14 — Systems Browser

**Goal**: Show available systems at active store.

#### Phase 1 — Mount
```
GET /stores/:storeId/systems/available
```
Response: `{ systems: [{ id, name, platform, systemTypeId, status, pricePerHour }] }`

#### Phase 2 — Tab filter (All / PC / PS5 / Xbox / VR / Other)
Filter client-side from loaded data (no new API call needed unless data is stale).

#### Phase 3 — Auto-refresh every 30s
Re-fetch same endpoint. System status changes frequently.

#### Phase 4 — Pull-to-refresh
Re-fetch same endpoint.

**Frontend validations**: None (read-only). Show "No systems available" empty state if filtered list is empty.

---

### SCREEN 15 — Availability Calendar

**Goal**: Pick date + time slot.

#### Phase 1 — Mount
Determine selectable dates: today + next 7 days (capped by `booking_window_minutes` from store config — but no API to fetch this directly; use 7-day default).

#### Phase 2 — Date selected → Fetch slots
```
GET /stores/:storeId/bookings/availability?date={ISO_date}&systemTypeId={id?}&duration={minutes?}
```
| Param | Type | Notes |
|-------|------|-------|
| `date` | ISO date string `2026-04-18` | Required |
| `systemTypeId` | UUID | Optional, from filter carry-over |
| `duration` | minutes, e.g. `60` | Optional |

Response: `{ slots: [{ startTime, endTime, status: 'available'|'booked'|'walk_in_only', systemCount }] }`

- ✅ Render slot grid with color coding
- ❌ Error → "Couldn't load slots. Pull to refresh."

#### Phase 3 — Slot selected
Highlight selected slot. Enable "Select System" CTA.
Navigate `SystemPicker` with `{ storeId, systemTypeId, startTime, endTime }`.

**Frontend validations**:
- Cannot select past dates
- Cannot select dates with 0 available systems

---

### SCREEN 16 — System Picker

**Goal**: Choose specific system for selected slot.

#### Phase 1 — Mount
```
GET /stores/:storeId/systems/available?startTime={ISO}&endTime={ISO}&systemTypeId={id?}
```
Filters to systems free during the chosen window.

- ✅ Render system cards with specs
- Empty → "No systems available for this slot. [Pick different time]"

#### Phase 2 — System selected
Navigate `BookingSummary` with `{ storeId, systemId, systemTypeId, startTime, endTime }`.

---

### SCREEN 17 — Booking Summary Screen

**Goal**: Review + confirm booking. Apply credits/campaigns.

#### Phase 1 — Mount (parallel calls)
```
GET /stores/:storeId/campaigns/active
GET /stores/:storeId/credits/balance
```

#### Phase 2 — Display price breakdown
Derive in client:
```typescript
const durationHours = (endTime - startTime) / 3600000;
const subtotal = system.pricePerHour * durationHours;
// Show as estimate — server re-calculates on submit
```
**Clearly label**: "Price calculated by server at confirmation"

#### Phase 3 — Campaign selection
Show list from Phase 1. User selects one → store `selectedCampaignId`.

#### Phase 4 — Credits input
Validate:
| Rule | Check |
|------|-------|
| Max credits | `creditsToRedeem <= balance` |
| Min credits | `creditsToRedeem >= 0` |
| Integer only | No decimals |

#### Phase 5 — Confirm booking
Generate idempotency is NOT needed here (bookings are not idempotent — use booking mutex server-side).

```
POST /stores/:storeId/bookings
Body: {
  systemId,
  startTime,     // ISO string e.g. "2026-04-18T10:00:00Z"
  endTime,       // ISO string e.g. "2026-04-18T11:00:00Z"
  systemTypeId,
  campaignId?,   // null if none selected
  creditsToRedeem?,  // 0 if none
  paymentMethod  // 'cash' | 'card' | 'upi' | 'wallet' | 'credits'
}
```
- ✅ 201 → navigate `BookingConfirmation` with `{ booking }`
- ❌ `SLOT_UNAVAILABLE` → "This slot was just taken. [Choose another]" → back to Calendar
- ❌ `INSUFFICIENT_CREDITS` → "Not enough credits. Adjust credit amount."
- ❌ `CAMPAIGN_EXPIRED` → "Campaign no longer active." → re-fetch campaigns, clear selection
- ❌ `OUTSIDE_BOOKING_WINDOW` → "Bookings not open for this date yet."
- ❌ Network timeout → allow retry (same body, same request — mutex is server-side)

**Frontend validations**:
```typescript
paymentMethod: one of ['cash', 'card', 'upi', 'wallet', 'credits']
startTime < endTime
creditsToRedeem >= 0 && creditsToRedeem <= balance
```

---

### SCREEN 18 — Booking Confirmation Screen

**Goal**: Show success. No API calls.

Data comes from navigation params `{ booking }` from Screen 17.

Derive locally:
```typescript
const checkInOpensAt = new Date(booking.startTime);
checkInOpensAt.setMinutes(checkInOpensAt.getMinutes() - CHECK_IN_EARLY_MINUTES); // use store config or default 15
```

CTAs:
- "View Booking" → navigate `BookingDetail` with `{ bookingId: booking.id, storeId }`
- "Back to Home" → navigate `Home`

---

### SCREEN 19 — Activity Hub (3 sub-tabs)

**Goal**: All user activity in one place.

#### Tab A: Upcoming — Phase 1 — Mount
```
GET /stores/:storeId/bookings/my?status=upcoming&page=1&limit=20
```
> **Note**: No global cross-store endpoint. Must iterate across stores user has bookings in. Check `activeStoreId` first; show store switcher for others.

- Statuses to show: `pending`, `confirmed`, `checked_in`
- Sort by `startTime` ascending
- Empty → "No upcoming bookings. [Book a slot →]"

#### Tab B: Active Session — Phase 1 — Mount
```
GET /stores/:storeId/sessions/my?status=in_progress
```
- If session exists → show live timer card
- Connect WebSocket for real-time updates (see WS section)
- Empty → "No active session right now"

#### Tab C: History — Phase 1 — Mount (parallel)
```
GET /stores/:storeId/bookings/my?status=past&page=1&limit=20
GET /stores/:storeId/sessions/my?status=completed&page=1&limit=20
```
- Group by month
- Merge and sort descending by date

#### Pull-to-refresh on all tabs
Re-fetch relevant endpoint(s).

---

### SCREEN 20 — Booking Detail Screen

**Goal**: Full booking info + contextual actions.

#### Phase 1 — Mount
```
GET /stores/:storeId/bookings/:id
```
Response includes: `{ id, status, storeId, systemId, systemName, startTime, endTime, paymentMethod, paymentStatus, totalAmount, discountsApplied[] }`

#### Phase 2 — Action buttons (derive from status + current time)
```typescript
const now = new Date();
const checkInWindowStart = new Date(booking.startTime);
checkInWindowStart.setMinutes(checkInWindowStart.getMinutes() - CHECK_IN_EARLY_MINUTES);

const showPayNow = booking.status === 'pending' && booking.paymentStatus !== 'completed';
const showCheckIn = booking.status === 'confirmed' && now >= checkInWindowStart && now <= new Date(booking.startTime);
const showCancel = ['pending', 'confirmed'].includes(booking.status);
const showDispute = booking.status === 'no_show';
```

Action triggers:
- "Pay Now" → navigate `PaymentScreen` with `{ bookingId, storeId, amountDue }`
- "Check In" → navigate `CheckInScreen` with `{ bookingId, storeId }`
- "Cancel" → inline confirm dialog → `POST /stores/:storeId/bookings/:id/cancel`
    - ✅ refresh booking detail
    - ❌ `CANCELLATION_NOT_ALLOWED` → "Cannot cancel at this time."
- "File Dispute" → navigate `CreateDispute` with `{ sessionId }`

---

### SCREEN 21 — Payment Screen

**Goal**: Pay for a pending booking. Critical — idempotency required.

#### Phase 1 — Display
Show booking summary + amount from nav params.

#### Phase 2 — Payment method selection
Available: `cash`, `upi`, `card`, `credits`
- If `credits` selected → fetch balance first:
  ```
  GET /stores/:storeId/credits/balance
  ```
  Show "Credits available: X"

#### Phase 3 — Submit payment
Generate idempotency key once (on mount, before user taps pay):
```typescript
const idempotencyKey = randomUUID(); // from expo-crypto
```

```
POST /stores/:storeId/bookings/:id/pay
Body: { paymentMethod, idempotencyKey }
```
- ✅ 200/201 → show "Payment confirmed!" → navigate back to `BookingDetail`
- ✅ 200 with same `idempotencyKey` (duplicate) → same success response (already paid)
- ❌ `INSUFFICIENT_CREDITS` → "Not enough credits."
- ❌ `PAYMENT_WINDOW_EXPIRED` → "Payment window closed. Booking may be cancelled."
- ❌ Network error → allow retry using **same** `idempotencyKey` (DO NOT regenerate)

**Frontend validations**:
| Rule | Check |
|------|-------|
| Payment method | Must be selected before submit |
| Credits | If credits selected, check balance locally |
| Idempotency key | Never regenerate on retry |

---

### SCREEN 22 — Check-In Screen

**Goal**: Check in via QR or tap.

#### Phase 1 — Display
Generate QR code from `bookingId` (use `react-native-qrcode-svg`).
Show countdown: time until check-in window closes (`booking.startTime` + ~15min grace).

#### Phase 2 — "Tap to Check In" button
```
POST /stores/:storeId/bookings/:id/check-in
Body: (empty)
```
- ✅ 200 + session started → navigate `ActiveSession` with `{ sessionId, storeId }`
- ✅ 200 + no session yet → navigate `BookingDetail` (status now `checked_in`)
- ❌ `NOT_IN_CHECK_IN_WINDOW` → "Check-in window not open yet."
- ❌ `ALREADY_CHECKED_IN` → navigate `BookingDetail`

---

### SCREEN 23 — Active Session Screen

**Goal**: Real-time session monitor. Most time-critical screen.

#### Phase 1 — Mount
```
GET /stores/:storeId/sessions/:id
```
Response: `{ id, startTime, endTime?, status, systemName, storeName, baseRate, appliedMultiplier }`

Start local timer from `startTime`.

#### Phase 2 — WebSocket (primary)
```
WS /ws/users/{userId}/notify?token={accessToken}
```
Listen for events:
| Event | Action |
|-------|--------|
| `session.extended` | Update `endTime` in state, update countdown |
| `session.ended` | Show "Session ended!" toast → navigate `SessionHistoryDetail` |
| `booking.checked_in` | (informational, already on screen) |

#### Phase 3 — Polling fallback (if WS disconnected)
```
GET /stores/:storeId/sessions/:id
```
Every 30s. Compare `status` and `endTime` to local state.

#### Phase 4 — Estimated cost (client-side, informational only)
```typescript
const elapsedHours = (now - session.startTime) / 3600000;
const estimatedCost = session.baseRate * session.appliedMultiplier * elapsedHours;
// Label clearly: "Estimated — final bill by server"
```

---

### SCREEN 24 — Session History Detail Screen

**Goal**: Completed session summary.

#### Phase 1 — Mount
```
GET /stores/:storeId/sessions/:id
```
Show all fields. Credits earned: look for `creditsAwarded` field in response.

#### Phase 2 — "File Dispute" button visibility
```typescript
// Show if session ended within dispute window (e.g., 72h — server may enforce)
const sessionEndTime = new Date(session.endTime);
const hoursSinceEnd = (now - sessionEndTime) / 3600000;
const showDispute = hoursSinceEnd < 72; // use server config if available
```
Tap → navigate `CreateDispute` with `{ sessionId: session.id, storeId }`

---

### SCREEN 25 — Billing History Screen

**Goal**: Full billing record list, grouped by month.

#### Phase 1 — Mount
```
GET /stores/:storeId/billing/my?page=1&limit=20
```

#### Phase 2 — Pagination
Load more on scroll-to-bottom:
```
GET /stores/:storeId/billing/my?page={next}&limit=20
```

#### Phase 3 — Store filter
Dropdown to switch `activeStoreId` → re-fetch with new `storeId`.

Group records by `month = format(createdAt, 'MMMM yyyy')`.
Show monthly total as section header: `sum(records.map(r => r.amount))`.

---

### SCREEN 26 — Wallet Home

**Goal**: Credits balance + recent transactions + campaigns.

#### Phase 1 — Mount (parallel calls)
```
GET /stores/:storeId/credits/balance
GET /stores/:storeId/credits/transactions?limit=5
GET /stores/:storeId/campaigns/active
```

#### Phase 2 — Store selector
Tap store pill → `StoreSelector` sheet → on store selected:
```typescript
await AsyncStorage.setItem('activeStoreId', newStoreId);
setActiveStore(newStoreId); // Zustand
// Re-fetch all 3 endpoints with new storeId
```

#### Phase 3 — Quick actions
- "Redeem Credits" → navigate `RedeemCredits` with `{ balance, storeId }`
- "View History" → navigate `CreditTransactionHistory`
- "Campaigns" → navigate `CampaignsList`

---

### SCREEN 27 — Credit Transaction History Screen

**Goal**: Paginated ledger of credit transactions.

#### Phase 1 — Mount
```
GET /stores/:storeId/credits/transactions?page=1&limit=20
```

#### Phase 2 — Pagination
```
GET /stores/:storeId/credits/transactions?page={next}&limit=20
```

Group by month. Icon map:
```typescript
const icons = {
  earned: 'star',
  redeemed: 'arrow-up',
  bonus: 'gift',
  admin_adjust: 'wrench',
  expired: 'clock',
  refund: 'undo',
};
```

---

### SCREEN 28 — Redeem Credits Screen

**Goal**: Apply credits from wallet.

> **Note**: This screen redeems credits as a standalone action (for use in next booking), NOT during a booking. See Screen 17 for booking-time redemption.

#### Phase 1 — Validate before submit
| Rule | Check |
|------|-------|
| Amount | Required, positive integer |
| Max | `amount <= balance` |
| Non-zero | `amount > 0` |

#### Phase 2 — Confirm dialog
"Are you sure? Credits will apply to your next booking at {Store Name}."

#### Phase 3 — Submit
```
POST /stores/:storeId/credits/redeem
Body: { amount }
```
- ✅ 200 → update balance, show "X credits redeemed!" toast → dismiss sheet
- ❌ `INSUFFICIENT_CREDITS` → "Not enough credits. Max: {balance}"
- ❌ `CREDITS_EXPIRED` → "Some credits expired. Available: {balance}"

---

### SCREEN 29 — Campaigns List Screen

**Goal**: Browse all active campaigns.

#### Phase 1 — Mount
```
GET /stores/:storeId/campaigns/active
```
Response: `{ campaigns: [{ id, name, type, discountValue, validFrom, validTo, usageLimit, redemptionCount, eligibilityTier?, timeRestrictions? }] }`

#### Phase 2 — Client-side filter tabs
```typescript
const filters = {
  all: () => true,
  discounts: (c) => ['percentage_off', 'fixed_off'].includes(c.type),
  bonusCredits: (c) => c.type === 'bonus_credits',
  happyHour: (c) => c.type === 'happy_hour',
  firstVisit: (c) => c.type === 'first_visit',
};
```
No new API call on filter switch — filter in-memory.

---

### SCREEN 30 — Campaign Detail Screen

**Goal**: Full campaign info + redeem action.

#### Phase 1 — Mount
Data from navigation params (passed from Campaigns List). No additional API call needed.

#### Phase 2 — "Redeem Now" tap
```
POST /stores/:storeId/campaigns/:id/redeem
Body: (empty)
```
- ✅ 200 → show "Campaign redeemed!" + show `creditsAwarded` if applicable → navigate back
- ❌ `CAMPAIGN_MAX_USES_REACHED` → "This campaign is fully redeemed."
- ❌ `ALREADY_REDEEMED` → "You've already redeemed this campaign."
- ❌ `NOT_ELIGIBLE` → "You don't meet the eligibility requirements."
- ❌ `CAMPAIGN_EXPIRED` → "This campaign has ended."

---

### SCREEN 31 — Profile Home

**Goal**: User info + navigation hub + sign out.

#### Phase 1 — Mount
```
GET /auth/me
```
Response: `{ id, name, email, phone, isEmailVerified, isPhoneVerified, createdAt }`

Derive stats (if API provides them — else omit):
- Total sessions, hours, stores: derive from sessions history or show from `GET /auth/me` extended fields.

#### Phase 2 — Sign Out
Show confirm dialog: "Sign out of this device?"
On confirm:
```
POST /auth/logout
Headers: Authorization: Bearer {accessToken}
```
Then:
```typescript
// Clear all storage regardless of API response
await SecureStore.deleteItemAsync('refreshToken');
await SecureStore.deleteItemAsync('userId');
await AsyncStorage.removeItem('activeStoreId');
clearMemoryState(); // Zustand reset
navigate('AuthLanding');
```

---

### SCREEN 32 — Edit Profile Screen

**Goal**: Update name and email.

#### Phase 1 — Mount
Pre-fill from `currentUser` in memory (no extra API call if already loaded).

#### Phase 2 — Validate
| Field | Rule |
|-------|------|
| Name | Required, 2–100 chars |
| Email | Optional, valid format if provided |

#### Phase 3 — Submit on change (save button)
```
PATCH /auth/me
Body: { name?, email? }
```
- ✅ 200 → update `currentUser` in memory → show "Profile updated" toast
- If email changed → also show `EmailVerificationPending` notice (email not yet verified)
- ❌ 409 `EMAIL_TAKEN` → "Email already in use."

---

### SCREEN 33 — Change Phone Screen

**Goal**: Replace phone number via OTP.

#### Phase 1 — Validate new phone
| Field | Rule |
|-------|------|
| New Phone | Required, E.164, different from current |

#### Phase 2 — Send OTP to new number
```
POST /auth/phone/change
Body: { newPhone }
```
- ✅ 200 → show `OTPInputSheet` (reusable sheet) targeting new phone number

#### Phase 3 — OTP verification (via reusable sheet)
```
POST /auth/verify/otp
Body: { phone: newPhone, code }
```
- ✅ 200 → update `currentUser.phone` in memory → show "Phone updated" toast → dismiss sheet
- ❌ OTP errors → same as Screen 05

---

### SCREEN 34 — Notification Preferences Screen

**Goal**: Manage notification channels and types.

#### Phase 1 — Mount
```
GET /notifications/preferences
```
Response: `{ push, email, sms, inApp, bookingConfirm, bookingReminder, sessionEndingSoon, creditUpdates, newCampaigns, disputeUpdates }`

#### Phase 2 — Toggle change (debounced 1s)
```
PATCH /notifications/preferences
Body: { [changedKey]: boolean }
```
- Send only changed key, not full object
- ✅ 200 → update local state
- ❌ Error → revert toggle to previous state + show error toast

#### Phase 3 — Push toggle ON
1. Request OS permission via `expo-notifications`
2. If granted → get FCM token
3. Register device:
```
PATCH /auth/me/device
Body: { fcmToken, platform: 'ios' | 'android' }
```
- ✅ 200 → proceed
- If permission denied → revert push toggle to OFF, show "Enable in Settings"

---

### SCREEN 35 — Disputes List Screen

**Goal**: List user's disputes.

#### Phase 1 — Mount
```
GET /stores/:storeId/disputes/my
```
Response: `{ disputes: [{ id, sessionId, status, disputedAmount, createdAt, resolution? }] }`

#### Phase 2 — Store filter
If user has disputes across multiple stores, show store dropdown.
Change store → re-fetch with new `storeId`.

Empty state: "No disputes filed."

---

### SCREEN 36 — Dispute Detail Screen

**Goal**: Full dispute info + withdraw option.

#### Phase 1 — Mount
```
GET /stores/:storeId/disputes/:id
```
Response: `{ id, status, sessionId, reason, disputedAmount, resolution?, adminNotes?, timeline[], createdAt }`

#### Phase 2 — "Withdraw Dispute" button (only if `status === 'open'`)
Show confirm: "Are you sure? This cannot be undone."

```
POST /stores/:storeId/disputes/:id/withdraw
Body: (empty)
```
- ✅ 200 → update status in state to `withdrawn` → show "Dispute withdrawn" toast
- ❌ `ALREADY_RESOLVED` → "Dispute already resolved."

---

### SCREEN 37 — Create Dispute Screen

**Goal**: File a new dispute tied to a session.

#### Phase 1 — Session selector (if not pre-filled)
If navigated from `SessionHistoryDetail`, `sessionId` comes as nav param.
If from `DisputesList`, show picker fetching:
```
GET /stores/:storeId/sessions/my?status=completed
```

#### Phase 2 — Validate form
| Field | Rule |
|-------|------|
| Session | Required, must select a session |
| Reason | Required, 10–500 chars |
| Disputed Amount | Optional, positive number, ≤ original charge |

#### Phase 3 — Submit
```
POST /stores/:storeId/disputes
Body: { sessionId, reason, disputedAmount? }
```
- ✅ 201 → navigate `DisputeDetail` with new dispute → show "Dispute filed!" toast
- ❌ `ALREADY_DISPUTED` → "A dispute already exists for this session."
- ❌ `DISPUTE_WINDOW_CLOSED` → "Dispute window for this session has closed."

---

### SCREEN 38 — Notification Center

**Goal**: Full notification list with mark-all-read.

#### Phase 1 — Mount
```
GET /notifications?page=1&limit=30
```
Response: `{ notifications: [{ id, title, body, status, type, createdAt, metadata }], unreadCount }`

#### Phase 2 — "Mark all as read"
```
POST /notifications/read-all
Body: (empty)
```
- ✅ 200 → set all notifications to `read` in local state, clear badge count

#### Phase 3 — WebSocket real-time
`notification.new` event → prepend new notification, increment unread badge.

#### Phase 4 — Pagination
```
GET /notifications?page={next}&limit=30
```
Load more on scroll.

---

### SCREEN 39 — Notification Detail Sheet

**Goal**: Full notification content + mark as read.

#### Phase 1 — Open
Mark as read immediately:
```
PATCH /notifications/:id/read
Body: (empty)
```
- Fire-and-forget (don't await — show content immediately)
- Update local state: set `status = 'read'` for this id, decrement unread count

#### Phase 2 — Deep-link action button
Use `notification.metadata` to derive action:
```typescript
const actions = {
  booking: () => navigate('BookingDetail', { bookingId: metadata.bookingId }),
  session: () => navigate('ActiveSession', { sessionId: metadata.sessionId }),
  credit: () => navigate('WalletHome'),
  dispute: () => navigate('DisputeDetail', { disputeId: metadata.disputeId }),
  campaign: () => navigate('CampaignDetail', { campaignId: metadata.campaignId }),
};
```

---

### SCREEN 40 — Store Selector Sheet

**Goal**: Switch active store context.

#### Phase 1 — Mount
```
GET /stores?isActive=true&page=1&limit=50
```

#### Phase 2 — Search (debounced 300ms)
```
GET /stores?search={query}&isActive=true
```

#### Phase 3 — Store selected
```typescript
await AsyncStorage.setItem('activeStoreId', store.id);
setActiveStore(store.id); // Zustand
dismissSheet();
// Parent screen re-fetches with new storeId
```

---

## 3. WebSocket Strategy (Full)

### Connect
```typescript
// Connect when user authenticates OR app comes to foreground
const userId = await SecureStore.getItemAsync('userId');
const { accessToken } = getAuthStore();

const ws = new WebSocket(`wss://api.gamingzone.app/ws/users/${userId}/notify?token=${accessToken}`);
```

### Reconnect Pattern
```typescript
let retryDelay = 1000; // ms
ws.onclose = () => {
  setTimeout(() => reconnect(), retryDelay);
  retryDelay = Math.min(retryDelay * 2, 30000); // max 30s
};
ws.onopen = () => { retryDelay = 1000; }; // reset on success
```

### Event Handlers
```typescript
ws.onmessage = (event) => {
  const msg = JSON.parse(event.data);
  switch (msg.type) {
    case 'notification.new':
      prependNotification(msg.data);
      incrementUnreadCount();
      break;
    case 'session.started':
      updateActivityHub(); // refresh tab B
      break;
    case 'session.ended':
      if (currentScreen === 'ActiveSession') {
        showToast('Session ended!');
        navigate('SessionHistoryDetail', { sessionId: msg.data.sessionId });
      }
      break;
    case 'session.extended':
      if (currentScreen === 'ActiveSession') {
        updateSessionEndTime(msg.data.newEndTime);
      }
      break;
    case 'booking.checked_in':
      updateBookingStatus(msg.data.bookingId, 'checked_in');
      break;
  }
};
```

### Token Expiry Handling
WS uses access token. When access token expires (15 min), WS may disconnect.
On reconnect attempt with expired token → get new token via refresh flow → reconnect with new token.

---

## 4. Global Error Handling Patterns

| HTTP Status | Behavior |
|------------|----------|
| 400 | Show `message` from response as inline error or toast |
| 401 | Trigger silent refresh → retry → if fails → logout |
| 403 | Show "You don't have permission" toast |
| 404 | Show "Not found" or empty state depending on context |
| 409 | Show specific conflict message (see per-screen) |
| 422 | Map `field` from response to form field inline errors |
| 429 | Show "Too many requests. Try again in X minutes." |
| 500+ | Show "Something went wrong. Try again." + Retry button |
| Network | Show "No internet connection." + Retry button |

---

## 5. State Management Map (Zustand Stores)

```typescript
// authStore
{
  accessToken: string | null,
  currentUser: User | null,
  setTokens: (access, refresh) => void,
  logout: () => void,
}

// storeContextStore  
{
  activeStoreId: string | null,
  activeStoreName: string | null,
  setActiveStore: (id, name) => void,
}

// notificationStore
{
  notifications: Notification[],
  unreadCount: number,
  prependNotification: (n) => void,
  markAllRead: () => void,
}

// sessionStore
{
  activeSession: Session | null,
  setActiveSession: (s) => void,
  clearSession: () => void,
}
```

---

## 6. Deep Link Handlers

| URL | Handler |
|-----|---------|
| `gzapp://reset-password?token=X` | Extract `token` → navigate `ResetPassword` |
| `gzapp://verify-email?token=X` | Call `POST /auth/verify/email { token }` → navigate `Home` |
| `gzapp://stores/:slug` | Navigate `StoreDetail` with `slug` |
| `gzapp://bookings/:bookingId` | Navigate `BookingDetail` — resolve `storeId` from booking data |
| `gzapp://sessions/:sessionId` | Navigate `ActiveSession` if `in_progress`, else `SessionHistoryDetail` |
| `gzapp://notifications` | Navigate `NotificationCenter` |

---

## 7. FCM Push Notification Handler

```typescript
// When app is in background/killed, FCM delivers notification
// When app is in foreground, handle via onMessage

import * as Notifications from 'expo-notifications';

Notifications.addNotificationResponseReceivedListener((response) => {
  const { type, bookingId, sessionId, disputeId } = response.notification.request.content.data;
  // Route same as Screen 39 deep-link actions
});
```

---

## 8. Complete Endpoint → Screen Index

| Endpoint | Screens |
|----------|---------|
| `GET /auth/me` | 01, 10, 11, 31 |
| `POST /auth/register` | 04 |
| `POST /auth/login/otp` | 03, 05 (resend) |
| `POST /auth/login/email` | 06 |
| `POST /auth/login/oauth/:provider` | 07 |
| `POST /auth/verify/otp` | 05, 33 |
| `POST /auth/verify/email` | Deep link handler |
| `POST /auth/refresh` | 01, interceptor (all screens) |
| `POST /auth/logout` | 31 |
| `POST /auth/password/reset/request` | 08 |
| `POST /auth/password/reset/confirm` | 09 |
| `POST /auth/phone/change` | 33 |
| `PATCH /auth/me` | 32 |
| `PATCH /auth/me/device` | 34 |
| `GET /stores` | 11, 12, 40 |
| `GET /stores/:slug` | 13 |
| `GET /stores/:storeId/systems/available` | 14, 16 |
| `GET /stores/:storeId/bookings/availability` | 15 |
| `GET /stores/:storeId/bookings/my` | 19 (Tab A, Tab C) |
| `GET /stores/:storeId/bookings/:id` | 20 |
| `POST /stores/:storeId/bookings` | 17 |
| `POST /stores/:storeId/bookings/:id/pay` | 21 |
| `POST /stores/:storeId/bookings/:id/cancel` | 20 |
| `POST /stores/:storeId/bookings/:id/check-in` | 22 |
| `GET /stores/:storeId/sessions/my` | 19 (Tab B, Tab C) |
| `GET /stores/:storeId/sessions/:id` | 23, 24 |
| `GET /stores/:storeId/billing/my` | 25 |
| `GET /stores/:storeId/credits/balance` | 17, 21, 26, 28 |
| `GET /stores/:storeId/credits/transactions` | 26 (preview), 27 |
| `POST /stores/:storeId/credits/redeem` | 28 |
| `GET /stores/:storeId/campaigns/active` | 13, 17, 26, 29 |
| `POST /stores/:storeId/campaigns/:id/redeem` | 30 |
| `GET /notifications` | 38 |
| `PATCH /notifications/:id/read` | 39 |
| `POST /notifications/read-all` | 38 |
| `GET /notifications/preferences` | 34 |
| `PATCH /notifications/preferences` | 34 |
| `GET /stores/:storeId/disputes/my` | 35 |
| `GET /stores/:storeId/disputes/:id` | 36 |
| `POST /stores/:storeId/disputes` | 37 |
| `POST /stores/:storeId/disputes/:id/withdraw` | 36 |
| `WS /ws/users/:userId/notify?token=` | 23, 38, global |
