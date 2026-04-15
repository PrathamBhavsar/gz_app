import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/home_notifier.dart';
import '../../../../models/domain_global.dart';

class HomeTabletLayout extends ConsumerWidget {
  const HomeTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('GAMING ZONE', style: AppTypography.headingLarge),
        actions: [
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedSearch01, color: AppColors.textPrimary, size: 28),
            onPressed: () => context.push('/home/search'),
          ),
          const SizedBox(width: AppSpacing.lg),
        ],
      ),
      body: homeState.when(
        data: (stores) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          children: [
            _buildSectionTitle('Active Offers🔥'),
            _buildOffersGrid(),
            _buildSectionTitle('Nearby Gaming Centers'),
            _buildStoresGrid(context, stores),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.rose)),
        error: (err, st) => Center(child: Text('Error: \$err', style: AppTypography.bodyLarge.copyWith(color: AppColors.error))),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Text(title, style: AppTypography.headingMedium),
    );
  }

  Widget _buildOffersGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 2.5,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          ),
          child: Center(child: Text('Offer \${index + 1}', style: AppTypography.headingMedium)),
        );
      },
    );
  }

  Widget _buildStoresGrid(BuildContext context, List<StoreModel> stores) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 1.1,
      ),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return GestureDetector(
          onTap: () => context.push('/home/store/\${store.slug}'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                    ),
                    child: const Center(child: HugeIcon(icon: HugeIcons.strokeRoundedGameboy, color: AppColors.primary, size: 60)),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(store.name ?? 'Unknown Store', style: AppTypography.headingMedium),
                const SizedBox(height: AppSpacing.xs),
                Text('\${store.address}, \${store.city}', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        );
      },
    );
  }
}
