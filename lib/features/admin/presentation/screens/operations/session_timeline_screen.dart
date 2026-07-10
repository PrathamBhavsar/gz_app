import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_session_timeline.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_session_timeline_notifier.dart';
import 'end_session_sheet.dart';
import 'extend_session_sheet.dart';

/// Full session detail with the shared event timeline — the common
/// "open a session" destination from both the system view and the
/// store-wide Session Management feed.
class SessionTimelineScreen extends ConsumerWidget {
  const SessionTimelineScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminSessionTimelineNotifierProvider(id));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Session'),
      body: state.when(
        loading: () => const GzLoadingView(message: 'Loading session'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminSessionTimelineNotifierProvider(id).notifier).refresh(),
        ),
        data: (data) => _SessionTimelineContent(id: id, session: data.session, logs: data.logs),
      ),
    );
  }
}

class _SessionTimelineContent extends ConsumerWidget {
  const _SessionTimelineContent({
    required this.id,
    required this.session,
    required this.logs,
  });

  final String id;
  final SessionModel session;
  final List<SessionLogModel> logs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLive = session.status?.name == 'inProgress';

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: () =>
            ref.read(adminSessionTimelineNotifierProvider(id).notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            GzCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.systemName ?? session.systemId ?? 'System',
                          style: AppTypography.h2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          session.userName ??
                              session.walkInPhone ??
                              'Walk-in player',
                          style: AppTypography.bodyR,
                        ),
                        if (session.userPhone != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            session.userPhone!,
                            style: AppTypography.small.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  GzTag(
                    kind: _statusKind(session.status?.name),
                    label: _statusLabel(session.status?.name),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GzCard(
              child: Column(
                children: [
                  GzMetaRow(
                    label: 'Booked at',
                    value: _dateTimeLabel(session.bookedAt),
                  ),
                  GzMetaRow(
                    label: 'Started',
                    value: _dateTimeLabel(session.startedAt),
                  ),
                  GzMetaRow(
                    label: 'Ended',
                    value: _dateTimeLabel(session.endedAt),
                  ),
                  GzMetaRow(
                    label: 'Duration',
                    value: _durationLabel(session.durationMinutes),
                  ),
                  GzMetaRow(
                    label: 'Payment',
                    value: _paymentLabel(session),
                  ),
                ],
              ),
            ),
            if (isLive) ...[
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
                      label: 'Extend',
                      onPressed: session.id == null
                          ? null
                          : () => showExtendSessionSheet(
                              context,
                              sessionId: session.id!,
                              systemName: session.systemName ?? 'System',
                              onCompleted: () => ref
                                  .read(
                                    adminSessionTimelineNotifierProvider(
                                      id,
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
                      onPressed: session.id == null
                          ? null
                          : () => showEndSessionSheet(
                              context,
                              sessionId: session.id!,
                              systemName: session.systemName ?? 'System',
                              elapsed: _elapsedLabel(session),
                              onCompleted: () => ref
                                  .read(
                                    adminSessionTimelineNotifierProvider(
                                      id,
                                    ).notifier,
                                  )
                                  .refresh(),
                            ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Text('Timeline', style: AppTypography.small),
            const SizedBox(height: 10),
            GzCard(child: GzSessionTimeline(logs: logs)),
          ],
        ),
      ),
    );
  }
}

String _dateTimeLabel(DateTime? value) {
  if (value == null) return 'Unavailable';
  final local = value.toLocal();
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final hour = local.hour > 12
      ? local.hour - 12
      : (local.hour == 0 ? 12 : local.hour);
  final minute = local.minute.toString().padLeft(2, '0');
  final suffix = local.hour >= 12 ? 'PM' : 'AM';
  return '${months[local.month - 1]} ${local.day}, ${local.year} · $hour:$minute $suffix';
}

String _durationLabel(int? minutes) {
  if (minutes == null) return 'Open-ended';
  final hours = minutes ~/ 60;
  final rem = minutes % 60;
  if (hours == 0) return '${rem}m';
  if (rem == 0) return '${hours}h';
  return '${hours}h ${rem}m';
}

String _elapsedLabel(SessionModel session) {
  final start = session.startedAt;
  if (start == null) return _durationLabel(session.durationMinutes);
  final end = session.endedAt ?? DateTime.now();
  final diff = end.difference(start);
  final hours = diff.inHours;
  final minutes = diff.inMinutes.remainder(60);
  final seconds = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:$seconds';
}

String _paymentLabel(SessionModel session) {
  if (session.isBilled == true && session.billedAmount != null) {
    return 'Billed ₹${session.billedAmount!.toStringAsFixed(0)}';
  }
  if (session.billedAmount != null) {
    return 'Pending ₹${session.billedAmount!.toStringAsFixed(0)}';
  }
  return session.isBilled == true ? 'Billed' : 'Pending';
}

String _statusLabel(String? status) {
  switch (status) {
    case 'inProgress':
      return 'Live';
    case 'completed':
      return 'Ended';
    case 'cancelled':
      return 'Cancelled';
    case 'disputed':
      return 'Disputed';
    default:
      return 'Unknown';
  }
}

GzTagKind _statusKind(String? status) {
  switch (status) {
    case 'inProgress':
      return GzTagKind.ok;
    case 'completed':
      return GzTagKind.mute;
    case 'cancelled':
    case 'disputed':
      return GzTagKind.err;
    default:
      return GzTagKind.warn;
  }
}
