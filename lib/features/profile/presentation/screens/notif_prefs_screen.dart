import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/notif_prefs_notifier.dart';

class NotifPrefsScreen extends ConsumerWidget {
  const NotifPrefsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsState = ref.watch(notifPrefsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Notifications'),
      body: SafeArea(
        top: false,
        child: prefsState.when(
          loading: () =>
              const GzLoadingView(message: 'Loading notification preferences'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () =>
                ref.read(notifPrefsNotifierProvider.notifier).refresh(),
          ),
          data: (prefs) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              _ToggleCard(
                children: [
                  _ToggleRow(
                    label: 'Push notifications',
                    value: prefs['push_notifications'] ?? true,
                    onChanged: (value) =>
                        _updatePref(context, ref, 'push_notifications', value),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Channels', style: AppTypography.meta),
              const SizedBox(height: AppSpacing.sm),
              _ToggleCard(
                children: [
                  _ToggleRow(
                    label: 'Booking updates',
                    value: prefs['booking_updates'] ?? true,
                    onChanged: (value) =>
                        _updatePref(context, ref, 'booking_updates', value),
                  ),
                  _ToggleRow(
                    label: 'Session alerts',
                    value: prefs['session_alerts'] ?? true,
                    onChanged: (value) =>
                        _updatePref(context, ref, 'session_alerts', value),
                  ),
                  _ToggleRow(
                    label: 'Promotions',
                    value: prefs['promotions'] ?? false,
                    onChanged: (value) =>
                        _updatePref(context, ref, 'promotions', value),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Topics', style: AppTypography.meta),
              const SizedBox(height: AppSpacing.sm),
              _ToggleCard(
                children: [
                  _ToggleRow(
                    label: 'New campaigns',
                    value: prefs['new_campaigns'] ?? true,
                    onChanged: (value) =>
                        _updatePref(context, ref, 'new_campaigns', value),
                  ),
                  _ToggleRow(
                    label: 'System availability',
                    value: prefs['system_availability'] ?? false,
                    onChanged: (value) =>
                        _updatePref(context, ref, 'system_availability', value),
                  ),
                  _ToggleRow(
                    label: 'Credit expiry',
                    value: prefs['credit_expiry'] ?? true,
                    onChanged: (value) =>
                        _updatePref(context, ref, 'credit_expiry', value),
                    showDivider: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updatePref(
    BuildContext context,
    WidgetRef ref,
    String key,
    bool value,
  ) async {
    try {
      await ref
          .read(notifPrefsNotifierProvider.notifier)
          .setPreference(key, value);
    } catch (error) {
      if (context.mounted) {
        showErrorSnackbar(context, error);
      }
    }
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTypography.h3)),
              _PreferenceSwitch(value: value, onChanged: onChanged),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  const _PreferenceSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: AppSpacing.xxl + AppSpacing.sm,
        height: AppSpacing.lg + AppSpacing.sm,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? AppColors.textPrimary : AppColors.rule,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: AppSpacing.lg + AppSpacing.xs,
            height: AppSpacing.lg + AppSpacing.xs,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
