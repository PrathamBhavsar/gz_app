import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class PricingRulesScreen extends StatelessWidget {
  const PricingRulesScreen({super.key});

  static const _rules = [
    _PricingRuleData(
      name: 'Standard Rate',
      rate: '₹80/hour · All day',
      isActive: true,
      tags: ['PC', 'All hours'],
    ),
    _PricingRuleData(
      name: 'Peak Hour',
      rate: '₹120/hour · 6 PM–10 PM',
      isActive: true,
      tags: ['All', 'Evening'],
    ),
    _PricingRuleData(
      name: 'Weekend Rate',
      rate: '₹100/hour · Sat–Sun',
      isActive: true,
      tags: ['All', 'Weekend'],
    ),
    _PricingRuleData(
      name: 'VR Premium',
      rate: '₹150/hour',
      isActive: false,
      tags: ['VR', 'All hours'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Pricing Rules',
        trailing: const _TopBarAction(icon: HugeIcons.strokeRoundedAdd01),
      ),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              children: _rules
                  .map(
                    (rule) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PricingRuleCard(rule: rule),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _PricingRuleCard extends StatelessWidget {
  const _PricingRuleCard({required this.rule});

  final _PricingRuleData rule;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rule.name, style: AppTypography.h3),
                    const SizedBox(height: 2),
                    Text(rule.rate, style: AppTypography.small),
                  ],
                ),
              ),
              _StaticToggle(isActive: rule.isActive),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: rule.tags
                .map((tag) => GzTag(kind: GzTagKind.mute, label: tag))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StaticToggle extends StatelessWidget {
  const _StaticToggle({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 26,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isActive ? AppColors.buttonBg : AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
      ),
      child: Align(
        alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _TopBarAction extends StatelessWidget {
  const _TopBarAction({required this.icon});

  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      ),
      alignment: Alignment.center,
      child: HugeIcon(icon: icon, color: AppColors.textTertiary, size: 18),
    );
  }
}

class _PricingRuleData {
  const _PricingRuleData({
    required this.name,
    required this.rate,
    required this.isActive,
    required this.tags,
  });

  final String name;
  final String rate;
  final bool isActive;
  final List<String> tags;
}
