import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/admin_store_models.dart';
import '../../../application/admin_system_type_command_notifier.dart';
import '../../../application/admin_systems_notifier.dart';

class SystemManagementScreen extends ConsumerStatefulWidget {
  const SystemManagementScreen({super.key});

  @override
  ConsumerState<SystemManagementScreen> createState() =>
      _SystemManagementScreenState();
}

class _SystemManagementScreenState extends ConsumerState<SystemManagementScreen> {
  static const _allType = '__all__';

  String _selectedTypeId = _allType;

  @override
  Widget build(BuildContext context) {
    final systemsState = ref.watch(adminSystemsNotifierProvider);
    ref.listen<AdminCommandState>(adminSystemTypeCommandNotifierProvider, (
      _,
      next,
    ) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(adminSystemTypeCommandNotifierProvider.notifier).reset();
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Systems',
        trailing: GestureDetector(
          onTap: () => context.push(AppRoutes.adminAddSystemPath()),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: systemsState.when(
          loading: () => const GzLoadingView(message: 'Loading systems'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(adminSystemsNotifierProvider.notifier).refresh(),
          ),
          data: (data) {
            final typesById = {
              for (final type in data.systemTypes)
                if (type.id != null) type.id!: type.name ?? 'Type',
            };
            final filtered = _selectedTypeId == _allType
                ? data.systems
                : data.systems
                      .where((item) => item.systemTypeId == _selectedTypeId)
                      .toList(growable: false);

            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                  child: Row(
                    children: [
                      _TypeChip(
                        label: 'All',
                        active: _selectedTypeId == _allType,
                        onTap: () => setState(() => _selectedTypeId = _allType),
                      ),
                      for (final type in data.systemTypes)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _TypeChip(
                            label: type.name ?? 'Type',
                            active: _selectedTypeId == type.id,
                            onTap: () => setState(
                              () => _selectedTypeId = type.id ?? _allType,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: GestureDetector(
                    onTap: () => _showSystemTypesSheet(context, ref, data),
                    child: GzCard(
                      variant: CardVariant.inset,
                      padding: 14,
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Manage system types',
                                  style: AppTypography.h3,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Create, rename, or deactivate the types used by systems.',
                                  style: AppTypography.small,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusLg,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowRight01,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: '${data.totalCount}',
                          label: 'Total',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatCard(
                          value: '${data.inUseCount}',
                          label: 'In Use',
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatCard(
                          value: '${data.maintenanceCount}',
                          label: 'Maint.',
                          color: AppColors.warn,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: data.systems.isEmpty
                      ? const PageErrorDisplay(error: AppPageError.empty)
                      : filtered.isEmpty
                      ? const PageErrorDisplay(error: AppPageError.empty)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final system = filtered[index];
                            return GestureDetector(
                              onTap: () => context.push(
                                AppRoutes.adminSystemDetailPath(system.id ?? ''),
                              ),
                              child: GzCard(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.pillBg,
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.borderRadiusLg,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: HugeIcon(
                                        icon: _iconForPlatform(system.platform),
                                        color: AppColors.textSecondary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            system.name ?? 'System',
                                            style: AppTypography.h3,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            [
                                              typesById[system.systemTypeId] ??
                                                  system.platform?.name.toUpperCase(),
                                              if (system.stationNumber != null)
                                                'Seat ${system.stationNumber}',
                                              _systemSpecs(system),
                                            ].whereType<String>().where((item) => item.isNotEmpty).join(' · '),
                                            style: AppTypography.small,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              GzTag(
                                                kind: _tagKindForStatus(
                                                  system.status,
                                                ),
                                                label: _statusLabel(system.status),
                                              ),
                                              const Spacer(),
                                              Text(
                                                _priceLabel(system),
                                                style: AppTypography.num.copyWith(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.buttonBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
          border: active ? null : Border.all(color: AppColors.rule),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.small.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.buttonFg : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.color,
  });

  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      variant: CardVariant.inset,
      padding: 12,
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.h2.copyWith(color: color),
          ),
          Text(label, style: AppTypography.small),
        ],
      ),
    );
  }
}

dynamic _iconForPlatform(SystemPlatform? platform) => switch (platform) {
  SystemPlatform.ps5 => HugeIcons.strokeRoundedGameController01,
  SystemPlatform.ps4 => HugeIcons.strokeRoundedGameController01,
  SystemPlatform.xbox => HugeIcons.strokeRoundedGameController01,
  SystemPlatform.vr => HugeIcons.strokeRoundedVirtualRealityVr01,
  _ => HugeIcons.strokeRoundedComputerDesk01,
};

GzTagKind _tagKindForStatus(SystemStatus? status) => switch (status) {
  SystemStatus.available => GzTagKind.ok,
  SystemStatus.inUse => GzTagKind.info,
  SystemStatus.maintenance => GzTagKind.warn,
  SystemStatus.offline => GzTagKind.mute,
  null => GzTagKind.mute,
};

String _statusLabel(SystemStatus? status) => switch (status) {
  SystemStatus.available => 'Available',
  SystemStatus.inUse => 'In Use',
  SystemStatus.maintenance => 'Maintenance',
  SystemStatus.offline => 'Offline',
  null => 'Unknown',
};

String _priceLabel(SystemModel system) {
  final price = system.pricePerHour;
  if (price == null) {
    return 'Rate pending';
  }
  final normalized = price == price.roundToDouble()
      ? price.toInt().toString()
      : price.toStringAsFixed(0);
  return 'Rs $normalized/hr';
}

String _systemSpecs(SystemModel system) {
  final specs = system.specs;
  if (specs == null || specs.isEmpty) {
    return '';
  }

  final summary = specs['summary']?.toString();
  if (summary != null && summary.isNotEmpty) {
    return summary;
  }

  return specs.entries
      .take(3)
      .map((entry) => '${entry.key}: ${entry.value}')
      .join(' · ');
}

Future<void> _showSystemTypesSheet(
  BuildContext context,
  WidgetRef ref,
  AdminSystemsOverviewData data,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SystemTypesSheet(data: data),
  );
}

class _SystemTypesSheet extends ConsumerStatefulWidget {
  const _SystemTypesSheet({required this.data});

  final AdminSystemsOverviewData data;

  @override
  ConsumerState<_SystemTypesSheet> createState() => _SystemTypesSheetState();
}

class _SystemTypesSheetState extends ConsumerState<_SystemTypesSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rateController = TextEditingController();

  String? _editingId;

  bool get _editing => _editingId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final commandState = ref.watch(adminSystemTypeCommandNotifierProvider);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, bottomInset + 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusPill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('System types', style: AppTypography.h2),
                const SizedBox(height: 4),
                Text(
                  'These types power the list filters and system creation flow.',
                  style: AppTypography.small,
                ),
                const SizedBox(height: 16),
                ...widget.data.systemTypes.map(
                  (type) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _SystemTypeRow(
                      type: type,
                      onEdit: () => _beginEdit(type),
                      onDelete: type.id == null
                          ? null
                          : () => _deleteType(type.id!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _editing ? 'Edit type' : 'Create type',
                  style: AppTypography.h3,
                ),
                const SizedBox(height: 10),
                _SheetField(
                  label: 'Type name',
                  controller: _nameController,
                  hintText: 'e.g. PS5',
                ),
                const SizedBox(height: 10),
                _SheetField(
                  label: 'Description',
                  controller: _descriptionController,
                  hintText: 'Optional operator-facing note',
                ),
                const SizedBox(height: 10),
                _SheetField(
                  label: 'Base rate',
                  controller: _rateController,
                  hintText: 'Optional hourly base rate',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 14),
                GzButton(
                  label: _editing ? 'Save type' : 'Create type',
                  loading: commandState is AdminCommandLoading,
                  onPressed: _submit,
                ),
                if (_editing) ...[
                  const SizedBox(height: 8),
                  GzButton(
                    label: 'Cancel edit',
                    variant: GzButtonVariant.ghost,
                    onPressed: _resetForm,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _beginEdit(SystemTypeModel type) {
    setState(() {
      _editingId = type.id;
      _nameController.text = type.name ?? '';
      _descriptionController.text = type.description ?? '';
      _rateController.text = type.hourlyBaseRate?.toString() ?? '';
    });
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _descriptionController.clear();
      _rateController.clear();
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final rate = _rateController.text.trim().isEmpty
        ? null
        : double.tryParse(_rateController.text.trim());
    if (name.isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Type name is required'),
      );
      return;
    }
    if (_rateController.text.trim().isNotEmpty && rate == null) {
      showErrorSnackbar(
        context,
        const ValidationException('Base rate must be a valid number'),
      );
      return;
    }

    final notifier = ref.read(adminSystemTypeCommandNotifierProvider.notifier);
    if (_editingId != null) {
      notifier.updateType(
        id: _editingId!,
        name: name,
        description: description.isEmpty ? null : description,
        hourlyBaseRate: rate,
      );
    } else {
      notifier.createType(
        name: name,
        description: description.isEmpty ? null : description,
        hourlyBaseRate: rate,
      );
    }
    _resetForm();
  }

  Future<void> _deleteType(String id) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove system type?'),
        content: const Text(
          'This will deactivate the selected type for future system assignment.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (approved != true) {
      return;
    }
    ref.read(adminSystemTypeCommandNotifierProvider.notifier).deleteType(id);
  }
}

class _SystemTypeRow extends StatelessWidget {
  const _SystemTypeRow({
    required this.type,
    required this.onEdit,
    required this.onDelete,
  });

  final SystemTypeModel type;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if ((type.description ?? '').isNotEmpty) type.description!,
      if (type.hourlyBaseRate != null) 'Base Rs ${type.hourlyBaseRate}',
    ].join(' · ');

    return GzCard(
      padding: 14,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type.name ?? 'Unnamed type', style: AppTypography.h3),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTypography.small),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedEdit02,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedDelete02,
              color: AppColors.err,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: AppTypography.small,
        filled: true,
        fillColor: AppColors.pillBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          borderSide: const BorderSide(color: AppColors.rule),
        ),
      ),
    );
  }
}
