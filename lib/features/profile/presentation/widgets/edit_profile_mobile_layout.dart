import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../providers/edit_profile_notifier.dart';
import '../providers/profile_notifier.dart';

class EditProfileMobileLayout extends ConsumerStatefulWidget {
  const EditProfileMobileLayout({super.key});

  @override
  ConsumerState<EditProfileMobileLayout> createState() =>
      _EditProfileMobileLayoutState();
}

class _EditProfileMobileLayoutState
    extends ConsumerState<EditProfileMobileLayout> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _initControllers(String name, String? email) {
    if (_initialized) return;
    _nameCtrl = TextEditingController(text: name);
    _emailCtrl = TextEditingController(text: email ?? '');
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final formState = ref.watch(editProfileProvider);

    ref.listen(editProfileProvider, (_, next) {
      if (next is EditProfileSuccess) {
        ref.read(profileNotifierProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated'),
          backgroundColor: AppColors.ok,
        ));
        context.pop();
      } else if (next is EditProfileError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text((next).message),
          backgroundColor: AppColors.err,
        ));
      }
    });

    return profileState.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (_, _) => Column(children: [
        const EmTopBar(title: 'Edit Profile'),
        Expanded(
          child: Center(
            child: Text('Unable to load profile',
                style: AppTypography.bodyR
                    .copyWith(color: AppColors.textSecondary)),
          ),
        ),
      ]),
      data: (user) {
        _initControllers(user.name ?? '', user.email);
        final isLoading = formState is EditProfileLoading;
        final emailVerified = user.isVerified ?? false;

        return Column(
          children: [
            EmTopBar(
              title: 'Edit Profile',
              trailing: GestureDetector(
                onTap: isLoading
                    ? null
                    : () => ref.read(editProfileProvider.notifier).save(
                          name: _nameCtrl.text.trim(),
                          email: _emailCtrl.text.trim().isEmpty
                              ? null
                              : _emailCtrl.text.trim(),
                        ),
                child: Text(
                  isLoading ? 'Saving…' : 'Save',
                  style: AppTypography.body.copyWith(
                    color: isLoading
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: EmScrollContent(
                padded: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Full name'),
                    _TextField(
                      controller: _nameCtrl,
                      hint: 'Your name',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(child: _FieldLabel('Email address')),
                        EmTag(
                          kind: emailVerified ? EmTagKind.ok : EmTagKind.warn,
                          label: emailVerified ? 'Verified' : 'Unverified',
                        ),
                      ],
                    ),
                    _TextField(
                      controller: _emailCtrl,
                      hint: 'your@email.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (!emailVerified && (user.email?.isNotEmpty ?? false)) ...[
                      const SizedBox(height: AppSpacing.sm),
                      EmCard(
                        variant: CardVariant.inset,
                        child: Row(children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedInformationCircle,
                            color: AppColors.warn,
                            size: 16,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Verify your email to enable email notifications.',
                              style: AppTypography.small
                                  .copyWith(color: AppColors.warn),
                            ),
                          ),
                        ]),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    EmButtonFull(
                      label: 'Save Changes',
                      loading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () => ref.read(editProfileProvider.notifier).save(
                                name: _nameCtrl.text.trim(),
                                email: _emailCtrl.text.trim().isEmpty
                                    ? null
                                    : _emailCtrl.text.trim(),
                              ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(label,
        style: AppTypography.small.copyWith(color: AppColors.textSecondary)),
  );
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
  });
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      border: Border.all(color: AppColors.rule),
    ),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.body,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        hintText: hint,
        hintStyle: AppTypography.bodyR
            .copyWith(color: AppColors.textMuted),
      ),
    ),
  );
}
