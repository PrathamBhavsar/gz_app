import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class DisputesListScreen extends StatefulWidget {
  const DisputesListScreen({super.key});

  @override
  State<DisputesListScreen> createState() => _DisputesListScreenState();
}

class _DisputesListScreenState extends State<DisputesListScreen> {
  static const List<_DisputeItem> _allDisputes = [
    _DisputeItem(
      id: 'DIS-001',
      title: 'Overcharged for session',
      subtitle: 'GameZone Koramangala · Jun 02',
      tagKind: GzTagKind.err,
      tagLabel: 'Open',
      filter: 'Open',
    ),
    _DisputeItem(
      id: 'DIS-002',
      title: 'Credits not applied',
      subtitle: 'GameZone Indiranagar · May 28',
      tagKind: GzTagKind.warn,
      tagLabel: 'In Review',
      filter: 'In Review',
    ),
    _DisputeItem(
      id: 'DIS-003',
      title: 'System not working',
      subtitle: 'GameZone Whitefield · May 15',
      tagKind: GzTagKind.ok,
      tagLabel: 'Resolved',
      filter: 'Resolved',
    ),
  ];

  final List<String> _filters = const ['All', 'Open', 'In Review', 'Resolved'];
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final activeFilter = _filters[_selectedFilter];
    final visibleDisputes = activeFilter == 'All'
        ? _allDisputes
        : _allDisputes.where((item) => item.filter == activeFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'My disputes',
        trailing: GzIconBtn(
          tooltip: 'Create dispute',
          onTap: () => context.push(AppRoutes.disputeCreate),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedPlusSign,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GzChip(
                  label: _filters[index],
                  active: _selectedFilter == index,
                  onTap: () => setState(() => _selectedFilter = index),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSpacing.sm),
                itemCount: _filters.length,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemBuilder: (context, index) {
                  final dispute = visibleDisputes[index];
                  return _DisputeCard(dispute: dispute);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemCount: visibleDisputes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisputeCard extends StatelessWidget {
  const _DisputeCard({required this.dispute});

  final _DisputeItem dispute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.disputeDetailPath(dispute.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dispute.title, style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.xs),
                  Text(dispute.subtitle, style: AppTypography.small),
                  const SizedBox(height: AppSpacing.sm),
                  GzTag(kind: dispute.tagKind, label: dispute.tagLabel),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _DisputeItem {
  const _DisputeItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tagKind,
    required this.tagLabel,
    required this.filter,
  });

  final String id;
  final String title;
  final String subtitle;
  final GzTagKind tagKind;
  final String tagLabel;
  final String filter;
}
