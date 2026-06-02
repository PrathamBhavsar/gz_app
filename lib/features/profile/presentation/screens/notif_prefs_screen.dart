import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class NotifPrefsScreen extends StatefulWidget {
  const NotifPrefsScreen({super.key});

  @override
  State<NotifPrefsScreen> createState() => _NotifPrefsScreenState();
}

class _NotifPrefsScreenState extends State<NotifPrefsScreen> {
  bool _pushNotifications = true;
  bool _bookingUpdates = true;
  bool _sessionAlerts = true;
  bool _promotions = false;
  bool _newCampaigns = true;
  bool _systemAvailability = false;
  bool _creditExpiry = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Notifications'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _ToggleCard(
              children: [
                _ToggleRow(
                  label: 'Push notifications',
                  value: _pushNotifications,
                  onChanged: (value) => setState(() => _pushNotifications = value),
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
                  value: _bookingUpdates,
                  onChanged: (value) => setState(() => _bookingUpdates = value),
                ),
                _ToggleRow(
                  label: 'Session alerts',
                  value: _sessionAlerts,
                  onChanged: (value) => setState(() => _sessionAlerts = value),
                ),
                _ToggleRow(
                  label: 'Promotions',
                  value: _promotions,
                  onChanged: (value) => setState(() => _promotions = value),
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
                  value: _newCampaigns,
                  onChanged: (value) => setState(() => _newCampaigns = value),
                ),
                _ToggleRow(
                  label: 'System availability',
                  value: _systemAvailability,
                  onChanged: (value) => setState(() => _systemAvailability = value),
                ),
                _ToggleRow(
                  label: 'Credit expiry',
                  value: _creditExpiry,
                  onChanged: (value) => setState(() => _creditExpiry = value),
                  showDivider: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
              _PreferenceSwitch(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  const _PreferenceSwitch({
    required this.value,
    required this.onChanged,
  });

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
