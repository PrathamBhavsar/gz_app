---
type: Concept
title: Glossary — Shared Vocabulary
description: App/UI word → what it means → where it lives in code → backend counterpart. Use these words when describing changes.
tags: [glossary, dictionary, vocabulary]
timestamp: 2026-07-04
---

# How to read this

Use **these words** when you describe a change and I'll map them to the right screen, notifier,
repository, and backend endpoint. Domain words (store, session, credit…) mirror the backend
[glossary](../references/backend-brain-link.md) 1:1.

## Frontend architecture words

| Word | Meaning | Where |
| --- | --- | --- |
| **Screen** | A full page widget (a route target). | `lib/features/*/presentation/screens/` |
| **Sheet** | A modal bottom sheet (e.g. payment, adjust-credits, end-session). | `presentation/screens/**/*_sheet.dart` |
| **Notifier** | Riverpod state holder with the logic for a screen/flow. Calls repositories. | `lib/features/*/application/*_notifier.dart` |
| **Repository** | The data-access object that calls `ApiClient` and parses models. | `lib/features/*/data/repositories/*_repository.dart` |
| **ApiClient** | The single HTTP wrapper (base URL, auth header, envelope handling). | `lib/core/api/api_client.dart` |
| **Provider** | A Riverpod provider exposing a notifier/value to the widget tree. | `application/` + `presentation/providers/` |
| **AsyncValue** | Riverpod's loading/error/data wrapper the UI switches on. | throughout |
| **Route constant** | A named path string (`AppRoutes.home`). Never hard-code paths. | `lib/core/navigation/routes.dart` |
| **Path builder** | A function that fills `:param`s (`AppRoutes.storeDetailPath(slug)`). | `routes.dart` |
| **Router** | The `go_router` config with redirects/guards. | `lib/core/navigation/app_router.dart` |
| **Shell** | The bottom-nav scaffold hosting tabs (Player `main_page`, Admin `admin_shell`). | `main_shell/`, `admin/presentation/widgets/admin_shell.dart` |
| **Active store** | The store the player currently has selected (persisted). | `home/application/active_store_notifier.dart` |
| **Token storage** | Persisted access/refresh tokens. | `lib/core/auth/token_storage.dart` |
| **Envelope** | The backend `{success, message, data}` / `{success, data, meta}` / `{success:false, error}` wrapper the repos unwrap. | [Backend Contract](../systems/backend-contract.md) |

## Domain words (shared with backend)

| Word | In the app | Backend |
| --- | --- | --- |
| **Store** | Selected via store-selector; drives `/stores/:storeId/...` calls. `home` module. | `stores` |
| **System / station** | A bookable machine; shown in booking + admin systems. `booking`, `admin`. | `systems` |
| **Booking** | A slot reservation; player booking flow + admin BookingManagement. | `bookings` |
| **Walk-in** | Admin counter booking with instant session. `admin` WalkIn. | `bookings` (walk_in) |
| **Session** | Actual play; player ActiveSession/History + admin SessionManagement. | `sessions` |
| **Billing** | Charges; player BillingHistory + admin BillingPayments. | `billing_ledger` |
| **Payment** | Settlement; admin BillingPayments. | `payments` |
| **Credit / wallet** | Loyalty balance; player Wallet + admin CreditsManagement. | `credit_ledger` |
| **Campaign** | Promo; player Campaigns + admin CampaignManagement. | `campaigns` |
| **Dispute** | Bill challenge; player Disputes + admin DisputeResolution. | `billing_disputes` |
| **Pricing rule** | Admin PricingRules. | `pricing_rules` |
| **Notification** | Player inbox + admin AdminNotifications. | `notifications` |

## Realtime & platform words

| Word | Meaning | Where |
| --- | --- | --- |
| **Player WS** | The player notification WebSocket client. | `lib/core/network/player_ws_service.dart` |
| **Admin live** | The admin store-live WebSocket client (dashboard feed). | `lib/core/network/admin_live_service.dart` |
| **Connectivity** | Online/offline detection. | `lib/core/network/connectivity_service.dart` |
| **Responsive builder / breakpoints** | Layout that adapts to width. | `lib/core/responsive/` |
| **Theme tokens** | Colors/spacing/typography constants. | `lib/core/theme/` |
| **Native social transport** | Google (`google_sign_in`→idToken) / Discord (`flutter_web_auth_2`→code). | `auth/data/services/` |
</content>
