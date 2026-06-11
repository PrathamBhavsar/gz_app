import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_progress_bar.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class SystemPerformanceScreen extends StatelessWidget {
  const SystemPerformanceScreen({super.key});

  static const _systems = [
    _SystemCardData(
      name: 'PC Station 01',
      type: 'PC Gaming Rig',
      icon: HugeIcons.strokeRoundedComputer,
      revenue: '₹12,400',
      utilization: 78,
    ),
    _SystemCardData(
      name: 'PC Station 02',
      type: 'PC Gaming Rig',
      icon: HugeIcons.strokeRoundedComputer,
      revenue: '₹11,200',
      utilization: 72,
    ),
    _SystemCardData(
      name: 'PS5 Console 01',
      type: 'PlayStation 5',
      icon: HugeIcons.strokeRoundedGameController01,
      revenue: '₹9,800',
      utilization: 65,
    ),
    _SystemCardData(
      name: 'Xbox Series X',
      type: 'Xbox Gaming',
      icon: HugeIcons.strokeRoundedGameboy,
      revenue: '₹7,400',
      utilization: 45,
      lowUsage: true,
    ),
    _SystemCardData(
      name: 'VR Pod 01',
      type: 'VR Experience',
      icon: HugeIcons.strokeRoundedGameController02,
      revenue: '₹14,200',
      utilization: 88,
    ),
    _SystemCardData(
      name: 'PC Station 03',
      type: 'PC Gaming Rig',
      icon: HugeIcons.strokeRoundedComputer,
      revenue: '₹6,100',
      utilization: 38,
      lowUsage: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'System Performance'),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemBuilder: (context, index) => _SystemCard(data: _systems[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: _systems.length,
        ),
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.data});

  final _SystemCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.pillBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: HugeIcon(
                  icon: data.icon,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name, style: AppTypography.h3),
                    const SizedBox(height: 2),
                    Text(data.type, style: AppTypography.small),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.revenue,
                    style: AppTypography.body.copyWith(
                      fontFamily: 'GeistMono',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('revenue', style: AppTypography.small),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Utilization: ${data.utilization}%', style: AppTypography.small),
          const SizedBox(height: 4),
          GzProgressBar(
            value: data.utilization / 100,
            height: 6,
            fillColor: AppColors.surfaceTintStrong,
          ),
          if (data.lowUsage) ...[
            const SizedBox(height: 8),
            const GzTag(
              kind: GzTagKind.warn,
              label: 'Low usage - consider promotion',
            ),
          ],
        ],
      ),
    );
  }
}

class _SystemCardData {
  const _SystemCardData({
    required this.name,
    required this.type,
    required this.icon,
    required this.revenue,
    required this.utilization,
    this.lowUsage = false,
  });

  final String name;
  final String type;
  final List<List<dynamic>> icon;
  final String revenue;
  final int utilization;
  final bool lowUsage;
}
