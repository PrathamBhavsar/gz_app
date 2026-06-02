import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import 'package:gz_app/features/notifications/presentation/widgets/notification_center_sheet.dart';
import '../../../../shared/widgets/connectivity_banner.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_live_dot.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/activity_hub_notifier.dart';

class SessionsMobileLayout extends ConsumerWidget {
  const SessionsMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(activityHubProvider);
    final n = ref.read(activityHubProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          // ── Title row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('My games', style: AppTypography.title),
              Row(children: [
                _IconBtn(
                  icon: HugeIcons.strokeRoundedFilter,
                  onTap: () {},
                  tooltip: 'Filter',
                ),
                _IconBtn(
                  icon: HugeIcons.strokeRoundedNotification01,
                  onTap: () => showNotificationCenter(context),
                  tooltip: 'Notifications',
                ),
              ]),
            ]),
          ),

          const ConnectivityBanner(),

          // ── Tab bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm + AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.pillBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: s.data.when(
                loading: () => Row(children: [
                  _Tab(id: 'upcoming', label: 'Upcoming', active: s.tab == 'upcoming', onTap: () => n.setTab('upcoming')),
                  _Tab(id: 'active',   label: 'Active',   active: s.tab == 'active',   onTap: () => n.setTab('active')),
                  _Tab(id: 'history',  label: 'History',  active: s.tab == 'history',  onTap: () => n.setTab('history')),
                ]),
                error: (e, st) => Row(children: [
                  _Tab(id: 'upcoming', label: 'Upcoming', active: s.tab == 'upcoming', onTap: () => n.setTab('upcoming')),
                  _Tab(id: 'active',   label: 'Active',   active: s.tab == 'active',   onTap: () => n.setTab('active')),
                  _Tab(id: 'history',  label: 'History',  active: s.tab == 'history',  onTap: () => n.setTab('history')),
                ]),
                data: (data) => Row(children: [
                  _Tab(
                    id: 'upcoming',
                    label: 'Upcoming',
                    count: data.upcomingBookings.isNotEmpty ? data.upcomingBookings.length : null,
                    active: s.tab == 'upcoming',
                    onTap: () => n.setTab('upcoming'),
                  ),
                  _Tab(
                    id: 'active',
                    label: 'Active',
                    dot: data.activeSession != null,
                    count: data.activeSession != null ? 1 : null,
                    active: s.tab == 'active',
                    onTap: () => n.setTab('active'),
                  ),
                  _Tab(
                    id: 'history',
                    label: 'History',
                    active: s.tab == 'history',
                    onTap: () => n.setTab('history'),
                  ),
                ]),
              ),
            ),
          ),

          // ── Tab content ──
          Expanded(
            child: s.data.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref.read(activityHubProvider.notifier).refresh(),
              ),
              data: (data) => RefreshIndicator(
                onRefresh: () => ref.read(activityHubProvider.notifier).refresh(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
                  children: [
                    if (s.tab == 'upcoming') ..._upcoming(context, n, data),
                    if (s.tab == 'active')   ..._active(context, data),
                    if (s.tab == 'history')  ..._history(context, s, n, data),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Upcoming tab ──
  List<Widget> _upcoming(BuildContext context, ActivityHubNotifier n, ActivityHubData data) {
    final items = <Widget>[];

    // Live session banner if active
    if (data.activeSession != null) {
      items.add(
        GestureDetector(
          onTap: () => n.setTab('active'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceTint,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
            ),
            child: Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(color: AppColors.buttonBg, shape: BoxShape.circle),
                child: const Center(child: GzLiveDot(color: AppColors.surfaceTintStrong, size: 8)),
              ),
              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Session live now', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    data.activeSession!.systemId ?? 'Active session',
                    style: AppTypography.small,
                  ),
                ]),
              ),
              const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.textPrimary, size: 18),
            ]),
          ),
        ),
      );
    }

    if (data.upcomingBookings.isEmpty && data.activeSession == null) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: GzCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.pillBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCalendar01,
                    color: AppColors.textTertiary,
                    size: 26,
                  )),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('No upcoming bookings', style: AppTypography.h2),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Book a slot to get started',
                  style: AppTypography.bodyR,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                GzButton(
                  label: 'Book a slot',
                  onPressed: () => context.go(AppRoutes.book),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        ),
      );
    } else {
      for (var i = 0; i < data.upcomingBookings.length; i++) {
        final booking = data.upcomingBookings[i];
        items.add(
          _BookingCard(
            booking: booking,
            onCardTap: () {
              if (booking.id != null) {
                context.push(AppRoutes.bookingDetailPath(booking.id!));
              }
            },
          )
              .animate(delay: (i * 60).ms)
              .fadeIn(duration: 220.ms)
              .slideY(begin: 0.05, end: 0, duration: 220.ms),
        );
        items.add(const SizedBox(height: AppSpacing.sm + AppSpacing.xs));
      }
    }

    return items;
  }

  // ── Active tab ──
  List<Widget> _active(BuildContext context, ActivityHubData data) {
    if (data.activeSession == null && data.activeBooking == null) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: GzCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.pillBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: HugeIcon(
                    icon: HugeIcons.strokeRoundedGameController01,
                    color: AppColors.textTertiary,
                    size: 26,
                  )),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('No active session', style: AppTypography.h2),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Check in to start playing',
                  style: AppTypography.bodyR,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        ),
      ];
    }

    final items = <Widget>[];

    if (data.activeSession != null) {
      final session = data.activeSession!;
      items.addAll([
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.surfaceTint,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Column(children: [
            Row(children: [
              const GzLiveDot(),
              const SizedBox(width: AppSpacing.sm),
              Text('LIVE NOW', style: AppTypography.meta.copyWith(color: AppColors.ok)),
            ]),
            const SizedBox(height: 14),
            Align(alignment: Alignment.centerLeft,
              child: Text(session.systemId ?? '—', style: AppTypography.h2)),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerLeft,
              child: Text(session.storeId ?? '—', style: AppTypography.small)),
            const SizedBox(height: 18),
            Text('ACTIVE SESSION', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
          ]),
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        if (session.id != null)
          GestureDetector(
            onTap: () {
              context.push(AppRoutes.activeSessionDetailPath(session.id!));
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.buttonBg,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Open session', style: AppTypography.button),
                const SizedBox(width: AppSpacing.sm),
                const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.buttonFg, size: 18),
              ]),
            ),
          ),
      ]);
    }

    return items;
  }

  // ── History tab ──
  List<Widget> _history(
    BuildContext context,
    ActivityHubState s,
    ActivityHubNotifier n,
    ActivityHubData data,
  ) {
    if (data.history.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: GzCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.pillBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: HugeIcon(
                    icon: HugeIcons.strokeRoundedClock01,
                    color: AppColors.textTertiary,
                    size: 26,
                  )),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('No activity yet', style: AppTypography.h2),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Completed sessions will appear here',
                  style: AppTypography.bodyR,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        ),
      ];
    }

    // Group by month
    final grouped = <String, List<SessionModel>>{};
    for (final session in data.history) {
      final dt = session.startedAt ?? session.createdAt;
      final key = dt != null ? _monthLabel(dt) : 'Unknown';
      (grouped[key] ??= []).add(session);
    }

    final items = <Widget>[];
    for (final entry in grouped.entries) {
      items.add(_MonthSep(label: entry.key.toUpperCase()));
      for (final session in entry.value) {
        items.add(_HistoryRow(
          id: session.id ?? '',
          store: session.storeId ?? '—',
          system: session.systemId ?? '—',
          dur: session.durationMinutes != null
              ? '${session.durationMinutes}m'
              : '—',
          cost: '—',
          cancelled: session.status == SessionStatus.cancelled,
          expanded: s.expandedHistId,
          onTap: n.toggleHist,
          onDetailTap: session.id != null
              ? () {
                  context.push(AppRoutes.sessionHistoryDetailPath(session.id!));
                }
              : null,
        ));
        items.add(const SizedBox(height: AppSpacing.sm));
      }
    }

    return items;
  }

  String _monthLabel(DateTime dt) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _Tab extends StatelessWidget {
  const _Tab({
    required this.id,
    required this.label,
    required this.active,
    required this.onTap,
    this.count,
    this.dot = false,
  });

  final String id;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final int? count;
  final bool dot;

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 150.ms,
        height: 40,
        decoration: BoxDecoration(
          color: active ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: active
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 3, offset: const Offset(0, 1))]
              : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (dot && active) ...[
            const GzLiveDot(size: 6),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTypography.small.copyWith(
              color: active ? AppColors.textPrimary : AppColors.textTertiary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: active ? AppColors.buttonBg : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: AppTypography.small.copyWith(
                  color: active ? AppColors.buttonFg : AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ]),
      ),
    ),
  );
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, this.onCardTap});

  final BookingModel booking;
  final VoidCallback? onCardTap;

  GzTagKind _tagKind(BookingStatus? status) => switch (status) {
        BookingStatus.confirmed => GzTagKind.ok,
        BookingStatus.pending => GzTagKind.warn,
        BookingStatus.checkedIn => GzTagKind.info,
        _ => GzTagKind.mute,
      };

  String _tagLabel(BookingStatus? status) => switch (status) {
        BookingStatus.confirmed => 'Confirmed',
        BookingStatus.pending => 'Payment pending',
        BookingStatus.checkedIn => 'Checked in',
        _ => '—',
      };

  String _formatWhen() {
    final start = booking.scheduledStart;
    if (start == null) return '—';
    final end = booking.scheduledEnd;
    final h1 = start.hour.toString().padLeft(2, '0');
    final m1 = start.minute.toString().padLeft(2, '0');
    final h2 = end?.hour.toString().padLeft(2, '0') ?? '—';
    final m2 = end?.minute.toString().padLeft(2, '0') ?? '—';
    return '${start.day}/${start.month} · $h1:$m1 – $h2:$m2';
  }

  String _formatDuration() {
    final start = booking.scheduledStart;
    final end = booking.scheduledEnd;
    if (start == null || end == null) return '—';
    final mins = end.difference(start).inMinutes;
    if (mins >= 60) {
      final h = mins ~/ 60;
      final m = mins % 60;
      return m > 0 ? '${h}h ${m}m' : '${h}h';
    }
    return '${mins}m';
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onCardTap,
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
            ),
            child: const Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedComputerDesk01,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                booking.systemId ?? '—',
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(booking.storeId ?? '—', style: AppTypography.small),
            ]),
          ),
          GzTag(
            kind: _tagKind(booking.status),
            label: _tagLabel(booking.status),
          ),
        ]),
        const SizedBox(height: 14),
        Wrap(spacing: 6, runSpacing: 6, children: [
          GzChip(keyLabel: 'WHEN', value: _formatWhen()),
          GzChip(keyLabel: 'FOR', value: _formatDuration()),
        ]),
        const SizedBox(height: 10),
        const HugeIcon(
          icon: HugeIcons.strokeRoundedArrowRight01,
          color: AppColors.textTertiary,
          size: 14,
        ),
      ]),
    ),
  );
}

class _MonthSep extends StatelessWidget {
  const _MonthSep({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(children: [
      Text(label, style: AppTypography.meta),
      const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
      Expanded(child: Container(height: 1, color: AppColors.rule)),
    ]),
  );
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.id,
    required this.store,
    required this.system,
    required this.dur,
    required this.cost,
    required this.cancelled,
    required this.expanded,
    required this.onTap,
    this.onDetailTap,
  });

  final String id, store, system, dur, cost;
  final bool cancelled;
  final String? expanded;
  final void Function(String) onTap;
  final VoidCallback? onDetailTap;

  bool get open => expanded == id;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
    ),
    child: Column(children: [
      GestureDetector(
        onTap: () => onTap(id),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  store,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text('$system · $dur', style: AppTypography.small),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                cost,
                style: AppTypography.num.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cancelled ? AppColors.textTertiary : AppColors.textPrimary,
                  decoration: cancelled ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                cancelled ? 'Cancelled' : 'Completed',
                style: AppTypography.small.copyWith(
                  color: cancelled ? AppColors.err : AppColors.textTertiary,
                ),
              ),
            ]),
          ]),
        ),
      ),
      if (open) ...[
        Container(
          height: 1,
          color: AppColors.rule,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
          child: Column(children: [
            GzMetaRow(label: 'Session ID', value: id.length > 8 ? '#${id.substring(0, 8)}' : '#$id'),
            if (onDetailTap != null)
              GestureDetector(
                onTap: onDetailTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      'View details',
                      style: AppTypography.small.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                      color: AppColors.textPrimary,
                      size: 14,
                    ),
                  ]),
                ),
              ),
          ]),
        ),
      ],
    ]),
  );
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap, this.tooltip});

  final List<List<dynamic>> icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    Widget btn = GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Center(
          child: HugeIcon(icon: icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
    if (tooltip != null) {
      btn = Tooltip(message: tooltip!, child: btn);
    }
    return btn;
  }
}
