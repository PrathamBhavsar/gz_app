import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_systems.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/store_admins_notifier.dart';
import 'edit_staff_sheet.dart';

class StaffManagementScreen extends ConsumerWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffState = ref.watch(storeAdminsNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Staff',
        trailing: GzIconBtn(
          tooltip: 'Add staff',
          onTap: () => context.push(AppRoutes.adminInviteStaff),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: staffState.when(
          loading: () => const GzLoadingView(message: 'Loading staff'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(storeAdminsNotifierProvider.notifier).refresh(),
          ),
          data: (members) {
            final activeMembers = members
                .where((item) => item.isActive ?? true)
                .toList(growable: false);
            if (activeMembers.isEmpty) {
              return const PageErrorDisplay(error: AppPageError.empty);
            }

            return GzScrollContent(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: const [
                        GzTag(kind: GzTagKind.purple, label: 'Super Admin'),
                        GzTag(kind: GzTagKind.info, label: 'Admin'),
                        GzTag(kind: GzTagKind.mute, label: 'Staff'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...activeMembers.map(
                      (member) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => showEditStaffSheet(
                            context,
                            member: member,
                          ),
                          child: _StaffCard(member: member),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({required this.member});

  final StoreAdminModel member;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      child: Row(
        children: [
          GzAvatar(
            letter: _initial(member),
            size: GzAvatarSize.lg,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name ?? 'Unknown', style: AppTypography.h3),
                const SizedBox(height: 2),
                Text(member.email ?? 'No email', style: AppTypography.small),
                if (member.lastLoginAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Last login ${_dateLabel(member.lastLoginAt)}',
                    style: AppTypography.small.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                GzTag(
                  kind: _roleKind(member.role),
                  label: _roleLabel(member.role),
                ),
              ],
            ),
          ),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textTertiary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

String _initial(StoreAdminModel member) {
  final source = member.name ?? member.email ?? '?';
  return source.substring(0, 1).toUpperCase();
}

GzTagKind _roleKind(AdminRole? role) => switch (role) {
  AdminRole.superAdmin => GzTagKind.purple,
  AdminRole.admin => GzTagKind.info,
  AdminRole.staff => GzTagKind.mute,
  null => GzTagKind.mute,
};

String _roleLabel(AdminRole? role) => switch (role) {
  AdminRole.superAdmin => 'Super Admin',
  AdminRole.admin => 'Admin',
  AdminRole.staff => 'Staff',
  null => 'Unknown',
};

String _dateLabel(DateTime? value) {
  if (value == null) {
    return 'unknown';
  }
  final local = value.toLocal();
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.day}/${local.month}/${local.year} ${local.hour}:$minute';
}
