import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_chip.dart';

// ── UI state providers ──
final _slideProvider = StateProvider<int>((ref) => 0);
final _bookRippleProvider = StateProvider<bool>((ref) => false);

class StoreDetailMobileLayout extends ConsumerWidget {
  const StoreDetailMobileLayout({super.key});

  static const _heroes = [
    (tag: 'STOREFRONT', hue: 215.0),
    (tag: 'PC LOUNGE',  hue: 145.0),
    (tag: 'CONSOLE BAY', hue: 25.0),
  ];

  static const _systems = [
    (icon: HugeIcons.strokeRoundedComputerDesk01, name: 'RTX 4090',     type: 'PC · Seat 3',    rate: 80,  avail: true),
    (icon: HugeIcons.strokeRoundedGameboy,   name: 'PS5 Slim',      type: 'Console · S1',  rate: 60,  avail: false),
    (icon: HugeIcons.strokeRoundedVrGlasses, name: 'Valve Index',   type: 'VR · Pod B',    rate: 120, avail: true),
    (icon: HugeIcons.strokeRoundedGameboy,   name: 'Xbox Series X', type: 'Console · S4',  rate: 60,  avail: true),
    (icon: HugeIcons.strokeRoundedComputerDesk01, name: 'RTX 3080',      type: 'PC · Seat 9',   rate: 70,  avail: false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slide      = ref.watch(_slideProvider);
    final bookRipple = ref.watch(_bookRippleProvider);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── Hero carousel ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            _HeroPlaceholder(hue: _heroes[slide].hue, tag: _heroes[slide].tag),

                            // Back
                            Positioned(
                              top: 12, left: 12,
                              child: GestureDetector(
                                onTap: () => context.pop(),
                                child: _HeroBtn(child: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 18)),
                              ),
                            ),

                            // Favourite
                            Positioned(
                              top: 12, right: 12,
                              child: _HeroBtn(child: const HugeIcon(icon: HugeIcons.strokeRoundedStar, color: AppColors.textPrimary, size: 18)),
                            ),

                            // Prev arrow
                            Positioned(
                              top: 0, bottom: 0, left: 8,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => ref.read(_slideProvider.notifier).state =
                                      (slide - 1 + _heroes.length) % _heroes.length,
                                  child: _ArrowBtn(child: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 16)),
                                ),
                              ),
                            ),

                            // Next arrow
                            Positioned(
                              top: 0, bottom: 0, right: 8,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => ref.read(_slideProvider.notifier).state =
                                      (slide + 1) % _heroes.length,
                                  child: _ArrowBtn(child: const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.textPrimary, size: 16)),
                                ),
                              ),
                            ),

                            // Dots
                            Positioned(
                              bottom: 12, left: 0, right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(_heroes.length, (i) =>
                                    Container(
                                      width: i == slide ? 16 : 5,
                                      height: 5,
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      decoration: BoxDecoration(
                                        color: i == slide ? Colors.white : Colors.white60,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Status block ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            const EmTag(kind: EmTagKind.ok, label: 'Open now'),
                            const SizedBox(width: AppSpacing.sm),
                            const Text('·', style: TextStyle(color: AppColors.textTertiary)),
                            const SizedBox(width: AppSpacing.sm),
                            Text('★ 4.7 (412)', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: AppSpacing.sm),
                          Text('GameZone Koramangala', style: AppTypography.title),
                          const SizedBox(height: 6),
                          Row(children: [
                            const HugeIcon(icon: HugeIcons.strokeRoundedLocation01, color: AppColors.textTertiary, size: 13),
                            const SizedBox(width: 6),
                            Text('5th Block, 80ft Road · 1.2 km away', style: AppTypography.small),
                          ]),
                        ]),
                      ),

                      // ── Info tiles ──
                      Row(children: const [
                        Expanded(child: _InfoTile(icon: HugeIcons.strokeRoundedClock01, k: 'HOURS', v: '9 – 23')),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(child: _InfoTile(icon: HugeIcons.strokeRoundedCall, k: 'CALL', v: 'Tap', action: true)),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(child: _InfoTile(icon: HugeIcons.strokeRoundedNavigation01, k: 'DIRECTIONS', v: 'Go', action: true)),
                      ]),
                      const SizedBox(height: AppSpacing.md),

                      // ── Stations ──
                      Text('STATIONS', style: AppTypography.meta),
                      const SizedBox(height: 10),
                      Wrap(spacing: 6, runSpacing: 6, children: const [
                        EmChip(value: '12', keyLabel: 'PC Gaming'),
                        EmChip(value: '4',  keyLabel: 'PS5'),
                        EmChip(value: '2',  keyLabel: 'VR'),
                        EmChip(value: '3',  keyLabel: 'Xbox'),
                      ]),
                      const SizedBox(height: 18),

                      // ── Campaigns ──
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Active campaigns', style: AppTypography.h2),
                        Text('2', style: AppTypography.small),
                      ]),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: const [
                          _MiniCamp(title: 'Happy Hour',     sub: '30% off · Mon–Fri 10–2', tag: EmTag(kind: EmTagKind.ok,   label: 'Eligible')),
                          SizedBox(width: 10),
                          _MiniCamp(title: 'Double Credits', sub: 'Earn 2× this weekend',   tag: EmTag(kind: EmTagKind.warn, label: 'Limited')),
                        ]),
                      ),
                      const SizedBox(height: 18),

                      // ── Available now ──
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Available now', style: AppTypography.h2),
                        Text('3 of 21 ready', style: AppTypography.small),
                      ]),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _systems.map((sys) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _SystemCard(icon: sys.icon, name: sys.name, type: sys.type, rate: sys.rate, available: sys.avail),
                          )).toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky CTAs ──
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm + AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
            color: AppColors.background,
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  ref.read(_bookRippleProvider.notifier).state = true;
                  Future.delayed(const Duration(milliseconds: 700), () {
                    ref.read(_bookRippleProvider.notifier).state = false;
                  });
                  context.push(AppRoutes.book);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 56,
                  decoration: BoxDecoration(
                    color: bookRipple ? AppColors.ok : AppColors.buttonBg,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: Center(child: bookRipple
                      ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle01, color: AppColors.buttonFg, size: 18),
                          const SizedBox(width: AppSpacing.sm),
                          Text('Slot opened', style: AppTypography.button),
                        ])
                      : Text('Book a slot', style: AppTypography.button)),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.rule),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: Center(child: Text('View all slots',
                      style: AppTypography.body.copyWith(fontWeight: FontWeight.w600))),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder({required this.hue, required this.tag});
  final double hue;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final bg     = HSLColor.fromAHSL(1, hue, 0.3, 0.87).toColor();
    final stripe = HSLColor.fromAHSL(1, hue, 0.35, 0.83).toColor();
    return Container(
      width: double.infinity, height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bg, stripe, bg, stripe, bg, stripe, bg],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 0.15, 0.15, 0.3, 0.3, 0.45, 0.45],
        ),
      ),
      child: Align(
        alignment: const Alignment(-0.9, 0.85),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(tag, style: AppTypography.meta.copyWith(color: AppColors.textSecondary, fontSize: 10)),
        ),
      ),
    );
  }
}

class _HeroBtn extends StatelessWidget {
  const _HeroBtn({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: 36, height: 36,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.85),
      shape: BoxShape.circle,
    ),
    child: Center(child: child),
  );
}

class _ArrowBtn extends StatelessWidget {
  const _ArrowBtn({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: 30, height: 30,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.7),
      shape: BoxShape.circle,
    ),
    child: Center(child: child),
  );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.k, required this.v, this.action = false});
  final List<List<dynamic>> icon;
  final String k, v;
  final bool action;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      HugeIcon(icon: icon, color: AppColors.textSecondary, size: 16),
      const SizedBox(height: 6),
      Text(k, style: AppTypography.meta),
      const SizedBox(height: 2),
      Text(v, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
    ]),
  );
}

class _MiniCamp extends StatelessWidget {
  const _MiniCamp({required this.title, required this.sub, required this.tag});
  final String title, sub;
  final Widget tag;
  @override
  Widget build(BuildContext context) => Container(
    width: 220, padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: AppTypography.h3),
        tag,
      ]),
      const SizedBox(height: 6),
      Text(sub, style: AppTypography.small),
    ]),
  );
}

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.icon, required this.name, required this.type, required this.rate, required this.available});
  final List<List<dynamic>> icon;
  final String name, type;
  final int rate;
  final bool available;

  @override
  Widget build(BuildContext context) => Container(
    width: 170, padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: available ? AppColors.surfaceTint : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: available ? Colors.black.withValues(alpha: 0.06) : AppColors.pillBg,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
          ),
          child: Center(child: HugeIcon(icon: icon, color: AppColors.textPrimary, size: 18)),
        ),
        EmTag(kind: available ? EmTagKind.ok : EmTagKind.mute, label: available ? 'Available' : 'In use'),
      ]),
      const SizedBox(height: 10),
      Text(name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text(type, style: AppTypography.small),
      const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
      Text('₹$rate / hr', style: AppTypography.num.copyWith(fontWeight: FontWeight.w700)),
    ]),
  );
}
