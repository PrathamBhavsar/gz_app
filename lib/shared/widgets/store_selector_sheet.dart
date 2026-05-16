import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/auth/token_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../features/home/presentation/providers/store_selector_notifier.dart';
import '../../models/domain_global.dart';
import 'em_card.dart';
import 'page_error_display.dart';
import 'package:gz_app/core/errors/app_exception.dart';

void showStoreSelectorSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.borderRadiusCard),
      ),
    ),
    builder: (ctx) => const StoreSelectorSheet(),
  );
}

class StoreSelectorSheet extends ConsumerStatefulWidget {
  const StoreSelectorSheet({super.key});

  @override
  ConsumerState<StoreSelectorSheet> createState() =>
      _StoreSelectorSheetState();
}

class _StoreSelectorSheetState extends ConsumerState<StoreSelectorSheet> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _selectStore(StoreModel store) {
    if (store.id == null) return;
    ref.read(activeStoreIdProvider.notifier).state = store.id;
    ref.read(tokenStorageProvider).saveActiveStoreId(store.id!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentId = ref.watch(activeStoreIdProvider);
    final storesAsync = ref.watch(storeSelectorNotifierProvider);

    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textMuted,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
          child: Text('Select Store', style: AppTypography.h2),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Search field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(AppSpacing.borderRadiusLg),
              border: Border.all(color: AppColors.rule),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: AppSpacing.md),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: AppColors.textTertiary,
                    size: 18,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    style: AppTypography.body,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.all(AppSpacing.md),
                      hintText: 'Search stores...',
                      hintStyle: AppTypography.bodyR
                          .copyWith(color: AppColors.textMuted),
                    ),
                    onChanged: (q) => ref
                        .read(storeSelectorNotifierProvider.notifier)
                        .search(q),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: storesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => PageErrorDisplay(
              error: AppPageError.from(e),
              onRetry: () => ref
                  .read(storeSelectorNotifierProvider.notifier)
                  .refresh(),
            ),
            data: (stores) {
              if (stores.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: EmCard(
                      child: Text(
                        'No stores found',
                        style: AppTypography.bodyR,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              // Current store at top, rest below
              final current = stores.where((s) => s.id == currentId).toList();
              final others = stores.where((s) => s.id != currentId).toList();

              return ListView(
                padding: const EdgeInsets.only(
                    bottom: AppSpacing.xl),
                children: [
                  if (current.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
                      child: Text('Current',
                          style: AppTypography.meta),
                    ),
                    ...current.map((s) => _StoreSelectRow(
                          store: s,
                          isActive: true,
                          onTap: () => _selectStore(s),
                        )),
                  ],
                  if (others.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
                      child: Text(
                          current.isEmpty ? 'All Stores' : 'Other Stores',
                          style: AppTypography.meta),
                    ),
                    ...others.map((s) => _StoreSelectRow(
                          store: s,
                          isActive: false,
                          onTap: () => _selectStore(s),
                        )),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StoreSelectRow extends StatelessWidget {
  const _StoreSelectRow({
    required this.store,
    required this.isActive,
    required this.onTap,
  });

  final StoreModel store;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.rule)),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm + AppSpacing.xs),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isActive ? AppColors.okBg : AppColors.pillBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedStore01,
                  color: isActive ? AppColors.ok : AppColors.textTertiary,
                  size: 17,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name ?? 'Unknown Store',
                    style: AppTypography.body,
                  ),
                  if (store.address != null || store.city != null)
                    Text(
                      [store.city, store.address]
                          .where((s) => s != null)
                          .join(', '),
                      style: AppTypography.small,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (isActive)
              const HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                color: AppColors.ok,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
