import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/active_store_notifier.dart';

class StoreDetailMobileLayout extends ConsumerWidget {
  const StoreDetailMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStoreState = ref.watch(activeStoreProvider);

    return activeStoreState.when(
      data: (store) {
        if (store == null) return const Center(child: CircularProgressIndicator(color: AppColors.rose));
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.background,
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: HugeIcon(icon: HugeIcons.strokeRoundedGameboy, color: AppColors.primary, size: 80),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name ?? 'Unknown Store', style: AppTypography.headingLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const HugeIcon(icon: HugeIcons.strokeRoundedLocation01, color: AppColors.rose, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Text('\${store.address}, \${store.city}', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text('About', style: AppTypography.headingMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Welcome to \${store.name}. The ultimate gaming experience with \${store.settings?['systemCount'] ?? 'many'} modern PC and console setups waiting for you.',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/book');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
                          ),
                          child: Text('Book a Session', style: AppTypography.button),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.rose)),
      error: (err, st) => Center(child: Text('Error: \$err', style: AppTypography.bodyLarge.copyWith(color: AppColors.error))),
    );
  }
}
