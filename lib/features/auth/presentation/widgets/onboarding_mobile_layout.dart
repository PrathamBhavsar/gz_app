import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/auth/token_storage.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';

class _OnboardingPage {
  final String headline;
  final String body;
  const _OnboardingPage({required this.headline, required this.body});
}

const _pages = [
  _OnboardingPage(
    headline: 'Book Gaming Slots',
    body: 'Reserve PCs, consoles, and VR rigs at your favourite venue in seconds.',
  ),
  _OnboardingPage(
    headline: 'Track Your Sessions',
    body: 'See live timers, session history, and billing — all in one place.',
  ),
  _OnboardingPage(
    headline: 'Earn Credits & Rewards',
    body: 'Collect store credits every visit and redeem them on future bookings.',
  ),
];

final _onboardingPageProvider = StateProvider.autoDispose<int>((ref) => 0);

class OnboardingMobileLayout extends ConsumerStatefulWidget {
  const OnboardingMobileLayout({super.key});

  @override
  ConsumerState<OnboardingMobileLayout> createState() =>
      _OnboardingMobileLayoutState();
}

class _OnboardingMobileLayoutState
    extends ConsumerState<OnboardingMobileLayout> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(tokenStorageProvider).setHasSeenOnboarding();
    if (mounted) context.go(AppRoutes.authLanding);
  }

  void _onPageChanged(int index) =>
      ref.read(_onboardingPageProvider.notifier).state = index;

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(_onboardingPageProvider);
    return SafeArea(
      child: Column(
        children: [
          // Skip link row
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                right: AppSpacing.md,
              ),
              child: GestureDetector(
                onTap: _finish,
                child: Text(
                  'Skip',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),

          // Page content
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, i) {
                final page = _pages[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: GzCard(
                    variant: CardVariant.tint,
                    padding: AppSpacing.xl,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(page.headline, style: AppTypography.title)
                            .animate()
                            .fadeIn(duration: 220.ms)
                            .slideY(begin: 0.05, end: 0, duration: 220.ms),
                        const SizedBox(height: AppSpacing.md),
                        Text(page.body, style: AppTypography.bodyR)
                            .animate(delay: 60.ms)
                            .fadeIn(duration: 220.ms),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Dot indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (i) {
              final active = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                width: active ? 20 : AppSpacing.sm,
                height: AppSpacing.sm,
                decoration: BoxDecoration(
                  color: active ? AppColors.buttonBg : AppColors.rule,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
                ),
              );
            }),
          ),

          // CTA row
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.xxl,
            ),
            child: currentPage == _pages.length - 1
                ? GzButton(label: 'Get Started', onPressed: _finish)
                : GzButton(
                    label: 'Next',
                    onPressed: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
