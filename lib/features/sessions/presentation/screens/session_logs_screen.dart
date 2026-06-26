import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/session_runtime_providers.dart';

class SessionLogsScreen extends ConsumerStatefulWidget {
  const SessionLogsScreen({
    super.key,
    required this.sessionId,
    this.systemName = 'Session',
    this.storeName = 'Gaming Zone',
    this.isLive = false,
  });

  final String sessionId;
  final String systemName;
  final String storeName;
  final bool isLive;

  @override
  ConsumerState<SessionLogsScreen> createState() => _SessionLogsScreenState();
}

class _SessionLogsScreenState extends ConsumerState<SessionLogsScreen> {
  String _filter = 'All';

  static const _filters = <String>['All', 'System', 'Alerts', 'Activity'];

  Color _dotColor(SessionEventLogEntry event) {
    return switch (event.category) {
      'Alerts' => AppColors.warn,
      'System' => AppColors.info,
      _ => AppColors.textMuted,
    };
  }

  @override
  Widget build(BuildContext context) {
    final shortId = widget.sessionId
        .substring(0, min(8, widget.sessionId.length))
        .toUpperCase();
    final logs = ref.watch(sessionLogsNotifierProvider(widget.sessionId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: logs.when(
        loading: () => const SafeArea(
          child: GzLoadingView(message: 'Loading session events...'),
        ),
        error: (error, _) => SafeArea(
          child: PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref
                .read(sessionLogsNotifierProvider(widget.sessionId).notifier)
                .refresh(),
          ),
        ),
        data: (items) {
          final filtered = [
            for (final item in items)
              if (_filter == 'All' || item.category == _filter) item,
          ];

          if (filtered.isEmpty) {
            return SafeArea(
              child: PageErrorDisplay(
                error: const AppPageError(
                  title: 'No session events yet',
                  message: 'This session does not have any event logs to show.',
                  icon: 'inbox',
                  kind: AppPageErrorKind.empty,
                ),
              ),
            );
          }

          return Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 40,
                          height: 40,
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Session events', style: AppTypography.h2),
                      ),
                      Text('#$shortId', style: AppTypography.meta),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.pillBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.systemName} · ${widget.storeName}',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (widget.isLive)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.ok,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Updating live',
                        style: AppTypography.small.copyWith(
                          color: AppColors.ok,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: _filters.map((f) {
                    final selected = _filter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.textPrimary
                                : AppColors.surface,
                            border: selected
                                ? null
                                : Border.all(color: AppColors.rule),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusPill,
                            ),
                          ),
                          child: Text(
                            f,
                            style: AppTypography.small.copyWith(
                              color: selected
                                  ? AppColors.surface
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: 1, color: AppColors.rule),
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.rule,
                  ),
                  itemBuilder: (context, index) {
                    final event = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              event.time,
                              style: AppTypography.small.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: _dotColor(event),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              event.event,
                              style: AppTypography.body.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
