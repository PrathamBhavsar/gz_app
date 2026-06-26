import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_store_models.dart';
import '../../../application/admin_system_detail_notifier.dart';
import 'regenerate_system_key_sheet.dart';

class SystemDetailScreen extends ConsumerWidget {
  const SystemDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(adminSystemDetailNotifierProvider(id));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'System Detail',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => showRegenerateSystemKeySheet(
                context,
                systemId: id,
                systemName: id,
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedKey01,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: () => context.push(AppRoutes.adminEditSystemPath(id)),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedEdit02,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: detailState.when(
          loading: () => const GzLoadingView(message: 'Loading system detail'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref
                .read(adminSystemDetailNotifierProvider(id).notifier)
                .refresh(),
          ),
          data: (data) => _SystemDetailContent(data: data, id: id),
        ),
      ),
    );
  }
}

class _SystemDetailContent extends StatelessWidget {
  const _SystemDetailContent({required this.data, required this.id});

  final String id;
  final AdminSystemDetailData data;

  @override
  Widget build(BuildContext context) {
    final detail = data.system;
    final liveStatus = data.liveStatus;
    final status = liveStatus?.status ?? detail.status?.name;
    final currentSession = liveStatus?.currentSession;
    final systemName = detail.name ?? id;

    return GzScrollContent(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GzCard(
              variant: status == 'available'
                  ? CardVariant.tint
                  : CardVariant.base,
              padding: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.pillBg,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusLg,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: HugeIcon(
                          icon: _iconForPlatform(detail.platform),
                          size: 32,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(detail.name ?? id, style: AppTypography.h2),
                            Text(
                              [
                                    liveStatus?.systemTypeName ??
                                        detail.systemTypeId,
                                    detail.platform?.name.toUpperCase(),
                                    if (detail.stationNumber != null)
                                      'Seat ${detail.stationNumber}',
                                  ]
                                  .whereType<String>()
                                  .where((item) => item.isNotEmpty)
                                  .join(' · '),
                              style: AppTypography.small,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GzTag(kind: _tagKind(status), label: _statusLabel(status)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (currentSession != null) ...[
              GzCard(
                variant: CardVariant.inset,
                padding: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CURRENT SESSION', style: AppTypography.meta),
                    const SizedBox(height: 8),
                    GzMetaRow(
                      label: 'Player',
                      value: currentSession.userName ?? 'Unknown',
                    ),
                    GzMetaRow(
                      label: 'Started',
                      value: _dateTimeLabel(currentSession.startedAt),
                    ),
                    GzMetaRow(
                      label: 'Duration',
                      value: currentSession.durationMinutes == null
                          ? 'Unknown'
                          : '${currentSession.durationMinutes} min',
                    ),
                    GzMetaRow(
                      label: 'Session ID',
                      value: currentSession.sessionId ?? 'Unavailable',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            GzCard(
              padding: 14,
              child: Column(
                children: [
                  GzMetaRow(
                    label: 'Seat number',
                    value: detail.stationNumber?.toString() ?? 'Unknown',
                  ),
                  GzMetaRow(label: 'System ID', value: detail.id ?? id),
                  GzMetaRow(
                    label: 'Platform',
                    value: detail.platform?.name.toUpperCase() ?? 'Unknown',
                  ),
                  GzMetaRow(
                    label: 'Type',
                    value:
                        liveStatus?.systemTypeName ??
                        detail.systemTypeId ??
                        'Unknown',
                  ),
                  if (liveStatus?.lastHeartbeatAt != null)
                    GzMetaRow(
                      label: 'Last heartbeat',
                      value: _dateTimeLabel(liveStatus?.lastHeartbeatAt),
                    ),
                  if (detail.createdAt != null)
                    GzMetaRow(
                      label: 'Added',
                      value: _dateTimeLabel(detail.createdAt),
                    ),
                  if (_specsLabel(detail).isNotEmpty)
                    GzMetaRow(label: 'Specs', value: _specsLabel(detail)),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => showRegenerateSystemKeySheet(
                      context,
                      systemId: id,
                      systemName: systemName,
                    ),
                    child: const Text('Regenerate API key'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

dynamic _iconForPlatform(SystemPlatform? platform) => switch (platform) {
  SystemPlatform.ps5 => HugeIcons.strokeRoundedGameController01,
  SystemPlatform.ps4 => HugeIcons.strokeRoundedGameController01,
  SystemPlatform.xbox => HugeIcons.strokeRoundedGameController01,
  SystemPlatform.vr => HugeIcons.strokeRoundedVirtualRealityVr01,
  _ => HugeIcons.strokeRoundedComputerDesk01,
};

GzTagKind _tagKind(String? status) => switch (status) {
  'available' => GzTagKind.ok,
  'in_use' || 'inUse' => GzTagKind.info,
  'maintenance' => GzTagKind.warn,
  'offline' => GzTagKind.mute,
  _ => GzTagKind.mute,
};

String _statusLabel(String? status) => switch (status) {
  'available' => 'Available',
  'in_use' || 'inUse' => 'In Use',
  'maintenance' => 'Maintenance',
  'offline' => 'Offline',
  _ => 'Unknown',
};

String _specsLabel(SystemModel system) {
  final specs = system.specs;
  if (specs == null || specs.isEmpty) {
    return '';
  }
  final summary = specs['summary']?.toString();
  if (summary != null && summary.isNotEmpty) {
    return summary;
  }
  return specs.entries
      .take(3)
      .map((entry) => '${entry.key}: ${entry.value}')
      .join(' · ');
}

String _dateTimeLabel(DateTime? value) {
  if (value == null) {
    return 'Unavailable';
  }
  final local = value.toLocal();
  final month = [
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
  ][local.month - 1];
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.day} $month ${local.year}, ${local.hour}:$minute';
}
