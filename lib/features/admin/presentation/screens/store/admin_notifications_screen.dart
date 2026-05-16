import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_auth_provider.dart';
import '../../../data/services/admin_store_service.dart';
final _notifChannelProvider = StateProvider.autoDispose<String>((ref) => 'push');
final _notifTargetProvider = StateProvider.autoDispose<String>((ref) => 'all');
final _notifSendingProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Admin Notifications — Screen 60.
/// Broadcast console with channel/target selector.
class AdminNotificationsScreen extends ConsumerStatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  ConsumerState<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState
    extends ConsumerState<AdminNotificationsScreen> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(adminRoleProvider);
    final canSend = role == 'super_admin' || role == 'admin';
    final channel = ref.watch(_notifChannelProvider);
    final target = ref.watch(_notifTargetProvider);
    final sending = ref.watch(_notifSendingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminSystemsMgmt),
        ),
        title: Text('Notifications', style: AppTypography.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),

            if (!canSend) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedLock,
                        color: AppColors.textSecondary,
                        size: 48,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('View only',
                          style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary)),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Only admins can send broadcasts.',
                          style: AppTypography.caption),
                    ],
                  ),
                ),
              ),
            ],

            // Broadcast Composer
            Text('Broadcast', style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _titleCtrl,
              enabled: canSend,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: AppTypography.caption,
                filled: true,
                fillColor: canSend ? AppColors.surface : AppColors.surface2,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _bodyCtrl,
              enabled: canSend,
              style: AppTypography.bodyMedium,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Message',
                labelStyle: AppTypography.caption,
                filled: true,
                fillColor: canSend ? AppColors.surface : AppColors.surface2,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Channel selector
            Text('Channel', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                _buildChip('Push', 'push', canSend, channel),
                _buildChip('Email', 'email', canSend, channel),
                _buildChip('In-App', 'in_app', canSend, channel),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Target selector
            Text('Target', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                _buildTargetChip('All Users', 'all', canSend, target),
                _buildTargetChip('On-Floor Players', 'on_floor', canSend, target),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Send button
            if (canSend)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: sending ? null : _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rose,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadius),
                    ),
                  ),
                  child: sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.background,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Send Broadcast', style: AppTypography.button),
                ),
              ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, String value, bool enabled, String channel) {
    final isActive = channel == value;
    return GestureDetector(
      onTap: enabled ? () => ref.read(_notifChannelProvider.notifier).state = value : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(
            color: isActive ? AppColors.rose : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color:
                isActive ? AppColors.background : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTargetChip(String label, String value, bool enabled, String target) {
    final isActive = target == value;
    return GestureDetector(
      onTap: enabled ? () => ref.read(_notifTargetProvider.notifier).state = value : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(
            color: isActive ? AppColors.rose : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color:
                isActive ? AppColors.background : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Future<void> _send() async {
    if (_titleCtrl.text.trim().isEmpty || _bodyCtrl.text.trim().isEmpty) {
      return;
    }

    ref.read(_notifSendingProvider.notifier).state = true;
    final channel = ref.read(_notifChannelProvider);
    final target = ref.read(_notifTargetProvider);

    try {
      final service = ref.read(adminStoreServiceProvider);
      if (target == 'on_floor') {
        await service.sendNotification({
          'title': _titleCtrl.text.trim(),
          'body': _bodyCtrl.text.trim(),
          'channel': channel,
          'target': target,
        });
      } else {
        await service.sendTopicNotification({
          'title': _titleCtrl.text.trim(),
          'body': _bodyCtrl.text.trim(),
          'channel': channel,
          'topic': 'all_users',
        });
      }

      if (mounted) {
        _titleCtrl.clear();
        _bodyCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Broadcast sent'),
            backgroundColor: AppColors.ok,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) ref.read(_notifSendingProvider.notifier).state = false;
    }
  }
}
