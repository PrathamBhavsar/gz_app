import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import 'end_session_sheet.dart';
import 'extend_session_sheet.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_live_dot.dart';
import '../../../../../shared/widgets/gz_progress_bar.dart';

class SessionManagementScreen extends StatelessWidget {
  const SessionManagementScreen({super.key, this.systemId});

  final String? systemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'PC Station 03',
        onBack: () => context.go(AppRoutes.adminDashboard),
        trailing: const _LiveBadge(),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _InfoCard(
                icon: HugeIcons.strokeRoundedGameboy,
                iconColor: AppColors.rose,
                title: 'PC Station 03',
                subtitle: 'PC Gaming Rig',
              ),
              const SizedBox(height: 16),
              const _TimerCard(),
              const SizedBox(height: 16),
              const _InfoCard(
                icon: HugeIcons.strokeRoundedUserCircle,
                iconColor: AppColors.textTertiary,
                title: 'Rahul Mehra',
                subtitle: 'Walk-in',
              ),
              const SizedBox(height: 16),
              const Text('Actions', style: AppTypography.small),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: _ActionTile(
                      icon: HugeIcons.strokeRoundedPause,
                      label: 'Pause',
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: _ActionTile(
                      icon: HugeIcons.strokeRoundedPlay,
                      label: 'Resume',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showEndSessionSheet(
                        context,
                        sessionId: 'SES-20948',
                        systemName: 'PC Station 03',
                        elapsed: '01:22:38',
                      ),
                      child: const _ActionTile(
                        icon: HugeIcons.strokeRoundedStop,
                        label: 'End',
                        active: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showExtendSessionSheet(
                        context,
                        sessionId: 'SES-20948',
                        systemName: 'PC Station 03',
                      ),
                      child: const _ActionTile(
                        icon: HugeIcons.strokeRoundedForward01,
                        label: 'Extend',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.okBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GzLiveDot(size: 6),
          SizedBox(width: 4),
          Text(
            'Live',
            style: TextStyle(
              fontFamily: 'Geist',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.ok,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final dynamic icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, color: iconColor, size: 32),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.h2),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.small),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerCard extends StatelessWidget {
  const _TimerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text('01:22:38', style: AppTypography.heroMd.copyWith(fontSize: 44)),
          const SizedBox(height: 10),
          const GzProgressBar(value: 0.65, fillColor: AppColors.ok),
          const SizedBox(height: 8),
          Text(
            '57 min remaining',
            style: AppTypography.small.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final dynamic icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final background = active ? AppColors.rose : AppColors.surface;
    final foreground = active ? AppColors.surface : AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: active ? null : Border.all(color: AppColors.rule),
      ),
      child: Column(
        children: [
          HugeIcon(icon: icon, color: foreground, size: 20),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.small.copyWith(color: foreground)),
        ],
      ),
    );
  }
}
