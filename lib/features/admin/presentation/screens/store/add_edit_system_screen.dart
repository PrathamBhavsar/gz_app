import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';

class AddEditSystemScreen extends StatefulWidget {
  const AddEditSystemScreen({super.key, this.id});

  final String? id;

  @override
  State<AddEditSystemScreen> createState() => _AddEditSystemScreenState();
}

class _AddEditSystemScreenState extends State<AddEditSystemScreen> {
  final _nameCtrl = TextEditingController();
  final _seatCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _specsCtrl = TextEditingController();

  String _selectedType = 'PC';
  String _selectedStatus = 'Available';
  bool _saved = false;

  static const _types = ['PC', 'PS5', 'Xbox', 'VR', 'Other'];
  static const _statusOptions = ['Available', 'Maintenance'];

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      // Fill with demo values for edit mode
      _nameCtrl.text = 'PC Station 01';
      _seatCtrl.text = '01';
      _rateCtrl.text = '80';
      _specsCtrl.text = 'RTX 4090 · 32GB · 240Hz';
      _selectedType = 'PC';
      _selectedStatus = 'Available';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _seatCtrl.dispose();
    _rateCtrl.dispose();
    _specsCtrl.dispose();
    super.dispose();
  }

  Widget _inputField(
    String label,
    TextEditingController ctrl, {
    String? hint,
    TextInputType? kbType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.small),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.pillBg,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: kbType ?? TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppTypography.bodyR,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: AppTypography.bodyR.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _typeChip(String type) {
    final isActive = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.buttonBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
          border: isActive ? null : Border.all(color: AppColors.rule),
        ),
        alignment: Alignment.center,
        child: Text(
          type,
          style: AppTypography.small.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.buttonFg : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final isActive = _selectedStatus == status;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.buttonBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
          border: isActive ? null : Border.all(color: AppColors.rule),
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: AppTypography.small.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.buttonFg : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.id != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(title: isEdit ? 'Edit System' : 'Add System'),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. System name
                _inputField(
                  'System name',
                  _nameCtrl,
                  hint: 'e.g. PC Station 04',
                ),

                // 2. System type
                Text('System type', style: AppTypography.small),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_types.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: i == _types.length - 1 ? 0 : 8,
                        ),
                        child: _typeChip(_types[i]),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Seat number
                _inputField('Seat / bay number', _seatCtrl, hint: '04'),

                // 4. Rate
                _inputField(
                  'Rate (₹ per hour)',
                  _rateCtrl,
                  hint: '80',
                  kbType: TextInputType.number,
                ),

                // 5. Specs
                _inputField(
                  'Specs / description',
                  _specsCtrl,
                  hint: 'RTX 4090 · 32GB · 240Hz',
                ),

                // 6. Status (edit mode only)
                if (isEdit) ...[
                  Text('Status', style: AppTypography.small),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(_statusOptions.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: i == _statusOptions.length - 1 ? 0 : 8,
                        ),
                        child: _statusChip(_statusOptions[i]),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                ],

                // 7. Success confirmation
                if (_saved) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GzCard(
                      variant: CardVariant.tint,
                      padding: 14,
                      child: Text(
                        isEdit ? 'Changes saved!' : 'System added!',
                        style: AppTypography.body.copyWith(color: AppColors.ok),
                      ),
                    ),
                  ),
                ],

                // 8. Primary action
                GzButton(
                  label: isEdit ? 'Save Changes' : 'Add System',
                  onPressed: () => setState(() => _saved = true),
                ),

                // 9. Remove (edit mode only)
                if (isEdit) ...[
                  const SizedBox(height: 8),
                  GzButton(
                    label: 'Remove System',
                    variant: GzButtonVariant.dangerOutline,
                    onPressed: () => context.pop(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
