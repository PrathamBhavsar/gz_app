import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../providers/notifications_notifier.dart';

class NotificationsMobileLayout extends ConsumerWidget {
  const NotificationsMobileLayout({super.key});

  static List<List<dynamic>> _iconFor(String key) => switch (key) {
    'check' => HugeIcons.strokeRoundedCheckmarkCircle01,
    'star'  => HugeIcons.strokeRoundedStar,
    'bell'  => HugeIcons.strokeRoundedNotification01,
    'info'  => HugeIcons.strokeRoundedInformationCircle,
    'pin'   => HugeIcons.strokeRoundedLocation01,
    'pad'   => HugeIcons.strokeRoundedGameboy,
    _       => HugeIcons.strokeRoundedClock01,
  };

  static GzTagKind _kindFor(String k) => switch (k) {
    'ok'     => GzTagKind.ok,
    'warn'   => GzTagKind.warn,
    'err'    => GzTagKind.err,
    'info'   => GzTagKind.info,
    'purple' => GzTagKind.purple,
    _        => GzTagKind.mute,
  };

  static ({Color bg, Color fg}) _palette(String kind) {
    return switch (kind) {
      'ok'     => (bg: AppColors.okBg,     fg: AppColors.ok),
      'warn'   => (bg: AppColors.warnBg,   fg: AppColors.warn),
      'err'    => (bg: AppColors.errBg,    fg: AppColors.err),
      'info'   => (bg: AppColors.infoBg,   fg: AppColors.info),
      'purple' => (bg: AppColors.purpleBg, fg: AppColors.purple),
      _        => (bg: AppColors.pillBg,   fg: AppColors.textSecondary),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(notificationsProvider);
    final n = ref.read(notificationsProvider.notifier);
    final unread = s.items.where((it) => !it.read).length;

    return SafeArea(
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: const SizedBox(
                  width: 38, height: 38,
                  child: Center(child: HugeIcon(icon: HugeIcons.strokeRoundedMultiplicationSign, color: AppColors.textPrimary, size: 20)),
                ),
              ),
              Expanded(child: Center(child: Text('Notifications', style: AppTypography.h2))),
              GestureDetector(
                onTap: unread > 0 ? n.markAllRead : null,
                child: Text('Mark all read',
                    style: AppTypography.small.copyWith(
                        color: unread > 0 ? AppColors.textPrimary : AppColors.textMuted,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm + AppSpacing.xs, AppSpacing.md, AppSpacing.sm + AppSpacing.xs),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GzTag(
                kind: unread > 0 ? GzTagKind.info : GzTagKind.mute,
                label: '$unread unread',
              ),
            ),
          ),

          // ── List ──
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: s.items.length,
              itemBuilder: (context, i) {
                final notif  = s.items[i];
                final open   = s.expandedId == notif.id;
                final p      = _palette(notif.kind);

                return GestureDetector(
                  onTap: () => n.toggleExpand(notif.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: notif.read
                          ? Colors.transparent
                          : AppColors.infoBg.withValues(alpha: 0.35),
                      border: Border(
                        top: BorderSide(color: AppColors.rule),
                        bottom: i == s.items.length - 1 ? BorderSide(color: AppColors.rule) : BorderSide.none,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // Unread dot
                        Container(
                          width: 8, height: 8,
                          margin: const EdgeInsets.only(top: 14),
                          decoration: BoxDecoration(
                            color: notif.read ? Colors.transparent : AppColors.info,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        // Icon circle
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: p.bg, shape: BoxShape.circle),
                          child: Center(child: HugeIcon(icon: _iconFor(notif.icon), color: p.fg, size: 17)),
                        ),
                        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                        // Content
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                              Expanded(
                                child: Text(notif.title,
                                    style: AppTypography.body.copyWith(fontWeight: notif.read ? FontWeight.w500 : FontWeight.w700),
                                    overflow: open ? TextOverflow.visible : TextOverflow.ellipsis,
                                    maxLines: open ? null : 1),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(notif.when, style: AppTypography.small),
                            ]),
                            const SizedBox(height: 3),
                            Text(notif.body,
                                style: AppTypography.bodyR.copyWith(fontSize: 13),
                                overflow: open ? TextOverflow.visible : TextOverflow.ellipsis,
                                maxLines: open ? null : 1),
                            if (open) ...[
                              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                              Text(notif.action,
                                  style: AppTypography.body.copyWith(
                                      fontSize: 13, fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline)),
                            ],
                          ]),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
