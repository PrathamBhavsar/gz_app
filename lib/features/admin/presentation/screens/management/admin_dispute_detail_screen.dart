import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class AdminDisputeDetailScreen extends StatefulWidget {
  const AdminDisputeDetailScreen({
    super.key,
    required this.id,
    this.playerName = 'Rahul Mehra',
    this.description = 'Overcharged for session duration',
    this.status = GzTagKind.err,
    this.statusLabel = 'Open',
  });

  final String id;
  final String playerName;
  final String description;
  final GzTagKind status;
  final String statusLabel;

  @override
  State<AdminDisputeDetailScreen> createState() =>
      _AdminDisputeDetailScreenState();
}

class _AdminDisputeDetailScreenState extends State<AdminDisputeDetailScreen> {
  String? _selectedResolution;
  final TextEditingController _notesController = TextEditingController();
  bool _resolved = false;

  static const _resolutionOptions = [
    'Full Refund',
    'Partial Refund',
    'Credit Issued',
    'Upheld',
  ];

  static const _timeline = [
    ('Dispute opened', 'Jun 02 at 3:45 PM', AppColors.err),
    ('Under review', 'Jun 02 at 5:00 PM', AppColors.warn),
    ('Pending resolution', 'Jun 03', AppColors.textMuted),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Dispute #${widget.id.toUpperCase()}',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section 1 — Status + player
                GzCard(
                  padding: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.playerName,
                              style: AppTypography.h3,
                            ),
                          ),
                          GzTag(kind: widget.status, label: widget.statusLabel),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(widget.description, style: AppTypography.bodyR),
                      const SizedBox(height: 10),
                      const GzMetaRow(label: 'Session', value: '#SES-20948'),
                      const GzMetaRow(label: 'Date', value: 'Jun 02, 2025'),
                      const GzMetaRow(label: 'Disputed', value: '₹160'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Section 2 — Timeline
                GzCard(
                  padding: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TIMELINE',
                        style: AppTypography.meta,
                      ),
                      const SizedBox(height: 12),
                      ..._timeline.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final (event, time, color) = entry.value;
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event,
                                      style: AppTypography.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(time, style: AppTypography.small),
                                  ],
                                ),
                              ],
                            ),
                            if (idx < _timeline.length - 1)
                              const Divider(
                                height: 20,
                                color: AppColors.rule,
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Section 3 — Resolve form
                GzCard(
                  padding: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resolution', style: AppTypography.h3),
                      const SizedBox(height: 12),
                      Text('Select outcome', style: AppTypography.small),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _resolutionOptions.map((option) {
                          final selected = _selectedResolution == option;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedResolution = option),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.textPrimary
                                    : AppColors.pillBg,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusPill,
                                ),
                              ),
                              child: Text(
                                option,
                                style: AppTypography.body.copyWith(
                                  color: selected
                                      ? AppColors.surface
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      Text('Admin notes', style: AppTypography.small),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.pillBg,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusLg,
                          ),
                        ),
                        child: TextField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add notes for player...',
                            hintStyle: AppTypography.bodyR,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 3,
                          style: AppTypography.bodyR,
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (_resolved) ...[
                        GzCard(
                          variant: CardVariant.tint,
                          padding: 12,
                          child: Text(
                            'Dispute resolved. Player notified.',
                            style: AppTypography.body.copyWith(
                              color: AppColors.ok,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      GzButton(
                        label: _resolved ? 'Resolved ✓' : 'Mark as Resolved',
                        variant: GzButtonVariant.primary,
                        onPressed: _selectedResolution == null
                            ? null
                            : () => setState(() => _resolved = true),
                      ),
                      if (!_resolved) ...[
                        const SizedBox(height: 8),
                        GzButton(
                          label: 'Mark as Under Review',
                          variant: GzButtonVariant.ghost,
                          onPressed: () {},
                        ),
                      ],
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
}
