import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_management_provider.dart';
import '../../providers/admin_permissions.dart';

/// Pricing Rules — Screen 52.
/// CRUD for dynamic pricing rules with active toggle.
class PricingRulesScreen extends ConsumerStatefulWidget {
  const PricingRulesScreen({super.key});

  @override
  ConsumerState<PricingRulesScreen> createState() =>
      _PricingRulesScreenState();
}

class _PricingRulesScreenState extends ConsumerState<PricingRulesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(pricingRulesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pricingRulesProvider);
    final perms = ref.watch(adminPermissionsProvider);
    final canEdit = perms.canManagePricingRules;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminPricing),
        ),
        title: Text('Pricing Rules', style: AppTypography.headingSmall),
        actions: [
          if (canEdit)
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedAdd01,
                color: AppColors.textPrimary,
              ),
              onPressed: () => _showAddRuleSheet(context),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () =>
            ref.read(pricingRulesProvider.notifier).load(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              _buildContent(state, canEdit),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ManagementState<List<dynamic>> state, bool canEdit) {
    if (state is ManagementLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }

    if (state is ManagementError) {
      return _buildError(state.error);
    }

    if (state is ManagementLoaded) {
      final rules = state.data;
      if (rules.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text('No pricing rules configured',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ),
        );
      }
      return Column(
        children: rules
            .map((r) => _buildRuleCard(r as Map<String, dynamic>, canEdit))
            .toList(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load pricing rules',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () =>
                  ref.read(pricingRulesProvider.notifier).load(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Retry', style: AppTypography.button),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard(Map<String, dynamic> rule, bool canEdit) {
    final isActive = rule['is_active'] as bool? ?? false;
    final name = rule['name'] ?? 'Unnamed Rule';
    final ruleType = rule['rule_type'] ?? '--';
    final multiplier = rule['multiplier']?.toString() ?? '--';
    final startTime = rule['start_time'] ?? '';
    final endTime = rule['end_time'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$ruleType · ${multiplier}x${startTime.isNotEmpty ? ' · $startTime–$endTime' : ''}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF4CAF50).withOpacity(0.15)
                  : AppColors.surface2,
              borderRadius:
                  BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: AppTypography.bodySmall.copyWith(
                color: isActive ? const Color(0xFF4CAF50) : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRuleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (context) => const _AddRuleSheet(),
    );
  }
}

class _AddRuleSheet extends ConsumerStatefulWidget {
  const _AddRuleSheet();

  @override
  ConsumerState<_AddRuleSheet> createState() => _AddRuleSheetState();
}

class _AddRuleSheetState extends ConsumerState<_AddRuleSheet> {
  final _nameCtrl = TextEditingController();
  final _multiplierCtrl = TextEditingController(text: '1.0');
  String _ruleType = 'peak';
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _multiplierCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Pricing Rule', style: AppTypography.headingSmall),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _nameCtrl,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Rule Name',
              labelStyle: AppTypography.caption,
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildTypeChip('Peak', 'peak'),
              const SizedBox(width: AppSpacing.sm),
              _buildTypeChip('Off-Peak', 'off_peak'),
              const SizedBox(width: AppSpacing.sm),
              _buildTypeChip('Custom', 'custom'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _multiplierCtrl,
            style: AppTypography.bodyMedium,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Multiplier',
              labelStyle: AppTypography.caption,
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.background,
                        strokeWidth: 2,
                      ),
                    )
                  : Text('Create Rule', style: AppTypography.button),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, String value) {
    final isActive = _ruleType == value;
    return GestureDetector(
      onTap: () => setState(() => _ruleType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.rose : AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(color: isActive ? AppColors.rose : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isActive ? AppColors.background : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);

    final success = await ref.read(pricingRulesProvider.notifier).createRule({
      'name': _nameCtrl.text.trim(),
      'rule_type': _ruleType,
      'multiplier': double.tryParse(_multiplierCtrl.text) ?? 1.0,
      'is_active': true,
    });

    if (mounted) {
      setState(() => _saving = false);
      if (success) {
        Navigator.pop(context);
      }
    }
  }
}
