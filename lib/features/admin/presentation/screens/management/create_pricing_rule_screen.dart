import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';

class CreatePricingRuleScreen extends StatefulWidget {
  const CreatePricingRuleScreen({super.key});

  @override
  State<CreatePricingRuleScreen> createState() =>
      _CreatePricingRuleScreenState();
}

class _CreatePricingRuleScreenState extends State<CreatePricingRuleScreen> {
  final _nameController = TextEditingController();
  final _rateController = TextEditingController();
  String _selectedDays = 'All days';
  String _selectedTimeWindow = 'All hours';
  Set<String> _selectedSystems = {'All Systems'};
  bool _saved = false;

  static const _dayOptions = ['All days', 'Weekdays', 'Weekends'];
  static const _timeOptions = [
    'All hours',
    'Morning 8AM-12PM',
    'Afternoon 12-6PM',
    'Evening 6-10PM',
  ];
  static const _systemOptions = [
    'All Systems',
    'PC Gaming',
    'PS5',
    'Xbox',
    'VR',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Widget _inputField(String label, TextEditingController ctrl, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: AppTypography.small),
          const SizedBox(height: 6),
        ],
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
              hintStyle: AppTypography.bodyR.copyWith(
                color: AppColors.textMuted,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: AppTypography.bodyR.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _section(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.small),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _chipRow(
    List<String> options,
    String selected,
    void Function(String) onSelect,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.asMap().entries.map((entry) {
          final i = entry.key;
          final o = entry.value;
          final isSelected = o == selected;
          final isLast = i == options.length - 1;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: GestureDetector(
              onTap: () => setState(() => onSelect(o)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textPrimary : AppColors.pillBg,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusPill,
                  ),
                ),
                child: Text(
                  o,
                  style: AppTypography.body.copyWith(
                    color: isSelected
                        ? AppColors.surface
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _systemsChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _systemOptions.map((o) {
        final isSelected = _selectedSystems.contains(o);
        return GestureDetector(
          onTap: () => setState(() {
            if (o == 'All Systems') {
              _selectedSystems = {'All Systems'};
            } else {
              _selectedSystems.remove('All Systems');
              if (isSelected) {
                _selectedSystems.remove(o);
                if (_selectedSystems.isEmpty) {
                  _selectedSystems = {'All Systems'};
                }
              } else {
                _selectedSystems.add(o);
              }
            }
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.textPrimary : AppColors.pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
            ),
            child: Text(
              o,
              style: AppTypography.body.copyWith(
                color: isSelected ? AppColors.surface : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'New Pricing Rule',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _inputField(
                  'Rule name',
                  _nameController,
                  hint: 'e.g. Peak Hours',
                ),
                _inputField('Rate (₹ per hour)', _rateController, hint: '80'),
                _section('Applicable systems', _systemsChips()),
                _section(
                  'Day filter',
                  _chipRow(
                    _dayOptions,
                    _selectedDays,
                    (v) => _selectedDays = v,
                  ),
                ),
                _section(
                  'Time window',
                  _chipRow(
                    _timeOptions,
                    _selectedTimeWindow,
                    (v) => _selectedTimeWindow = v,
                  ),
                ),
                if (_saved)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GzCard(
                      variant: CardVariant.tint,
                      child: Text(
                        'Pricing rule created!',
                        style: AppTypography.body.copyWith(color: AppColors.ok),
                      ),
                    ),
                  ),
                GzButton(
                  label: 'Create Rule',
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
