import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/auth/token_storage.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    (
      title: 'Book your station',
      subtitle: 'Reserve a gaming system at your favourite zone in seconds.',
    ),
    (
      title: 'Play without limits',
      subtitle: 'Track your sessions, credits and history all in one place.',
    ),
    (
      title: 'Powered by GZ',
      subtitle: 'The fastest way to game on demand.',
    ),
  ];

  Future<void> _complete() async {
    await ref.read(tokenStorageProvider).setHasSeenOnboarding();
    if (mounted) context.go(AppRoutes.authLanding);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _complete,
                  child: Text(
                    'Skip',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceTint,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusCard,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '0${index + 1}',
                              style: AppTypography.heroMd.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          Text(
                            slide.title,
                            style: AppTypography.title,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide.subtitle,
                            style: AppTypography.bodyR,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: index == _currentPage ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? AppColors.textPrimary
                          : AppColors.rule,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GzButton(
                label: _currentPage == _slides.length - 1
                    ? 'Get started'
                    : 'Next',
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _complete();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
