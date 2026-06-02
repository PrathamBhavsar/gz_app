import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_section_head.dart';
import '../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../../core/errors/app_exception.dart';
import '../providers/notif_prefs_notifier.dart';

class NotifPrefsMobileLayout extends ConsumerWidget {
  const NotifPrefsMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notifPrefsProvider);

    return Column(
      children: [
        const GzTopBar(title: 'Notifications'),
        Expanded(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => PageErrorDisplay(
              error: AppPageError.from(e),
              onRetry: () =>
                  ref.read(notifPrefsProvider.notifier).refresh(),
            ),
            data: (prefs) => _PrefsContent(prefs: prefs),
          ),
        ),
      ],
    );
  }
}

class _PrefsContent extends ConsumerWidget {
  const _PrefsContent({required this.prefs});
  final NotifPrefsData prefs;

  void _update(WidgetRef ref, NotifPrefsData updated) =>
      ref.read(notifPrefsProvider.notifier).update(updated);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GzScrollContent(
      padded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GzSectionHead('Channels'),
          GzCard(
            padding: 0,
            child: Column(
              children: [
                _ToggleRow(
                  label: 'Push Notifications',
                  value: prefs.push,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(push: v)),
                ),
                _Divider(),
                _ToggleRow(
                  label: 'Email Notifications',
                  value: prefs.email,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(email: v)),
                ),
                _Divider(),
                _ToggleRow(
                  label: 'SMS Notifications',
                  value: prefs.sms,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(sms: v)),
                ),
                _Divider(),
                _ToggleRow(
                  label: 'In-App Notifications',
                  value: true,
                  onChanged: null,
                  subtitle: 'Always on',
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          const GzSectionHead('When to notify me'),
          GzCard(
            padding: 0,
            child: Column(
              children: [
                _ToggleRow(
                  label: 'Booking confirmations',
                  value: prefs.bookingConfirmations,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(bookingConfirmations: v)),
                ),
                _Divider(),
                _ToggleRow(
                  label: 'Booking reminders',
                  value: prefs.bookingReminders,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(bookingReminders: v)),
                ),
                _Divider(),
                _ToggleRow(
                  label: 'Session ending soon',
                  value: prefs.sessionEnding,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(sessionEnding: v)),
                ),
                _Divider(),
                _ToggleRow(
                  label: 'Credit balance updates',
                  value: prefs.creditUpdates,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(creditUpdates: v)),
                ),
                _Divider(),
                _ToggleRow(
                  label: 'New campaigns',
                  value: prefs.newCampaigns,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(newCampaigns: v)),
                ),
                _Divider(),
                _ToggleRow(
                  label: 'Dispute status updates',
                  value: prefs.disputeUpdates,
                  onChanged: (v) =>
                      _update(ref, prefs.copyWith(disputeUpdates: v)),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Changes are saved automatically.',
            style: AppTypography.small
                .copyWith(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.body),
                if (subtitle != null)
                  Text(subtitle!,
                      style: AppTypography.small
                          .copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.buttonBg,
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.rule,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(left: AppSpacing.md),
    child: Divider(color: AppColors.rule, height: 1),
  );
}
