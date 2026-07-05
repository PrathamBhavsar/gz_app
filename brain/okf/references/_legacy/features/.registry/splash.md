---
name: splash
description: S-01 Splash screen — auth-check on launch, routes to home / auth / onboarding
metadata:
  type: project
---

# Feature: Splash (S-01)
> IMPLEMENTED — bootstrap now uses `splashNotifierProvider`

## Reality Check
Existing files today:
- `lib/features/auth/presentation/screens/splash/splash_screen.dart`
- `lib/features/auth/application/splash_notifier.dart`

Missing today:
- `lib/features/auth/data/repositories/splash_repository.dart`
- Any splash-specific state classes or auth bootstrap provider wiring

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/auth/data/repositories/splash_repository.dart` | Thin token/bootstrap helper over `TokenStorage` | No |
| `lib/features/auth/application/splash_notifier.dart` | Startup routing state machine | Yes |

## Planned Logic
1. Read refresh token and onboarding flags from `TokenStorage`.
2. If no session exists, route to onboarding or auth landing.
3. If a session exists, validate bootstrap state through the auth layer.
4. Route to player home or admin dashboard based on authenticated user type.

## Planned Route
- `/`

## Notes
- Splash now belongs to the live Phase 1 auth/identity implementation track.
- The repository layer was intentionally folded into `AuthRepository` + secure-storage reads instead of a dedicated splash repository.
