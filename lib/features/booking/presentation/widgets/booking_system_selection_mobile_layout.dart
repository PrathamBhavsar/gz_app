import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../providers/booking_notifier.dart';
import '../../../../models/domain_systems.dart';

class BookingSystemSelectionMobileLayout extends ConsumerWidget {
  const BookingSystemSelectionMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Generate some mock systems since we don't have a real API
    final systems = [
      const SystemTypeModel(id: '1', name: 'Standard PC', description: 'RTX 3060, 16GB RAM', hourlyBaseRate: 5.0),
      const SystemTypeModel(id: '2', name: 'Premium PC', description: 'RTX 4080, 32GB RAM, 240Hz', hourlyBaseRate: 10.0),
      const SystemTypeModel(id: '3', name: 'PS5 Lounge', description: 'PS5 with 4K TV and 2 controllers', hourlyBaseRate: 8.0),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: systems.length,
      itemBuilder: (context, index) {
        final system = systems[index];
        return _buildSystemCard(context, ref, system);
      },
    );
  }

  Widget _buildSystemCard(BuildContext context, WidgetRef ref, SystemTypeModel system) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
            child: const Center(child: HugeIcon(icon: HugeIcons.strokeRoundedLaptopProgramming, color: AppColors.primary, size: 40)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(system.name ?? '', style: AppTypography.headingSmall),
                Text(system.description ?? '', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.sm),
                Text('\$ \${system.hourlyBaseRate} / hr', style: AppTypography.headingSmall.copyWith(color: AppColors.primary)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm)),
            ),
            child: Text('Select', style: AppTypography.button),
          ),
        ],
      ),
    );
  }
}
