import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gz_app/core/navigation/routes.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import 'package:gz_app/core/errors/app_exception.dart';
import '../../../../models/domain_global.dart';
import '../providers/home_notifier.dart';

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
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: AppColors.textPrimary,
              size: 28,
            ),
            onPressed: () => context.push(AppRoutes.storeSearch),
          ),
          const SizedBox(width: AppSpacing.lg),
        ],
      ),
      body: homeState.when(
        data: (data) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          children: [
            _buildSectionTitle('Nearby Gaming Centers'),
            _buildStoresGrid(context, data.stores),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: PageErrorDisplay(
            error: AppPageError.from(e),
            onRetry: () => ref.read(homeNotifierProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Text(title, style: AppTypography.headingMedium),
    );
  }

  Widget _buildStoresGrid(BuildContext context, List<StoreModel> stores) {
    if (stores.isEmpty) {
      return Center(
        child: Text(
          'No stores nearby.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      );
    }
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
          onTap: () => context.push(AppRoutes.storeDetailPath(store.slug ?? '')),
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
                      color: AppColors.pillBg,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusSm),
                    ),
                    child: const Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedGameboy,
                        color: AppColors.textTertiary,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  store.name ?? 'Unknown Store',
                  style: AppTypography.headingMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${store.address ?? ''}, ${store.city ?? ''}',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
