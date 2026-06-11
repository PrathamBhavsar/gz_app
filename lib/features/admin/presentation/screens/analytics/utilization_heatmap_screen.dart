import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';

class UtilizationHeatmapScreen extends StatefulWidget {
  const UtilizationHeatmapScreen({super.key});

  @override
  State<UtilizationHeatmapScreen> createState() =>
      _UtilizationHeatmapScreenState();
}

class _UtilizationHeatmapScreenState extends State<UtilizationHeatmapScreen> {
  static const _filters = ['Day', 'Week'];
  static const _hours = [
    '10',
    '11',
    '12',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
  ];
  static const _rows = 12;
  static const _cols = 14;

  int _activeFilter = 0;

  double _intensity(int row, int col) {
    const base = [
      0.10,
      0.15,
      0.25,
      0.35,
      0.40,
      0.45,
      0.50,
      0.60,
      0.75,
      0.90,
      0.85,
      0.70,
      0.50,
      0.30,
    ];
    final noise = ((row * 7 + col * 13) % 11) / 30;
    final value = (base[col] + noise - 0.15).clamp(0.0, 1.0);
    return value;
  }

  Color _colorFor(double value) {
    if (value < 0.15) return AppColors.surface;
    if (value < 0.40) return AppColors.surfaceTint;
    if (value < 0.65) return AppColors.surfaceTintStrong;
    if (value < 0.85) return const Color(0xFF7BA87B);
    return AppColors.buttonBg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Utilization'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  _filters.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == _filters.length - 1 ? 0 : 8,
                    ),
                    child: _RoseChip(
                      label: _filters[index],
                      active: _activeFilter == index,
                      onTap: () => setState(() => _activeFilter = index),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Peak hour: 7 PM – 9 PM', style: AppTypography.h3),
                    SizedBox(height: 4),
                    Text(
                      '89% average occupancy',
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: AppColors.ok,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hourly occupancy', style: AppTypography.h3),
                    const SizedBox(height: 14),
                    Row(
                      children: List.generate(
                        _hours.length,
                        (index) => SizedBox(
                          width: 18,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == _hours.length - 1 ? 0 : 2,
                            ),
                            child: Text(
                              _hours[index],
                              textAlign: TextAlign.center,
                              style: AppTypography.meta.copyWith(
                                fontSize: 8,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...List.generate(
                      _rows,
                      (row) => Padding(
                        padding: EdgeInsets.only(
                          bottom: row == _rows - 1 ? 0 : 2,
                        ),
                        child: Row(
                          children: List.generate(_cols, (col) {
                            final color = _colorFor(_intensity(row, col));
                            return Padding(
                              padding: EdgeInsets.only(
                                right: col == _cols - 1 ? 0 : 2,
                              ),
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(3),
                                  border: color == AppColors.surface
                                      ? Border.all(color: AppColors.rule)
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '0%',
                          style: AppTypography.small.copyWith(fontSize: 10),
                        ),
                        const SizedBox(width: 6),
                        ...[
                          AppColors.surface,
                          AppColors.surfaceTint,
                          AppColors.surfaceTintStrong,
                          AppColors.buttonBg,
                        ].map(
                          (color) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(2),
                                border: color == AppColors.surface
                                    ? Border.all(color: AppColors.rule)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '100%',
                          style: AppTypography.small.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const _Card(
                child: Column(
                  children: [
                    GzMetaRow(label: 'Avg occupancy', value: '67%'),
                    GzMetaRow(label: 'Peak time', value: '7:00 PM'),
                    GzMetaRow(label: 'Quietest', value: '11:00 AM'),
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

class _RoseChip extends StatelessWidget {
  const _RoseChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: active ? null : Border.all(color: AppColors.rule),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.num.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.surface : AppColors.textPrimary,
          ),
        ),
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
