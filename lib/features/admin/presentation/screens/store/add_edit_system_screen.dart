import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/admin_store_models.dart';
import '../../../application/admin_system_command_notifier.dart';
import '../../../application/admin_system_detail_notifier.dart';
import '../../../application/admin_systems_notifier.dart';

class AddEditSystemScreen extends ConsumerStatefulWidget {
  const AddEditSystemScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<AddEditSystemScreen> createState() => _AddEditSystemScreenState();
}

class _AddEditSystemScreenState extends ConsumerState<AddEditSystemScreen> {
  final _nameCtrl = TextEditingController();
  final _seatCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _specsCtrl = TextEditingController();

  String? _selectedTypeId;
  SystemStatus _selectedStatus = SystemStatus.available;
  bool _seeded = false;
  bool _deleteRequested = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _seatCtrl.dispose();
    _rateCtrl.dispose();
    _specsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.id != null;
    final systemsState = ref.watch(adminSystemsNotifierProvider);
    final detailState = isEdit
        ? ref.watch(adminSystemDetailNotifierProvider(widget.id!))
        : const AsyncValue<AdminSystemDetailData?>.data(null);
    final commandState = ref.watch(adminSystemCommandNotifierProvider);

    ref.listen<AdminCommandState>(adminSystemCommandNotifierProvider, (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(adminSystemCommandNotifierProvider.notifier).reset();
        if (_deleteRequested) {
          _deleteRequested = false;
          context.go(AppRoutes.adminSystemsList);
          return;
        }
        final target = widget.id;
        if (target == null) {
          context.go(AppRoutes.adminSystemsList);
        } else {
          context.go(AppRoutes.adminSystemDetailPath(target));
        }
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(title: isEdit ? 'Edit System' : 'Add System'),
      body: SafeArea(
        top: false,
        child: systemsState.when(
          loading: () => const GzLoadingView(message: 'Loading system types'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(adminSystemsNotifierProvider.notifier).refresh(),
          ),
          data: (systemsData) {
            if (systemsData.systemTypes.isEmpty) {
              return const PageErrorDisplay(error: AppPageError.empty);
            }

            return detailState.when(
              loading: () => const GzLoadingView(message: 'Loading system detail'),
              error: (error, _) => PageErrorDisplay(
                error: AppPageError.from(error),
                onRetry: isEdit
                    ? () => ref
                          .read(
                            adminSystemDetailNotifierProvider(widget.id!).notifier,
                          )
                          .refresh()
                    : null,
              ),
              data: (detailData) {
                _seedFormIfNeeded(
                  systemsData.systemTypes,
                  detailData?.system,
                );
                return GzScrollContent(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _inputField(
                          'System name',
                          _nameCtrl,
                          hint: 'e.g. PC Station 04',
                        ),
                        Text('System type', style: AppTypography.small),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: systemsData.systemTypes.map((type) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _typeChip(type),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _inputField(
                          'Seat / bay number',
                          _seatCtrl,
                          hint: '04',
                          keyboardType: TextInputType.number,
                        ),
                        _inputField(
                          'Rate (Rs per hour)',
                          _rateCtrl,
                          hint: '80',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _inputField(
                          'Specs / description',
                          _specsCtrl,
                          hint: 'RTX 4090 · 32GB · 240Hz',
                        ),
                        if (isEdit) ...[
                          Text('Status', style: AppTypography.small),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: SystemStatus.values.map((status) {
                              return _statusChip(status);
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                        GzButton(
                          label: isEdit ? 'Save Changes' : 'Add System',
                          loading: commandState is AdminCommandLoading,
                          onPressed: () => _submit(isEdit),
                        ),
                        if (isEdit) ...[
                          const SizedBox(height: 8),
                          GzButton(
                            label: 'Remove System',
                            variant: GzButtonVariant.dangerOutline,
                            loading: _deleteRequested &&
                                commandState is AdminCommandLoading,
                            onPressed: _confirmDelete,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _seedFormIfNeeded(
    List<SystemTypeModel> systemTypes,
    SystemModel? system,
  ) {
    if (_seeded) {
      return;
    }
    _seeded = true;
    _selectedTypeId = system?.systemTypeId ?? systemTypes.first.id;
    if (system != null) {
      _nameCtrl.text = system.name ?? '';
      _seatCtrl.text = system.stationNumber?.toString() ?? '';
      _rateCtrl.text = system.pricePerHour?.toString() ?? '';
      _specsCtrl.text = system.specs?['summary']?.toString() ?? '';
      _selectedStatus = system.status ?? SystemStatus.available;
    }
  }

  Widget _inputField(
    String label,
    TextEditingController ctrl, {
    String? hint,
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
            keyboardType: keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppTypography.bodyR,
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

  Widget _typeChip(SystemTypeModel type) {
    final selected = _selectedTypeId == type.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedTypeId = type.id),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.buttonBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
          border: selected ? null : Border.all(color: AppColors.rule),
        ),
        alignment: Alignment.center,
        child: Text(
          type.name ?? 'Type',
          style: AppTypography.small.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.buttonFg : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _statusChip(SystemStatus status) {
    final selected = _selectedStatus == status;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.buttonBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
          border: selected ? null : Border.all(color: AppColors.rule),
        ),
        alignment: Alignment.center,
        child: Text(
          switch (status) {
            SystemStatus.available => 'Available',
            SystemStatus.inUse => 'In Use',
            SystemStatus.maintenance => 'Maintenance',
            SystemStatus.offline => 'Offline',
          },
          style: AppTypography.small.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.buttonFg : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  void _submit(bool isEdit) {
    final name = _nameCtrl.text.trim();
    final seatNumber = int.tryParse(_seatCtrl.text.trim());
    final rate = double.tryParse(_rateCtrl.text.trim());
    final typeId = _selectedTypeId;

    if (name.isEmpty || seatNumber == null || rate == null || typeId == null) {
      showErrorSnackbar(
        context,
        const ValidationException('Fill the required system fields first'),
      );
      return;
    }

    final notifier = ref.read(adminSystemCommandNotifierProvider.notifier);
    if (isEdit) {
      notifier.updateSystem(
        id: widget.id!,
        name: name,
        systemTypeId: typeId,
        stationNumber: seatNumber,
        pricePerHour: rate,
        platform: _platformForTypeName(typeId),
        status: _selectedStatus,
        specs: _specsCtrl.text.trim().isEmpty
            ? null
            : {'summary': _specsCtrl.text.trim()},
      );
      return;
    }

    notifier.createSystem(
      name: name,
      systemTypeId: typeId,
      stationNumber: seatNumber,
      pricePerHour: rate,
      platform: _platformForTypeName(typeId),
      specs: _specsCtrl.text.trim().isEmpty
          ? null
          : {'summary': _specsCtrl.text.trim()},
    );
  }

  SystemPlatform _platformForTypeName(String systemTypeId) {
    final data = ref.read(adminSystemsNotifierProvider).value;
    final name = data?.systemTypes
        .where((item) => item.id == systemTypeId)
        .map((item) => item.name?.toLowerCase() ?? '')
        .firstOrNull;
    if (name == null) {
      return SystemPlatform.other;
    }
    if (name.contains('ps5')) {
      return SystemPlatform.ps5;
    }
    if (name.contains('ps4')) {
      return SystemPlatform.ps4;
    }
    if (name.contains('xbox')) {
      return SystemPlatform.xbox;
    }
    if (name.contains('vr')) {
      return SystemPlatform.vr;
    }
    if (name.contains('pc')) {
      return SystemPlatform.pc;
    }
    return SystemPlatform.other;
  }

  Future<void> _confirmDelete() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove system?'),
        content: const Text(
          'This will deactivate the system and remove it from the admin list.',
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
    if (approved != true || widget.id == null) {
      return;
    }
    _deleteRequested = true;
    await ref.read(adminSystemCommandNotifierProvider.notifier).deleteSystem(
      widget.id!,
    );
  }
}
