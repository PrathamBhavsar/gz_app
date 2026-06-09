# FLUTTER WORKSPACE MAP
> Update this file whenever `.dart` files are created, moved, or deleted.

## Core
- `lib/core/api/`
  - `api_client.dart`
  - `api_constants.dart`
- `lib/core/auth/`
  - `token_storage.dart`
- `lib/core/errors/`
  - `app_exception.dart`
  - `error_snackbar.dart`
- `lib/core/navigation/`
  - `app_router.dart`
  - `routes.dart`
- `lib/core/network/`
  - `admin_live_service.dart`
  - `connectivity_service.dart`
  - `network_checker.dart`
  - `player_ws_service.dart`
- `lib/core/responsive/`
  - `breakpoints.dart`
  - `responsive_builder.dart`
- `lib/core/theme/`
  - `app_colors.dart`
  - `app_spacing.dart`
  - `app_theme.dart`
  - `app_typography.dart`

## Models
- `lib/models/`
  - `api_responses.dart`
  - `api_responses_admin.dart`
  - `core.dart`
  - `domain_admin.dart`
  - `domain_analytics.dart`
  - `domain_billing.dart`
  - `domain_global.dart`
  - `domain_loyalty.dart`
  - `domain_misc.dart`
  - `domain_systems.dart`
  - `enums.dart`

## Shared
- `lib/shared/widgets/`
  - Base UI primitives and shell widgets
  - Error/loading widgets: `page_error_display.dart`, `gz_loading_view.dart`
  - Common overlays: `otp_input_sheet.dart`, `store_selector_sheet.dart`

## Features
- `lib/features/auth/`
  - `data/repositories/auth_repository.dart`
  - `data/repositories/admin_auth_repository.dart`
  - `application/`
    - `auth_notifier.dart`
    - `admin_auth_notifier.dart`
    - `email_verification_notifier.dart`
    - `login_notifier.dart`
    - `oauth_login_notifier.dart`
    - `register_notifier.dart`
    - `otp_notifier.dart`
    - `password_reset_notifier.dart`
    - `splash_notifier.dart`
  - `presentation/screens/`
  - `presentation/widgets/auth_input_field.dart`
- `lib/features/home/`
  - `data/repositories/store_repository.dart`
  - `application/`
    - `active_store_notifier.dart`
    - `home_notifier.dart`
    - `store_detail_notifier.dart`
    - `store_search_notifier.dart`
  - `presentation/screens/`
- `lib/features/booking/`
  - `data/repositories/`
    - `booking_repository.dart`
    - `systems_repository.dart`
  - `application/`
    - `availability_notifier.dart`
    - `booking_form_notifier.dart`
    - `booking_notifier.dart`
    - `booking_payment_notifier.dart`
    - `booking_summary_ui_notifier.dart`
    - `system_types_notifier.dart`
    - `systems_notifier.dart`
  - `presentation/`
    - `booking_presenters.dart`
    - `screens/`
- `lib/features/sessions/`
  - `presentation/screens/`
  - `presentation/providers/session_runtime_providers.dart`
- `lib/features/wallet/`
  - `presentation/screens/` only today
- `lib/features/notifications/`
  - `presentation/screens/`
  - `presentation/providers/notification_feed_notifier.dart`
- `lib/features/profile/`
  - `presentation/screens/` only today
- `lib/features/disputes/`
  - `presentation/screens/` only today
- `lib/features/main_shell/`
  - `presentation/screens/main_page.dart`
- `lib/features/admin/`
  - `presentation/screens/admin_login_screen.dart`
  - `presentation/screens/admin_password_reset_screen.dart`
  - `presentation/screens/analytics/`
  - `presentation/screens/management/`
  - `presentation/screens/operations/`
  - `presentation/screens/store/`
  - `presentation/widgets/admin_shell.dart`

## Target Convention For API Phases
Live phases add:
```text
lib/features/<feature>/
  data/repositories/
  application/
  presentation/
```
Models remain centralized in `lib/models/`.

## Phase 2 Notes
- `lib/shared/widgets/store_selector_sheet.dart` now consumes `homeNotifierProvider` for store lists and `activeStoreNotifierProvider` for persisted selection instead of a separate overlay-specific notifier file.
