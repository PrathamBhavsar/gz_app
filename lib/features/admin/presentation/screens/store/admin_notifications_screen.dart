import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_chip.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_section_head.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/admin_notify_send_notifier.dart';

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
  String _channel = 'push';
  String _audience = 'all';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewTitle = _titleCtrl.text.trim().isEmpty
        ? 'Notification title'
        : _titleCtrl.text.trim();
    final previewBody = _bodyCtrl.text.trim().isEmpty
        ? 'Notification body preview'
        : _bodyCtrl.text.trim();
    final commandState = ref.watch(adminNotifySendNotifierProvider);

    ref.listen<AdminCommandState>(adminNotifySendNotifierProvider, (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(adminNotifySendNotifierProvider.notifier).reset();
        _titleCtrl.clear();
        _bodyCtrl.clear();
        setState(() {});
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Notifications'),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GzSectionHead('Channel'),
                GzCard(
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      GzAdminChip(
                        label: 'Push',
                        active: _channel == 'push',
                        onTap: () => setState(() => _channel = 'push'),
                      ),
                      GzAdminChip(
                        label: 'Email',
                        active: _channel == 'email',
                        onTap: () => setState(() => _channel = 'email'),
                      ),
                      GzAdminChip(
                        label: 'SMS',
                        active: _channel == 'sms',
                        onTap: () => setState(() => _channel = 'sms'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const GzSectionHead('Audience'),
                GzCard(
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      GzAdminChip(
                        label: 'All Players',
                        active: _audience == 'all',
                        onTap: () => setState(() => _audience = 'all'),
                      ),
                      GzAdminChip(
                        label: 'Active Now',
                        active: _audience == 'active',
                        onTap: () => setState(() => _audience = 'active'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const GzSectionHead('Compose'),
                GzCard(
                  child: Column(
                    children: [
                      _ComposeField(
                        label: 'Title',
                        controller: _titleCtrl,
                        onChanged: () => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _ComposeField(
                        label: 'Body',
                        controller: _bodyCtrl,
                        maxLines: 5,
                        onChanged: () => setState(() {}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const GzSectionHead('Preview'),
                GzCard(
                  variant: CardVariant.inset,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.infoBg,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusLg,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const HugeIcon(
                          icon: HugeIcons.strokeRoundedNotification03,
                          color: AppColors.info,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(previewTitle, style: AppTypography.h3),
                            const SizedBox(height: 4),
                            Text(
                              previewBody,
                              style: AppTypography.bodyR.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                GzButton(
                  label: 'Send notification',
                  loading: commandState is AdminCommandLoading,
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _send() {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (title.isEmpty || body.isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Title and body are required'),
      );
      return;
    }
    ref.read(adminNotifySendNotifierProvider.notifier).send(
      title: title,
      body: body,
      channel: _channel,
      audience: _audience,
    );
  }
}

class _ComposeField extends StatelessWidget {
  const _ComposeField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => onChanged(),
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
