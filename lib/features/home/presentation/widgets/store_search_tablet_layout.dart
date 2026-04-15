import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/store_search_notifier.dart';

class StoreSearchTabletLayout extends ConsumerWidget {
  const StoreSearchTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(storeSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 28),
          onPressed: () => context.pop(),
        ),
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: TextField(
              autofocus: true,
              style: AppTypography.bodyLarge.copyWith(fontSize: 20),
              onChanged: (val) => ref.read(storeSearchProvider.notifier).search(val),
              decoration: InputDecoration(
                hintText: 'Search stores...',
                hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary, fontSize: 20),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: const [SizedBox(width: 48)], // Balance the centering
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _buildBody(context, searchState),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, StoreSearchState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.rose));
    }
    if (state.error != null) {
      return Center(child: Text('Error: \${state.error}', style: AppTypography.bodyLarge.copyWith(color: AppColors.error)));
    }
    if (state.results.isEmpty) {
      return Center(child: Text('Search for stores or amenities', style: AppTypography.headingSmall.copyWith(color: AppColors.textSecondary)));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      itemCount: state.results.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final store = state.results[index];
        return ListTile(
          contentPadding: const EdgeInsets.all(AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm)),
          tileColor: AppColors.surface,
          leading: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: const HugeIcon(icon: HugeIcons.strokeRoundedGameboy, color: AppColors.primary, size: 32),
          ),
          title: Text(store.name ?? 'Unknown', style: AppTypography.headingMedium),
          subtitle: Text('\${store.address}, \${store.city}', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary),
          onTap: () => context.push('/home/store/\${store.slug}'),
        );
      },
    );
  }
}
