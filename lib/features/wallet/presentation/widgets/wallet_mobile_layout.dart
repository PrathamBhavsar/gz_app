import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_progress_bar.dart';
import '../providers/wallet_ui_notifier.dart';

// ── Store data (mock) ─────────────────────────────────────────────────────────

class _Store {
  const _Store({required this.id, required this.name, required this.credits});
  final String id;
  final String name;
  final int credits;
}

const _stores = [
  _Store(id: 'kor', name: 'GameZone Koramangala', credits: 850),
  _Store(id: 'mgr', name: 'GameZone MG Road',     credits: 220),
  _Store(id: 'hsr', name: 'GameZone HSR',         credits: 80),
];

_Store _storeById(String id) => _stores.firstWhere((s) => s.id == id);

const _txData = [
  (icon: HugeIcons.strokeRoundedStar, label: 'Session completed',   sub: '2 hours ago',  amt: 80,  sign: '+', ok: true),
  (icon: HugeIcons.strokeRoundedArrowUp01, label: 'Credits redeemed',    sub: 'Yesterday',    amt: 300, sign: '−', ok: false),
  (icon: HugeIcons.strokeRoundedGift, label: 'Welcome bonus',       sub: '3 days ago',   amt: 200, sign: '+', ok: true),
  (icon: HugeIcons.strokeRoundedStar, label: 'Session completed',   sub: '5 days ago',   amt: 60,  sign: '+', ok: true),
  (icon: HugeIcons.strokeRoundedGift, label: 'Referral bonus',      sub: '1 week ago',   amt: 500, sign: '+', ok: true),
  (icon: HugeIcons.strokeRoundedArrowUp01, label: 'Credits redeemed',    sub: '2 weeks ago',  amt: 200, sign: '−', ok: false),
];

// ── Layout ────────────────────────────────────────────────────────────────────

class WalletMobileLayout extends ConsumerWidget {
  const WalletMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s     = ref.watch(walletUiProvider);
    final n     = ref.read(walletUiProvider.notifier);
    final store = _storeById(s.storeId);
    final rupees = (store.credits / 10).toStringAsFixed(2);
    final txList = s.seeAllTx ? _txData : _txData.sublist(0, 3);

    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              // ── Title row ──
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Wallet', style: AppTypography.title),
                  GestureDetector(
                    onTap: () {},
                    child: const HugeIcon(icon: HugeIcons.strokeRoundedNotification01, color: AppColors.textPrimary, size: 22),
                  ),
                ]),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
                  children: [
                    // ── Store selector ──
                    GestureDetector(
                      onTap: n.openStores,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(color: AppColors.pillBg, borderRadius: BorderRadius.circular(999)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(store.name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: AppSpacing.xs),
                          const HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, color: AppColors.textTertiary, size: 16),
                        ]),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Hero credit card ──
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceTint,
                        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('YOUR CREDITS', style: AppTypography.meta.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 14),
                        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                          Text('${store.credits}', style: AppTypography.hero),
                          const SizedBox(width: 10),
                          Text('credits', style: AppTypography.bodyR),
                        ]),
                        const SizedBox(height: 6),
                        Text('= ₹$rupees in-store value', style: AppTypography.bodyR),
                        Container(height: 1, color: Colors.black.withValues(alpha: 0.08), margin: const EdgeInsets.symmetric(vertical: AppSpacing.md)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(child: Text('Valid at ${store.name} only', style: AppTypography.small.copyWith(color: AppColors.textSecondary))),
                          GestureDetector(
                            onTap: n.openEarnInfo,
                            child: Text('How do I earn more?', style: AppTypography.small.copyWith(
                                color: AppColors.textPrimary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                          ),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 18),

                    // ── Quick actions ──
                    Row(children: [
                      Expanded(child: _QuickAction(icon: HugeIcons.strokeRoundedCoins01, label: 'Redeem', onTap: n.openRedeem)),
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(child: _QuickAction(icon: HugeIcons.strokeRoundedListView, label: 'History')),
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(child: _QuickAction(icon: HugeIcons.strokeRoundedGift, label: 'Campaigns')),
                    ]),
                    const SizedBox(height: 18),

                    // ── Transactions ──
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                      ),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Recent', style: AppTypography.h2),
                            GestureDetector(
                              onTap: n.toggleAllTx,
                              child: Text(s.seeAllTx ? 'Show less' : 'See all →',
                                  style: AppTypography.small.copyWith(color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
                            ),
                          ]),
                        ),
                        ...txList.asMap().entries.map((e) => _TxRow(
                          icon: e.value.icon, label: e.value.label, sub: e.value.sub,
                          amt: e.value.amt, sign: e.value.sign, ok: e.value.ok,
                          first: e.key == 0,
                        )),
                        const SizedBox(height: AppSpacing.sm),
                      ]),
                    ),
                    const SizedBox(height: 18),

                    // ── Campaigns ──
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                      Text('Active campaigns', style: AppTypography.h2),
                      Text('3', style: AppTypography.small),
                    ]),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        _CampCard(
                          title: 'Happy Hour',
                          sub: '30% off · Mon–Fri 10am–2pm',
                          tag: const GzTag(kind: GzTagKind.ok, label: 'Eligible'),
                          footer: const Text('Ends 30 Apr', style: TextStyle(fontSize: 12)),
                          onTap: () => n.openCampDetail('Happy Hour'),
                        ),
                        const SizedBox(width: 10),
                        _CampCard(
                          title: 'Double credits',
                          sub: 'Earn 2× credits this weekend',
                          tag: const GzTag(kind: GzTagKind.warn, label: 'Limited'),
                          footer: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                            GzProgressBar(value: 0.847, height: 4, fillColor: AppColors.warn),
                            SizedBox(height: 5),
                            Text('847 / 1000 redeemed', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                          ]),
                          onTap: () => n.openCampDetail('Double Credits Weekend'),
                        ),
                        const SizedBox(width: 10),
                        _CampCard(
                          title: 'Refer a friend',
                          sub: 'Get 500 credits per referral',
                          tag: const GzTag(kind: GzTagKind.purple, label: 'New'),
                          footer: Text('Share invite link →', style: AppTypography.small.copyWith(decoration: TextDecoration.underline)),
                          onTap: () => n.openCampDetail('Refer a Friend'),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Store selector sheet ──
          if (s.showStores)
            _Sheet(
              onClose: n.closeStores,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Switch store', style: AppTypography.h1),
                const SizedBox(height: 4),
                Text('Credits are scoped per store', style: AppTypography.bodyR),
                const SizedBox(height: AppSpacing.md),
                ..._stores.map((st) => GestureDetector(
                  onTap: () => n.selectStore(st.id),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: st.id == s.storeId ? AppColors.surfaceTint : AppColors.pillBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(st.name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text('${st.credits} credits available', style: AppTypography.small),
                      ]),
                      if (st.id == s.storeId)
                        const HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle01, color: AppColors.textPrimary, size: 18),
                    ]),
                  ),
                )),
              ]),
            ),

          // ── Redeem credits sheet ──
          if (s.redeemOpen)
            _Sheet(
              onClose: n.closeRedeem,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Redeem credits', style: AppTypography.h1),
                const SizedBox(height: 4),
                Text('${store.credits} available · 10 credits = ₹1', style: AppTypography.bodyR),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: AppColors.pillBg, borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg)),
                  child: Column(children: [
                    Text('REDEEM', style: AppTypography.meta),
                    const SizedBox(height: AppSpacing.sm),
                    Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                      Text('${s.redeemAmt}', style: AppTypography.hero.copyWith(fontSize: 44)),
                      const SizedBox(width: 12),
                      Text('= ₹${s.redeemAmt ~/ 10}', style: AppTypography.bodyR),
                    ]),
                    const SizedBox(height: AppSpacing.md),
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
                        min: 0, max: store.credits.toDouble(),
                        divisions: store.credits ~/ 10,
                        value: s.redeemAmt.toDouble().clamp(0, store.credits.toDouble()),
                        onChanged: (v) => n.setRedeemAmt(v.toInt()),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [100, 250, 500, store.credits].map((v) =>
                      GestureDetector(
                        onTap: () => n.setRedeemAmt(v.clamp(0, store.credits)),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: s.redeemAmt == v ? AppColors.buttonBg : AppColors.surface,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(v == store.credits ? 'Max' : '$v',
                              style: AppTypography.num.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w600,
                                  color: s.redeemAmt == v ? AppColors.buttonFg : AppColors.textPrimary)),
                        ),
                      ),
                    ).toList()),
                  ]),
                ),
                const SizedBox(height: AppSpacing.md),
                _CtaBtn(label: 'Redeem ${s.redeemAmt} credits', onTap: n.closeRedeem),
              ]),
            ),

          // ── Earn info sheet ──
          if (s.earnInfoOpen)
            _Sheet(
              onClose: n.closeEarnInfo,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('How to earn credits', style: AppTypography.h1),
                const SizedBox(height: 14),
                ...const [
                  ('40 / hr', 'Completing booked sessions'),
                  ('200',     'First-time booking at any store'),
                  ('500',     'When a referred friend books'),
                  ('2×',      'During Double Credits weekends'),
                ].asMap().entries.map((e) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: e.key == 0 ? null : Border(top: BorderSide(color: AppColors.rule)),
                  ),
                  child: Row(children: [
                    GzChip(value: e.value.$1),
                    const SizedBox(width: 14),
                    Expanded(child: Text(e.value.$2, style: AppTypography.body)),
                  ]),
                )),
              ]),
            ),

          // ── Campaign detail sheet ──
          if (s.campDetail != null)
            _Sheet(
              onClose: n.closeCampDetail,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(s.campDetail!, style: AppTypography.h1),
                const SizedBox(height: 8),
                Text(_campBody(s.campDetail!), style: AppTypography.bodyR),
                const SizedBox(height: 18),
                Text('TERMS', style: AppTypography.meta),
                const SizedBox(height: 10),
                ..._campTerms(s.campDetail!).map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 4, height: 4,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: const BoxDecoration(color: AppColors.textTertiary, shape: BoxShape.circle),
                    ),
                    Expanded(child: Text(t, style: AppTypography.body.copyWith(fontSize: 13))),
                  ]),
                )),
              ]),
            ),
        ],
      ),
    );
  }

  static String _campBody(String title) => switch (title) {
    'Happy Hour'              => 'Get 30% off all sessions during weekday off-peak hours. Auto-applied at checkout.',
    'Double Credits Weekend'  => 'Every session this Saturday and Sunday earns double the credits.',
    _                         => 'Invite friends to GameZone. They get ₹100 off their first booking; you get 500 credits.',
  };

  static List<String> _campTerms(String title) => switch (title) {
    'Happy Hour'              => ['Valid Mon–Fri 10am–2pm', 'Excludes VR rigs', 'Stackable with credits'],
    'Double Credits Weekend'  => ['Sat–Sun only', 'First 1000 customers', 'No max cap'],
    _                         => ['Unlimited referrals', 'Credits valid 90 days', 'New users only'],
  };
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, this.onTap});
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        HugeIcon(icon: icon, color: AppColors.textPrimary, size: 20),
        const SizedBox(height: 6),
        Text(label, style: AppTypography.small.copyWith(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12)),
      ]),
    ),
  );
}

class _TxRow extends StatelessWidget {
  const _TxRow({
    required this.icon, required this.label, required this.sub,
    required this.amt, required this.sign, required this.ok, required this.first,
  });
  final List<List<dynamic>> icon;
  final String label, sub, sign;
  final int amt;
  final bool ok, first;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
    decoration: BoxDecoration(
      border: first ? null : Border(top: BorderSide(color: AppColors.rule)),
    ),
    child: Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: ok ? AppColors.okBg : AppColors.errBg,
          shape: BoxShape.circle,
        ),
        child: Center(child: HugeIcon(icon: icon, color: ok ? AppColors.ok : AppColors.err, size: 16)),
      ),
      const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 1),
        Text(sub, style: AppTypography.small),
      ])),
      Text('$sign$amt', style: AppTypography.num.copyWith(
          fontWeight: FontWeight.w700, color: ok ? AppColors.ok : AppColors.err)),
    ]),
  );
}

class _CampCard extends StatelessWidget {
  const _CampCard({required this.title, required this.sub, required this.tag, required this.footer, required this.onTap});
  final String title, sub;
  final Widget tag, footer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 220,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(title, style: AppTypography.h3)),
          tag,
        ]),
        const SizedBox(height: AppSpacing.sm),
        Text(sub, style: AppTypography.small),
        const SizedBox(height: AppSpacing.md),
        footer,
      ]),
    ),
  );
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.child, required this.onClose});
  final Widget child;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onClose,
    behavior: HitTestBehavior.opaque,
    child: Container(
      color: Colors.black54,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 8, AppSpacing.md, AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 38, height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(color: AppColors.rule, borderRadius: BorderRadius.circular(999)),
              ),
              child,
            ]),
          ),
        ),
      ),
    ),
  );
}

class _CtaBtn extends StatelessWidget {
  const _CtaBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 56,
      decoration: BoxDecoration(color: AppColors.buttonBg, borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg)),
      child: Center(child: Text(label, style: AppTypography.button)),
    ),
  );
}
