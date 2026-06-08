# Phase 1 — Auth & Identity — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- Splash bootstrap uses `/auth/me` and `/auth/admin/me` to trigger silent refresh through `ApiClient`; this assumes backend 401->refresh behavior matches the existing client implementation.
- Backend source confirms `POST /auth/login/oauth/:provider` accepts `{ code, state?, redirectUri? }`; app now sends that shape from the OAuth callback screen.
- Backend source confirms password reset confirm endpoints require `newPassword`; app now sends that shape for both player and admin reset flows.
- Backend source confirms registration is email-password-first (`name`, `email`, `password`, optional `phone`), which supersedes the older plan text that treated email/password as optional.

## Missing / renamed endpoints or constants
- No email-verification resend endpoint exists in the backend. `email_verification_pending_screen.dart` now rate-limits the button and surfaces guidance instead of pretending a resend API exists.
- Admin auth path remains under review; the master plan explicitly calls out a possible mismatch between Flutter `/auth/admin/login` and backend store-scoped admin login.

## Model ↔ JSON field mismatches (nullable, casing, types)
- `AdminAuthModel` now accepts both `storeId` and `store_id` casing.

## Registry ↔ code drift fixed
- Added `brain/features/.registry/auth_identity.md` for the Phase 1 auth layer.
- Updated `brain/features/.registry/splash.md` to reflect the live splash notifier.

## Dummy data removed (file:line)
- `lib/features/auth/presentation/screens/email_login/email_login_screen.dart`
- `lib/features/auth/presentation/screens/register/register_screen.dart`
- `lib/features/auth/presentation/screens/otp/otp_verification_screen.dart`
- `lib/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart`
- `lib/features/auth/presentation/screens/reset_password/reset_password_screen.dart`
- `lib/features/admin/presentation/screens/admin_login_screen.dart`
- `lib/features/admin/presentation/screens/admin_password_reset_screen.dart`
- `lib/features/auth/presentation/screens/email_verification_pending/email_verification_pending_screen.dart`
- `lib/features/auth/presentation/screens/email_verify_success/email_verify_success_screen.dart`
- `lib/features/auth/presentation/screens/oauth_handler/oauth_handler_screen.dart`

## Open TODOs / deferred
- OAuth start/handoff is still external to the app layer; Phase 1 now handles the callback/exchange side, but provider-specific browser/native launch remains dependent on whichever auth handoff owns the initial authorization request.
