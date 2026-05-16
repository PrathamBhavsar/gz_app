import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_analytics_provider.dart';
import '../../../../../../models/domain_analytics.dart';

/// Player Analytics — Screen 50.
/// Player segments (New/Returning) and top player minutes.
class PlayerAnalyticsScreen extends ConsumerStatefulWidget {
  const PlayerAnalyticsScreen({super.key});

  @override
  ConsumerState<PlayerAnalyticsScreen> createState() =>
      _PlayerAnalyticsScreenState();
}

class _PlayerAnalyticsScreenState
    extends ConsumerState<PlayerAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.go(AppRoutes.adminAnalytics),
        ),
        title: Text('Players', style: AppTypography.headingSmall),
      ),
      body: RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () => _load(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              _buildContent(state),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AnalyticsState<PlayerAnalyticsModel> state) {
    if (state is AnalyticsLoading<PlayerAnalyticsModel>) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }
    if (state is AnalyticsError<PlayerAnalyticsModel>) {
      return _PlayerError(onRetry: _load);
    }
    if (state is AnalyticsLoaded<PlayerAnalyticsModel>) {
      return _PlayerStatsContent(data: state.data);
    }
    return const SizedBox.shrink();
  }

  Future<void> _load() async {
    final now = DateTime.now();
    ref.read(playersProvider.notifier).load(
          dateFrom: _formatDate(now.subtract(const Duration(days: 30))),
          dateTo: _formatDate(now),
        );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _PlayerError extends StatelessWidget {
  const _PlayerError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load player analytics',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Retry', style: AppTypography.button),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Player Stats Content ─────────────────────────────────────────────────────

class _PlayerStatsContent extends StatelessWidget {
  const _PlayerStatsContent({required this.data});
  final PlayerAnalyticsModel data;

  @override
  Widget build(BuildContext context) {
    final unique = data.uniquePlayers ?? 0;
    final newPlayers = data.newPlayers ?? 0;
    final returning = data.returningPlayers ?? 0;
    final topMinutes = data.topPlayerMinutes ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Player Segments', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _SegmentCard(
              label: 'Unique',
              value: '$unique',
              icon: HugeIcons.strokeRoundedUserGroup,
              iconColor: AppColors.rose,
            ),
            const SizedBox(width: AppSpacing.sm),
            _SegmentCard(
              label: 'New',
              value: '$newPlayers',
              icon: HugeIcons.strokeRoundedUserAdd01,
              iconColor: AppColors.ok,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _SegmentCard(
              label: 'Returning',
              value: '$returning',
              icon: HugeIcons.strokeRoundedUserCircle,
              iconColor: AppColors.info,
            ),
            const SizedBox(width: AppSpacing.sm),
            _SegmentCard(
              label: 'Top Minutes',
              value: '${(topMinutes / 60).toStringAsFixed(1)}h',
              icon: HugeIcons.strokeRoundedStar,
              iconColor: AppColors.gold,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('New vs Returning', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        _RetentionBar(newPlayers: newPlayers, returning: returning),
      ],
    );
  }
}

// ─── Segment Card ─────────────────────────────────────────────────────────────

class _SegmentCard extends StatelessWidget {
  const _SegmentCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });
  final String label;
  final String value;
  final List<List<dynamic>> icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HugeIcon(icon: icon, color: iconColor, size: 20),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}

// ─── Retention Bar ────────────────────────────────────────────────────────────

class _RetentionBar extends StatelessWidget {
  const _RetentionBar({required this.newPlayers, required this.returning});
  final int newPlayers;
  final int returning;

  @override
  Widget build(BuildContext context) {
    final total = newPlayers + returning;
    final newPct =
        total > 0 ? (newPlayers / total * 100).toStringAsFixed(0) : '0';
    final retPct =
        total > 0 ? (returning / total * 100).toStringAsFixed(0) : '0';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: newPlayers > 0 ? newPlayers : 1,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.ok,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                flex: returning > 0 ? returning : 1,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.info,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label('New', '$newPlayers ($newPct%)', AppColors.ok),
              _label('Returning', '$returning ($retPct%)', AppColors.info),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text('$text: $value', style: AppTypography.bodySmall),
      ],
    );
  }
}
