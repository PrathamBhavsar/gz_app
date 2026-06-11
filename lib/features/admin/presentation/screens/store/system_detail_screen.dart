import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import 'system_management_screen.dart';

class SystemDetailScreen extends StatelessWidget {
  const SystemDetailScreen({super.key, required this.id});

  final String id;

  _SystemDetailData _resolveData() {
    if (id == 'SYS-001') {
      return const _SystemDetailData(
        name: 'PC Station 01',
        type: 'PC',
        specs: 'RTX 4090 · 32GB · 240Hz',
        status: SystemStatus.available,
        seatNumber: '01',
        baseRate: '₹80/hr',
        added: 'Jan 15, 2025',
      );
    }
    if (id == 'SYS-002') {
      return const _SystemDetailData(
        name: 'PC Station 02',
        type: 'PC',
        specs: 'RTX 4080 · 16GB · 165Hz',
        status: SystemStatus.inUse,
        seatNumber: '02',
        baseRate: '₹80/hr',
        added: 'Jan 15, 2025',
      );
    }
    if (id == 'SYS-005') {
      return const _SystemDetailData(
        name: 'Xbox Series X',
        type: 'Xbox',
        specs: 'Xbox Series X · 4K',
        status: SystemStatus.maintenance,
        seatNumber: '01',
        baseRate: '₹100/hr',
        added: 'Mar 10, 2025',
      );
    }
    // Generic fallback
    return _SystemDetailData(
      name: id,
      type: 'PC',
      specs: 'Gaming System',
      status: SystemStatus.available,
      seatNumber: '01',
      baseRate: '₹80/hr',
      added: 'Jan 2025',
    );
  }

  List<List<dynamic>> _iconForType(String type) => switch (type) {
    'PS5' => HugeIcons.strokeRoundedGameController01,
    'Xbox' => HugeIcons.strokeRoundedGameController01,
    'VR' => HugeIcons.strokeRoundedVirtualRealityVr01,
    _ => HugeIcons.strokeRoundedComputerDesk01,
  };

  @override
  Widget build(BuildContext context) {
    final data = _resolveData();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: data.name,
        trailing: GestureDetector(
          onTap: () => context.push('/admin/systems/edit/$id'),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedEdit02,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1 — Status card
                GzCard(
                  variant: data.status == SystemStatus.available
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
                              icon: _iconForType(data.type),
                              size: 32,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.name, style: AppTypography.h2),
                                Text(
                                  '${data.type} · ${data.specs}',
                                  style: AppTypography.small,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GzTag(
                        kind: data.status.tagKind,
                        label: data.status.label,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Section 2 — Current session (if inUse)
                if (data.status == SystemStatus.inUse) ...[
                  GzCard(
                    variant: CardVariant.inset,
                    padding: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('CURRENT SESSION', style: AppTypography.meta),
                        SizedBox(height: 8),
                        GzMetaRow(label: 'Player', value: 'Rahul Mehra'),
                        GzMetaRow(label: 'Started', value: '4:00 PM'),
                        GzMetaRow(label: 'Remaining', value: '57 min'),
                        GzMetaRow(label: 'Time elapsed', value: '1:22:38'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Section 3 — Today's schedule
                GzCard(
                  padding: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today's schedule", style: AppTypography.h3),
                      const SizedBox(height: 12),
                      ..._buildScheduleSlots(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Section 4 — Actions (if maintenance)
                if (data.status == SystemStatus.maintenance) ...[
                  GzCard(
                    padding: 16,
                    child: GzButton(
                      label: 'Mark as Available',
                      variant: GzButtonVariant.ghost,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Section 5 — Info
                GzCard(
                  padding: 14,
                  child: Column(
                    children: [
                      GzMetaRow(label: 'Seat number', value: data.seatNumber),
                      GzMetaRow(label: 'Base rate', value: data.baseRate),
                      GzMetaRow(label: 'Added', value: data.added),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScheduleSlots() {
    final slots = [
      _ScheduleSlot(
        time: '09:00–11:00',
        player: 'Rahul M.',
        tag: GzTag(kind: GzTagKind.ok, label: 'Paid'),
      ),
      _ScheduleSlot(
        time: '11:00–13:00',
        player: 'Priya S.',
        tag: GzTag(kind: GzTagKind.warn, label: 'Unpaid'),
      ),
      _ScheduleSlot(time: '14:00–16:00', player: null, tag: null),
    ];

    return List.generate(slots.length, (i) {
      final slot = slots[i];
      final isLast = i == slots.length - 1;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(bottom: BorderSide(color: AppColors.rule)),
        ),
        child: Row(
          children: [
            Text(slot.time, style: AppTypography.num.copyWith(fontSize: 13)),
            const SizedBox(width: 8),
            if (slot.player != null)
              Text(slot.player!, style: AppTypography.body)
            else
              Text(
                'Available',
                style: AppTypography.small.copyWith(color: AppColors.ok),
              ),
            const Spacer(),
            if (slot.tag != null) slot.tag!,
          ],
        ),
      );
    });
  }
}

class _ScheduleSlot {
  const _ScheduleSlot({
    required this.time,
    required this.player,
    required this.tag,
  });

  final String time;
  final String? player;
  final GzTag? tag;
}

class _SystemDetailData {
  const _SystemDetailData({
    required this.name,
    required this.type,
    required this.specs,
    required this.status,
    required this.seatNumber,
    required this.baseRate,
    required this.added,
  });

  final String name;
  final String type;
  final String specs;
  final SystemStatus status;
  final String seatNumber;
  final String baseRate;
  final String added;
}
