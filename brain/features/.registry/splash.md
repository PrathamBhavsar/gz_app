---
name: splash
description: S-01 Splash screen — auth-check on launch, routes to home / auth / onboarding
metadata:
  type: project
---

# Feature: Splash (S-01)

**Route**: `/`  
**Phase**: 2 (DONE — 2026-05-16)

## Files

| Layer | File |
|---|---|
| Screen | `lib/features/auth/presentation/screens/splash/splash_screen.dart` |
| Mobile layout | `lib/features/auth/presentation/widgets/splash_mobile_layout.dart` |
| Tablet layout | `lib/features/auth/presentation/widgets/splash_tablet_layout.dart` |
| Notifier + sealed state | `lib/features/auth/presentation/providers/splash_notifier.dart` |
| Repository | `lib/features/auth/data/repositories/splash_repository.dart` |

## State

`SplashState` (sealed):
- `SplashChecking` — initial, resolving
- `SplashToHome` — navigate to `/home`
- `SplashToAdmin` — navigate to `/admin/dashboard`
- `SplashToAuth` — navigate to `/auth`
- `SplashToOnboarding` — navigate to `/onboarding`

Provider: `splashNotifierProvider` (`NotifierProvider<SplashNotifier, SplashState>`)

## Logic (in SplashNotifier._resolve)

1. Read `refreshToken` from `TokenStorage`
2. If null → check `hasSeenOnboarding` → `SplashToOnboarding` or `SplashToAuth`
3. If exists → call `authNotifierProvider.checkAuthStatus()` (ApiClient handles 401→refresh→retry)
4. `AuthAuthenticated` → check userType → `SplashToHome` or admin path
5. `AuthError(NetworkException)` → offline, trust tokens → `SplashToHome`
6. Other error → clear tokens → `SplashToAuth` or `SplashToOnboarding`

## UI

`SplashScreen` — thin `StatelessWidget`, `ResponsiveBuilderWidget`  
Layouts — `ConsumerWidget` with `ref.listen(splashNotifierProvider)` for navigation  
Visual: centered `EmGzLogo` + `EmLiveDot` on `AppColors.background`

## Dependencies

- `splashRepositoryProvider` → wraps `TokenStorage` (getRefreshToken, getHasSeenOnboarding, getUserType)
- `authNotifierProvider` — validates session and populates user object
- `adminAuthNotifierProvider` — validates admin session
- `tokenStorageProvider` — clearAll on auth failure

## API

None called directly (delegated to `authNotifierProvider.checkAuthStatus()`)
