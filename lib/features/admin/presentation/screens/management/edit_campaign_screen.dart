import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_loyalty.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_campaign_command_notifier.dart';
import '../../../../admin/application/admin_campaigns_notifier.dart';
import '../../../../admin/application/admin_command_state.dart';

const _campaignTypeLabels = ['Discount %', 'Bonus Credits', 'Happy Hour', 'First Visit'];
const _campaignTypeApiValues = {
  'Discount %': 'percentage_off',
  'Bonus Credits': 'bonus_credits',
  'Happy Hour': 'happy_hour',
  'First Visit': 'first_visit',
};
const _apiToCampaignTypeLabel = {
  'percentage_off': 'Discount %',
  'percentageOff': 'Discount %',
  'bonus_credits': 'Bonus Credits',
  'bonusCredits': 'Bonus Credits',
  'happy_hour': 'Happy Hour',
  'happyHour': 'Happy Hour',
  'first_visit': 'First Visit',
  'firstVisit': 'First Visit',
};

class EditCampaignScreen extends ConsumerWidget {
  const EditCampaignScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(adminCampaignsNotifierProvider);

    return asyncData.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: GzAdminTopBar(
          title: 'Edit Campaign',
          onBack: () => context.pop(),
        ),
        body: const GzLoadingView(message: 'Loading campaign'),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: GzAdminTopBar(
          title: 'Edit Campaign',
          onBack: () => context.pop(),
        ),
        body: PageErrorDisplay(
          error: AppPageError.from(e),
          onRetry: () =>
              ref.read(adminCampaignsNotifierProvider.notifier).refresh(),
        ),
      ),
      data: (data) {
        final campaign = data.findById(id);
        if (campaign == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: GzAdminTopBar(
              title: 'Edit Campaign',
              onBack: () => context.pop(),
            ),
            body: const PageErrorDisplay(error: AppPageError.empty),
          );
        }
        return _EditForm(
          id: id,
          campaign: campaign,
          systemTypes: data.systemTypes,
        );
      },
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({
    required this.id,
    required this.campaign,
    required this.systemTypes,
  });

  final String id;
  final CampaignModel campaign;
  final List systemTypes;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _maxPerUserController;
  late String _selectedType;
  late Set<String> _selectedSystems;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final c = widget.campaign;
    _nameController = TextEditingController(text: c.name ?? '');
    _descriptionController = TextEditingController(text: c.description ?? '');
    _maxPerUserController = TextEditingController(
      text: (c.maxPerUser ?? 1).toString(),
    );
    _selectedType = _apiToCampaignTypeLabel[c.campaignType?.name] ??
        _campaignTypeLabels.first;
    _selectedSystems = Set.from(c.applicableSystemTypes ?? []);
    _startDate = c.validFrom ?? DateTime.now();
    _endDate = c.validUntil ?? DateTime.now().add(const Duration(days: 90));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _maxPerUserController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showErrorSnackbar(context, 'Campaign name is required');
      return;
    }
    final body = <String, dynamic>{
      'name': name,
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
      'campaign_type':
          _campaignTypeApiValues[_selectedType] ?? 'percentage_off',
      if (_selectedSystems.isNotEmpty)
        'applicable_system_types': _selectedSystems.toList(),
      'valid_from': _startDate.toIso8601String(),
      'valid_until': _endDate.toIso8601String(),
      'max_per_user': int.tryParse(_maxPerUserController.text) ?? 1,
    };
    ref
        .read(adminCampaignCommandNotifierProvider.notifier)
        .update(widget.id, body);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AdminCommandState>(adminCampaignCommandNotifierProvider, (
      _,
      next,
    ) {
      if (!context.mounted) return;
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        context.pop();
      }
      if (next is AdminCommandError) showErrorSnackbar(context, next.message);
    });

    final cmdState = ref.watch(adminCampaignCommandNotifierProvider);
    final isLoading = cmdState is AdminCommandLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Edit Campaign',
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
                _inputField('Campaign name', _nameController,
                    hint: 'e.g. Happy Hours', enabled: !isLoading),
                _inputField(
                  'Description',
                  _descriptionController,
                  hint: 'Short description for players',
                  maxLines: 2,
                  enabled: !isLoading,
                ),

                Text('Campaign type', style: AppTypography.small),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _campaignTypeLabels.map((type) {
                    final selected = _selectedType == type;
                    return _selectChip(
                      label: type,
                      selected: selected,
                      onTap: isLoading
                          ? null
                          : () => setState(() => _selectedType = type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                if (widget.systemTypes.isNotEmpty) ...[
                  Text('Applicable systems', style: AppTypography.small),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.systemTypes.map((t) {
                      final name = (t.name as String?) ?? '';
                      final selected = _selectedSystems.contains(name);
                      return _selectChip(
                        label: name,
                        selected: selected,
                        onTap: isLoading
                            ? null
                            : () => setState(() {
                                  if (selected) {
                                    _selectedSystems.remove(name);
                                  } else {
                                    _selectedSystems.add(name);
                                  }
                                }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                Text('Validity', style: AppTypography.small),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _dateField(
                        'Start date',
                        _startDate,
                        () => _pickDate(true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _dateField(
                        'End date',
                        _endDate,
                        () => _pickDate(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _inputField(
                  'Max uses per user',
                  _maxPerUserController,
                  hint: '1',
                  keyboardType: TextInputType.number,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),

                GzButton(
                  label: 'Save Changes',
                  variant: GzButtonVariant.primary,
                  loading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController ctrl, {
    String? hint,
    int maxLines = 1,
    bool enabled = true,
    TextInputType? keyboardType,
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
            enabled: enabled,
            keyboardType: keyboardType,
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

  Widget _dateField(String label, DateTime date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.pillBg,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${_month(date.month)} ${date.day}, ${date.year}',
                style: AppTypography.bodyR,
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar02,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectChip({
    required String label,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : AppColors.pillBg,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            color: selected ? AppColors.surface : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];
}
