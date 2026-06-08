import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/errors/app_exception.dart';
import '../../core/errors/error_snackbar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../features/home/application/active_store_notifier.dart';
import '../../features/home/application/home_notifier.dart';
import '../../models/domain_global.dart';
import 'gz_card.dart';
import 'gz_loading_view.dart';
import 'page_error_display.dart';

void showStoreSelectorSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.borderRadiusCard),
      ),
    ),
    builder: (_) => const StoreSelectorSheet(),
  );
}

class StoreSelectorSheet extends ConsumerStatefulWidget {
  const StoreSelectorSheet({super.key});

  @override
  ConsumerState<StoreSelectorSheet> createState() => _StoreSelectorSheetState();
}

class _StoreSelectorSheetState extends ConsumerState<StoreSelectorSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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

    final homeState = ref.watch(homeNotifierProvider);
    final activeStoreState = ref.watch(activeStoreNotifierProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textMuted,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
          ),
        ),
        const SizedBox(height: 12),
        Text('Select store', style: AppTypography.h1),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
            ),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search stores...',
                    ),
                    style: AppTypography.bodyR.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Flexible(
          child: homeState.when(
            loading: () => const GzLoadingView(message: 'Loading stores...'),
            error: (error, _) => PageErrorDisplay(
              error: AppPageError.from(error),
              onRetry: () => ref.read(homeNotifierProvider.notifier).refresh(),
            ),
            data: (data) {
              final filteredStores = _filterStores(data.stores, _query);
              if (filteredStores.isEmpty) {
                return const PageErrorDisplay(
                  error: AppPageError.empty,
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: filteredStores.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final store = filteredStores[index];
                  final isActive = activeStoreState.selectedStore?.id == store.id;

                  return GestureDetector(
                    onTap: () => _selectStore(context, store),
                    child: GzCard(
                      variant: isActive ? CardVariant.tint : CardVariant.base,
                      padding: 14,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.surfaceTintStrong
                                  : AppColors.pillBg,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedStore01,
                                color: isActive
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store.name ?? 'Unnamed store',
                                  style: AppTypography.body,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _storeSubtitle(store),
                                  style: AppTypography.small.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isActive)
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                              color: AppColors.ok,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectStore(BuildContext context, StoreModel store) async {
    await ref.read(activeStoreNotifierProvider.notifier).selectStore(store);
    final selectedStore = ref.read(activeStoreNotifierProvider).selectedStore;
    if (selectedStore?.id == store.id && context.mounted) {
      context.pop();
    }
  }
}

List<StoreModel> _filterStores(List<StoreModel> stores, String query) {
  final trimmed = query.trim().toLowerCase();
  if (trimmed.isEmpty) {
    return stores;
  }

  return stores.where((store) {
    final haystack = [
      store.name,
      store.city,
      store.country,
      store.address,
      store.slug,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(trimmed);
  }).toList(growable: false);
}

String _storeSubtitle(StoreModel store) {
  final parts = <String>[
    if (store.city != null && store.city!.isNotEmpty) store.city!,
    if (store.country != null && store.country!.isNotEmpty) store.country!,
  ];

  if (parts.isNotEmpty) {
    return parts.join(', ');
  }

  if (store.address != null && store.address!.isNotEmpty) {
    return store.address!;
  }

  return store.slug ?? 'Store';
}
