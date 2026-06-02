import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gz_app/core/navigation/routes.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../providers/store_search_notifier.dart';

const _filters = ['All', 'PC', 'PS5', 'VR', 'Xbox', 'Open Now'];

class StoreSearchMobileLayout extends ConsumerWidget {
  const StoreSearchMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(storeSearchProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search header row
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm, 8, AppSpacing.sm, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 38,
                  height: 38,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    behavior: HitTestBehavior.opaque,
                    child: const Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowLeft01,
                        color: AppColors.textPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    style: AppTypography.body,
                    onChanged: (val) =>
                        ref.read(storeSearchProvider.notifier).search(val),
                    decoration: InputDecoration(
                      hintText: 'Search stores...',
                      hintStyle: AppTypography.bodyR,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(
                  width: 38,
                  height: 38,
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(storeSearchProvider.notifier).search(''),
                    behavior: HitTestBehavior.opaque,
                    child: const Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedMultiplicationSign,
                        color: AppColors.textTertiary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 6),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final f = _filters[i];
                final selected = f == searchState.selectedFilter;
                return GestureDetector(
                  onTap: () =>
                      ref.read(storeSearchProvider.notifier).setFilter(f),
                  child: Container(
                    margin: const EdgeInsets.only(right: AppSpacing.xs),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.buttonBg
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusChip),
                    ),
                    child: Center(
                      child: Text(
                        f,
                        style: AppTypography.small.copyWith(
                          color: selected
                              ? AppColors.buttonFg
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Results
          Expanded(
            child: _buildBody(context, ref, searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, WidgetRef ref, StoreSearchState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return PageErrorDisplay(
        error: AppPageError.from(Exception(state.error)),
        onRetry: () => ref
            .read(storeSearchProvider.notifier)
            .search(state.selectedFilter),
      );
    }

    if (state.results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: GzCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.pillBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      color: AppColors.textTertiary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('No stores found', style: AppTypography.h2),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Try a different name or filter',
                  style: AppTypography.bodyR,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      itemCount: state.results.length,
      itemBuilder: (context, i) {
        final store = state.results[i];
        final initial =
            store.name?.isNotEmpty == true ? store.name![0] : 'S';
        return GestureDetector(
          onTap: () => context.push(AppRoutes.storeDetailPath(store.slug ?? '')),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GzCard(
              variant: CardVariant.base,
              padding: AppSpacing.sm + AppSpacing.xs,
              child: Row(
                children: [
                  GzAvatar(children: initial, index: i),
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
                          [store.address, store.city]
                              .where((s) => s != null && s.isNotEmpty)
                              .join(', '),
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
            .animate(delay: (i * 60).ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.05, end: 0, duration: 220.ms);
      },
    );
  }
}
