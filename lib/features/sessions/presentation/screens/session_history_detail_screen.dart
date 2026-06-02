import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_collapse.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class SessionHistoryDetailScreen extends StatelessWidget {
  const SessionHistoryDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Session receipt'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    id.isEmpty ? 'GZ-2406-4891' : id,
                    style: AppTypography.h3.copyWith(
                      fontFamily: 'GeistMono',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const GzTag(kind: GzTagKind.ok, label: 'Completed'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PC Station 03 · GameZone Koramangala',
                      style: AppTypography.h3),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: const Column(
                children: [
                  GzMetaRow(label: 'Started', value: '09:41'),
                  GzMetaRow(label: 'Ended', value: '11:48'),
                  GzMetaRow(label: 'Duration', value: '2h 07m'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                children: [
                  const GzMetaRow(label: 'Rate', value: '₹80/hr'),
                  GzMetaRow(
                    label: 'Total',
                    value: '₹1,740',
                    valueBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: const Column(
                children: [
                  GzMetaRow(label: 'Method', value: 'Cash'),
                  GzMetaRow(label: 'Status', value: 'Paid'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GzCollapse(
              title: 'Session events',
              initiallyOpen: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EventRow(time: '09:41', event: 'Session started'),
                  _EventRow(time: '11:48', event: 'Session ended'),
                ],
              ),
            ),
          ],
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
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: child,
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.time, required this.event});
  final String time;
  final String event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            time,
            style: AppTypography.small.copyWith(
              color: AppColors.textTertiary,
              fontFamily: 'GeistMono',
            ),
          ),
          const SizedBox(width: 12),
          Text(event, style: AppTypography.bodyR),
        ],
      ),
    );
  }
}
