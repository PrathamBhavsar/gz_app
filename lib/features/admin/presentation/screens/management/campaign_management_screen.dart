import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_management_provider.dart';
import '../../providers/admin_permissions.dart';

/// Campaign Management — Screen 54.
/// Campaign list with status badges, pause/resume actions, redemption stats.
class CampaignManagementScreen extends ConsumerStatefulWidget {
  const CampaignManagementScreen({super.key});

  @override
  ConsumerState<CampaignManagementScreen> createState() =>
      _CampaignManagementScreenState();
}

class _CampaignManagementScreenState
    extends ConsumerState<CampaignManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(campaignsProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(campaignsProvider);
    final perms = ref.watch(adminPermissionsProvider);
    final canEdit = perms.canManagePricingRules; // Campaign edit follows pricing permission level

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminPricing),
        ),
        title: Text('Campaigns', style: AppTypography.headingSmall),
      ),
      body: RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () => ref.read(campaignsProvider.notifier).load(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              _buildContent(state, canEdit),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ManagementState<List<dynamic>> state, bool canEdit) {
    if (state is ManagementLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }

    if (state is ManagementError) {
      return _buildError(state.error);
    }

    if (state is ManagementLoaded) {
      final campaigns = state.data;
      if (campaigns.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text('No campaigns created',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ),
        );
      }
      return Column(
        children: campaigns
            .map((c) =>
                _buildCampaignCard(c as Map<String, dynamic>, canEdit))
            .toList(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load campaigns',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () =>
                  ref.read(campaignsProvider.notifier).load(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Retry', style: AppTypography.button),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> campaign, bool canEdit) {
    final id = campaign['id']?.toString() ?? '';
    final name = campaign['name']?.toString() ?? 'Unnamed';
    final status = campaign['status']?.toString() ?? 'draft';
    final type = campaign['campaign_type']?.toString() ?? '--';
    final value = campaign['value']?.toString() ?? '0';
    final maxRedemptions = campaign['max_redemptions'] as int?;
    final currentRedemptions = campaign['current_redemptions'] as int? ?? 0;

    final statusColor = switch (status.toLowerCase()) {
      'active' => const Color(0xFF4CAF50),
      'paused' => AppColors.gold,
      'expired' => AppColors.textSecondary,
      'scheduled' => const Color(0xFF2196F3),
      'draft' => AppColors.textSecondary,
      _ => AppColors.textSecondary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTypography.bodyMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text('$type · ₹$value',
                        style: AppTypography.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTypography.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (maxRedemptions != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: maxRedemptions > 0
                          ? currentRedemptions / maxRedemptions
                          : 0,
                      backgroundColor: AppColors.surface2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.rose),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('$currentRedemptions/$maxRedemptions',
                    style: AppTypography.caption),
              ],
            ),
          ],
          if (canEdit && (status.toLowerCase() == 'active' || status.toLowerCase() == 'paused'))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (status.toLowerCase() == 'active')
                    TextButton(
                      onPressed: () =>
                          ref.read(campaignsProvider.notifier).pauseCampaign(id),
                      child: Text('Pause',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.gold)),
                    ),
                  if (status.toLowerCase() == 'paused')
                    TextButton(
                      onPressed: () => ref
                          .read(campaignsProvider.notifier)
                          .resumeCampaign(id),
                      child: Text('Resume',
                          style: AppTypography.bodySmall.copyWith(
                              color: const Color(0xFF4CAF50))),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
