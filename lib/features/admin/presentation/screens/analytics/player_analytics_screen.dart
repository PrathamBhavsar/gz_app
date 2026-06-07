import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';

class PlayerAnalyticsScreen extends StatelessWidget {
  const PlayerAnalyticsScreen({super.key});

  static const _players = [
    _PlayerRow(letter: 'R', name: 'Rahul Mehra', minutes: '420 min', index: 0),
    _PlayerRow(letter: 'P', name: 'Priya Singh', minutes: '380 min', index: 1),
    _PlayerRow(letter: 'A', name: 'Amit Kumar', minutes: '310 min', index: 2),
    _PlayerRow(letter: 'N', name: 'Neha Reddy', minutes: '290 min', index: 3),
    _PlayerRow(letter: 'S', name: 'Suresh V.', minutes: '245 min', index: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Players'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Player segments', style: AppTypography.h3),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _SegmentCell(
                            value: '68',
                            label: 'New',
                          ),
                        ),
                        SizedBox(
                          width: 1,
                          height: 40,
                          child: ColoredBox(color: AppColors.rule),
                        ),
                        Expanded(
                          child: _SegmentCell(
                            value: '74',
                            label: 'Returning',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Top players · minutes', style: AppTypography.h3),
                    const SizedBox(height: 12),
                    ...List.generate(_players.length, (index) {
                      final player = _players[index];
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
                            SizedBox(
                              width: 20,
                              child: Text(
                                '${index + 1}',
                                textAlign: TextAlign.center,
                                style: AppTypography.body.copyWith(
                                  fontFamily: 'GeistMono',
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GzAvatar(
                              letter: player.letter,
                              index: player.index,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                player.name,
                                style: AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              player.minutes,
                              style: AppTypography.small.copyWith(
                                fontFamily: 'GeistMono',
                              ),
                            ),
                            const SizedBox(width: 8),
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowRight01,
                              color: AppColors.textTertiary,
                              size: 14,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const _Card(
                child: Column(
                  children: [
                    GzMetaRow(label: 'Total players', value: '142'),
                    GzMetaRow(label: 'Active today', value: '28'),
                    GzMetaRow(label: 'Avg sessions/player', value: '2.3'),
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

class _SegmentCell extends StatelessWidget {
  const _SegmentCell({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.h1.copyWith(fontFamily: 'GeistMono')),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.small),
      ],
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

class _PlayerRow {
  const _PlayerRow({
    required this.letter,
    required this.name,
    required this.minutes,
    required this.index,
  });

  final String letter;
  final String name;
  final String minutes;
  final int index;
}
