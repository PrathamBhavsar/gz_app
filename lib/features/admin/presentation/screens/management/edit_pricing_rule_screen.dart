import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_billing.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/admin_pricing_notifier.dart';
import '../../../application/pricing_rule_command_notifier.dart';
import 'pricing_rule_form_support.dart';

class EditPricingRuleScreen extends ConsumerStatefulWidget {
  const EditPricingRuleScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<EditPricingRuleScreen> createState() =>
      _EditPricingRuleScreenState();
}

class _EditPricingRuleScreenState extends ConsumerState<EditPricingRuleScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _rateController;
  String _selectedDays = 'All days';
  String _selectedTimeWindow = 'All hours';
  String? _selectedSystemTypeId;
  bool _initialized = false;

  static const _dayOptions = ['All days', 'Weekdays', 'Weekends'];
  static const _timeOptions = [
    'All hours',
    'Morning 8AM-12PM',
    'Afternoon 12-6PM',
    'Evening 6-10PM',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _rateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pricingState = ref.watch(adminPricingNotifierProvider);
    final commandState = ref.watch(pricingRuleCommandNotifierProvider);
    ref.listen<AdminCommandState>(pricingRuleCommandNotifierProvider, (
      _,
      next,
    ) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(pricingRuleCommandNotifierProvider.notifier).reset();
        context.go(AppRoutes.adminPricing);
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(title: 'Edit Rule', onBack: () => context.pop()),
      body: pricingState.when(
        loading: () => const GzLoadingView(message: 'Loading pricing rule'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminPricingNotifierProvider.notifier).refresh(),
        ),
        data: (data) {
          final rule = data.ruleById(widget.id);
          if (rule == null) {
            return PageErrorDisplay(
              error: AppPageError.from(
                const ValidationException('Pricing rule not found'),
              ),
              onRetry: () =>
                  ref.read(adminPricingNotifierProvider.notifier).refresh(),
            );
          }
          if (!_initialized) {
            _seedForm(rule);
          }

          final options = [
            const SystemTypeOption(id: null, label: 'All Systems'),
            ...data.systemTypes.map(
              (type) => SystemTypeOption(
                id: type.id,
                label: type.name ?? 'System type',
              ),
            ),
          ];

          return SafeArea(
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
                    _inputField(
                      'Rate (₹ per hour)',
                      _rateController,
                      hint: '80',
                    ),
                    _section('Applicable systems', _systemsChips(options)),
                    _section(
                      'Day filter',
                      _chipRow(
                        _dayOptions,
                        _selectedDays,
                        (value) => _selectedDays = value,
                      ),
                    ),
                    _section(
                      'Time window',
                      _chipRow(
                        _timeOptions,
                        _selectedTimeWindow,
                        (value) => _selectedTimeWindow = value,
                      ),
                    ),
                    GzButton(
                      label: 'Save Changes',
                      loading: commandState is AdminCommandLoading,
                      onPressed: () => _submit(rule.id ?? ''),
                    ),
                    const SizedBox(height: 12),
                    GzButton(
                      label: 'Delete Rule',
                      variant: GzButtonVariant.dangerOutline,
                      loading: commandState is AdminCommandLoading,
                      onPressed: () => ref
                          .read(pricingRuleCommandNotifierProvider.notifier)
                          .deleteRule(rule.id ?? ''),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _seedForm(PricingRuleModel rule) {
    _initialized = true;
    _nameController.text = rule.name ?? '';
    _rateController.text = rule.fixedRate == null
        ? ''
        : (rule.fixedRate!.truncateToDouble() == rule.fixedRate
              ? rule.fixedRate!.toStringAsFixed(0)
              : rule.fixedRate!.toStringAsFixed(2));
    _selectedDays = pricingDaysSelection(rule.dayOfWeek);
    _selectedTimeWindow = pricingWindowSelection(rule.startTime, rule.endTime);
    _selectedSystemTypeId = rule.systemTypeId;
  }

  Widget _inputField(
    String label,
    TextEditingController controller, {
    String? hint,
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
            controller: controller,
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
          final isSelected = entry.value == selected;
          return Padding(
            padding: EdgeInsets.only(
              right: entry.key == options.length - 1 ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => setState(() => onSelect(entry.value)),
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
                  entry.value,
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

  Widget _systemsChips(List<SystemTypeOption> options) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option.id == _selectedSystemTypeId;
        return GestureDetector(
          onTap: () => setState(() => _selectedSystemTypeId = option.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.textPrimary : AppColors.pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
            ),
            child: Text(
              option.label,
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

  void _submit(String id) {
    final name = _nameController.text.trim();
    final rate = double.tryParse(_rateController.text.trim());
    if (name.isEmpty || rate == null) {
      showErrorSnackbar(
        context,
        const ValidationException('Name and numeric hourly rate are required'),
      );
      return;
    }
    final time = pricingTimeWindowRange(_selectedTimeWindow);
    ref.read(pricingRuleCommandNotifierProvider.notifier).updateRule(id, {
      'name': name,
      'rule_type': 'custom',
      'fixed_rate': rate,
      'day_of_week': pricingDayFilter(_selectedDays),
      'start_time': time.$1,
      'end_time': time.$2,
      if (_selectedSystemTypeId != null)
        'system_type_id': _selectedSystemTypeId,
    });
  }
}
