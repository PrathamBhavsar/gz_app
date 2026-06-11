import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';

Future<void> showEditStaffSheet(
  BuildContext context, {
  required String staffId,
  required String staffName,
  required String currentRole,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EditStaffSheet(
      staffId: staffId,
      staffName: staffName,
      currentRole: currentRole,
    ),
  );
}

class EditStaffSheet extends StatefulWidget {
  const EditStaffSheet({
    super.key,
    required this.staffId,
    required this.staffName,
    required this.currentRole,
  });

  final String staffId;
  final String staffName;
  final String currentRole;

  @override
  State<EditStaffSheet> createState() => _EditStaffSheetState();
}

class _EditStaffSheetState extends State<EditStaffSheet> {
  late String _selectedRole;
  bool _removed = false;
  bool _saved = false;

  static const _roleOptions = ['Admin', 'Staff'];

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.currentRole;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusPill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    GzAvatar(
                      letter: widget.staffName.substring(0, 1),
                      size: GzAvatarSize.lg,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.staffName, style: AppTypography.h2),
                        Text(widget.currentRole, style: AppTypography.bodyR),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Change role', style: AppTypography.h3),
                const SizedBox(height: 10),
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
                const SizedBox(height: 18),
                if (_saved)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GzCard(
                      variant: CardVariant.tint,
                      child: Text(
                        'Role updated to $_selectedRole',
                        style: AppTypography.body.copyWith(color: AppColors.ok),
                      ),
                    ),
                  ),
                GzButton(
                  label: _saved ? 'Done' : 'Save Role',
                  onPressed: _saved
                      ? () => Navigator.pop(context)
                      : () => setState(() => _saved = true),
                ),
                const SizedBox(height: 8),
                if (!_removed)
                  GzButton(
                    label: 'Remove from staff',
                    variant: GzButtonVariant.dangerOutline,
                    onPressed: () => setState(() => _removed = true),
                  ),
                if (_removed)
                  GzCard(
                    variant: CardVariant.inset,
                    child: Text(
                      '${widget.staffName} has been removed.',
                      style: AppTypography.body.copyWith(color: AppColors.err),
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
