import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_section_head.dart';

class StoreConfigScreen extends StatefulWidget {
  const StoreConfigScreen({super.key});

  @override
  State<StoreConfigScreen> createState() => _StoreConfigScreenState();
}

class _StoreConfigScreenState extends State<StoreConfigScreen> {
  final _bookingWindowCtrl = TextEditingController(text: '1440');
  final _paymentWindowCtrl = TextEditingController(text: '30');
  final _noShowGraceCtrl = TextEditingController(text: '10');
  final _maxDurationCtrl = TextEditingController(text: '240');
  final _hoursStartCtrl = TextEditingController(text: '10:00');
  final _hoursEndCtrl = TextEditingController(text: '23:00');
  bool _allowWalkIns = true;
  bool _autoStart = true;

  @override
  void dispose() {
    _bookingWindowCtrl.dispose();
    _paymentWindowCtrl.dispose();
    _noShowGraceCtrl.dispose();
    _maxDurationCtrl.dispose();
    _hoursStartCtrl.dispose();
    _hoursEndCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Store Config',
        trailing: SizedBox(
          width: 72,
          child: GzButton(
            label: 'Save',
            variant: GzButtonVariant.ghost,
            small: true,
            onPressed: () {},
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
                const GzSectionHead('Booking settings'),
                GzCard(
                  child: Column(
                    children: [
                      _ConfigField(
                        label: 'Booking window',
                        valueController: _bookingWindowCtrl,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ConfigField(
                        label: 'Payment window',
                        valueController: _paymentWindowCtrl,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ConfigField(
                        label: 'No-show grace',
                        valueController: _noShowGraceCtrl,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ConfigField(
                        label: 'Max duration',
                        valueController: _maxDurationCtrl,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const GzSectionHead('Operating hours'),
                GzCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: _ConfigField(
                          label: 'Opens',
                          valueController: _hoursStartCtrl,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _ConfigField(
                          label: 'Closes',
                          valueController: _hoursEndCtrl,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const GzSectionHead('Operations'),
                GzCard(
                  child: Column(
                    children: [
                      _ToggleRow(
                        label: 'Allow walk-ins',
                        value: _allowWalkIns,
                        onChanged: (value) {
                          setState(() => _allowWalkIns = value);
                        },
                      ),
                      const Divider(height: 24, color: AppColors.rule),
                      _ToggleRow(
                        label: 'Auto-start on check-in',
                        value: _autoStart,
                        onChanged: (value) {
                          setState(() => _autoStart = value);
                        },
                      ),
                    ],
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

class _ConfigField extends StatelessWidget {
  const _ConfigField({
    required this.label,
    required this.valueController,
    this.keyboardType = TextInputType.number,
  });

  final String label;
  final TextEditingController valueController;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: valueController,
      keyboardType: keyboardType,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.small,
        filled: true,
        fillColor: AppColors.pillBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          borderSide: const BorderSide(color: AppColors.rule),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.buttonBg,
          activeTrackColor: AppColors.surfaceTintStrong,
          inactiveThumbColor: AppColors.textMuted,
          inactiveTrackColor: AppColors.pillBg,
        ),
      ],
    );
  }
}
