import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_progress_bar.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class SessionStatisticsScreen extends StatelessWidget {
  const SessionStatisticsScreen({super.key});

  static const _kpis = [
    _KpiData(
      label: 'Avg Duration',
      value: '87 min',
      icon: HugeIcons.strokeRoundedClock01,
      accent: AppColors.info,
    ),
    _KpiData(
      label: 'Completion',
      value: '94%',
      icon: HugeIcons.strokeRoundedCheckmarkCircle01,
      accent: AppColors.ok,
    ),
    _KpiData(
      label: 'Walk-ins',
      value: '34',
      icon: HugeIcons.strokeRoundedGameboy,
      accent: AppColors.rose,
    ),
    _KpiData(
      label: 'Bookings',
      value: '108',
      icon: HugeIcons.strokeRoundedCalendar03,
      accent: AppColors.textTertiary,
    ),
  ];
  static const _sessions = [
    _SessionRow(
      title: 'Rahul M. · PC Station 01',
      duration: '2h 10m',
      tag: GzTagKind.ok,
      tagLabel: 'Completed',
    ),
    _SessionRow(
      title: 'Priya S. · PS5 Console',
      duration: '1h 30m',
      tag: GzTagKind.ok,
      tagLabel: 'Completed',
    ),
    _SessionRow(
      title: 'Amit K. · Xbox Series X',
      duration: '0h 45m',
      tag: GzTagKind.warn,
      tagLabel: 'Early end',
    ),
    _SessionRow(
      title: 'Neha R. · VR Pod 01',
      duration: '2h 00m',
      tag: GzTagKind.ok,
      tagLabel: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Session Stats'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.25,
                ),
                itemCount: _kpis.length,
                itemBuilder: (context, index) => _KpiCard(data: _kpis[index]),
              ),
              const SizedBox(height: 14),
              const _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Session types', style: AppTypography.h3),
                    SizedBox(height: 14),
                    _TypeBreakdownRow(
                      label: 'Walk-in',
                      percent: 24,
                      color: AppColors.rose,
                    ),
                    SizedBox(height: 8),
                    _TypeBreakdownRow(
                      label: 'Booking',
                      percent: 76,
                      color: AppColors.info,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent sessions', style: AppTypography.h3),
                    const SizedBox(height: 12),
                    ...List.generate(_sessions.length, (index) {
                      final item = _sessions[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: index == 0
                              ? null
                              : const Border(
                                  top: BorderSide(color: AppColors.rule),
                                ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: AppTypography.body.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.duration,
                                    style: AppTypography.small,
                                  ),
                                ],
                              ),
                            ),
                            GzTag(kind: item.tag, label: item.tagLabel),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBreakdownRow extends StatelessWidget {
  const _TypeBreakdownRow({
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.body)),
        SizedBox(
          width: 100,
          child: GzProgressBar(
            value: percent / 100,
            height: 6,
            fillColor: color,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            '$percent%',
            textAlign: TextAlign.right,
            style: AppTypography.small.copyWith(fontFamily: 'GeistMono'),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.data});

  final _KpiData data;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(icon: data.icon, color: data.accent, size: 18),
          const Spacer(),
          Text(
            data.value,
            style: AppTypography.h1.copyWith(fontFamily: 'GeistMono'),
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
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

class _KpiData {
  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final List<List<dynamic>> icon;
  final Color accent;
}

class _SessionRow {
  const _SessionRow({
    required this.title,
    required this.duration,
    required this.tag,
    required this.tagLabel,
  });

  final String title;
  final String duration;
  final GzTagKind tag;
  final String tagLabel;
}
