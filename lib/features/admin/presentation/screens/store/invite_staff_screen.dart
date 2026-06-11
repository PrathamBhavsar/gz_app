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
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/store_admin_command_notifier.dart';

class InviteStaffScreen extends ConsumerStatefulWidget {
  const InviteStaffScreen({super.key});

  @override
  ConsumerState<InviteStaffScreen> createState() => _InviteStaffScreenState();
}

class _InviteStaffScreenState extends ConsumerState<InviteStaffScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  AdminRole _selectedRole = AdminRole.staff;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commandState = ref.watch(storeAdminCommandNotifierProvider);
    ref.listen<AdminCommandState>(storeAdminCommandNotifierProvider, (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(storeAdminCommandNotifierProvider.notifier).reset();
        context.go(AppRoutes.adminStaff);
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(title: 'Invite Staff', onBack: () => context.pop()),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GzCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New staff member', style: AppTypography.h3),
                      const SizedBox(height: 14),
                      _inputField(
                        'Full name',
                        _nameController,
                        hint: 'e.g. Raj Kumar',
                      ),
                      _inputField(
                        'Email address',
                        _emailController,
                        hint: 'name@example.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Text('Role', style: AppTypography.small),
                      const SizedBox(height: 8),
                      Row(
                        children: [AdminRole.admin, AdminRole.staff].map((role) {
                          final selected = role == _selectedRole;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = role),
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GzCard(
                  variant: CardVariant.inset,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PERMISSIONS', style: AppTypography.meta),
                      const SizedBox(height: 10),
                      _permRow('View analytics', true),
                      _permRow('Manage bookings', true),
                      _permRow('Manage sessions', true),
                      _permRow(
                        'Edit store config',
                        _selectedRole == AdminRole.admin,
                      ),
                      _permRow(
                        'Manage staff',
                        _selectedRole == AdminRole.admin,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GzButton(
                  label: 'Send Invitation',
                  loading: commandState is AdminCommandLoading,
                  onPressed: _submit,
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
    TextInputType? keyboardType,
  }) {
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
            keyboardType: keyboardType,
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
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _permRow(String label, bool granted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.body)),
          HugeIcon(
            icon: granted
                ? HugeIcons.strokeRoundedCheckmarkCircle02
                : HugeIcons.strokeRoundedCancelCircle,
            size: 18,
            color: granted ? AppColors.ok : AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Name and email are required'),
      );
      return;
    }
    ref.read(storeAdminCommandNotifierProvider.notifier).createAdmin(
      name: name,
      email: email,
      role: _selectedRole,
    );
  }
}
