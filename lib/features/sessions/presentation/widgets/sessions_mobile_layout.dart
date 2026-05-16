import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_chip.dart';
import '../../../../shared/widgets/em_meta_row.dart';
import '../../../../shared/widgets/em_live_dot.dart';
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
                _IconBtn(icon: HugeIcons.strokeRoundedFilter, onTap: () {}),
                _IconBtn(icon: HugeIcons.strokeRoundedNotification01, onTap: () => context.push(AppRoutes.notifications)),
              ]),
            ]),
          ),

          // ── Tab bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm + AppSpacing.xs, AppSpacing.md, AppSpacing.xs),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.pillBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                _Tab(id: 'upcoming', label: 'Upcoming', count: 2, active: s.tab == 'upcoming', onTap: () => n.setTab('upcoming')),
                _Tab(id: 'active',   label: 'Active',   count: 1, dot: true, active: s.tab == 'active',   onTap: () => n.setTab('active')),
                _Tab(id: 'history',  label: 'History',  active: s.tab == 'history',  onTap: () => n.setTab('history')),
              ]),
            ),
          ),

          // ── Tab content ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
              children: [
                if (s.tab == 'upcoming') ..._upcoming(context, n),
                if (s.tab == 'active')   ..._active(context),
                if (s.tab == 'history')  ..._history(context, s, n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Upcoming tab ──
  List<Widget> _upcoming(BuildContext context, ActivityHubNotifier n) => [
    // Live banner
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
            width: 38, height: 38,
            decoration: const BoxDecoration(color: AppColors.buttonBg, shape: BoxShape.circle),
            child: const Center(child: EmLiveDot(color: AppColors.surfaceTintStrong, size: 8)),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Session live now', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('RTX 4090 · 1:36:04 remaining', style: AppTypography.small),
          ])),
          const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.textPrimary, size: 18),
        ]),
      ),
    ),
    // Booking card 1
    _BookingCard(
      icon: HugeIcons.strokeRoundedComputerDesk01,
      system: 'RTX 4090 PC — Seat 3',
      store: 'GameZone Koramangala',
      when: 'Tomorrow · 4:00 – 6:00 PM',
      duration: '2h',
      statusTag: const EmTag(kind: EmTagKind.ok, label: 'Confirmed'),
      countdown: 'Starts in 18h 24m',
      actions: [
        _BookingAction(label: 'Check in', ghost: true, disabled: true, onTap: null),
        _BookingAction(label: 'Cancel',   ghost: true, onTap: () {}),
      ],
    ),
    const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
    // Booking card 2
    _BookingCard(
      icon: HugeIcons.strokeRoundedGameboy,
      system: 'PS5 Console — Seat 1',
      store: 'GameZone MG Road',
      when: 'Sat, 20 Apr · 6:00 – 7:00 PM',
      duration: '1h',
      statusTag: const EmTag(kind: EmTagKind.warn, label: 'Payment pending'),
      countdown: 'Pay before tomorrow 11 PM',
      countdownColor: AppColors.warn,
      actions: [
        _BookingAction(label: 'Pay now', primary: true, onTap: () {}),
        _BookingAction(label: 'Cancel',  ghost: true, onTap: () {}),
      ],
    ),
    const SizedBox(height: AppSpacing.xl),
    // Empty state
    Center(child: Column(children: [
      Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: AppColors.pillBg, borderRadius: BorderRadius.circular(14)),
        child: const Center(child: HugeIcon(icon: HugeIcons.strokeRoundedCalendar01, color: AppColors.textTertiary, size: 26)),
      ),
      const SizedBox(height: 14),
      Text('No more upcoming bookings', style: AppTypography.h3),
      const SizedBox(height: 4),
      Text('Find a slot for the weekend', style: AppTypography.small),
    ])),
  ];

  // ── Active tab ──
  List<Widget> _active(BuildContext context) => [
    Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Column(children: [
        Row(children: [
          const EmLiveDot(),
          const SizedBox(width: AppSpacing.sm),
          Text('LIVE NOW', style: AppTypography.meta.copyWith(color: AppColors.ok)),
        ]),
        const SizedBox(height: 14),
        Align(alignment: Alignment.centerLeft, child: Text('RTX 4090 — Seat 3', style: AppTypography.h2)),
        const SizedBox(height: 4),
        Align(alignment: Alignment.centerLeft, child: Text('GameZone Koramangala', style: AppTypography.small)),
        const SizedBox(height: 18),
        Text('REMAINING', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Text('1:36:04', style: AppTypography.hero),
        const SizedBox(height: 18),
        Container(height: 6, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(999)),
          child: const Align(alignment: Alignment.centerLeft,
            child: FractionallySizedBox(widthFactor: 0.20,
              child: DecoratedBox(decoration: BoxDecoration(
                color: AppColors.buttonBg, borderRadius: BorderRadius.all(Radius.circular(999)))))),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('₹31.87 so far', style: AppTypography.small),
          Text('20% complete', style: AppTypography.small),
        ]),
      ]),
    ),
    const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
    GestureDetector(
      onTap: () => context.push(AppRoutes.activeSession),
      child: Container(
        height: 56,
        decoration: BoxDecoration(color: AppColors.buttonBg, borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Open session', style: AppTypography.button),
          const SizedBox(width: AppSpacing.sm),
          const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.buttonFg, size: 18),
        ]),
      ),
    ),
    const SizedBox(height: AppSpacing.sm),
    Text('Live cost will keep accumulating until you check out', style: AppTypography.small, textAlign: TextAlign.center),
  ];

  // ── History tab ──
  List<Widget> _history(BuildContext context, ActivityHubState s, ActivityHubNotifier n) => [
    _MonthSep(label: 'APRIL 2026'),
    _HistoryRow(id: 'h1', store: 'GameZone Koramangala', system: 'RTX 4090', dur: '2h',   cost: '₹160', cancelled: false, expanded: s.expandedHistId, onTap: n.toggleHist),
    const SizedBox(height: AppSpacing.sm),
    _HistoryRow(id: 'h2', store: 'GameZone MG Road',     system: 'PS5',      dur: '1.5h', cost: '₹90',  cancelled: false, expanded: s.expandedHistId, onTap: n.toggleHist),
    const SizedBox(height: AppSpacing.sm),
    _HistoryRow(id: 'h3', store: 'GameZone Koramangala', system: 'Xbox',     dur: '—',    cost: '₹0',   cancelled: true,  expanded: s.expandedHistId, onTap: n.toggleHist),
    const SizedBox(height: AppSpacing.sm),
    _MonthSep(label: 'MARCH 2026'),
    _HistoryRow(id: 'h4', store: 'GameZone Koramangala', system: 'VR Rig',   dur: '1h',   cost: '₹200', cancelled: false, expanded: s.expandedHistId, onTap: n.toggleHist),
    const SizedBox(height: AppSpacing.sm),
    _HistoryRow(id: 'h5', store: 'GameZone HSR',         system: 'RTX 3080', dur: '3h',   cost: '₹240', cancelled: false, expanded: s.expandedHistId, onTap: n.toggleHist),
    const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
    GestureDetector(
      onTap: () {},
      child: Container(
        height: 38, decoration: BoxDecoration(
          color: AppColors.surface, border: Border.all(color: AppColors.rule),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
        ),
        child: Center(child: Text('Load more', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600))),
      ),
    ),
  ];
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _Tab extends StatelessWidget {
  const _Tab({required this.id, required this.label, required this.active, required this.onTap, this.count, this.dot = false});
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
          boxShadow: active ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 3, offset: const Offset(0, 1))] : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (dot && active) ...[
            const EmLiveDot(size: 6),
            const SizedBox(width: 6),
          ],
          Text(label, style: AppTypography.small.copyWith(
              color: active ? AppColors.textPrimary : AppColors.textTertiary,
              fontWeight: FontWeight.w600, fontSize: 13)),
          if (count != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: active ? AppColors.buttonBg : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('$count', style: AppTypography.small.copyWith(
                  color: active ? AppColors.buttonFg : AppColors.textTertiary,
                  fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ],
        ]),
      ),
    ),
  );
}

class _BookingAction {
  const _BookingAction({required this.label, this.primary = false, this.ghost = false, this.disabled = false, this.onTap});
  final String label;
  final bool primary;
  final bool ghost;
  final bool disabled;
  final VoidCallback? onTap;
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.icon, required this.system, required this.store,
    required this.when, required this.duration, required this.statusTag,
    required this.countdown, required this.actions,
    this.countdownColor,
  });
  final List<List<dynamic>> icon;
  final String system;
  final String store;
  final String when;
  final String duration;
  final Widget statusTag;
  final String countdown;
  final Color? countdownColor;
  final List<_BookingAction> actions;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: AppColors.pillBg, borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip)),
          child: Center(child: HugeIcon(icon: icon, color: AppColors.textPrimary, size: 20)),
        ),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(system, style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(store, style: AppTypography.small),
        ])),
        statusTag,
      ]),
      const SizedBox(height: 14),
      Wrap(spacing: 6, runSpacing: 6, children: [
        EmChip(keyLabel: 'WHEN', value: when),
        EmChip(keyLabel: 'FOR', value: duration),
      ]),
      const SizedBox(height: 14),
      Text(countdown, style: AppTypography.small.copyWith(
          color: countdownColor ?? AppColors.textTertiary)),
      const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
      Row(children: actions.map((a) => Expanded(child: Padding(
        padding: EdgeInsets.only(left: a == actions.first ? 0 : AppSpacing.sm),
        child: Opacity(
          opacity: a.disabled ? 0.4 : 1,
          child: GestureDetector(
            onTap: a.disabled ? null : a.onTap,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: a.primary ? AppColors.buttonBg : AppColors.surface,
                border: a.ghost ? Border.all(color: AppColors.rule) : null,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
              ),
              child: Center(child: Text(a.label, style: AppTypography.small.copyWith(
                  color: a.primary ? AppColors.buttonFg : AppColors.textPrimary,
                  fontWeight: FontWeight.w600, fontSize: 13))),
            ),
          ),
        ),
      ))).toList()),
    ]),
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
    required this.id, required this.store, required this.system,
    required this.dur, required this.cost, required this.cancelled,
    required this.expanded, required this.onTap,
  });
  final String id, store, system, dur, cost;
  final bool cancelled;
  final String? expanded;
  final void Function(String) onTap;

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
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(store, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text('$system · $dur', style: AppTypography.small),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(cost, style: AppTypography.num.copyWith(
                fontWeight: FontWeight.w700,
                color: cancelled ? AppColors.textTertiary : AppColors.textPrimary,
                decoration: cancelled ? TextDecoration.lineThrough : null,
              )),
              const SizedBox(height: 2),
              Text(cancelled ? 'Cancelled' : 'Completed', style: AppTypography.small.copyWith(
                  color: cancelled ? AppColors.err : AppColors.textTertiary)),
            ]),
          ]),
        ),
      ),
      if (open) ...[
        Container(height: 1, color: AppColors.rule, margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md)),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
          child: Column(children: const [
            EmMetaRow(label: 'Session ID',     value: '#SES-20945'),
            EmMetaRow(label: 'Payment method', value: 'UPI'),
          ]),
        ),
      ],
    ]),
  );
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final List<List<dynamic>> icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 38, height: 38,
      child: Center(child: HugeIcon(icon: icon, color: AppColors.textPrimary, size: 22)),
    ),
  );
}
