import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SessionLogsScreen extends StatefulWidget {
  const SessionLogsScreen({
    super.key,
    required this.sessionId,
    this.systemName = 'RTX 4090 · Seat 3',
    this.storeName = 'GameZone Koramangala',
    this.isLive = false,
  });

  final String sessionId;
  final String systemName;
  final String storeName;
  final bool isLive;

  static const _events = <_LogEvent>[
    _LogEvent(time: '6:01 PM', type: 'alert', title: '5-minute warning sent'),
    _LogEvent(
        time: '5:58 PM',
        type: 'activity',
        title: 'Controller disconnected briefly',
        muted: true),
    _LogEvent(
        time: '5:30 PM', type: 'alert', title: '1-hour remaining alert'),
    _LogEvent(
        time: '5:15 PM', type: 'system', title: 'High GPU load detected'),
    _LogEvent(time: '4:45 PM', type: 'system', title: 'Game launched'),
    _LogEvent(
        time: '4:32 PM', type: 'alert', title: 'Brief inactivity (4 min)'),
    _LogEvent(time: '4:12 PM', type: 'system', title: 'Application opened'),
    _LogEvent(
        time: '4:03 PM', type: 'system', title: 'System activity detected'),
    _LogEvent(
        time: '4:00 PM',
        type: 'system',
        title: 'Session started',
        isFirst: true),
  ];

  @override
  State<SessionLogsScreen> createState() => _SessionLogsScreenState();
}

class _SessionLogsScreenState extends State<SessionLogsScreen> {
  String _filter = 'All';

  static const _filters = <String>['All', 'System', 'Alerts', 'Activity'];

  List<_LogEvent> get _filteredEvents {
    if (_filter == 'All') return SessionLogsScreen._events;
    final typeKey = switch (_filter) {
      'System' => 'system',
      'Alerts' => 'alert',
      'Activity' => 'activity',
      _ => '',
    };
    return SessionLogsScreen._events
        .where((e) => e.type == typeKey)
        .toList();
  }

  Color _dotColor(_LogEvent event) {
    if (event.isFirst) return AppColors.ok;
    return switch (event.type) {
      'alert' => AppColors.warn,
      'system' => AppColors.info,
      _ => AppColors.textMuted,
    };
  }

  @override
  Widget build(BuildContext context) {
    final shortId = widget.sessionId
        .substring(0, min(8, widget.sessionId.length))
        .toUpperCase();
    final filtered = _filteredEvents;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top bar
          SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    constraints:
                        const BoxConstraints.tightFor(width: 40, height: 40),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child:
                        Text('Session events', style: AppTypography.h2),
                  ),
                  Text(
                    '#$shortId',
                    style: AppTypography.meta,
                  ),
                ],
              ),
            ),
          ),

          // System + store info pill
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${widget.systemName} · ${widget.storeName}',
              style: AppTypography.small
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),

          // Live indicator
          if (widget.isLive)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: _filters.map((f) {
                final selected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.surface,
                        border: selected
                            ? null
                            : Border.all(color: AppColors.rule),
                        borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusPill),
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

          // Event list
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
                      horizontal: 16, vertical: 12),
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
                          event.title,
                          style: AppTypography.body.copyWith(
                            color: event.muted
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                            fontWeight: event.isFirst
                                ? FontWeight.w600
                                : FontWeight.w500,
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
      ),
    );
  }
}

class _LogEvent {
  const _LogEvent({
    required this.time,
    required this.type,
    required this.title,
    this.muted = false,
    this.isFirst = false,
  });

  final String time;
  final String type;
  final String title;
  final bool muted;
  final bool isFirst;
}
