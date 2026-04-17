import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/sessions_notifier.dart';
import '../../../../models/domain_systems.dart';

class SessionsMobileLayout extends ConsumerWidget {
  const SessionsMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionsNotifierProvider);

    if (state.isLoading && state.activeSessions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load sessions', style: AppTypography.headingMedium),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton(
              onPressed: () => ref
                  .read(sessionsNotifierProvider.notifier)
                  .refresh('placeholder'),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(sessionsNotifierProvider.notifier).refresh('placeholder'),
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Active Now', style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.md),
          if (state.activeSessions.isEmpty) ...[
            _buildEmptyState('No active sessions'),
            const SizedBox(height: AppSpacing.xl),
          ] else ...[
            ...state.activeSessions.map((s) => _buildActiveSessionCard(s)),
            const SizedBox(height: AppSpacing.xl),
          ],

          Text('History', style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.md),
          if (state.completedSessions.isEmpty)
            _buildEmptyState('No history available')
          else
            ...state.completedSessions.map((s) => _buildHistoryItem(s)),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(SessionModel session) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
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
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'System ID: ${session.systemId ?? 'N/A'}',
                    style: AppTypography.headingSmall,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'LIVE',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Time Remaining',
            style: AppTypography.bodySmall.copyWith(
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedClock01,
          color: AppColors.textSecondary,
          size: 20,
        ),
      ),
      title: Text(
        'Session ${session.id?.substring(0, 8) ?? 'Unknown'}',
        style: AppTypography.bodyLarge,
      ),
      subtitle: Text(
        session.endedAt?.toString().split('.')[0] ?? 'Time N/A',
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Text(
        '${session.durationMinutes ?? 0} mins',
        style: AppTypography.bodyMedium,
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Text(
          message,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
