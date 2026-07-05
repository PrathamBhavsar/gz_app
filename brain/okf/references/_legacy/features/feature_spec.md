# MASTER FEATURE SPECIFICATION
> Source of truth for Phase 0 is `brain/API_INTEGRATION_PLAN.md`.

## Product Summary
`gz_app` is a dual-client Flutter application for the Gaming Zone platform:
- Player app for discovery, booking, sessions, wallet, notifications, profile, and disputes.
- Admin dashboard for operations, systems, campaigns, disputes, pricing, billing, and analytics.

The app is currently presentation-first. The repository already contains most screens, a router, shared UI primitives, a central model layer, token storage, API transport, connectivity checks, and WebSocket services. It does not yet contain the per-feature repository/notifier wiring needed to replace dummy UI data with live backend data.

## Backend Contract
- Base URL comes from `ApiConstants`.
- Success envelope: `{ success, message, data }`
- Paginated envelope: `{ success, data, meta }`
- Error envelope: `{ success: false, error: { code, message, details } }`
- Auth uses bearer tokens plus refresh tokens.
- Player endpoints are often store-scoped: `/stores/{storeId}/...`
- Backend enum payloads use `snake_case`; parsers live in `lib/models/enums.dart`.

## Existing Reusable Foundation
- Transport: `lib/core/api/api_client.dart`
- Session/token storage: `lib/core/auth/token_storage.dart`
- Connectivity gate: `lib/core/network/network_checker.dart`
- Error normalization: `lib/core/errors/app_exception.dart`
- Error UI: `lib/shared/widgets/page_error_display.dart`
- WebSockets: `lib/core/network/player_ws_service.dart`, `lib/core/network/admin_live_service.dart`
- Shared models: `lib/models/*.dart`

## Locked Engineering Decisions
1. Keep `http` as the transport layer. Do not introduce `dio`.
2. Keep manual model parsing in `lib/models/`. Do not introduce codegen.
3. Use plain Riverpod notifiers. Do not introduce `@riverpod` or `build_runner`.
4. Add feature-specific `data/repositories/` and `application/` folders as API phases progress.
5. Every API-bound screen must handle loading, error, empty, and data states explicitly.

## Feature Groups
### Player
- Auth and identity
- Home and store discovery
- Booking
- Sessions and billing
- Wallet, credits, and campaigns
- Notifications
- Profile
- Disputes

### Admin
- Auth
- Operations dashboard, sessions, walk-in bookings, bookings management
- Store and systems management
- Pricing, billing, payments, credits
- Campaigns and disputes
- Analytics

## Cross-Cutting Rules
1. Repository -> notifier -> UI is the only allowed state/data path.
2. `activeStoreIdProvider` and `TokenStorage` are the source of truth for selected player store scope.
3. Errors are typed and must remain visible to the notifier/UI instead of being swallowed.
4. Brain files under `brain/` must stay synchronized with the real codebase as Phase 0 and later phases land.
