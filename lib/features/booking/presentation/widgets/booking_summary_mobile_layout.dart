import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../providers/booking_summary_ui_notifier.dart';

class BookingSummaryMobileLayout extends ConsumerWidget {
  const BookingSummaryMobileLayout({super.key});

  static const _base     = 160;
  static const _peak     = 20;
  static const _subtotal = _base + _peak;
  static const _maxCred  = 850;

  static const _campMap = {
    'happy': (label: 'Happy Hour — 30%',  amt: 54),
    'first': (label: 'First Visit Bonus', amt: 30),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s  = ref.watch(bookingSummaryUiProvider);
    final n  = ref.read(bookingSummaryUiProvider.notifier);
    final campAmt  = s.selectedCampaign != null ? (_campMap[s.selectedCampaign]?.amt ?? 0) : 0;
    final credAmt  = s.credits ~/ 10;
    final total    = (_subtotal - campAmt - credAmt).clamp(0, _subtotal);

    return Column(
      children: [
        GzTopBar(
          title: 'Confirm booking',
          subtitle: 'GameZone · Koramangala',
          trailing: const HugeIcon(
            icon: HugeIcons.strokeRoundedInformationCircle,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.md),
            children: [
              // ── Booking card ──
              _GzCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  _IconTile(filled: true, child: HugeIcon(icon: HugeIcons.strokeRoundedComputerDesk01, color: AppColors.buttonFg, size: 22)),
                  const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('RTX 4090 Gaming PC', style: AppTypography.h2),
                    const SizedBox(height: 2),
                    Text('Seat 3 · PC station', style: AppTypography.small),
                  ])),
                  Text('SLOT', style: AppTypography.meta),
                ]),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                  decoration: BoxDecoration(color: AppColors.pillBg, borderRadius: BorderRadius.circular(14)),
                  child: const IntrinsicHeight(
                    child: Row(children: [
                      Expanded(child: _SlotCell(label: 'DATE',     value: 'Sat, 18 Apr')),
                      VerticalDivider(width: 1, color: AppColors.rule),
                      Expanded(flex: 2, child: _SlotCell(label: 'TIME',     value: '4:00 – 6:00 PM', padLeft: true)),
                      VerticalDivider(width: 1, color: AppColors.rule),
                      Expanded(child: _SlotCell(label: 'DURATION', value: '2h', mono: true, alignRight: true, padLeft: true)),
                    ]),
                  ),
                ),
              ])),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

              // ── Base price ──
              _GzCard(child: Column(children: [
                Align(alignment: Alignment.centerLeft, child: Text('BASE', style: AppTypography.meta)),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                const GzMetaRow(label: '₹80/hr × 2 hrs', value: '₹160'),
                const GzMetaRow(label: 'Peak hour surcharge', value: '+ ₹20'),
                const _HRule(),
                GzMetaRow(label: 'Subtotal', value: '₹$_subtotal'),
              ])),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

              // ── Campaigns ──
              _Collapsible(
                title: 'Apply campaign',
                open: s.campOpen,
                onToggle: n.toggleCampSection,
                badge: campAmt > 0 ? GzTag(kind: GzTagKind.ok, label: '−₹$campAmt') : null,
                emptyBadge: 'Optional',
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _CampaignCard(title: 'Happy Hour', sub: '30% off · Mon–Fri 10–2',
                      tag: const GzTag(kind: GzTagKind.ok, label: 'Eligible'),
                      selected: s.selectedCampaign == 'happy',
                      onTap: () => n.toggleCampaign('happy')),
                    const SizedBox(width: AppSpacing.sm),
                    _CampaignCard(title: 'First Visit Bonus', sub: '200 credits awarded',
                      tag: const GzTag(kind: GzTagKind.info, label: 'Applied'),
                      selected: s.selectedCampaign == 'first',
                      onTap: () => n.toggleCampaign('first')),
                    const SizedBox(width: AppSpacing.sm),
                    _CampaignCard(title: 'Weekend Special', sub: '15% off · Sat–Sun',
                      tag: const GzTag(kind: GzTagKind.mute, label: 'Not met'),
                      disabled: true),
                  ]),
                ),
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

              // ── Credits ──
              _Collapsible(
                title: 'Use credits',
                open: s.credOpen,
                onToggle: n.toggleCredSection,
                badge: s.credits > 0 ? GzTag(kind: GzTagKind.ok, label: '−₹$credAmt') : null,
                emptyBadge: '$_maxCred available',
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Balance · GameZone Koramangala', style: AppTypography.small),
                    Text('$_maxCred credits', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbColor: AppColors.buttonBg,
                      activeTrackColor: AppColors.buttonBg,
                      inactiveTrackColor: AppColors.rule,
                      overlayColor: Colors.transparent,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      min: 0, max: _maxCred.toDouble(), divisions: _maxCred ~/ 10,
                      value: s.credits.toDouble(),
                      onChanged: (v) => n.setCredits(v.toInt()),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${s.credits} credits',
                        style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                    Text('= ₹$credAmt off',
                        style: AppTypography.body.copyWith(color: AppColors.ok, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
                    decoration: BoxDecoration(color: AppColors.warnBg, borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip)),
                    child: Row(children: [
                      const HugeIcon(icon: HugeIcons.strokeRoundedInformationCircle, color: AppColors.warn, size: 14),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text('Credits valid at this store only',
                          style: AppTypography.small.copyWith(color: AppColors.warn, fontSize: 12))),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

              // ── Total ──
              _GzCard(child: Column(children: [
                GzMetaRow(label: 'Subtotal', value: '₹$_subtotal'),
                if (campAmt > 0)
                  GzMetaRow(
                    label: 'Campaign · ${_campMap[s.selectedCampaign]?.label ?? ''}',
                    value: '− ₹$campAmt',
                    valueStyle: AppTypography.num.copyWith(color: AppColors.ok, fontWeight: FontWeight.w600),
                  ),
                if (credAmt > 0)
                  GzMetaRow(
                    label: 'Credits · ${s.credits}',
                    value: '− ₹$credAmt',
                    valueStyle: AppTypography.num.copyWith(color: AppColors.ok, fontWeight: FontWeight.w600),
                  ),
                Container(height: 2, color: AppColors.textPrimary,
                    margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm + AppSpacing.xs)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('Total', style: AppTypography.h2),
                      Text('₹$total', style: AppTypography.heroMd),
                    ]),
              ])),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),

              // ── Payment method ──
              _GzCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PAYMENT METHOD', style: AppTypography.meta),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 3.2,
                  children: [
                    _PayPill(icon: HugeIcons.strokeRoundedCash01,          label: 'Cash',    sub: 'At venue',      active: s.payMethod == 'cash',    onTap: () => n.setPayMethod('cash')),
                    _PayPill(icon: HugeIcons.strokeRoundedSmartphoneWifi, label: 'UPI',     sub: 'Any app',       active: s.payMethod == 'upi',     onTap: () => n.setPayMethod('upi')),
                    _PayPill(icon: HugeIcons.strokeRoundedCreditCard,     label: 'Card',    sub: 'Visa · Master', active: s.payMethod == 'card',    onTap: () => n.setPayMethod('card')),
                    _PayPill(icon: HugeIcons.strokeRoundedCoins01,        label: 'Credits', sub: 'Balance only',  active: s.payMethod == 'credits', onTap: () => n.setPayMethod('credits')),
                  ],
                ),
              ])),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),

        // ── Sticky CTA ──
        Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm + AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
          color: AppColors.background,
          child: Column(children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: s.confirmed ? AppColors.ok : AppColors.buttonBg,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                ),
                child: TextButton(
                  onPressed: n.confirm,
                  child: s.confirmed
                      ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle01, color: AppColors.buttonFg, size: 18),
                          const SizedBox(width: AppSpacing.sm),
                          Text('Booking confirmed', style: AppTypography.button),
                        ])
                      : Text('Confirm booking · ₹$total', style: AppTypography.button),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              s.payMethod == 'cash' ? 'Payment after session at counter' : 'Pay now to secure slot',
              style: AppTypography.small,
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ],
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _GzCard extends StatelessWidget {
  const _GzCard({required this.child, this.tint = false});
  final Widget child;
  final bool tint;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: tint ? AppColors.surfaceTint : AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
    ),
    child: child,
  );
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.child, this.filled = false});
  final Widget child;
  final bool filled;
  @override
  Widget build(BuildContext context) => Container(
    width: 44, height: 44,
    decoration: BoxDecoration(
      color: filled ? AppColors.buttonBg : AppColors.pillBg,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
    ),
    child: Center(child: child),
  );
}

class _HRule extends StatelessWidget {
  const _HRule();
  @override
  Widget build(BuildContext context) => Container(
    height: 1, color: AppColors.rule,
    margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
  );
}

class _SlotCell extends StatelessWidget {
  const _SlotCell({
    required this.label, required this.value,
    this.mono = false, this.alignRight = false, this.padLeft = false,
  });
  final String label;
  final String value;
  final bool mono;
  final bool alignRight;
  final bool padLeft;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: padLeft ? AppSpacing.sm : 0),
    child: Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTypography.meta),
        const SizedBox(height: 6),
        Text(value,
          style: mono
              ? AppTypography.num.copyWith(fontWeight: FontWeight.w600)
              : AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _Collapsible extends StatelessWidget {
  const _Collapsible({
    required this.title, required this.open, required this.onToggle,
    required this.child, this.badge, this.emptyBadge,
  });
  final String title;
  final bool open;
  final VoidCallback onToggle;
  final Widget child;
  final Widget? badge;
  final String? emptyBadge;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
    ),
    child: Column(children: [
      GestureDetector(
        onTap: onToggle,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(children: [
            Text(title, style: AppTypography.h2),
            const Spacer(),
            if (badge != null) badge!
            else if (emptyBadge != null) Text(emptyBadge!, style: AppTypography.small),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
            AnimatedRotation(
              turns: open ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, color: AppColors.textTertiary, size: 18),
            ),
          ]),
        ),
      ),
      if (open)
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          child: child,
        ),
    ]),
  );
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({
    required this.title, required this.sub, required this.tag,
    this.selected = false, this.disabled = false, this.onTap,
  });
  final String title;
  final String sub;
  final Widget tag;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: disabled ? 0.55 : 1,
    child: GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceTint : AppColors.pillBg,
          borderRadius: BorderRadius.circular(14),
          border: selected ? Border.all(color: AppColors.textPrimary, width: 2) : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w700))),
            tag,
          ]),
          const SizedBox(height: 6),
          Text(sub, style: AppTypography.small),
        ]),
      ),
    ),
  );
}

class _PayPill extends StatelessWidget {
  const _PayPill({
    required this.icon, required this.label, required this.sub,
    required this.active, required this.onTap,
  });
  final dynamic icon;
  final String label;
  final String sub;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + AppSpacing.xs, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: active ? AppColors.buttonBg : AppColors.pillBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        HugeIcon(icon: icon, color: active ? AppColors.buttonFg : AppColors.textPrimary, size: 20),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: AppTypography.body.copyWith(
              color: active ? AppColors.buttonFg : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
          Text(sub, style: AppTypography.small.copyWith(
              color: active ? AppColors.buttonFg.withValues(alpha: 0.65) : AppColors.textTertiary, fontSize: 11)),
        ])),
      ]),
    ),
  );
}
