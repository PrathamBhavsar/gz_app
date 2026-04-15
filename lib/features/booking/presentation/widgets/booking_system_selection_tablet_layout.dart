import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../providers/booking_notifier.dart';
import '../../../../models/domain_systems.dart';

class BookingSystemSelectionTabletLayout extends ConsumerWidget {
  const BookingSystemSelectionTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systems = [
      const SystemTypeModel(id: '1', name: 'Standard PC', description: 'RTX 3060, 16GB RAM', hourlyBaseRate: 5.0),
      const SystemTypeModel(id: '2', name: 'Premium PC', description: 'RTX 4080, 32GB RAM, 240Hz', hourlyBaseRate: 10.0),
      const SystemTypeModel(id: '3', name: 'PS5 Lounge', description: 'PS5 with 4K TV and 2 controllers', hourlyBaseRate: 8.0),
      const SystemTypeModel(id: '4', name: 'VIP Room', description: 'Private room with 5 PCs for team plays', hourlyBaseRate: 25.0),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 2.5,
      ),
      itemCount: systems.length,
      itemBuilder: (context, index) {
        return _buildSystemCard(context, ref, systems[index]);
      },
    );
  }

  Widget _buildSystemCard(BuildContext context, WidgetRef ref, SystemTypeModel system) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
            child: const Center(child: HugeIcon(icon: HugeIcons.strokeRoundedLaptopProgramming, color: AppColors.primary, size: 50)),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(system.name ?? '', style: AppTypography.headingMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(system.description ?? '', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.md),
                Text('\$ \${system.hourlyBaseRate} / hr', style: AppTypography.headingMedium.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(bookingNotifierProvider.notifier).selectSystemType(system);
              context.push('/book/summary');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
            ),
            child: Text('Select', style: AppTypography.button.copyWith(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
