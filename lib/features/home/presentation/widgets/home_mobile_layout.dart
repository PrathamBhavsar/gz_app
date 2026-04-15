import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/home_notifier.dart';
import '../../../../models/domain_global.dart';

class HomeMobileLayout extends ConsumerWidget {
  const HomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.background,
          floating: true,
          pinned: true,
          elevation: 0,
          title: Text('GAMING ZONE', style: AppTypography.headingMedium),
          actions: [
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedSearch01,
                color: AppColors.textPrimary,
                size: 24,
              ),
              onPressed: () =>
                  context.push('/home/search'), // We will add to routes later
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        homeState.when(
          data: (stores) => SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle('Active Offers🔥'),
              _buildOffersCarousel(),
              _buildSectionTitle('Nearby Gaming Centers'),
              ...stores.map((store) => _buildStoreCard(context, store)),
              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
          loading: () => const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.rose),
            ),
          ),
          error: (err, st) => SliverFillRemaining(
            child: Center(
              child: Text(
                'Error: \$err',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Text(title, style: AppTypography.headingSmall),
    );
  }

  Widget _buildOffersCarousel() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            ),
            child: Center(
              child: Text(
                'Offer ${index + 1}',
                style: AppTypography.headingMedium,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, StoreModel store) {
    return GestureDetector(
      onTap: () => context.push('/home/store/${store.slug}'),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
              child: const Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedGameboy,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              store.name ?? 'Unknown Store',
              style: AppTypography.headingSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${store.address}, ${store.city}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
