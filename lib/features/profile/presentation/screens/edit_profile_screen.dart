import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_avatar.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/edit_profile_notifier.dart';
import '../../application/profile_notifier.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _didSeedControllers = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EditProfileState>(editProfileNotifierProvider, (previous, next) {
      if (next is EditProfileError) {
        showErrorSnackbar(context, next.error);
      }
      if (next is EditProfileSuccess) {
        showSuccessSnackbar(context, 'Profile updated.');
        if (context.mounted) {
          context.pop();
        }
      }
    });

    final profileState = ref.watch(profileNotifierProvider);
    final editState = ref.watch(editProfileNotifierProvider);
    final isSaving = editState is EditProfileLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'Edit profile',
        trailingWidth: 72,
        trailing: TextButton(
          onPressed: isSaving ? null : _save,
          child: Text(
            'Save',
            style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: profileState.when(
          loading: () => const GzLoadingView(message: 'Loading profile'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
          ),
          data: (user) {
            if (!_didSeedControllers) {
              _nameController.text = user.name ?? '';
              _emailController.text = user.email ?? '';
              _didSeedControllers = true;
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Center(
                  child: Column(
                    children: [
                      GzAvatar(
                        letter: user.name ?? user.email ?? user.phone ?? 'P',
                        size: GzAvatarSize.xl,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const _ChangePhotoHint(),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _ProfileField(
                  label: 'Full name',
                  child: TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileField(
                  label: 'Email',
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldDecoration(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileField(
                  label: 'Phone',
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.changePhone),
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadiusLg,
                    ),
                    child: InputDecorator(
                      decoration: _fieldDecoration().copyWith(
                        hintText: 'Add a phone number',
                        suffixIcon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      child: Text(
                        user.phone?.trim().isNotEmpty == true
                            ? user.phone!.trim()
                            : 'Add a phone number',
                        style: AppTypography.body.copyWith(
                          color: user.phone?.trim().isNotEmpty == true
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Phone updates happen in a separate verification flow.',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                GzButton(
                  label: 'Save changes',
                  onPressed: isSaving ? null : _save,
                  loading: isSaving,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    await ref
        .read(editProfileNotifierProvider.notifier)
        .submit(name: name, email: email);
  }
}

class _ChangePhotoHint extends StatelessWidget {
  const _ChangePhotoHint();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Avatar is derived from your profile name for now.',
      style: AppTypography.body.copyWith(color: AppColors.textSecondary),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Text(label, style: AppTypography.meta),
        ),
        child,
      ],
    );
  }
}

InputDecoration _fieldDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      borderSide: const BorderSide(color: AppColors.rule),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      borderSide: const BorderSide(color: AppColors.textPrimary),
    ),
  );
}
