import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/domain_systems.dart';

/// Vertical event timeline for a session's log history (start → extend/pause/
/// resume → end). The single shared timeline widget used by the system
/// sessions screen, the session timeline screen, and session management.
class GzSessionTimeline extends StatelessWidget {
  const GzSessionTimeline({super.key, required this.logs});

  final List<SessionLogModel> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Text(
        'No session events yet.',
        style: AppTypography.bodyR,
      );
    }

    final sorted = [...logs]
      ..sort((a, b) {
        final aTime = a.eventAt ?? a.createdAt ?? DateTime(0);
        final bTime = b.eventAt ?? b.createdAt ?? DateTime(0);
        return aTime.compareTo(bTime);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < sorted.length; i++)
          _TimelineRow(
            log: sorted[i],
            isFirst: i == 0,
            isLast: i == sorted.length - 1,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.log,
    required this.isFirst,
    required this.isLast,
  });

  final SessionLogModel log;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _dotColor(log.eventType);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.divider),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_eventLabel(log), style: AppTypography.h3),
                  const SizedBox(height: 2),
                  Text(_eventTimeLabel(log), style: AppTypography.small),
                  if (_eventDetail(log) != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _eventDetail(log)!,
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _dotColor(String? eventType) {
  switch (eventType) {
    case 'start':
      return AppColors.ok;
    case 'end':
      return AppColors.textTertiary;
    case 'pause':
      return AppColors.warn;
    case 'resume':
      return AppColors.info;
    case 'extend':
      return AppColors.purple;
    default:
      return AppColors.textMuted;
  }
}

String _eventLabel(SessionLogModel log) {
  switch (log.eventType) {
    case 'start':
      return 'Session started';
    case 'end':
      return 'Session ended';
    case 'pause':
      return 'Paused';
    case 'resume':
      return 'Resumed';
    case 'extend':
      return 'Extended';
    default:
      return log.eventType ?? 'Event';
  }
}

String? _eventDetail(SessionLogModel log) {
  if (log.eventType == 'extend') {
    final minutes = log.metadata?['additionalMinutes'];
    if (minutes != null) return '+$minutes min';
  }
  if (log.eventType == 'end' && log.durationSeconds != null) {
    final mins = (log.durationSeconds! / 60).round();
    return 'Total duration: ${mins}m';
  }
  if (log.source != null && log.source != 'cloud') {
    return 'via ${log.source}';
  }
  return null;
}

String _eventTimeLabel(SessionLogModel log) {
  final value = log.eventAt ?? log.createdAt;
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
  return '${months[local.month - 1]} ${local.day} · $hour:$minute $suffix';
}
