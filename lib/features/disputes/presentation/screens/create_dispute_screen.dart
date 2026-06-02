import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class CreateDisputeScreen extends StatefulWidget {
  const CreateDisputeScreen({super.key});

  @override
  State<CreateDisputeScreen> createState() => _CreateDisputeScreenState();
}

class _CreateDisputeScreenState extends State<CreateDisputeScreen> {
  static const List<String> _sessions = [
    'PC Station 03 · Jun 02 · 2h 07m',
    'PS5 Lounge 02 · May 28 · 1h 45m',
    'Racing Rig 01 · May 15 · 58m',
  ];

  static const List<String> _types = [
    'Overcharge',
    'Tech issue',
    'Credits',
    'Other',
  ];

  int _selectedSession = 0;
  int _selectedType = 0;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'File a dispute'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text('Session', style: AppTypography.meta),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSession = (_selectedSession + 1) % _sessions.length;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _sessions[_selectedSession],
                        style: AppTypography.h3,
                      ),
                    ),
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Dispute type', style: AppTypography.meta),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: List.generate(_types.length, (index) {
                return GzChip(
                  label: _types[index],
                  active: _selectedType == index,
                  onTap: () => setState(() => _selectedType = index),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Issue description', style: AppTypography.meta),
            const SizedBox(height: AppSpacing.sm),
            Container(
              constraints: BoxConstraints(minHeight: AppSpacing.xxl * 2.5),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.pillBg,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Describe the issue…',
                  border: InputBorder.none,
                ),
                style: AppTypography.body,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            GzButton(
              label: 'Submit dispute',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dispute submitted.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
