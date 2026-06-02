import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class StoreSearchScreen extends StatelessWidget {
  const StoreSearchScreen({super.key});

  static const _filters = <String>['All', 'Open now', 'Nearby', 'PC', 'VR'];

  static const _stores = <_SearchStore>[
    _SearchStore(
      name: 'GameZone Koramangala',
      distance: '2.4 km',
      systems: '12 systems',
      status: 'Open',
      statusKind: GzTagKind.ok,
      slug: 'koramangala',
    ),
    _SearchStore(
      name: 'GameZone Indiranagar',
      distance: '3.1 km',
      systems: '8 systems',
      status: 'Open',
      statusKind: GzTagKind.ok,
      slug: 'indiranagar',
    ),
    _SearchStore(
      name: 'GameZone Whitefield',
      distance: '5.8 km',
      systems: '16 systems',
      status: 'Closed',
      statusKind: GzTagKind.mute,
      slug: 'whitefield',
    ),
    _SearchStore(
      name: 'GameZone HSR',
      distance: '4.2 km',
      systems: '6 systems',
      status: 'Open',
      statusKind: GzTagKind.ok,
      slug: 'hsr',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Find a store'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pillBg,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusLg,
                  ),
                ),
                child: const Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search by name or area…',
                        style: AppTypography.bodyR,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 30,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  return GzChip(label: filter, filled: index == 0);
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: _stores.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final store = _stores[index];
                  return _SearchResultCard(store: store);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.store});

  final _SearchStore store;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.storeDetailPath(store.slug)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.name, style: AppTypography.h3),
                  const SizedBox(height: 6),
                  Text(
                    '${store.distance} · ${store.systems}',
                    style: AppTypography.bodyR,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GzTag(kind: store.statusKind, label: store.status),
          ],
        ),
      ),
    );
  }
}

class _SearchStore {
  const _SearchStore({
    required this.name,
    required this.distance,
    required this.systems,
    required this.status,
    required this.statusKind,
    required this.slug,
  });

  final String name;
  final String distance;
  final String systems;
  final String status;
  final GzTagKind statusKind;
  final String slug;
}
