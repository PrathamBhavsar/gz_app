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

final _allowWalkInsProvider = StateProvider.autoDispose<bool>((ref) => true);
final _autoStartProvider = StateProvider.autoDispose<bool>((ref) => true);
final _configSavingProvider = StateProvider.autoDispose<bool>((ref) => false);

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
  bool _controllersPopulated = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(storeConfigProvider.notifier).load();
      ref.listenManual(storeConfigProvider, (_, next) {
        if (next is ManagementLoaded<Map<String, dynamic>> && !_controllersPopulated) {
          _controllersPopulated = true;
          final c = next.data;
          _bookingWindowCtrl.text = (c['booking_window_minutes'] ?? '').toString();
          _paymentWindowCtrl.text = (c['payment_window_minutes'] ?? '').toString();
          _noShowGraceCtrl.text = (c['no_show_grace_minutes'] ?? '').toString();
          _maxDurationCtrl.text = (c['max_booking_duration_minutes'] ?? '').toString();
          _hoursStartCtrl.text = (c['operating_hours_start'] ?? '').toString();
          _hoursEndCtrl.text = (c['operating_hours_end'] ?? '').toString();
          ref.read(_allowWalkInsProvider.notifier).state =
              c['allow_walk_ins'] as bool? ?? true;
          ref.read(_autoStartProvider.notifier).state =
              c['auto_start_session_on_check_in'] as bool? ?? true;
        }
      });
    });
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
    final allowWalkIns = ref.watch(_allowWalkInsProvider);
    final autoStart = ref.watch(_autoStartProvider);
    final saving = ref.watch(_configSavingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminSystemsMgmt),
        ),
        title: Text('Store Config', style: AppTypography.headingSmall),
      ),
      body: state is ManagementLoaded<Map<String, dynamic>>
          ? _buildForm(state.data, isSuperAdmin, allowWalkIns, autoStart, saving)
          : state is ManagementError<Map<String, dynamic>>
              ? _buildError(state.error)
              : const Center(
                  child: CircularProgressIndicator(color: AppColors.rose),
                ),
    );
  }

  Widget _buildForm(Map<String, dynamic> config, bool isSuperAdmin,
      bool allowWalkIns, bool autoStart, bool saving) {

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
          _buildToggle('Allow Walk-ins', allowWalkIns, (v) {
            if (isSuperAdmin) ref.read(_allowWalkInsProvider.notifier).state = v;
          }),
          _buildToggle('Auto-start session on check-in', autoStart, (v) {
            if (isSuperAdmin) ref.read(_autoStartProvider.notifier).state = v;
          }),
          const SizedBox(height: AppSpacing.xl),

          // Save button
          if (isSuperAdmin)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rose,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                  ),
                ),
                child: saving
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
            activeThumbColor: AppColors.rose,
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
    ref.read(_configSavingProvider.notifier).state = true;
    final success = await ref.read(storeConfigProvider.notifier).updateConfig({
      'booking_window_minutes': int.tryParse(_bookingWindowCtrl.text),
      'payment_window_minutes': int.tryParse(_paymentWindowCtrl.text),
      'no_show_grace_minutes': int.tryParse(_noShowGraceCtrl.text),
      'max_booking_duration_minutes': int.tryParse(_maxDurationCtrl.text),
      'operating_hours_start': _hoursStartCtrl.text.trim(),
      'operating_hours_end': _hoursEndCtrl.text.trim(),
      'allow_walk_ins': ref.read(_allowWalkInsProvider),
      'auto_start_session_on_check_in': ref.read(_autoStartProvider),
    });
    if (mounted) {
      ref.read(_configSavingProvider.notifier).state = false;
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Config updated'),
            backgroundColor: AppColors.ok,
          ),
        );
      }
    }
  }
}
