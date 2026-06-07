import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class DisputeResolutionScreen extends StatelessWidget {
  const DisputeResolutionScreen({super.key});

  static const _filters = ['All', 'Open', 'In Review', 'Resolved'];
  static const _disputes = [
    _DisputeData(
      id: 'DSP-001',
      name: 'Rahul Mehra',
      description: 'Overcharged for session duration',
      date: 'Jun 02, 2025',
      tag: GzTagKind.err,
      tagLabel: 'Open',
      showResolve: true,
    ),
    _DisputeData(
      id: 'DSP-002',
      name: 'Priya Singh',
      description: 'Credits not applied',
      date: 'Jun 01, 2025',
      tag: GzTagKind.warn,
      tagLabel: 'In Review',
      showResolve: true,
    ),
    _DisputeData(
      id: 'DSP-003',
      name: 'Amit Kumar',
      description: 'System not working properly',
      date: 'May 30, 2025',
      tag: GzTagKind.ok,
      tagLabel: 'Resolved',
    ),
    _DisputeData(
      id: 'DSP-004',
      name: 'Neha Reddy',
      description: 'Booking cancelled, no refund',
      date: 'May 28, 2025',
      tag: GzTagKind.err,
      tagLabel: 'Open',
      showResolve: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Disputes'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: List.generate(
                  _filters.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == _filters.length - 1 ? 0 : 8,
                    ),
                    child: GzChip(label: _filters[index], active: index == 0),
                  ),
                ),
              ),
            ),
            const Expanded(child: _DisputeList(disputes: _disputes)),
          ],
        ),
      ),
    );
  }
}

class _DisputeList extends StatelessWidget {
  const _DisputeList({required this.disputes});

  final List<_DisputeData> disputes;

  @override
  Widget build(BuildContext context) {
    return GzScrollContent(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: disputes
              .map(
                (dispute) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _DisputeCard(dispute: dispute),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _DisputeCard extends StatelessWidget {
  const _DisputeCard({required this.dispute});

  final _DisputeData dispute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/admin/disputes/${dispute.id}'),
      child: GzCard(
        padding: 14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(dispute.name, style: AppTypography.h3)),
                GzTag(kind: dispute.tag, label: dispute.tagLabel),
              ],
            ),
            const SizedBox(height: 4),
            Text(dispute.description, style: AppTypography.small),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(dispute.date, style: AppTypography.small),
                const Spacer(),
                if (dispute.showResolve)
                  SizedBox(
                    width: 116,
                    child: GzButton(
                      label: 'Resolve →',
                      variant: GzButtonVariant.ghost,
                      small: true,
                      onPressed: () =>
                          context.push('/admin/disputes/${dispute.id}'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DisputeData {
  const _DisputeData({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.tag,
    required this.tagLabel,
    this.showResolve = false,
  });

  final String id;
  final String name;
  final String description;
  final String date;
  final GzTagKind tag;
  final String tagLabel;
  final bool showResolve;
}
