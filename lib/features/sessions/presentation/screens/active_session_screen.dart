import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_live_dot.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_progress_bar.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/activity_hub_notifier.dart';

class ActiveSessionScreen extends ConsumerWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubState = ref.watch(activityHubNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Active Session'),
      body: SafeArea(
        top: false,
        child: hubState.when(
          loading: () => const GzLoadingView(message: 'Loading active session...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(activityHubNotifierProvider.notifier).refresh(),
          ),
          data: (data) {
            final active = data.activeSession;
            if (active == null) {
              return PageErrorDisplay(
                error: const AppPageError(
                  title: 'No active session',
                  message: 'Start or check in to a booking to see it here.',
                  icon: 'inbox',
                  kind: AppPageErrorKind.empty,
                ),
                onRetry: () => ref.read(activityHubNotifierProvider.notifier).refresh(),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusCard,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'TIME REMAINING',
                          style: AppTypography.small.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          active.remainingLabel.replaceAll(' remaining', ''),
                          style: AppTypography.h1.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'GeistMono',
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GzProgressBar(value: active.elapsedProgress),
                        const SizedBox(height: 10),
                        Text(
                          active.remainingLabel,
                          style: AppTypography.small.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusCard,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.pillBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedComputerDesk01,
                            color: AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(active.systemName, style: AppTypography.h3),
                              const SizedBox(height: 2),
                              Text(
                                'Live now',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const GzTag(kind: GzTagKind.ok, label: 'Live'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusCard,
                      ),
                    ),
                    child: Row(
                      children: [
                        const GzLiveDot(),
                        const SizedBox(width: 10),
                        Text(
                          'Session is live',
                          style: AppTypography.bodyR.copyWith(color: AppColors.ok),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GzButton(
                    label: 'View details',
                    onPressed: () => context.push(
                      AppRoutes.activeSessionDetailPath(active.sessionId),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
