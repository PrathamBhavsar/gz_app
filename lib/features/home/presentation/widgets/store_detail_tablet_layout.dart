import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import 'package:gz_app/core/errors/app_exception.dart';
import '../../../../core/auth/token_storage.dart';
import '../providers/store_detail_notifier.dart';

class StoreDetailTabletLayout extends ConsumerWidget {
  final String slug;

  const StoreDetailTabletLayout({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(storeDetailNotifierProvider(slug));

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
        return Scaffold(
          backgroundColor: AppColors.background,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: AppColors.textPrimary,
                size: 24,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: AppColors.pillBg,
                  child: const Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedGameboy,
                      color: AppColors.textTertiary,
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
                        store.name ?? 'Store',
                        style: AppTypography.headingLarge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedLocation01,
                            color: AppColors.textTertiary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              [store.address, store.city]
                                  .where((s) => s != null && s.isNotEmpty)
                                  .join(', '),
                              style: AppTypography.headingSmall
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GzButton(
                        label: 'Book a Session',
                        onPressed: () async {
                          if (store.id != null) {
                            ref.read(activeStoreIdProvider.notifier).state =
                                store.id;
                            await ref
                                .read(tokenStorageProvider)
                                .saveActiveStoreId(store.id!);
                          }
                          if (context.mounted) context.go(AppRoutes.book);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
