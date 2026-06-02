import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class StoreDetailScreen extends StatelessWidget {
  const StoreDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'GameZone Koramangala',
        trailing: const HugeIcon(
          icon: HugeIcons.strokeRoundedShare08,
          color: AppColors.textPrimary,
          size: 20,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceTint,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('GameZone Koramangala', style: AppTypography.h1),
                    const SizedBox(height: 8),
                    Text(
                      '4.8 ⭐ · 142 reviews',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Open · 10:00 AM – 11:00 PM',
                      style: AppTypography.bodyR,
                    ),
                    const SizedBox(height: 24),
                    Text('Systems', style: AppTypography.h2),
                    const SizedBox(height: 12),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        GzChip(label: '10 PC'),
                        GzChip(label: '2 PS5'),
                        GzChip(label: '1 VR'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Pricing', style: AppTypography.h2),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusLg,
                        ),
                      ),
                      child: const Column(
                        children: [
                          GzMetaRow(label: 'Standard rate', value: '₹80/hr'),
                          GzMetaRow(label: 'Peak (6–10 PM)', value: '₹120/hr'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.pillBg,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusCard,
                        ),
                      ),
                      child: const Center(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation01,
                          color: AppColors.textTertiary,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GzButton(
                  label: 'Book a system',
                  onPressed: () => context.go(AppRoutes.book),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
