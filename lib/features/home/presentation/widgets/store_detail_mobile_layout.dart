import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/auth/token_storage.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import 'package:gz_app/core/errors/app_exception.dart';
import '../../../../models/domain_loyalty.dart';
import '../providers/store_detail_notifier.dart';

final _slideProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

class StoreDetailMobileLayout extends ConsumerWidget {
  final String slug;

  const StoreDetailMobileLayout({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(storeDetailNotifierProvider(slug));
    final slide = ref.watch(_slideProvider(slug));

    return detailState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: PageErrorDisplay(
          error: AppPageError.from(e),
          onRetry: () =>
              ref.read(storeDetailNotifierProvider(slug).notifier).refresh(slug),
        ),
      ),
      data: (data) {
        final store = data.store;
        final campaigns = data.campaigns;
        const heroCount = 3;

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Hero carousel
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusCard - 4),
                          child: SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                _HeroPlaceholder(
                                  hue: [215.0, 145.0, 25.0][slide % 3],
                                  tag: [
                                    'STOREFRONT',
                                    'PC LOUNGE',
                                    'CONSOLE BAY'
                                  ][slide % 3],
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: GestureDetector(
                                    onTap: () => context.pop(),
                                    child: _HeroBtn(
                                      child: const HugeIcon(
                                        icon:
                                            HugeIcons.strokeRoundedArrowLeft01,
                                        color: AppColors.textPrimary,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                if (slide > 0)
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 8,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () => ref
                                            .read(_slideProvider(slug).notifier)
                                            .state = slide - 1,
                                        child: _ArrowBtn(
                                          child: const HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedArrowLeft01,
                                            color: AppColors.textPrimary,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (slide < heroCount - 1)
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    right: 8,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () => ref
                                            .read(_slideProvider(slug).notifier)
                                            .state = slide + 1,
                                        child: _ArrowBtn(
                                          child: const HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedArrowRight01,
                                            color: AppColors.textPrimary,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 12,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          heroCount,
                                          (i) => Container(
                                            width: i == slide ? 16 : 5,
                                            height: 5,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 3),
                                            decoration: BoxDecoration(
                                              color: i == slide
                                                  ? Colors.white
                                                  : Colors.white60,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Store info
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 14, 0, 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (store.isActive == true)
                                  const GzTag(
                                      kind: GzTagKind.ok, label: 'Open now')
                                else
                                  const GzTag(
                                      kind: GzTagKind.mute, label: 'Closed'),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  store.name ?? 'Store',
                                  style: AppTypography.title,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const HugeIcon(
                                      icon:
                                          HugeIcons.strokeRoundedLocation01,
                                      color: AppColors.textTertiary,
                                      size: 13,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        [store.address, store.city]
                                            .where((s) =>
                                                s != null && s.isNotEmpty)
                                            .join(', '),
                                        style: AppTypography.small,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: _InfoTile(
                                  icon: HugeIcons.strokeRoundedClock01,
                                  k: 'HOURS',
                                  v: '9 – 23',
                                ),
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: _InfoTile(
                                  icon: HugeIcons.strokeRoundedCall,
                                  k: 'CALL',
                                  v: 'Tap',
                                ),
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: _InfoTile(
                                  icon: HugeIcons.strokeRoundedNavigation01,
                                  k: 'DIRECTIONS',
                                  v: 'Go',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text('STATIONS', style: AppTypography.meta),
                          const SizedBox(height: 10),
                          const Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              GzChip(value: 'PC Gaming'),
                              GzChip(value: 'PS5'),
                              GzChip(value: 'VR'),
                              GzChip(value: 'Xbox'),
                            ],
                          ),
                          if (campaigns.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Active campaigns',
                                    style: AppTypography.h2),
                                Text('${campaigns.length}',
                                    style: AppTypography.small),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: campaigns
                                    .take(5)
                                    .map(
                                      (c) => Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10),
                                        child: _MiniCamp(campaign: c),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xl),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),

              // Sticky Book CTA
              Container(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md,
                    AppSpacing.lg),
                color: AppColors.background,
                child: GzButton(
                  label: 'Book a slot',
                  onPressed: () async {
                    if (store.id != null) {
                      ref.read(activeStoreIdProvider.notifier).state = store.id;
                      await ref
                          .read(tokenStorageProvider)
                          .saveActiveStoreId(store.id!);
                    }
                    if (context.mounted) context.go(AppRoutes.book);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder({required this.hue, required this.tag});

  final double hue;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final bg = HSLColor.fromAHSL(1, hue, 0.3, 0.87).toColor();
    final stripe = HSLColor.fromAHSL(1, hue, 0.35, 0.83).toColor();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bg, stripe, bg, stripe, bg, stripe, bg],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 0.15, 0.15, 0.3, 0.3, 0.45, 0.45],
        ),
      ),
      child: Align(
        alignment: const Alignment(-0.9, 0.85),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tag,
            style: AppTypography.meta.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBtn extends StatelessWidget {
  const _HeroBtn({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      );
}

class _ArrowBtn extends StatelessWidget {
  const _ArrowBtn({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.k,
    required this.v,
  });

  // HugeIcons returns List<List<dynamic>> path data, not IconData
  final List<List<dynamic>> icon;
  final String k, v;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(icon: icon, color: AppColors.textSecondary, size: 16),
            const SizedBox(height: 6),
            Text(k, style: AppTypography.meta),
            const SizedBox(height: 2),
            Text(
              v,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
}

class _MiniCamp extends StatelessWidget {
  const _MiniCamp({required this.campaign});

  final CampaignModel campaign;

  @override
  Widget build(BuildContext context) => Container(
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    campaign.name ?? 'Campaign',
                    style: AppTypography.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const GzTag(kind: GzTagKind.ok, label: 'Active'),
              ],
            ),
            const SizedBox(height: 6),
            if (campaign.validUntil != null)
              Text(
                'Valid until ${_formatDate(campaign.validUntil!)}',
                style: AppTypography.small,
              ),
          ],
        ),
      );

  String _formatDate(DateTime d) => '${d.day} ${_month(d.month)} ${d.year}';

  String _month(int m) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m];
}
