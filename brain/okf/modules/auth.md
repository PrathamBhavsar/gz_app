---
type: Module
title: Auth (Player)
description: Player authentication screens — splash, onboarding, OTP, email, social OAuth, password reset, email verify.
resource: file://lib/features/auth
tags: [auth, otp, oauth, login]
timestamp: 2026-07-04
---

# Responsibilities
All player sign-in/up flows + session bootstrap. Notifiers in `application/` (auth, login, otp, register,
password_reset, email_verification, splash, social_login, oauth_signup, admin_auth). Repositories:
`auth_repository.dart`, `admin_auth_repository.dart`. Native social transport in `data/services/`.
Backend: [auth module](../references/backend-brain-link.md). Admin login/reset screens live in [admin](admin.md).

# Screens

| # | Screen | Route | Backend call | Notes |
| --- | --- | --- | --- | --- |
| 1 | SplashScreen | `/` | — (bootstraps session) | Guard then routes to home/admin/auth. |
| 2 | OnboardingScreen | `/onboarding` | — | First-run intro. |
| 3 | AuthLandingScreen | `/auth` | — | Entry: choose OTP / email / social. |
| 4 | RegisterScreen | `/auth/register` | `POST /auth/register` | Email+password signup. |
| 5 | OtpVerificationScreen | `/auth/otp?phone=&email=` | `POST /auth/login/otp`, `POST /auth/verify/otp` | Phone OTP login/register. |
| 6 | EmailLoginScreen | `/auth/email-login` | `POST /auth/login/email` | |
| 7 | OAuthSignupDetailsScreen | `/auth/oauth/signup` | `POST /auth/oauth/signup` | Social phase 2 (takes `OAuthNewUser` extra). See [social login flow](../flows/social-login.md). |
| 8 | ForgotPasswordScreen | `/auth/forgot-password` | `POST /auth/password/reset/request` | |
| 9 | ResetPasswordScreen | `/auth/reset-password?token=` | `POST /auth/password/reset/confirm` | Deep-linked from email. |
| 10 | EmailVerificationPendingScreen | `/auth/email-verification-pending?email=` | verification status | |
| 11 | EmailVerifySuccessScreen | `/auth/email-verified?token=` | `POST /auth/verify/email` | Deep-linked. |

# Notes
Social login (Google via `google_sign_in`→idToken; Discord via `flutter_web_auth_2`→code) calls
`POST /auth/oauth/:provider/verify`; a new identity routes to screen #7. Two auth sessions (player/admin)
drive the [router guard](../systems/navigation-routing.md). See [Onboarding & Auth flow](../flows/onboarding-and-auth.md).
</content>
