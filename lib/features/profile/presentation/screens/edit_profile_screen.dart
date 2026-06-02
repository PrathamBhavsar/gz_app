import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_avatar.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Rahul Mehra');
    _emailController = TextEditingController(text: 'rahul@example.com');
    _phoneController = TextEditingController(text: '+91 98765 43210');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'Edit profile',
        trailing: TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile changes saved locally.')),
            );
          },
          child: Text(
            'Save',
            style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            const Center(
              child: Column(
                children: [
                  GzAvatar(letter: 'R', size: GzAvatarSize.xl),
                  SizedBox(height: AppSpacing.sm),
                  _ChangePhotoLink(),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _ProfileField(
              label: 'Full Name',
              child: TextField(
                controller: _nameController,
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
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _fieldDecoration(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangePhotoLink extends StatelessWidget {
  const _ChangePhotoLink();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Change photo',
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
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
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
