import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/network/admin_live_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/admin_session_command_notifier.dart';
import '../../../application/admin_sessions_notifier.dart';
import 'end_session_sheet.dart';
import 'extend_session_sheet.dart';

class SessionManagementScreen extends ConsumerStatefulWidget {
  const SessionManagementScreen({super.key, this.systemId});

  final String? systemId;

  @override
  ConsumerState<SessionManagementScreen> createState() =>
      _SessionManagementScreenState();
}

class _SessionManagementScreenState
    extends ConsumerState<SessionManagementScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(adminLiveEventsProvider, (_, next) {
      next.whenData((_) {
        ref
            .read(adminSessionsNotifierProvider(widget.systemId).notifier)
            .refresh();
      });
    });

    final sessions = ref.watch(adminSessionsNotifierProvider(widget.systemId));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Session Management',
        onBack: () => context.go(AppRoutes.adminDashboard),
      ),
      body: sessions.when(
        loading: () => const GzLoadingView(message: 'Loading sessions'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () => ref
              .read(adminSessionsNotifierProvider(widget.systemId).notifier)
              .refresh(),
        ),
        data: (data) {
          final session = data.selectedSession;
          if (session == null) {
            return const PageErrorDisplay(error: AppPageError.empty);
          }

          ref.listen(adminSessionCommandNotifierProvider(session.id ?? ''), (
            _,
            next,
          ) {
            if (next is AdminCommandSuccess) {
              showSuccessSnackbar(context, next.message);
              ref
                  .read(adminSessionsNotifierProvider(widget.systemId).notifier)
                  .refresh();
            } else if (next is AdminCommandError) {
              showErrorSnackbar(context, ValidationException(next.message));
            }
          });

          return SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(adminSessionsNotifierProvider(widget.systemId).notifier)
                  .refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  if (data.activeSessions.isNotEmpty) ...[
                    Text('Active sessions', style: AppTypography.small),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = data.activeSessions[index];
                          final active = item.id == session.id;
                          return GestureDetector(
                            onTap: item.systemId == null
                                ? null
                                : () => context.go(
                                    '${AppRoutes.adminSessions}?systemId=${Uri.encodeComponent(item.systemId!)}',
                                  ),
                            child: GzTag(
                              kind: active ? GzTagKind.ok : GzTagKind.mute,
                              label:
                                  item.systemName ?? item.systemId ?? 'Session',
                            ),
                          );
                        },
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemCount: data.activeSessions.length,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  GzCard(
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.rose.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedGameboy,
                            color: AppColors.rose,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.systemName ??
                                    session.systemId ??
                                    'System',
                                style: AppTypography.h2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                session.userName ??
                                    session.userId ??
                                    session.walkInPhone ??
                                    'Walk-in player',
                                style: AppTypography.bodyR,
                              ),
                            ],
                          ),
                        ),
                        GzTag(
                          kind: _sessionStatusKind(session.status?.name),
                          label: _sessionStatusLabel(session.status?.name),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GzCard(
                    child: Column(
                      children: [
                        GzMetaRow(
                          label: 'Started',
                          value: _dateTimeLabel(session.startedAt),
                        ),
                        GzMetaRow(
                          label: 'Elapsed',
                          value: _elapsedLabel(session),
                        ),
                        GzMetaRow(
                          label: 'Duration',
                          value: _durationLabel(session.durationMinutes),
                        ),
                        GzMetaRow(
                          label: 'Billing',
                          value: _billingLabel(session.billedAmount),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Actions', style: AppTypography.small),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 52) / 2,
                        child: GzButton(
                          label: 'Pause',
                          variant: GzButtonVariant.ghost,
                          onPressed: session.status?.name == 'inProgress'
                              ? () => ref
                                    .read(
                                      adminSessionCommandNotifierProvider(
                                        session.id ?? '',
                                      ).notifier,
                                    )
                                    .pause()
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 52) / 2,
                        child: GzButton(
                          label: 'Extend',
                          onPressed: () => showExtendSessionSheet(
                            context,
                            sessionId: session.id ?? '',
                            systemName:
                                session.systemName ??
                                session.systemId ??
                                'System',
                            onCompleted: () => ref
                                .read(
                                  adminSessionsNotifierProvider(
                                    widget.systemId,
                                  ).notifier,
                                )
                                .refresh(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 52) / 2,
                        child: GzButton(
                          label: 'End Session',
                          variant: GzButtonVariant.dangerOutline,
                          onPressed: session.status?.name == 'inProgress'
                              ? () => showEndSessionSheet(
                                  context,
                                  sessionId: session.id ?? '',
                                  systemName:
                                      session.systemName ??
                                      session.systemId ??
                                      'System',
                                  elapsed: _elapsedLabel(session),
                                  onCompleted: () => ref
                                      .read(
                                        adminSessionsNotifierProvider(
                                          widget.systemId,
                                        ).notifier,
                                      )
                                      .refresh(),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GzButton(
                    label: 'Open full session logs',
                    variant: GzButtonVariant.ghost,
                    onPressed: session.id == null
                        ? null
                        : () => context.push(
                            AppRoutes.sessionLogsPath(session.id!),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text('Recent activity', style: AppTypography.small),
                  const SizedBox(height: 10),
                  if (data.logs.isEmpty)
                    const GzCard(
                      child: Text(
                        'No session events yet.',
                        style: AppTypography.bodyR,
                      ),
                    )
                  else
                    ...data.logs
                        .take(6)
                        .map(
                          (log) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GzCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    log.eventType ?? 'Session event',
                                    style: AppTypography.h3,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _dateTimeLabel(
                                      log.eventAt ?? log.createdAt,
                                    ),
                                    style: AppTypography.small,
                                  ),
                                ],
                              ),
                            ),
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

String _dateTimeLabel(DateTime? value) {
  if (value == null) {
    return 'Unavailable';
  }
  final monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final hour = value.hour > 12
      ? value.hour - 12
      : (value.hour == 0 ? 12 : value.hour);
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '${monthNames[value.month - 1]} ${value.day}, ${value.year} · $hour:$minute $suffix';
}

String _elapsedLabel(SessionModel session) {
  final end = session.endedAt ?? DateTime.now();
  final start = session.startedAt;
  if (start == null) {
    return _durationLabel(session.durationMinutes);
  }
  final diff = end.difference(start);
  final hours = diff.inHours;
  final minutes = diff.inMinutes.remainder(60);
  final seconds = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:$seconds';
}

String _durationLabel(int? minutes) {
  if (minutes == null) {
    return 'Open-ended';
  }
  final hours = minutes ~/ 60;
  final rem = minutes % 60;
  if (hours == 0) {
    return '${rem}m';
  }
  if (rem == 0) {
    return '${hours}h';
  }
  return '${hours}h ${rem}m';
}

String _billingLabel(double? amount) {
  if (amount == null) {
    return 'Pending';
  }
  return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
}

String _sessionStatusLabel(String? status) {
  switch (status) {
    case 'inProgress':
      return 'Live';
    case 'completed':
      return 'Ended';
    case 'cancelled':
      return 'Cancelled';
    default:
      return 'Unknown';
  }
}

GzTagKind _sessionStatusKind(String? status) {
  switch (status) {
    case 'inProgress':
      return GzTagKind.ok;
    case 'completed':
      return GzTagKind.mute;
    case 'cancelled':
      return GzTagKind.err;
    default:
      return GzTagKind.warn;
  }
}
