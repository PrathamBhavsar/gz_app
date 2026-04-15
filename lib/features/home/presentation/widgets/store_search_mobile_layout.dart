import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../providers/store_search_notifier.dart';

class StoreSearchMobileLayout extends ConsumerWidget {
  const StoreSearchMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(storeSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          autofocus: true,
          style: AppTypography.bodyLarge,
          onChanged: (val) => ref.read(storeSearchProvider.notifier).search(val),
          decoration: InputDecoration(
            hintText: 'Search stores...',
            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            border: InputBorder.none,
          ),
        ),
      ),
      body: _buildBody(context, searchState),
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
      return Center(child: Text('No results found.', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)));
    }

    return ListView.builder(
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final store = state.results[index];
        return ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
            child: const HugeIcon(icon: HugeIcons.strokeRoundedGameboy, color: AppColors.primary, size: 24),
          ),
          title: Text(store.name ?? 'Unknown', style: AppTypography.headingSmall),
          subtitle: Text('\${store.address}, \${store.city}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          onTap: () => context.push('/home/store/\${store.slug}'),
        );
      },
    );
  }
}
