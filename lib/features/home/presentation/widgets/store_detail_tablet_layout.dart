import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/active_store_notifier.dart';

class StoreDetailTabletLayout extends ConsumerWidget {
  const StoreDetailTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStoreState = ref.watch(activeStoreProvider);

    return activeStoreState.when(
      data: (store) {
        if (store == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.rose),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.background),
              onPressed: () => context.pop(),
            ),
          ),
          body: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedGameboy,
                      color: AppColors.primary,
                      size: 120,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        store.name ?? 'Unknown Store',
                        style: AppTypography.headingLarge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedLocation01,
                            color: AppColors.rose,
                            size: 28,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '${store.address}, ${store.city}',
                            style: AppTypography.headingSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text('About', style: AppTypography.headingMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Welcome to ${store.name}. The ultimate gaming experience with ${store.settings?['systemCount'] ?? 'many'} modern PC and console setups waiting for you.',
                        style: AppTypography.bodyLarge,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/book');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.lg,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadius,
                              ),
                            ),
                          ),
                          child: Text(
                            'Book a Session',
                            style: AppTypography.headingSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.rose)),
      error: (err, st) => Center(
        child: Text(
          'Error: \$err',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
