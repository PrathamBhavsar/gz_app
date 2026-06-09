import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_collapse.dart';
import '../../../../shared/widgets/gz_live_dot.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_progress_bar.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/session_runtime_providers.dart';

class ActiveSessionDetailScreen extends ConsumerStatefulWidget {
  const ActiveSessionDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ActiveSessionDetailScreen> createState() =>
      _ActiveSessionDetailScreenState();
}

class _ActiveSessionDetailScreenState
    extends ConsumerState<ActiveSessionDetailScreen> {
  int _logFilterIndex = 0;
  final _logFilters = ['All', 'System', 'Alerts', 'Activity'];

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionDetailStateNotifierProvider(widget.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: session.when(
        loading: () => const SafeArea(
          child: GzLoadingView(message: 'Loading live session...'),
        ),
        error: (error, _) => SafeArea(
          child: PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref
                .read(activeSessionDetailStateNotifierProvider(widget.id).notifier)
                .refresh(),
          ),
        ),
        data: (sessionData) {
          final filteredEvents = [
            for (final event in sessionData.events)
              if (_logFilters[_logFilterIndex] == 'All' ||
                  event.category == _logFilters[_logFilterIndex])
                event,
          ];

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: GzTopBar(
              title: 'Live session',
              subtitle: sessionData.storeName,
            ),
            body: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.all(20),
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
                          formatRemaining(sessionData.remaining),
                          style: AppTypography.h1.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'GeistMono',
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${formatElapsed(sessionData.elapsed)} elapsed',
                          style: AppTypography.small.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GzProgressBar(value: sessionData.elapsedProgress),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(sessionData.elapsedProgress * 100).round()}% elapsed',
                              style: AppTypography.small.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'ID: ${sessionData.sessionCode}',
                              style: AppTypography.small.copyWith(
                                color: AppColors.textTertiary,
                                fontFamily: 'GeistMono',
                              ),
                            ),
                          ],
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
                              Text(sessionData.systemName, style: AppTypography.h3),
                              const SizedBox(height: 2),
                              Text(
                                sessionData.storeName,
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const GzTag(kind: GzTagKind.ok, label: 'Active'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GzCollapse(
                    title: 'Session events',
                    initiallyOpen: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _logFilters.length,
                            separatorBuilder: (_, index) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, i) => GzChip(
                              label: _logFilters[i],
                              active: _logFilterIndex == i,
                              onTap: () => setState(() => _logFilterIndex = i),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (final event in filteredEvents)
                          _EventRow(time: event.time, event: event.event),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.sessionLogsPath(widget.id)),
                    child: GzCard(
                      padding: 12,
                      child: Row(
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedListView,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text('Session events', style: AppTypography.body),
                          ),
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowRight01,
                            size: 16,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.time, required this.event});
  final String time;
  final String event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            time,
            style: AppTypography.small.copyWith(
              color: AppColors.textTertiary,
              fontFamily: 'GeistMono',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(event, style: AppTypography.bodyR)),
        ],
      ),
    );
  }
}
