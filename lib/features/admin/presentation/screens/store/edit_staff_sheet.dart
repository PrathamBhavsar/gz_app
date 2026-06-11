import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/store_admin_command_notifier.dart';

Future<void> showEditStaffSheet(
  BuildContext context, {
  required StoreAdminModel member,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EditStaffSheet(member: member),
  );
}

class EditStaffSheet extends ConsumerStatefulWidget {
  const EditStaffSheet({super.key, required this.member});

  final StoreAdminModel member;

  @override
  ConsumerState<EditStaffSheet> createState() => _EditStaffSheetState();
}

class _EditStaffSheetState extends ConsumerState<EditStaffSheet> {
  late AdminRole _selectedRole;
  bool _removeRequested = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.member.role ?? AdminRole.staff;
  }

  @override
  Widget build(BuildContext context) {
    final commandState = ref.watch(storeAdminCommandNotifierProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final isSuperAdmin = widget.member.role == AdminRole.superAdmin;

    ref.listen<AdminCommandState>(storeAdminCommandNotifierProvider, (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(storeAdminCommandNotifierProvider.notifier).reset();
        context.pop();
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
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
                Row(
                  children: [
                    GzAvatar(
                      letter: _initial(widget.member),
                      size: GzAvatarSize.lg,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.member.name ?? 'Unknown',
                          style: AppTypography.h2,
                        ),
                        Text(
                          _roleLabel(widget.member.role),
                          style: AppTypography.bodyR,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Change role', style: AppTypography.h3),
                const SizedBox(height: 10),
                Row(
                  children: [AdminRole.admin, AdminRole.staff].map((role) {
                    final selected = role == _selectedRole;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: isSuperAdmin
                            ? null
                            : () => setState(() => _selectedRole = role),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
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
                            role == AdminRole.admin ? 'Admin' : 'Staff',
                            style: AppTypography.body.copyWith(
                              color: selected
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
                if (isSuperAdmin) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Super admin access is kept read-only here.',
                    style: AppTypography.small.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                GzButton(
                  label: 'Save Role',
                  loading: !_removeRequested &&
                      commandState is AdminCommandLoading,
                  onPressed: isSuperAdmin ? null : _saveRole,
                ),
                const SizedBox(height: 8),
                if (!isSuperAdmin)
                  GzButton(
                    label: 'Remove from staff',
                    variant: GzButtonVariant.dangerOutline,
                    loading: _removeRequested &&
                        commandState is AdminCommandLoading,
                    onPressed: _remove,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveRole() {
    final id = widget.member.id;
    if (id == null || id.isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Missing staff identifier'),
      );
      return;
    }
    _removeRequested = false;
    ref.read(storeAdminCommandNotifierProvider.notifier).updateAdmin(
      id: id,
      role: _selectedRole,
      name: widget.member.name,
    );
  }

  void _remove() {
    final id = widget.member.id;
    if (id == null || id.isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Missing staff identifier'),
      );
      return;
    }
    _removeRequested = true;
    ref.read(storeAdminCommandNotifierProvider.notifier).deactivateAdmin(id);
  }
}

String _initial(StoreAdminModel member) {
  final source = member.name ?? member.email ?? '?';
  return source.substring(0, 1).toUpperCase();
}

String _roleLabel(AdminRole? role) => switch (role) {
  AdminRole.superAdmin => 'Super Admin',
  AdminRole.admin => 'Admin',
  AdminRole.staff => 'Staff',
  null => 'Unknown',
};
