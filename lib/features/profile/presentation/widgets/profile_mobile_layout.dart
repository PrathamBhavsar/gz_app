import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_avatar.dart';
import '../../../../shared/widgets/em_chip.dart';
import '../../../../shared/widgets/em_section_head.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../features/auth/presentation/providers/auth_notifier.dart';
import '../providers/profile_notifier.dart';

class ProfileMobileLayout extends ConsumerWidget {
  const ProfileMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    return Column(
      children: [
        const EmTopBar(title: 'Profile'),
        Expanded(
          child: profileState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => PageErrorDisplay(
              error: AppPageError.from(e),
              onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
            ),
            data: (user) => _ProfileContent(user: user),
          ),
        ),
      ],
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = user.name ?? 'Player';
    final email = user.email;
    final phone = user.phone;
    final createdAt = user.createdAt;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';
    final memberSince = createdAt != null
        ? 'Member since ${createdAt.year}'
        : 'Member';

    return EmScrollContent(
      padded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── User card ──
          EmCard(
            variant: CardVariant.tint,
            child: Row(
              children: [
                EmAvatar(size: AvatarSize.xl, children: initial),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTypography.h2),
                      const SizedBox(height: 2),
                      if (email != null)
                        Text(email,
                            style: AppTypography.bodyR
                                .copyWith(color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis),
                      if (phone != null)
                        Text(phone,
                            style: AppTypography.small
                                .copyWith(color: AppColors.textTertiary)),
                      const SizedBox(height: 4),
                      Text(memberSince,
                          style: AppTypography.small
                              .copyWith(color: AppColors.textTertiary)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Stats row ──
          Row(
            children: [
              Expanded(child: EmChip(keyLabel: 'SESSIONS', value: '—')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: EmChip(keyLabel: 'HOURS', value: '—')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: EmChip(keyLabel: 'STORES', value: '—')),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Menu ──
          const EmSectionHead('Account'),
          EmCard(
            padding: 0,
            child: Column(
              children: [
                _MenuItem(
                  icon: HugeIcons.strokeRoundedUserEdit01,
                  label: 'Edit Profile',
                  onTap: () => context.push(AppRoutes.editProfile),
                ),
                _Divider(),
                _MenuItem(
                  icon: HugeIcons.strokeRoundedSmartPhone01,
                  label: 'Change Phone',
                  onTap: () => context.push(AppRoutes.changePhone),
                ),
                _Divider(),
                _MenuItem(
                  icon: HugeIcons.strokeRoundedNotification03,
                  label: 'Notification Preferences',
                  onTap: () => context.push(AppRoutes.notifPrefs),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          const EmSectionHead('Activity'),
          EmCard(
            padding: 0,
            child: Column(
              children: [
                _MenuItem(
                  icon: HugeIcons.strokeRoundedInvoice01,
                  label: 'Billing History',
                  onTap: () => context.push(AppRoutes.billingHistory),
                ),
                _Divider(),
                _MenuItem(
                  icon: HugeIcons.strokeRoundedAlert01,
                  label: 'My Disputes',
                  onTap: () => context.push(AppRoutes.disputesList),
                ),
                _Divider(),
                _MenuItem(
                  icon: HugeIcons.strokeRoundedCustomerService01,
                  label: 'Help & Support',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Sign out ──
          EmButtonFull(
            label: 'Sign Out',
            variant: EmButtonVariant.dangerOutline,
            onPressed: () => _confirmSignOut(context, ref),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard)),
        title: Text('Sign out?', style: AppTypography.h2),
        content: Text('You\'ll need to log in again to access your account.',
            style: AppTypography.bodyR),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text('Cancel',
                style: AppTypography.body
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              ctx.pop();
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.authLanding);
            },
            child: Text('Sign Out',
                style: AppTypography.body.copyWith(color: AppColors.err)),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final dynamic icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm + AppSpacing.xs),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label, style: AppTypography.body),
            ),
            const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.textTertiary,
                size: 18),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(left: AppSpacing.md + 20 + AppSpacing.md),
    child: Divider(color: AppColors.rule, height: 1),
  );
}
