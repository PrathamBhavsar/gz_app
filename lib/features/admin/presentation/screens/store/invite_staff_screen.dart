import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';

class InviteStaffScreen extends StatefulWidget {
  const InviteStaffScreen({super.key});

  @override
  State<InviteStaffScreen> createState() => _InviteStaffScreenState();
}

class _InviteStaffScreenState extends State<InviteStaffScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedRole = 'Staff';
  bool _sent = false;

  static const _roleOptions = ['Admin', 'Staff'];

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
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
                        children: _roleOptions.asMap().entries.map((entry) {
                          final i = entry.key;
                          final o = entry.value;
                          final isSelected = o == _selectedRole;
                          final isLast = i == _roleOptions.length - 1;
                          return Padding(
                            padding: EdgeInsets.only(right: isLast ? 0 : 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = o),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.textPrimary
                                      : AppColors.pillBg,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.borderRadiusPill,
                                  ),
                                ),
                                child: Text(
                                  o,
                                  style: AppTypography.body.copyWith(
                                    color: isSelected
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
                      _permRow('Edit store config', _selectedRole == 'Admin'),
                      _permRow('Manage staff', _selectedRole == 'Admin'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (_sent)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GzCard(
                      variant: CardVariant.tint,
                      child: Text(
                        'Invitation sent to ${_emailController.text.isEmpty ? "staff member" : _emailController.text}!',
                        style: AppTypography.body.copyWith(color: AppColors.ok),
                      ),
                    ),
                  ),
                GzButton(
                  label: 'Send Invitation',
                  onPressed: () => setState(() => _sent = true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
