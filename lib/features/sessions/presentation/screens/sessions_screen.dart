import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_live_dot.dart';
import '../../../../shared/widgets/gz_tag.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  int _filterIndex = 0;
  final _filters = ['All', 'Upcoming', 'Active', 'Past'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sessions', style: AppTypography.h1),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, index) => const SizedBox(width: 8),
                        itemBuilder: (context, i) => GzChip(
                          label: _filters[i],
                          active: _filterIndex == i,
                          onTap: () => setState(() => _filterIndex = i),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _ActiveSessionBanner(),
                    const SizedBox(height: 24),
                    Text('Upcoming', style: AppTypography.h2),
                    const SizedBox(height: 12),
                    _UpcomingItem(
                      system: 'PC Station 01',
                      date: 'Wed 4 Jun',
                      time: '6:00 PM',
                      tag: const GzTag(kind: GzTagKind.ok, label: 'Confirmed'),
                      actionLabel: 'Check in',
                      onAction: () =>
                          context.push(AppRoutes.checkInPath('GZ-2406-4891')),
                    ),
                    const SizedBox(height: 10),
                    _UpcomingItem(
                      system: 'PS5 Console',
                      date: 'Thu 5 Jun',
                      time: '4:00 PM',
                      tag: const GzTag(kind: GzTagKind.warn, label: 'Unpaid'),
                      actionLabel: 'Pay',
                      onAction: () =>
                          context.push(AppRoutes.paymentSheetPath('GZ-2406-4892')),
                    ),
                    const SizedBox(height: 24),
                    Text('Past sessions', style: AppTypography.h2),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _PastSessionRow(
                  store: 'GameZone Koramangala',
                  system: 'PC Station 03',
                  date: '4 Jun',
                  duration: '2h 07m',
                  amount: '₹1,740',
                  onTap: () => context
                      .push(AppRoutes.sessionHistoryDetailPath('GZ-2406-4891')),
                ),
                _PastSessionRow(
                  store: 'GameZone Indiranagar',
                  system: 'PS5 Console',
                  date: '28 May',
                  duration: '1h 30m',
                  amount: '₹1,200',
                  onTap: () => context
                      .push(AppRoutes.sessionHistoryDetailPath('GZ-2405-3210')),
                ),
                _PastSessionRow(
                  store: 'GameZone Koramangala',
                  system: 'Xbox Series X',
                  date: '20 May',
                  duration: '3h 00m',
                  amount: '₹2,400',
                  onTap: () => context
                      .push(AppRoutes.sessionHistoryDetailPath('GZ-2405-2100')),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveSessionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.activeSessionDetailPath('sess-001')),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceTint,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        child: Row(
          children: [
            const GzLiveDot(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PC Station 03 · Live',
                      style: AppTypography.h3
                          .copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text('1:22:38 remaining',
                      style: AppTypography.small
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Row(
              children: [
                Text('View',
                    style: AppTypography.small.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: AppColors.textPrimary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingItem extends StatelessWidget {
  const _UpcomingItem({
    required this.system,
    required this.date,
    required this.time,
    required this.tag,
    required this.actionLabel,
    required this.onAction,
  });

  final String system;
  final String date;
  final String time;
  final Widget tag;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
                Text(system, style: AppTypography.h3),
                const SizedBox(height: 4),
                Text('$date · $time',
                    style: AppTypography.small
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                tag,
              ],
            ),
          ),
          SizedBox(
            width: 90,
            child: GzButton(
              label: actionLabel,
              small: true,
              variant: GzButtonVariant.ghost,
              onPressed: onAction,
            ),
          ),
        ],
      ),
    );
  }
}

class _PastSessionRow extends StatelessWidget {
  const _PastSessionRow({
    required this.store,
    required this.system,
    required this.date,
    required this.duration,
    required this.amount,
    required this.onTap,
  });

  final String store;
  final String system;
  final String date;
  final String duration;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.all(14),
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
                  Text(store, style: AppTypography.h3),
                  const SizedBox(height: 2),
                  Text('$system · $date · $duration',
                      style: AppTypography.small
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Text(amount,
                style: AppTypography.num.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
