import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_avatar.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../../models/domain_global.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../application/profile_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Sign out', style: AppTypography.h2),
        content: Text(
          'Are you sure you want to sign out?',
          style: AppTypography.bodyR,
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => dialogContext.pop(true),
            child: Text(
              'Sign out',
              style: AppTypography.body.copyWith(color: AppColors.err),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    await ref.read(authNotifierProvider.notifier).logout();
    if (context.mounted) {
      context.go(AppRoutes.authLanding);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final isSigningOut = authState is AuthLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: profileState.when(
          loading: () => const GzLoadingView(message: 'Loading profile'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
          ),
          data: (user) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text('Profile', style: AppTypography.h1),
              const SizedBox(height: AppSpacing.md),
              GzCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GzAvatar(
                          letter: _displayName(user),
                          size: GzAvatarSize.xl,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: _ProfileIdentity(user: user)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.editProfile),
                      child: Text(
                        'Edit profile →',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _ProfileNavTile(
                icon: HugeIcons.strokeRoundedTime04,
                label: 'Sessions',
                onTap: () => context.go(AppRoutes.sessions),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ProfileNavTile(
                icon: HugeIcons.strokeRoundedWallet01,
                label: 'Wallet',
                onTap: () => context.go(AppRoutes.wallet),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ProfileNavTile(
                icon: HugeIcons.strokeRoundedShield01,
                label: 'Disputes',
                onTap: () => context.push(AppRoutes.disputesList),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ProfileNavTile(
                icon: HugeIcons.strokeRoundedNotification03,
                label: 'Notification preferences',
                onTap: () => context.push(AppRoutes.notifPrefs),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ProfileNavTile(
                icon: HugeIcons.strokeRoundedCall02,
                label: 'Change phone',
                onTap: () => context.push(AppRoutes.changePhone),
              ),
              const SizedBox(height: AppSpacing.xl),
              GzButton(
                label: 'Sign out',
                variant: GzButtonVariant.dangerOutline,
                onPressed: isSigningOut ? null : () => _signOut(context, ref),
                loading: isSigningOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _displayName(UserModel user) {
    if (user.name != null && user.name!.trim().isNotEmpty) {
      return user.name!.trim();
    }
    if (user.email != null && user.email!.trim().isNotEmpty) {
      return user.email!.trim();
    }
    if (user.phone != null && user.phone!.trim().isNotEmpty) {
      return user.phone!.trim();
    }
    return 'P';
  }
}

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name?.trim().isNotEmpty == true ? user.name!.trim() : 'Player',
          style: AppTypography.h2,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (user.email != null && user.email!.trim().isNotEmpty)
          Text(user.email!.trim(), style: AppTypography.small)
        else if (user.phone != null && user.phone!.trim().isNotEmpty)
          Text(user.phone!.trim(), style: AppTypography.small)
        else
          Text('No contact details available', style: AppTypography.small),
      ],
    );
  }
}

class _ProfileNavTile extends StatelessWidget {
  const _ProfileNavTile({
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.pillBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: HugeIcon(
                icon: icon,
                color: AppColors.textSecondary,
                size: 14,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(label, style: AppTypography.h3)),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
