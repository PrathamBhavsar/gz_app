import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_store_provider.dart';
import '../../providers/admin_auth_provider.dart';

/// Staff Management — Screen 58.
/// Super Admin only. Employee directory with add/revoke access.
class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() =>
      _StaffManagementScreenState();
}

class _StaffManagementScreenState
    extends ConsumerState<StaffManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(staffProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = ref.watch(adminRoleProvider) == 'super_admin';
    final state = ref.watch(staffProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminSystemsMgmt),
        ),
        title: Text('Staff', style: AppTypography.headingSmall),
        actions: [
          if (isSuperAdmin)
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedAdd01,
                color: AppColors.textPrimary,
              ),
              onPressed: () => _showAddStaffSheet(context),
            ),
        ],
      ),
      body: _buildBody(state, isSuperAdmin),
    );
  }

  Widget _buildBody(ManagementState<List<dynamic>> state, bool isSuperAdmin) {
    if (state is ManagementLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.rose),
      );
    }
    if (state is ManagementError) {
      return _buildError(state.error);
    }
    if (state is ManagementLoaded) {
      final staff = state.data;
      if (staff.isEmpty) {
        return Center(
          child: Text('No staff members',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        );
      }
      return RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () => ref.read(staffProvider.notifier).load(),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: staff.length,
          itemBuilder: (ctx, i) =>
              _buildStaffCard(staff[i] as Map<String, dynamic>, isSuperAdmin),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStaffCard(Map<String, dynamic> member, bool isSuperAdmin) {
    final id = member['id']?.toString() ?? '';
    final name = member['name']?.toString() ?? 'Unknown';
    final email = member['email']?.toString() ?? '--';
    final role = member['role']?.toString() ?? 'staff';
    final isActive = member['is_active'] as bool? ?? true;
    final lastLogin = member['last_login_at']?.toString();

    final roleColor = switch (role.toLowerCase()) {
      'super_admin' => AppColors.rose,
      'admin' => const Color(0xFF2196F3),
      'staff' => AppColors.textSecondary,
      _ => AppColors.textSecondary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTypography.bodyMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(email, style: AppTypography.caption),
                    if (lastLogin != null)
                      Text('Last login: ${_formatDate(lastLogin)}',
                          style: AppTypography.caption),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusSm),
                    ),
                    child: Text(
                      role.replaceAll('_', ' ').toUpperCase(),
                      style: AppTypography.bodySmall.copyWith(
                        color: roleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (!isActive)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text('DEACTIVATED',
                          style: AppTypography.caption.copyWith(
                              color: AppColors.error)),
                    ),
                ],
              ),
            ],
          ),
          if (isSuperAdmin && isActive && role.toLowerCase() != 'super_admin')
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _confirmDeactivate(context, id, name),
                    child: Text('Revoke Access',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.error)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load staff',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => ref.read(staffProvider.notifier).load(),
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

  void _confirmDeactivate(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Revoke Access?', style: AppTypography.headingSmall),
        content: Text(
          'This will immediately deactivate $name and invalidate their session.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTypography.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(staffProvider.notifier).deactivateStaff(id);
            },
            child: Text('Revoke',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showAddStaffSheet(BuildContext context) {
    final emailCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    String role = 'staff';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Staff Member', style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: nameCtrl,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Name',
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
              TextField(
                controller: emailCtrl,
                style: AppTypography.bodyMedium,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
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
              Text('Role', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                children: ['admin', 'staff'].map((r) {
                  final isActive = role == r;
                  return GestureDetector(
                    onTap: () => setSheetState(() => role = r),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.rose : AppColors.background,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusSm),
                        border: Border.all(
                            color: isActive ? AppColors.rose : AppColors.border),
                      ),
                      child: Text(
                        r.toUpperCase(),
                        style: AppTypography.bodySmall.copyWith(
                          color: isActive
                              ? AppColors.background
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (emailCtrl.text.trim().isEmpty) return;
                    Navigator.pop(ctx);
                    await ref.read(staffProvider.notifier).addStaff({
                      'email': emailCtrl.text.trim(),
                      'name': nameCtrl.text.trim(),
                      'role': role,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rose,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadius),
                    ),
                  ),
                  child: Text('Add Staff', style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
