import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_global.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/store_search_notifier.dart';

class StoreSearchScreen extends ConsumerStatefulWidget {
  const StoreSearchScreen({super.key});

  @override
  ConsumerState<StoreSearchScreen> createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends ConsumerState<StoreSearchScreen> {
  late final TextEditingController _controller;

  static const platformFilters = <({String label, String? value})>[
    (label: 'All', value: null),
    (label: 'Open now', value: 'open_now'),
    (label: 'PC', value: 'pc'),
    (label: 'PS5', value: 'ps5'),
    (label: 'VR', value: 'vr'),
    (label: 'Xbox', value: 'xbox'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeSearchNotifierProvider);

    if (_controller.text != state.query) {
      _controller.value = _controller.value.copyWith(
        text: state.query,
        selection: TextSelection.collapsed(offset: state.query.length),
      );
    }

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
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.pillBg,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusLg,
                  ),
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
                        controller: _controller,
                        autofocus: true,
                        onChanged: ref
                            .read(storeSearchNotifierProvider.notifier)
                            .setQuery,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search by store name or area...',
                        ),
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
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
                itemCount: platformFilters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = platformFilters[index];
                  final isOpenChip = filter.value == 'open_now';
                  final active = isOpenChip
                      ? state.openNow
                      : state.selectedPlatform == filter.value;

                  return GzChip(
                    label: filter.label,
                    active: filter.value == null
                        ? !state.openNow && state.selectedPlatform == null
                        : active,
                    onTap: () {
                      if (filter.value == null) {
                        final notifier = ref.read(
                          storeSearchNotifierProvider.notifier,
                        );
                        if (state.openNow) {
                          notifier.toggleOpenNow();
                        }
                        if (state.selectedPlatform != null) {
                          notifier.togglePlatform(state.selectedPlatform);
                        }
                        return;
                      }

                      if (isOpenChip) {
                        ref
                            .read(storeSearchNotifierProvider.notifier)
                            .toggleOpenNow();
                        return;
                      }

                      ref
                          .read(storeSearchNotifierProvider.notifier)
                          .togglePlatform(filter.value);
                    },
                  );
                },
              ),
            ),
            if (state.helperMessage != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.helperMessage!,
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(child: _SearchResults(state: state)),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.state});

  final StoreSearchState state;

  @override
  Widget build(BuildContext context) {
    return state.results.when(
      loading: () => const GzLoadingView(message: 'Searching stores...'),
      error: (error, _) => PageErrorDisplay(
        error: AppPageError.from(error),
        onRetry: () {
          final container = ProviderScope.containerOf(context);
          container.read(storeSearchNotifierProvider.notifier).refresh();
        },
      ),
      data: (stores) {
        if (stores.isEmpty) {
          final message = state.query.trim().isEmpty
              ? 'No stores match the current filters.'
              : 'No stores found for "${state.query.trim()}".';
          return PageErrorDisplay(
            error: AppPageError(
              title: 'No results',
              message: message,
              icon: 'inbox',
              kind: AppPageErrorKind.empty,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: stores.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final store = stores[index];
            return _SearchResultCard(store: store);
          },
        );
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final slug = store.slug;

    return GestureDetector(
      onTap: slug == null || slug.isEmpty
          ? null
          : () => context.push(AppRoutes.storeDetailPath(slug)),
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
                  Text(
                    store.name ?? 'Unnamed store',
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _storeLocation(store),
                    style: AppTypography.bodyR,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GzTag(
              kind: store.isActive == false ? GzTagKind.mute : GzTagKind.ok,
              label: store.isActive == false ? 'Inactive' : 'Active',
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
  return store.slug ?? 'Store';
}
