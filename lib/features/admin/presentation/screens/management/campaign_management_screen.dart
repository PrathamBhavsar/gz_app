import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_loyalty.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_campaign_command_notifier.dart';
import '../../../../admin/application/admin_campaigns_notifier.dart';
import '../../../../admin/application/admin_command_state.dart';
import '../../../../admin/application/admin_management_models.dart';

class CampaignManagementScreen extends ConsumerWidget {
  const CampaignManagementScreen({super.key});

  static const _filters = ['All', 'Active', 'Paused'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AdminCommandState>(adminCampaignCommandNotifierProvider, (
      _,
      next,
    ) {
      if (!context.mounted) return;
      if (next is AdminCommandSuccess) showSuccessSnackbar(context, next.message);
      if (next is AdminCommandError) showErrorSnackbar(context, next.message);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Campaigns',
        trailing: GestureDetector(
          onTap: () => context.push(AppRoutes.adminCreateCampaign),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminCampaignsNotifierProvider)
            .when(
              loading: () => const GzLoadingView(message: 'Loading campaigns'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(adminCampaignsNotifierProvider.notifier)
                    .refresh(),
              ),
              data: (data) => _Body(data: data, filters: _filters),
            ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.data, required this.filters});

  final AdminCampaignData data;
  final List<String> filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = data.filtered;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            children: List.generate(filters.length, (i) {
              final f = filters[i];
              return Padding(
                padding: EdgeInsets.only(right: i == filters.length - 1 ? 0 : 8),
                child: GzChip(
                  label: f,
                  active: data.selectedFilter == f,
                  onTap: () => ref
                      .read(adminCampaignsNotifierProvider.notifier)
                      .selectFilter(f),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const PageErrorDisplay(error: AppPageError.empty)
              : GzScrollContent(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      children: items
                          .map(
                            (c) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _CampaignCard(campaign: c),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _CampaignCard extends ConsumerWidget {
  const _CampaignCard({required this.campaign});

  final CampaignModel campaign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = campaign.status == CampaignStatus.paused;
    final cmdState = ref.watch(adminCampaignCommandNotifierProvider);
    final isBusy = cmdState is AdminCommandLoading;

    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  campaign.name ?? 'Campaign',
                  style: AppTypography.h3,
                ),
              ),
              _statusTag(campaign.status),
            ],
          ),
          if (campaign.description != null) ...[
            const SizedBox(height: 6),
            Text(campaign.description!, style: AppTypography.small),
          ],
          const SizedBox(height: 10),
          if (campaign.currentRedemptions != null)
            GzMetaRow(
              label: 'Redemptions',
              value: campaign.currentRedemptions.toString(),
            ),
          if (campaign.validUntil != null)
            GzMetaRow(
              label: 'Expires',
              value: _formatDate(campaign.validUntil!),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GzButton(
                  label: isPaused ? 'Resume' : 'Pause',
                  variant: GzButtonVariant.ghost,
                  small: true,
                  loading: isBusy,
                  onPressed: isBusy
                      ? null
                      : () {
                          final id = campaign.id ?? '';
                          if (isPaused) {
                            ref
                                .read(adminCampaignCommandNotifierProvider.notifier)
                                .resume(id);
                          } else {
                            ref
                                .read(adminCampaignCommandNotifierProvider.notifier)
                                .pause(id);
                          }
                        },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GzButton(
                  label: 'Edit',
                  variant: GzButtonVariant.ghost,
                  small: true,
                  onPressed: () => context.push(
                    AppRoutes.adminEditCampaignPath(campaign.id ?? ''),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  GzTag _statusTag(CampaignStatus? status) {
    return switch (status) {
      CampaignStatus.active => const GzTag(kind: GzTagKind.ok, label: 'Active'),
      CampaignStatus.paused => const GzTag(kind: GzTagKind.mute, label: 'Paused'),
      CampaignStatus.expired => const GzTag(kind: GzTagKind.err, label: 'Expired'),
      CampaignStatus.scheduled => const GzTag(kind: GzTagKind.warn, label: 'Scheduled'),
      _ => const GzTag(kind: GzTagKind.mute, label: 'Draft'),
    };
  }

  String _formatDate(DateTime dt) =>
      '${_month(dt.month)} ${dt.day}, ${dt.year}';

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];
}
