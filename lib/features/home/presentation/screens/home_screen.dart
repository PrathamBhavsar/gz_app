import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../shared/widgets/gz_store_selector_pill.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/store_selector_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _nearbyStores = <_NearbyStore>[
    _NearbyStore(
      name: 'GameZone Koramangala',
      distance: '2.4 km',
      systems: '8 systems',
      rating: '4.8',
      status: 'Available',
      statusKind: GzTagKind.ok,
      slug: 'koramangala',
    ),
    _NearbyStore(
      name: 'GameZone Indiranagar',
      distance: '3.1 km',
      systems: '6 systems',
      rating: '4.6',
      status: 'Busy',
      statusKind: GzTagKind.warn,
      slug: 'indiranagar',
    ),
    _NearbyStore(
      name: 'GameZone Whitefield',
      distance: '5.8 km',
      systems: '10 systems',
      rating: '4.7',
      status: 'Available',
      statusKind: GzTagKind.ok,
      slug: 'whitefield',
    ),
  ];

  static const _recentSessions = <_RecentSession>[
    _RecentSession(
      storeName: 'GameZone Koramangala',
      system: 'RTX 4080 · Seat 04',
      date: 'Sat, 18 Apr',
      duration: '2 hr session',
    ),
    _RecentSession(
      storeName: 'GameZone Indiranagar',
      system: 'PS5 · Bay 02',
      date: 'Thu, 16 Apr',
      duration: '90 min session',
    ),
  ];

  static const _campaigns = <_CampaignPill>[
    _CampaignPill(
      title: 'Welcome Bonus',
      subtitle: '2× credits',
      tag: 'OK',
      tagKind: GzTagKind.ok,
    ),
    _CampaignPill(
      title: 'Happy Hours',
      subtitle: '50% off',
      tag: 'INFO',
      tagKind: GzTagKind.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Hey, Rahul 👋', style: AppTypography.h1),
                  ),
                  GzIconBtn(
                    tooltip: 'Notifications',
                    onTap: () => context.go(AppRoutes.notifications),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedNotification03,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GzStoreSelectorPill(
                storeName: 'GameZone Koramangala',
                onTap: () => showStoreSelectorSheet(context),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Nearby stores'),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _nearbyStores.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final store = _nearbyStores[index];
                    return _StoreCard(store: store);
                  },
                ),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(title: 'Your recent'),
              const SizedBox(height: 12),
              ..._recentSessions.map(
                (session) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RecentSessionRow(session: session),
                ),
              ),
              const SizedBox(height: 18),
              const _SectionHeader(title: 'Active campaigns'),
              const SizedBox(height: 12),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _campaigns.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final campaign = _campaigns[index];
                    return _CampaignCard(campaign: campaign);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypography.h2);
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store});

  final _NearbyStore store;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.storeDetailPath(store.slug)),
      child: SizedBox(
        width: 200,
        child: GzCard(
          padding: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusLg,
                  ),
                ),
              ),
              const Spacer(),
              Text(store.name, style: AppTypography.h3),
              const SizedBox(height: 6),
              Text(
                '${store.distance} · ${store.systems}',
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '${store.rating} ⭐',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GzTag(kind: store.statusKind, label: store.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSessionRow extends StatelessWidget {
  const _RecentSessionRow({required this.session});

  final _RecentSession session;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 14,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedGameController01,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.storeName, style: AppTypography.body),
                const SizedBox(height: 2),
                Text(session.system, style: AppTypography.small),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(session.date, style: AppTypography.small),
              const SizedBox(height: 2),
              Text(
                session.duration,
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign});

  final _CampaignPill campaign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: GzCard(
        padding: 14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(campaign.title, style: AppTypography.h3)),
                GzTag(kind: campaign.tagKind, label: campaign.tag),
              ],
            ),
            const SizedBox(height: 8),
            Text(campaign.subtitle, style: AppTypography.bodyR),
          ],
        ),
      ),
    );
  }
}

class _NearbyStore {
  const _NearbyStore({
    required this.name,
    required this.distance,
    required this.systems,
    required this.rating,
    required this.status,
    required this.statusKind,
    required this.slug,
  });

  final String name;
  final String distance;
  final String systems;
  final String rating;
  final String status;
  final GzTagKind statusKind;
  final String slug;
}

class _RecentSession {
  const _RecentSession({
    required this.storeName,
    required this.system,
    required this.date,
    required this.duration,
  });

  final String storeName;
  final String system;
  final String date;
  final String duration;
}

class _CampaignPill {
  const _CampaignPill({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagKind,
  });

  final String title;
  final String subtitle;
  final String tag;
  final GzTagKind tagKind;
}
