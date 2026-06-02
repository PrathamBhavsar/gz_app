import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'gz_card.dart';

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

class StoreSelectorSheet extends StatefulWidget {
  const StoreSelectorSheet({super.key});

  @override
  State<StoreSelectorSheet> createState() => _StoreSelectorSheetState();
}

class _StoreSelectorSheetState extends State<StoreSelectorSheet> {
  static const _stores = <_StoreOption>[
    _StoreOption(
      name: 'GameZone Koramangala',
      subtitle: '2.4 km',
      isActive: true,
    ),
    _StoreOption(name: 'GameZone Indiranagar', subtitle: '3.1 km'),
    _StoreOption(name: 'GameZone Whitefield', subtitle: '5.8 km'),
  ];

  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStores = _stores
        .where(
          (store) =>
              store.name.toLowerCase().contains(_query.toLowerCase()) ||
              store.subtitle.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

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
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: filteredStores.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final store = filteredStores[index];
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: GzCard(
                  variant: store.isActive ? CardVariant.tint : CardVariant.base,
                  padding: 14,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: store.isActive
                              ? AppColors.surfaceTintStrong
                              : AppColors.pillBg,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedStore01,
                            color: store.isActive
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
                            Text(store.name, style: AppTypography.body),
                            const SizedBox(height: 2),
                            Text(
                              store.subtitle,
                              style: AppTypography.small.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (store.isActive)
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
          ),
        ),
      ],
    );
  }
}

class _StoreOption {
  const _StoreOption({
    required this.name,
    required this.subtitle,
    this.isActive = false,
  });

  final String name;
  final String subtitle;
  final bool isActive;
}
