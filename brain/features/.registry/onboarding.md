---
name: onboarding
description: S-02 Onboarding — 3-page PageView shown on first launch, sets hasSeenOnboarding flag
metadata:
  type: project
---

# Feature: Onboarding (S-02)

**Route**: `/onboarding`  
**Phase**: 2 (DONE — 2026-05-16)

## Files

| Layer | File |
|---|---|
| Screen | `lib/features/auth/presentation/screens/onboarding/onboarding_screen.dart` |
| Mobile layout | `lib/features/auth/presentation/widgets/onboarding_mobile_layout.dart` |
| Tablet layout | `lib/features/auth/presentation/widgets/onboarding_tablet_layout.dart` |

No notifier — onboarding is purely UI with a single `TokenStorage` write on completion.

## State

No provider. UI state (`_currentPage`) managed by `ConsumerStatefulWidget` for `PageController`.

## Logic

1. `PageController` tracks current page (0–2)
2. "Skip" or "Get Started" (last page only) → `TokenStorage.setHasSeenOnboarding()` → `context.go(AppRoutes.authLanding)`
3. "Next" advances the PageView
4. Dot indicator animates between pages

## Pages

| Index | Headline | Body |
|---|---|---|
| 0 | Book Gaming Slots | Reserve PCs, consoles, and VR rigs at your favourite venue in seconds. |
| 1 | Track Your Sessions | See live timers, session history, and billing — all in one place. |
| 2 | Earn Credits & Rewards | Collect store credits every visit and redeem them on future bookings. |

## UI

- `OnboardingScreen` — thin `StatelessWidget`, `ResponsiveBuilderWidget`
- `OnboardingMobileLayout` / `OnboardingTabletLayout` — `ConsumerStatefulWidget` (PageController)
- Cards: `EmCard(variant: tint, padding: AppSpacing.xl)` with title + body text
- Dot indicator: `AnimatedContainer` row, active dot is `20×8`, inactive is `8×8`
- CTA: `EmButtonFull("Next")` or `EmButtonFull("Get Started")` on last page
- Skip: `GestureDetector` text link top-right

## Storage

- `TokenStorage.setHasSeenOnboarding()` — writes `'gz_has_seen_onboarding'` key to secure storage
- `TokenStorage.getHasSeenOnboarding()` — read by `SplashNotifier` on launch

## API

None.
