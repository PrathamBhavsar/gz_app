---
name: auth_identity
description: Player auth + admin auth Phase 1 wiring
metadata:
  type: project
---

# Feature: Auth & Identity (Phase 1)
> IMPLEMENTED — first live auth pass landed

## Core Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/auth/data/repositories/auth_repository.dart` | Player auth API calls + token persistence | Yes |
| `lib/features/auth/data/repositories/admin_auth_repository.dart` | Admin auth API calls + token persistence | Yes |
| `lib/features/auth/application/auth_notifier.dart` | Player session state for router + bootstrap | Yes |
| `lib/features/auth/application/admin_auth_notifier.dart` | Admin session state for router + bootstrap | Yes |
| `lib/features/auth/application/email_verification_notifier.dart` | Verify-email link + verification status checks | Yes |
| `lib/features/auth/application/login_notifier.dart` | Email login action flow | Yes |
| `lib/features/auth/application/oauth_login_notifier.dart` | OAuth callback exchange action flow | Yes |
| `lib/features/auth/application/register_notifier.dart` | Register action flow | Yes |
| `lib/features/auth/application/otp_notifier.dart` | OTP verification action flow | Yes |
| `lib/features/auth/application/password_reset_notifier.dart` | Player/admin password reset requests + player confirm | Yes |
| `lib/features/auth/application/splash_notifier.dart` | Splash routing bootstrap | Yes |
| `lib/features/auth/presentation/widgets/auth_input_field.dart` | Shared auth text field styling | Yes |

## Screen Wiring
| Screen | Route | Status |
|---|---|---|
| Splash | `/` | Uses `splashNotifierProvider` for bootstrap routing |
| Auth landing | `/auth` | Email + admin flows wired, OAuth callback route is live |
| Register | `/auth/register` | Calls `registerNotifierProvider`, routes to verification pending |
| OTP | `/auth/otp` | Calls `otpNotifierProvider`, authenticates player session |
| Email login | `/auth/email-login` | Calls `loginNotifierProvider`, authenticates player session |
| OAuth handler | `/auth/oauth-handler` | Exchanges callback `code` into a player session |
| Forgot password | `/auth/forgot-password` | Calls `passwordResetNotifierProvider.requestPlayerReset` |
| Reset password | `/auth/reset-password?token=` | Calls `passwordResetNotifierProvider.confirmPlayerReset` |
| Email verification pending | `/auth/email-verification-pending` | 60s resend guidance timer + verification status check |
| Email verified | `/auth/email-verified?token=` | Calls `/auth/verify/email` from deep-link token |
| Admin login | `/auth/admin-login` | Calls `adminLoginNotifierProvider`, authenticates admin session |
| Admin password reset | `/auth/admin-password-reset` | Request mode or confirm mode based on `token` query param |

## Router / Session Notes
1. `routerProvider` now refreshes from auth/admin session providers and guards player/admin private routes.
2. Splash bootstrap uses secure storage + refresh token backed `/auth/me` or `/auth/admin/me`.
3. Query params are now consumed for OTP phone/email, password-reset token, pending email, email-verify token, admin reset token, and OAuth callback fields.
4. Router deep-link normalization now accepts both `gzapp://...` links and backend-style `/verify-email`, `/reset-password`, `/admin/reset-password`, `/auth/oauth-handler` callback paths.

## Known Contract Notes
1. OAuth callback exchange is implemented; the app still depends on an external browser/native OAuth handoff to deliver `code` back into `/auth/oauth-handler`.
2. Email resend remains guidance-only by design because the backend exposes no resend endpoint.
3. Registration/backend truth differs from the original phase plan: the live backend requires `name + email + password`, with phone optional.
4. WP2 backend parity is now closed for player auth flows: `/auth/logout` exists for user logout, and `/auth/phone/change/verify` completes the existing two-step phone-change OTP UX without adding new widgets.
5. WP4 auth/profile coverage pass confirmed the player auth user shape is `id, name, phone, email, isVerified, createdAt`; the app now surfaces verification state and member-since metadata in the profile UI instead of only rendering name/contact.
6. WP5 removed the email-login demo credential chips entirely instead of debug-gating them. The auth flow now relies only on real backend credentials and reuses the existing `GzTopBar`, `AuthInputField`, and `GzButton` widgets.
