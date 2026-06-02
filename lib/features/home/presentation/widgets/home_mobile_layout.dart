import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:gz_app/features/notifications/presentation/widgets/notification_center_sheet.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/connectivity_banner.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_logo.dart';
import '../../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../../shared/widgets/gz_section_head.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import 'package:gz_app/core/errors/app_exception.dart';
import '../../../../models/domain_global.dart';
import '../providers/home_notifier.dart';

const double _storeCardWidth = 190;
const double _storeCardHeight = 188;
const double _storeCardMediaHeight = 96;

class HomeMobileLayout extends ConsumerWidget {
  const HomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              12,
              AppSpacing.md,
              0,
            ),
            child: Row(
              children: [
                const GzLogo(),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text('Hey, gamer', style: AppTypography.h3)),
                GzIconBtn(
                  tooltip: 'Notifications',
                  onTap: () => showNotificationCenter(context),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedNotification01,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            label: 'Search gaming stores',
            button: true,
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.storeSearch),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: GzCard(
                  variant: CardVariant.base,
                  padding: AppSpacing.sm + AppSpacing.xs,
                  child: Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        color: AppColors.textTertiary,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Search gaming stores...',
                          style: AppTypography.bodyR,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const ConnectivityBanner(),
          const SizedBox(height: AppSpacing.sm),
          homeState.when(
            loading: () => const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Expanded(
              child: Center(
                child: PageErrorDisplay(
                  error: AppPageError.from(e),
                  onRetry: () =>
                      ref.read(homeNotifierProvider.notifier).refresh(),
                ),
              ),
            ),
            data: (data) => Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(homeNotifierProvider.notifier).refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: GzSectionHead(
                          'Nearby stores',
                          subtitle: '${data.stores.length} within 10km',
                        ),
                      ),
                      if (data.stores.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: GzCard(
                            variant: CardVariant.inset,
                            child: Column(
                              children: [
                                GzAvatar(
                                  icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedStore01,
                                    color: AppColors.textTertiary,
                                    size: 24,
                                  ),
                                  size: GzAvatarSize.xl,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'No stores nearby',
                                  style: AppTypography.h2,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Pull to refresh and try again',
                                  style: AppTypography.bodyR,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                GzButton(
                                  label: 'Refresh',
                                  onPressed: () => ref
                                      .read(homeNotifierProvider.notifier)
                                      .refresh(),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: _storeCardHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            itemCount: data.stores.length,
                            itemBuilder: (_, i) => _StoreCardLg(
                              store: data.stores[i],
                              index: i,
                              onTap: () => context.push(
                                '/home/store/${data.stores[i].slug}',
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.lg),
                      if (data.stores.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: GzSectionHead(
                            'New in your city',
                            subtitle: '${data.stores.length} stores',
                          ),
                        ),
                        ...List.generate(
                          data.stores.length.clamp(0, 5),
                          (i) => _NewStoreRow(
                            store: data.stores[i],
                            index: i,
                            onTap: () => context.push(
                              '/home/store/${data.stores[i].slug}',
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCardLg extends StatelessWidget {
  const _StoreCardLg({
    required this.store,
    required this.index,
    required this.onTap,
  });

  final StoreModel store;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            width: _storeCardWidth,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            child: GzCard(
              variant: CardVariant.base,
              padding: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: _storeCardMediaHeight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.pillBg,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSpacing.borderRadiusCard),
                      ),
                    ),
                    child: const Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedGameboy,
                        color: AppColors.textTertiary,
                        size: 32,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      AppSpacing.sm + AppSpacing.xs,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name ?? 'Store',
                          style: AppTypography.h3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          store.city ?? '',
                          style: AppTypography.small,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        store.isActive == true
                            ? const GzTag(kind: GzTagKind.ok, label: 'Open')
                            : const GzTag(
                                kind: GzTagKind.mute,
                                label: 'Closed',
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 220.ms)
        .slideX(begin: 0.04, end: 0, duration: 220.ms);
  }
}

class _NewStoreRow extends StatelessWidget {
  const _NewStoreRow({
    required this.store,
    required this.index,
    required this.onTap,
  });

  final StoreModel store;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = store.name?.isNotEmpty == true ? store.name![0] : 'S';
    return GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: GzCard(
              variant: CardVariant.base,
              padding: AppSpacing.sm + AppSpacing.xs,
              child: Row(
                children: [
                  GzAvatar(children: initial, index: index),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name ?? 'Store',
                          style: AppTypography.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          [
                            store.address,
                            store.city,
                          ].where((s) => s != null && s.isNotEmpty).join(', '),
                          style: AppTypography.small,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  store.isActive == true
                      ? const GzTag(kind: GzTagKind.ok, label: 'Open')
                      : const GzTag(kind: GzTagKind.mute, label: 'Closed'),
                ],
              ),
            ),
          ),
        )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 220.ms)
        .slideY(begin: 0.05, end: 0, duration: 220.ms);
  }
}
