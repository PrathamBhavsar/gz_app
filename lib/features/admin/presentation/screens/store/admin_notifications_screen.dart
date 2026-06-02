import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_chip.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_section_head.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _titleCtrl = TextEditingController(text: 'Tonight at GZ Arena');
  final _bodyCtrl = TextEditingController(
    text:
        'Walk-in lanes open after 8 PM. Claim double credits on every 2-hour session.',
  );
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Notifications',
        onBack: () => context.go(AppRoutes.adminSystemsMgmt),
      ),
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
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
