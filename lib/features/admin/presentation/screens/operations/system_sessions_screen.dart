import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/network/admin_live_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_activity.dart';
import '../../../../../shared/widgets/gz_activity_card.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_session_timeline.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_operations_models.dart';
import '../../../application/admin_system_sessions_notifier.dart';
import 'end_session_sheet.dart';
import 'extend_session_sheet.dart';

/// Dedicated per-system operations view: opened by tapping a system tile on
/// the dashboard. Shows the live/last session, incoming bookings, and past
/// 7 days of sessions for this one system.
class SystemSessionsScreen extends ConsumerWidget {
  const SystemSessionsScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(adminLiveEventsProvider, (_, next) {
      next.whenData((_) {
        ref.read(adminSystemSessionsNotifierProvider(id).notifier).refresh();
      });
    });

    final state = ref.watch(adminSystemSessionsNotifierProvider(id));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'System Sessions'),
      body: state.when(
        loading: () => const GzLoadingView(message: 'Loading system sessions'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminSystemSessionsNotifierProvider(id).notifier).refresh(),
        ),
        data: (data) => _SystemSessionsContent(id: id, data: data),
      ),
    );
  }
}

class _SystemSessionsContent extends ConsumerWidget {
  const _SystemSessionsContent({required this.id, required this.data});

  final String id;
  final AdminSystemSessionsData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final system = data.system;
    final current = data.current;

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: () =>
            ref.read(adminSystemSessionsNotifierProvider(id).notifier).refresh(),
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
                        Text(system.name ?? 'System', style: AppTypography.h2),
                        const SizedBox(height: 4),
                        Text(
                          [
                                data.liveStatus?.systemTypeName,
                                system.platform?.name.toUpperCase(),
                                if (system.stationNumber != null)
                                  'Seat ${system.stationNumber}',
                              ]
                              .whereType<String>()
                              .where((s) => s.isNotEmpty)
                              .join(' · '),
                          style: AppTypography.bodyR,
                        ),
                      ],
                    ),
                  ),
                  GzTag(
                    kind: data.isLive ? GzTagKind.ok : GzTagKind.mute,
                    label: data.isLive ? 'Live' : 'Idle',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (current != null) ...[
              Text('Current session', style: AppTypography.small),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: current.id == null
                    ? null
                    : () => context.push(
                        AppRoutes.adminSessionDetailPath(current.id!),
                      ),
                child: GzCard(
                  variant: CardVariant.tint,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.ok.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const HugeIcon(
                              icon: HugeIcons.strokeRoundedGameboy,
                              color: AppColors.ok,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              current.userName ??
                                  current.walkInPhone ??
                                  'Walk-in player',
                              style: AppTypography.h3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GzMetaRow(
                        label: 'Started',
                        value: _dateTimeLabel(current.startAt),
                      ),
                      GzMetaRow(label: 'Elapsed', value: _elapsedLabel(current)),
                      GzMetaRow(
                        label: 'Billing',
                        value: _billingLabel(current),
                      ),
                    ],
                  ),
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
                      label: 'Extend',
                      onPressed: current.id == null
                          ? null
                          : () => showExtendSessionSheet(
                              context,
                              sessionId: current.id!,
                              systemName: system.name ?? id,
                              onCompleted: () {
                                if (!context.mounted) return;
                                ref
                                    .read(
                                      adminSystemSessionsNotifierProvider(
                                        id,
                                      ).notifier,
                                    )
                                    .refresh();
                              },
                            ),
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 52) / 2,
                    child: GzButton(
                      label: 'End Session',
                      variant: GzButtonVariant.dangerOutline,
                      onPressed: current.id == null
                          ? null
                          : () => showEndSessionSheet(
                              context,
                              sessionId: current.id!,
                              systemName: system.name ?? id,
                              elapsed: _elapsedLabel(current),
                              onCompleted: () {
                                if (!context.mounted) return;
                                ref
                                    .read(
                                      adminSystemSessionsNotifierProvider(
                                        id,
                                      ).notifier,
                                    )
                                    .refresh();
                              },
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Timeline', style: AppTypography.small),
              const SizedBox(height: 10),
              GzCard(child: GzSessionTimeline(logs: data.currentLogs)),
              const SizedBox(height: 20),
            ] else ...[
              const SizedBox(height: 4),
              const GzCard(
                child: Text(
                  'No active session on this system right now.',
                  style: AppTypography.bodyR,
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text('Incoming', style: AppTypography.small),
            const SizedBox(height: 10),
            if (data.incoming.isEmpty)
              const GzCard(
                child: Text('No upcoming bookings.', style: AppTypography.bodyR),
              )
            else
              ...data.incoming.map(
                (item) => GzActivityCard(item: item, onTap: null),
              ),
            const SizedBox(height: 20),
            Text('Past 7 days', style: AppTypography.small),
            const SizedBox(height: 10),
            if (data.past.isEmpty)
              const GzCard(
                child: Text('No sessions in the past week.', style: AppTypography.bodyR),
              )
            else
              ...data.past.map(
                (item) => GzActivityCard(
                  item: item,
                  onTap: item.id == null
                      ? null
                      : () =>
                          context.push(AppRoutes.adminSessionDetailPath(item.id!)),
                ),
              ),
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

String _elapsedLabel(AdminActivityItem session) {
  final start = session.startAt;
  if (start == null) return 'Unknown';
  final end = session.endAt ?? DateTime.now();
  final diff = end.difference(start);
  final hours = diff.inHours;
  final minutes = diff.inMinutes.remainder(60);
  final seconds = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:$seconds';
}

String _billingLabel(AdminActivityItem session) {
  if (session.isBilled == true && session.billedAmount != null) {
    return '₹${session.billedAmount!.toStringAsFixed(0)} billed';
  }
  if (session.amount != null) {
    return session.isPaid == true
        ? '₹${session.amount!.toStringAsFixed(0)} paid'
        : '₹${session.amount!.toStringAsFixed(0)} pending';
  }
  return 'Pending';
}
