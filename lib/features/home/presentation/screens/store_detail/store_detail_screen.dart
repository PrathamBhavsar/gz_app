import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_global.dart';
import '../../../../../models/domain_loyalty.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/active_store_notifier.dart';
import '../../../application/store_detail_notifier.dart';

class StoreDetailScreen extends ConsumerStatefulWidget {
  const StoreDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends ConsumerState<StoreDetailScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<ActiveStoreState>(activeStoreNotifierProvider, (
      previous,
      next,
    ) {
      final error = next.actionError;
      if (error != null && error != previous?.actionError) {
        showErrorSnackbar(context, error);
        ref.read(activeStoreNotifierProvider.notifier).clearActionError();
      }
    });

    final detailState = ref.watch(storeDetailNotifierProvider(widget.slug));
    final activeStoreState = ref.watch(activeStoreNotifierProvider);
    final storeName = detailState.valueOrNull?.store.name ?? 'Store';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: storeName,
        trailing: const HugeIcon(
          icon: HugeIcons.strokeRoundedShare08,
          color: AppColors.textPrimary,
          size: 20,
        ),
      ),
      body: SafeArea(
        top: false,
        child: detailState.when(
          loading: () => const GzLoadingView(message: 'Loading store...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref
                .read(storeDetailNotifierProvider(widget.slug).notifier)
                .refresh(),
          ),
          data: (data) => Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref
                      .read(storeDetailNotifierProvider(widget.slug).notifier)
                      .refresh(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceTint,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedStore01,
                            color: AppColors.textPrimary,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        data.store.name ?? 'Unnamed store',
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _storeAddress(data.store),
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.store.slug ?? 'Store',
                        style: AppTypography.bodyR,
                      ),
                      const SizedBox(height: 24),
                      Text('Store info', style: AppTypography.h2),
                      const SizedBox(height: 10),
                      GzCard(
                        padding: 14,
                        child: Column(
                          children: [
                            GzMetaRow(
                              label: 'City',
                              value: data.store.city ?? 'Unknown',
                            ),
                            GzMetaRow(
                              label: 'Country',
                              value: data.store.country ?? 'Unknown',
                            ),
                            GzMetaRow(
                              label: 'Timezone',
                              value: data.store.timezone ?? 'Not provided',
                            ),
                            GzMetaRow(
                              label: 'Currency',
                              value: data.store.currency ?? 'Not provided',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Available systems', style: AppTypography.h2),
                      const SizedBox(height: 12),
                      if (data.systems.isEmpty)
                        const _InlineEmptyCard(
                          title: 'No systems are available right now.',
                          subtitle: 'Try again later or choose another store.',
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _systemSummaryChips(data.systems),
                        ),
                      const SizedBox(height: 24),
                      Text('Active campaigns', style: AppTypography.h2),
                      const SizedBox(height: 12),
                      if (data.campaigns.isEmpty)
                        const _InlineEmptyCard(
                          title: 'No active campaigns right now.',
                          subtitle: 'This store does not have live offers yet.',
                        )
                      else
                        ...data.campaigns.map(
                          (campaign) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CampaignCard(campaign: campaign),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: GzButton(
                    label: 'Book a system',
                    loading: activeStoreState.isSaving,
                    onPressed: activeStoreState.isSaving
                        ? null
                        : () => _bookStore(context, data.store),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _bookStore(BuildContext context, StoreModel store) async {
    await ref.read(activeStoreNotifierProvider.notifier).selectStore(store);
    final current = ref.read(activeStoreNotifierProvider);
    if (current.selectedStore?.id == store.id && context.mounted) {
      context.go(AppRoutes.book);
    }
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign});

  final CampaignModel campaign;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 14,
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
              GzChip(
                label: _campaignValue(campaign),
                filled: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            campaign.description ?? 'Offer details are available at checkout.',
            style: AppTypography.bodyR,
          ),
        ],
      ),
    );
  }
}

class _InlineEmptyCard extends StatelessWidget {
  const _InlineEmptyCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.h3),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTypography.bodyR),
        ],
      ),
    );
  }
}

String _storeAddress(StoreModel store) {
  final parts = <String>[
    if (store.address != null && store.address!.isNotEmpty) store.address!,
    if (store.city != null && store.city!.isNotEmpty) store.city!,
    if (store.country != null && store.country!.isNotEmpty) store.country!,
  ];

  if (parts.isEmpty) {
    return 'Store address not available';
  }

  return parts.join(', ');
}

List<Widget> _systemSummaryChips(List<SystemModel> systems) {
  final counts = <String, int>{};
  for (final system in systems) {
    final platform = system.platform?.name.toUpperCase() ?? 'OTHER';
    counts.update(platform, (value) => value + 1, ifAbsent: () => 1);
  }

  return counts.entries
      .map((entry) => GzChip(label: '${entry.value} ${entry.key}'))
      .toList(growable: false);
}

String _campaignValue(CampaignModel campaign) {
  final value = campaign.value;
  if (value == null) {
    return campaign.status?.name ?? 'LIVE';
  }

  if (value % 1 == 0) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(1);
}
