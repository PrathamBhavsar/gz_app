import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_store_provider.dart';
import '../../providers/admin_auth_provider.dart';

/// Store Config — Screen 59.
/// Super Admin only. Operational settings and store profile.
class StoreConfigScreen extends ConsumerStatefulWidget {
  const StoreConfigScreen({super.key});

  @override
  ConsumerState<StoreConfigScreen> createState() =>
      _StoreConfigScreenState();
}

class _StoreConfigScreenState extends ConsumerState<StoreConfigScreen> {
  final _bookingWindowCtrl = TextEditingController();
  final _paymentWindowCtrl = TextEditingController();
  final _noShowGraceCtrl = TextEditingController();
  final _maxDurationCtrl = TextEditingController();
  final _hoursStartCtrl = TextEditingController();
  final _hoursEndCtrl = TextEditingController();
  bool _allowWalkIns = true;
  bool _autoStart = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(storeConfigProvider.notifier).load());
  }

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
    final isSuperAdmin = ref.watch(adminRoleProvider) == 'super_admin';
    final state = ref.watch(storeConfigProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminSystemsMgmt),
        ),
        title: Text('Store Config', style: AppTypography.headingSmall),
      ),
      body: state is ManagementLoaded
          ? _buildForm(state.data, isSuperAdmin)
          : state is ManagementError
              ? _buildError(state.error)
              : const Center(
                  child: CircularProgressIndicator(color: AppColors.rose),
                ),
    );
  }

  Widget _buildForm(Map<String, dynamic> config, bool isSuperAdmin) {
    // Populate controllers from config on first load
    if (_bookingWindowCtrl.text.isEmpty) {
      _bookingWindowCtrl.text =
          (config['booking_window_minutes'] ?? '').toString();
      _paymentWindowCtrl.text =
          (config['payment_window_minutes'] ?? '').toString();
      _noShowGraceCtrl.text =
          (config['no_show_grace_minutes'] ?? '').toString();
      _maxDurationCtrl.text =
          (config['max_booking_duration_minutes'] ?? '').toString();
      _hoursStartCtrl.text =
          (config['operating_hours_start'] ?? '').toString();
      _hoursEndCtrl.text =
          (config['operating_hours_end'] ?? '').toString();
      _allowWalkIns = config['allow_walk_ins'] as bool? ?? true;
      _autoStart = config['auto_start_session_on_check_in'] as bool? ?? true;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),

          // Operational Settings
          Text('Operational Settings', style: AppTypography.headingSmall),
          const SizedBox(height: AppSpacing.md),
          _buildField('Booking Window (min)', _bookingWindowCtrl, enabled: isSuperAdmin),
          const SizedBox(height: AppSpacing.md),
          _buildField('Payment Window (min)', _paymentWindowCtrl, enabled: isSuperAdmin),
          const SizedBox(height: AppSpacing.md),
          _buildField('No-Show Grace (min)', _noShowGraceCtrl, enabled: isSuperAdmin),
          const SizedBox(height: AppSpacing.md),
          _buildField('Max Booking Duration (min)', _maxDurationCtrl, enabled: isSuperAdmin),
          const SizedBox(height: AppSpacing.lg),

          // Operating Hours
          Text('Operating Hours', style: AppTypography.headingSmall),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _buildField('Start (HH:mm)', _hoursStartCtrl, enabled: isSuperAdmin)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildField('End (HH:mm)', _hoursEndCtrl, enabled: isSuperAdmin)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Toggles
          Text('Behavior', style: AppTypography.headingSmall),
          const SizedBox(height: AppSpacing.md),
          _buildToggle('Allow Walk-ins', _allowWalkIns, (v) {
            if (isSuperAdmin) setState(() => _allowWalkIns = v);
          }),
          _buildToggle('Auto-start session on check-in', _autoStart, (v) {
            if (isSuperAdmin) setState(() => _autoStart = v);
          }),
          const SizedBox(height: AppSpacing.xl),

          // Save button
          if (isSuperAdmin)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rose,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.background,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('Save Changes', style: AppTypography.button),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl,
      {bool enabled = true}) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      style: AppTypography.bodyMedium,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.caption,
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: AppTypography.bodyMedium)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.rose,
          ),
        ],
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load config',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () =>
                  ref.read(storeConfigProvider.notifier).load(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Retry', style: AppTypography.button),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final success = await ref.read(storeConfigProvider.notifier).updateConfig({
      'booking_window_minutes': int.tryParse(_bookingWindowCtrl.text),
      'payment_window_minutes': int.tryParse(_paymentWindowCtrl.text),
      'no_show_grace_minutes': int.tryParse(_noShowGraceCtrl.text),
      'max_booking_duration_minutes': int.tryParse(_maxDurationCtrl.text),
      'operating_hours_start': _hoursStartCtrl.text.trim(),
      'operating_hours_end': _hoursEndCtrl.text.trim(),
      'allow_walk_ins': _allowWalkIns,
      'auto_start_session_on_check_in': _autoStart,
    });
    if (mounted) {
      setState(() => _saving = false);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Config updated'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    }
  }
}
