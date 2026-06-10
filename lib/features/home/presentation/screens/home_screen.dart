import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_global.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../shared/widgets/gz_live_dot.dart';
import '../../../../shared/widgets/gz_store_selector_pill.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../../shared/widgets/store_selector_sheet.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../../notifications/application/notifications_notifier.dart';
import '../../../notifications/presentation/screens/notification_center_sheet.dart';
import '../../application/active_store_notifier.dart';
import '../../application/home_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<ActiveStoreState>(activeStoreNotifierProvider, (previous, next) {
      final error = next.actionError;
      if (error != null && error != previous?.actionError) {
        showErrorSnackbar(context, error);
        ref.read(activeStoreNotifierProvider.notifier).clearActionError();
      }
    });

    final homeState = ref.watch(homeNotifierProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final activeStoreState = ref.watch(activeStoreNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final userName = switch (authState) {
      AuthAuthenticated(:final user)
          when user.name != null && user.name!.isNotEmpty =>
        user.name!,
      _ => 'Player',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: homeState.when(
          loading: () => const GzLoadingView(message: 'Loading stores...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(homeNotifierProvider.notifier).refresh(),
          ),
          data: (data) {
            if (data.stores.isEmpty) {
              return PageErrorDisplay(
                error: const AppPageError(
                  title: 'No stores available',
                  message: 'There are no active stores to show right now.',
                  icon: 'inbox',
                  kind: AppPageErrorKind.empty,
                ),
                onRetry: () =>
                    ref.read(homeNotifierProvider.notifier).refresh(),
              );
            }

            final selectedStore =
                activeStoreState.selectedStore ?? data.stores.first;

            return RefreshIndicator(
              onRefresh: () async {
                await ref.read(homeNotifierProvider.notifier).refresh();
                await ref.read(activeStoreNotifierProvider.notifier).refresh();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text('Hey, $userName', style: AppTypography.h1),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GzIconBtn(
                            tooltip: 'Notifications',
                            onTap: () => showNotificationCenter(context),
                            child: const HugeIcon(
                              icon: HugeIcons.strokeRoundedNotification03,
                              color: AppColors.textPrimary,
                              size: 22,
                            ),
                          ),
                          if (unreadCount > 0)
                            const Positioned(
                              top: 6,
                              right: 6,
                              child: GzLiveDot(size: 6, color: AppColors.err),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GzStoreSelectorPill(
                    storeName: selectedStore.name ?? 'Select store',
                    onTap: () => showStoreSelectorSheet(context),
                  ),
                  const SizedBox(height: 24),
                  _SearchCalloutCard(
                    onTap: () => context.push(AppRoutes.storeSearch),
                  ),
                  const SizedBox(height: 28),
                  const _SectionHeader(title: 'Nearby stores'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 168,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.stores.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final store = data.stores[index];
                        return _StoreCard(store: store);
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _SectionHeader(title: 'All stores'),
                  const SizedBox(height: 12),
                  ...data.stores.map(
                    (store) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _StoreListRow(store: store),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SearchCalloutCard extends StatelessWidget {
  const _SearchCalloutCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GzCard(
        padding: 16,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.pillBg,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              ),
              child: const Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Search stores', style: AppTypography.h3),
                  const SizedBox(height: 4),
                  Text(
                    'Filter by platform, open status, or name.',
                    style: AppTypography.bodyR,
                  ),
                ],
              ),
            ),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypography.h2);
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final slug = store.slug;

    return GestureDetector(
      onTap: slug == null || slug.isEmpty
          ? null
          : () => context.push(AppRoutes.storeDetailPath(slug)),
      child: SizedBox(
        width: 220,
        child: GzCard(
          padding: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusLg,
                  ),
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedStore01,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                store.name ?? 'Unnamed store',
                style: AppTypography.h3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                _storeLocation(store),
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      store.slug ?? 'store',
                      style: AppTypography.num.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GzTag(
                    kind: _storeStatusKind(store),
                    label: _storeStatusLabel(store),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreListRow extends StatelessWidget {
  const _StoreListRow({required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final slug = store.slug;

    return GestureDetector(
      onTap: slug == null || slug.isEmpty
          ? null
          : () => context.push(AppRoutes.storeDetailPath(slug)),
      child: GzCard(
        padding: 14,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.pillBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedStore01,
                  color: AppColors.textPrimary,
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
                    _storeLocation(store),
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GzTag(
              kind: _storeStatusKind(store),
              label: _storeStatusLabel(store),
            ),
          ],
        ),
      ),
    );
  }
}

String _storeLocation(StoreModel store) {
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

  return 'Tap to view store details';
}

GzTagKind _storeStatusKind(StoreModel store) {
  return store.isActive == false ? GzTagKind.mute : GzTagKind.ok;
}

String _storeStatusLabel(StoreModel store) {
  return store.isActive == false ? 'Inactive' : 'Active';
}
