import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';

class CreateCampaignScreen extends StatefulWidget {
  const CreateCampaignScreen({super.key});

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'Discount %';
  final Set<String> _selectedSystems = {};
  bool _saved = false;

  static const _types = ['Discount %', 'Bonus Credits', 'Happy Hour', 'First Visit'];
  static const _systemTypes = ['All Systems', 'PC Gaming', 'PS5', 'Xbox', 'VR'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _inputField(
    String label,
    TextEditingController ctrl, {
    String? hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.small),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.pillBg,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          ),
          child: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppTypography.bodyR.copyWith(color: AppColors.textMuted),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: maxLines,
            style: AppTypography.bodyR.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _dateField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: AppTypography.bodyR)),
          HugeIcon(
            icon: HugeIcons.strokeRoundedCalendar02,
            size: 16,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'New Campaign',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _inputField(
                  'Campaign name',
                  _nameController,
                  hint: 'e.g. Happy Hours',
                ),
                _inputField(
                  'Description',
                  _descriptionController,
                  hint: 'Short description for players',
                  maxLines: 2,
                ),

                // Campaign type
                Text('Campaign type', style: AppTypography.small),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _types.map((type) {
                    final selected = _selectedType == type;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.textPrimary
                              : AppColors.pillBg,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusPill,
                          ),
                        ),
                        child: Text(
                          type,
                          style: AppTypography.body.copyWith(
                            color: selected
                                ? AppColors.surface
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Applicable systems
                Text('Applicable systems', style: AppTypography.small),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _systemTypes.map((system) {
                    final selected = _selectedSystems.contains(system);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selected) {
                          _selectedSystems.remove(system);
                        } else {
                          _selectedSystems.add(system);
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.textPrimary
                              : AppColors.pillBg,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusPill,
                          ),
                        ),
                        child: Text(
                          system,
                          style: AppTypography.body.copyWith(
                            color: selected
                                ? AppColors.surface
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Validity
                Text('Validity', style: AppTypography.small),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _dateField('Start date', 'Jun 01, 2025')),
                    const SizedBox(width: 8),
                    Expanded(child: _dateField('End date', 'Dec 31, 2025')),
                  ],
                ),
                const SizedBox(height: 16),

                // Usage limits
                Text('Usage limits', style: AppTypography.small),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pillBg,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Max uses per user',
                          style: AppTypography.bodyR,
                        ),
                      ),
                      Text(
                        '2',
                        style: AppTypography.body
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (_saved) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GzCard(
                      variant: CardVariant.tint,
                      padding: 12,
                      child: Text(
                        'Campaign created!',
                        style: AppTypography.body.copyWith(
                          color: AppColors.ok,
                        ),
                      ),
                    ),
                  ),
                ],
                GzButton(
                  label: 'Create Campaign',
                  variant: GzButtonVariant.primary,
                  onPressed: () => setState(() => _saved = true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
