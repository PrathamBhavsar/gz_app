---
name: splash
description: S-01 Splash screen — auth-check on launch, routes to home / auth / onboarding
metadata:
  type: project
---

# Feature: Splash (S-01)
> TARGET SPEC — not yet implemented

## Reality Check
Existing files today:
- `lib/features/auth/presentation/screens/splash/splash_screen.dart`

Missing today:
- `lib/features/auth/data/repositories/splash_repository.dart`
- `lib/features/auth/application/splash_notifier.dart`
- Any splash-specific state classes or auth bootstrap provider wiring

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/auth/data/repositories/splash_repository.dart` | Thin token/bootstrap helper over `TokenStorage` | No |
| `lib/features/auth/application/splash_notifier.dart` | Startup routing state machine | No |

## Planned Logic
1. Read refresh token and onboarding flags from `TokenStorage`.
2. If no session exists, route to onboarding or auth landing.
3. If a session exists, validate bootstrap state through the auth layer.
4. Route to player home or admin dashboard based on authenticated user type.

## Planned Route
- `/`

## Notes
- This registry was previously claiming a completed splash notifier and repository that do not exist in `lib/`.
- Splash belongs to the broader Phase 1 auth/identity implementation track even though the screen file already exists.
