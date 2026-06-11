import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_admin.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_section_head.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/store_config_command_notifier.dart';
import '../../../application/store_config_notifier.dart';

class StoreConfigScreen extends ConsumerStatefulWidget {
  const StoreConfigScreen({super.key});

  @override
  ConsumerState<StoreConfigScreen> createState() => _StoreConfigScreenState();
}

class _StoreConfigScreenState extends ConsumerState<StoreConfigScreen> {
  final _bookingWindowCtrl = TextEditingController();
  final _paymentWindowCtrl = TextEditingController();
  final _noShowGraceCtrl = TextEditingController();
  final _maxDurationCtrl = TextEditingController();
  final _hoursStartCtrl = TextEditingController();
  final _hoursEndCtrl = TextEditingController();
  bool _allowWalkIns = false;
  bool _autoStart = false;
  bool _seeded = false;

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
    final configState = ref.watch(storeConfigNotifierProvider);
    final commandState = ref.watch(storeConfigCommandNotifierProvider);

    ref.listen<AdminCommandState>(storeConfigCommandNotifierProvider, (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(storeConfigCommandNotifierProvider.notifier).reset();
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

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
            loading: commandState is AdminCommandLoading,
            onPressed: _save,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: configState.when(
          loading: () => const GzLoadingView(message: 'Loading store config'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(storeConfigNotifierProvider.notifier).refresh(),
          ),
          data: (config) {
            _seedForm(config);
            return GzScrollContent(
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
            );
          },
        ),
      ),
    );
  }

  void _seedForm(StoreConfigModel config) {
    if (_seeded) {
      return;
    }
    _seeded = true;
    _bookingWindowCtrl.text = '${config.bookingWindowMinutes ?? 0}';
    _paymentWindowCtrl.text = '${config.paymentWindowMinutes ?? 0}';
    _noShowGraceCtrl.text = '${config.noShowGraceMinutes ?? 0}';
    _maxDurationCtrl.text = '${config.maxBookingDurationMinutes ?? 0}';
    _hoursStartCtrl.text = config.operatingHoursStart ?? '';
    _hoursEndCtrl.text = config.operatingHoursEnd ?? '';
    _allowWalkIns = config.allowWalkIns ?? false;
    _autoStart = config.autoStartSessionOnCheckIn ?? false;
  }

  void _save() {
    final bookingWindow = int.tryParse(_bookingWindowCtrl.text.trim());
    final paymentWindow = int.tryParse(_paymentWindowCtrl.text.trim());
    final noShowGrace = int.tryParse(_noShowGraceCtrl.text.trim());
    final maxDuration = int.tryParse(_maxDurationCtrl.text.trim());
    if (bookingWindow == null ||
        paymentWindow == null ||
        noShowGrace == null ||
        maxDuration == null ||
        _hoursStartCtrl.text.trim().isEmpty ||
        _hoursEndCtrl.text.trim().isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Enter valid config values before saving'),
      );
      return;
    }

    ref.read(storeConfigCommandNotifierProvider.notifier).save(
      bookingWindowMinutes: bookingWindow,
      paymentWindowMinutes: paymentWindow,
      noShowGraceMinutes: noShowGrace,
      maxBookingDurationMinutes: maxDuration,
      operatingHoursStart: _hoursStartCtrl.text.trim(),
      operatingHoursEnd: _hoursEndCtrl.text.trim(),
      allowWalkIns: _allowWalkIns,
      autoStartSessionOnCheckIn: _autoStart,
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
