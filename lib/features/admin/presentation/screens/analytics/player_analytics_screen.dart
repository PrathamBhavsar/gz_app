import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_analytics.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_analytics_notifier.dart';

class PlayerAnalyticsScreen extends ConsumerWidget {
  const PlayerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Players'),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminPlayerAnalyticsNotifierProvider)
            .when(
              loading: () =>
                  const GzLoadingView(message: 'Loading player data'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(adminPlayerAnalyticsNotifierProvider.notifier)
                    .refresh(),
              ),
              data: (players) => _Body(players: players),
            ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.players});

  final PlayerAnalyticsModel players;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Player segments', style: AppTypography.h3),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _SegmentCell(
                        value: '${players.newPlayers ?? 0}',
                        label: 'New',
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                      height: 40,
                      child: ColoredBox(color: AppColors.rule),
                    ),
                    Expanded(
                      child: _SegmentCell(
                        value: '${players.returningPlayers ?? 0}',
                        label: 'Returning',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              children: [
                GzMetaRow(
                  label: 'Total unique players',
                  value: '${players.uniquePlayers ?? 0}',
                ),
                GzMetaRow(
                  label: 'New players',
                  value: '${players.newPlayers ?? 0}',
                ),
                GzMetaRow(
                  label: 'Returning players',
                  value: '${players.returningPlayers ?? 0}',
                ),
                if (players.topPlayerMinutes != null)
                  GzMetaRow(
                    label: 'Top player minutes',
                    value: '${players.topPlayerMinutes} min',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentCell extends StatelessWidget {
  const _SegmentCell({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.h1.copyWith(fontFamily: 'GeistMono'),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.small),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
