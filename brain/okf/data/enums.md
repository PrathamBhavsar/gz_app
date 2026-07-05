---
type: Data Model
title: Enums
description: App enums and the snake_case-tolerant parsers that map backend strings to Dart enums.
resource: file://lib/models/enums.dart
tags: [enums, parsing, snake-case]
timestamp: 2026-07-04
---

# `lib/models/enums.dart`
Dart enums + a `ParseEnums` string extension. `_normalizeEnumValue` strips `_`/`-` and lowercases, so it
matches backend **snake_case** (`in_progress` → `inProgress`). `_parseEnum` returns `null` on unknown
values (safe parsing). `PaymentStatus` also maps legacy `paid` → `completed`.

| App enum | Values | Backend enum |
| --- | --- | --- |
| `SystemStatus` | available, inUse, maintenance, offline | system_status |
| `BookingStatus` | pending, confirmed, checkedIn, cancelled, noShow | booking_status |
| `SessionStatus` | inProgress, completed, cancelled, disputed | session_status |
| `BookingType` | paid, reserved, walkIn | booking_type |
| `PaymentMethod` | cash, card, upi, wallet, credits | payment_method |
| `PaymentStatus` | pending, completed, failed, refunded | payment_status |
| `PricingRuleType` | base, peak, offPeak, weekend, custom | pricing_rule_type |
| `OverrideType` | price, duration, both | override_type |
| `AdminRole` | superAdmin, admin, staff | admin_role |
| `SystemPlatform` | pc, ps5, ps4, xbox, vr, other | system_platform |
| `DisputeStatus` | open, underReview, resolved, withdrawn | dispute_status |
| `DisputeResolution` | upheld, partialRefund, fullRefund, creditIssued | dispute_resolution |
| `CampaignType` | percentageOff, fixedOff, bonusMinutes, bonusCredits, happyHour, firstVisit | campaign_type |
| `CampaignStatus` | draft, scheduled, active, paused, expired, cancelled | campaign_status |
| `NotificationChannel` | push, sms, email, inApp | notification_channel |
| `NotificationStatus` | pending, sent, delivered, failed, read | notification_status |
| `VerificationPurpose` | phoneVerification, emailVerification, passwordReset, loginOtp, phoneChange | verification_purpose |
| `CreditTransactionType` | earned, redeemed, bonus, adminAdjust, expired, refund | credit_transaction_type |
| `AuthMethod` | phoneOtp, emailPassword, googleOauth, appleOauth | auth_method |
| `TransactionType` | topUp, refund, booking, purchase | (app-only, legacy) |

> Drift to watch: backend `auth_method` also has `discord_oauth` (Discord login is supported) but the app
> enum omits it; `TransactionType` is app-only with no backend equivalent. Flag when touching auth/wallet.
</content>
