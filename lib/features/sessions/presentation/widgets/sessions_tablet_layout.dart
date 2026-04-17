import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/sessions_notifier.dart';
import '../../../../models/domain_systems.dart';

class SessionsTabletLayout extends ConsumerWidget {
  const SessionsTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionsNotifierProvider);

    if (state.isLoading && state.activeSessions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Now', style: AppTypography.headingLarge),
                const SizedBox(height: AppSpacing.lg),
                if (state.activeSessions.isEmpty)
                  Center(
                    child: Text(
                      'No active sessions right now.',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.activeSessions.length,
                      itemBuilder: (context, index) =>
                          _buildActiveSessionCard(state.activeSessions[index]),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, color: AppColors.border),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Session History', style: AppTypography.headingLarge),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: state.completedSessions.isEmpty
                      ? Center(
                          child: Text(
                            'No history found.',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.completedSessions.length,
                          itemBuilder: (context, index) =>
                              _buildHistoryItem(state.completedSessions[index]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSessionCard(SessionModel session) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedGameboy,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'System ID: ${session.systemId ?? 'N/A'}',
                    style: AppTypography.headingMedium,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'LIVE',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Time Remaining',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            '${session.durationMinutes ?? 0} mins left',
            style: AppTypography.headingLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(SessionModel session) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                color: AppColors.textSecondary,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session ${session.id?.substring(0, 8) ?? 'Unknown'}',
                    style: AppTypography.headingSmall,
                  ),
                  Text(
                    session.endedAt?.toString().split('.')[0] ?? 'Time N/A',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${session.durationMinutes ?? 0} mins',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
