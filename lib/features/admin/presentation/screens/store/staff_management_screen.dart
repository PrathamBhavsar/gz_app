import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  static const _staff = [
    _StaffMember(
      name: 'Pratham Singh',
      email: 'pratham@gzarena.com',
      role: GzTagKind.purple,
      roleLabel: 'Super Admin',
      initials: 'P',
    ),
    _StaffMember(
      name: 'Ritika Sharma',
      email: 'ritika@gzarena.com',
      role: GzTagKind.info,
      roleLabel: 'Admin',
      initials: 'R',
      showTrash: true,
    ),
    _StaffMember(
      name: 'Kabir Nair',
      email: 'kabir@gzarena.com',
      role: GzTagKind.mute,
      roleLabel: 'Staff',
      initials: 'K',
      showTrash: true,
    ),
    _StaffMember(
      name: 'Megha Jain',
      email: 'megha@gzarena.com',
      role: GzTagKind.mute,
      roleLabel: 'Staff',
      initials: 'M',
      showTrash: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Staff',
        onBack: () => context.go(AppRoutes.adminSystemsMgmt),
        trailing: GzIconBtn(
          tooltip: 'Add staff',
          onTap: () {},
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
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
                ..._staff.map(
                  (member) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _StaffCard(member: member),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({required this.member});

  final _StaffMember member;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      child: Row(
        children: [
          GzAvatar(letter: member.initials, size: GzAvatarSize.lg),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: AppTypography.h3),
                const SizedBox(height: 2),
                Text(member.email, style: AppTypography.small),
                const SizedBox(height: AppSpacing.sm),
                GzTag(kind: member.role, label: member.roleLabel),
              ],
            ),
          ),
          if (member.showTrash)
            GzIconBtn(
              tooltip: 'Remove staff',
              onTap: () {},
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedDelete02,
                color: AppColors.textTertiary,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

class _StaffMember {
  const _StaffMember({
    required this.name,
    required this.email,
    required this.role,
    required this.roleLabel,
    required this.initials,
    this.showTrash = false,
  });

  final String name;
  final String email;
  final GzTagKind role;
  final String roleLabel;
  final String initials;
  final bool showTrash;
}
