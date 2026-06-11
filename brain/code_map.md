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
  - `data/repositories/`
    - `billing_repository.dart`
    - `bookings_repository.dart`
    - `sessions_repository.dart`
  - `application/`
    - `activity_hub_notifier.dart`
    - `active_session_notifier.dart`
    - `billing_notifier.dart`
    - `booking_detail_notifier.dart`
    - `payment_notifier.dart`
    - `session_detail_notifier.dart`
    - `session_logs_notifier.dart`
    - `session_ui_models.dart`
  - `presentation/screens/`
  - `presentation/providers/session_runtime_providers.dart`
- `lib/features/wallet/`
  - `data/repositories/wallet_repository.dart`
  - `application/`
    - `campaign_detail_notifier.dart`
    - `campaigns_notifier.dart`
    - `credit_history_notifier.dart`
    - `redeem_credits_notifier.dart`
    - `wallet_notifier.dart`
    - `wallet_ui_models.dart`
  - `presentation/screens/`
- `lib/features/notifications/`
  - `data/repositories/notifications_repository.dart`
  - `application/`
    - `notifications_notifier.dart`
    - `notification_detail_notifier.dart`
    - `notifications_ui_models.dart`
  - `presentation/screens/`
- `lib/features/profile/`
  - `application/`
    - `change_phone_notifier.dart`
    - `edit_profile_notifier.dart`
    - `notif_prefs_notifier.dart`
    - `profile_notifier.dart`
  - `presentation/screens/`
    - `disputes_list_screen.dart`
- `lib/features/disputes/`
  - `data/repositories/disputes_repository.dart`
  - `application/`
    - `create_dispute_notifier.dart`
    - `dispute_detail_notifier.dart`
    - `my_disputes_notifier.dart`
  - `presentation/screens/`
- `lib/features/main_shell/`
  - `presentation/screens/main_page.dart`
- `lib/features/admin/`
  - `data/repositories/`
    - `admin_notify_send_repository.dart`
    - `admin_bookings_repository.dart`
    - `admin_dashboard_repository.dart`
    - `admin_sessions_repository.dart`
    - `admin_store_repository_support.dart`
    - `store_admins_repository.dart`
    - `store_config_repository.dart`
    - `systems_admin_repository.dart`
    - `system_types_repository.dart`
  - `application/`
    - `admin_booking_command_notifier.dart`
    - `admin_booking_detail_notifier.dart`
    - `admin_bookings_notifier.dart`
    - `admin_command_state.dart`
    - `admin_dashboard_notifier.dart`
    - `admin_notify_send_notifier.dart`
    - `admin_operations_models.dart`
    - `admin_store_models.dart`
    - `admin_system_command_notifier.dart`
    - `admin_system_detail_notifier.dart`
    - `admin_system_type_command_notifier.dart`
    - `admin_systems_notifier.dart`
    - `admin_session_command_notifier.dart`
    - `admin_sessions_notifier.dart`
    - `admin_walk_in_notifier.dart`
    - `store_admin_command_notifier.dart`
    - `store_admins_notifier.dart`
    - `store_config_command_notifier.dart`
    - `store_config_notifier.dart`
  - `presentation/screens/admin_login_screen.dart`
  - `presentation/screens/admin_password_reset_screen.dart`
  - `presentation/screens/analytics/`
  - `presentation/screens/management/`
  - `presentation/screens/operations/`
    - `admin_booking_detail_screen.dart`
    - `admin_dashboard_screen.dart`
    - `booking_management_screen.dart`
    - `cancel_booking_sheet.dart`
    - `end_session_sheet.dart`
    - `extend_session_sheet.dart`
    - `session_management_screen.dart`
    - `walk_in_booking_screen.dart`
  - `presentation/screens/store/`
    - `add_edit_system_screen.dart`
    - `admin_notifications_screen.dart`
    - `admin_store_screen.dart`
    - `edit_staff_sheet.dart`
    - `invite_staff_screen.dart`
    - `staff_management_screen.dart`
    - `store_config_screen.dart`
    - `system_detail_screen.dart`
    - `system_management_screen.dart`
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
