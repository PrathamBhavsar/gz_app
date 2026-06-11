import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_billing.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_pricing_notifier.dart';

class PricingRulesScreen extends ConsumerWidget {
  const PricingRulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricing = ref.watch(adminPricingNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Pricing Rules',
        onBack: () => context.pop(),
        trailing: GestureDetector(
          onTap: () => context.push(AppRoutes.adminCreatePricing),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
      ),
      body: pricing.when(
        loading: () => const GzLoadingView(message: 'Loading pricing rules'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminPricingNotifierProvider.notifier).refresh(),
        ),
        data: (data) {
          if (data.rules.isEmpty) {
            return const PageErrorDisplay(error: AppPageError.empty);
          }
          return SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(adminPricingNotifierProvider.notifier).refresh(),
              child: GzScrollContent(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    children: data.rules
                        .map(
                          (rule) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () => context.push(
                                AppRoutes.adminEditPricingPath(rule.id ?? ''),
                              ),
                              child: _PricingRuleCard(
                                rule: rule,
                                systemLabel: data.systemTypeName(
                                  rule.systemTypeId,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PricingRuleCard extends StatelessWidget {
  const _PricingRuleCard({required this.rule, required this.systemLabel});

  final PricingRuleModel rule;
  final String systemLabel;

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
                    Text(rule.name ?? 'Pricing rule', style: AppTypography.h3),
                    const SizedBox(height: 2),
                    Text(_rateLabel(rule), style: AppTypography.small),
                  ],
                ),
              ),
              _StaticToggle(isActive: rule.isActive ?? false),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              GzTag(kind: GzTagKind.mute, label: systemLabel),
              GzTag(kind: GzTagKind.mute, label: _dayLabel(rule.dayOfWeek)),
              GzTag(
                kind: GzTagKind.mute,
                label: _timeLabel(rule.startTime, rule.endTime),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _rateLabel(PricingRuleModel rule) {
    final rate = rule.fixedRate ?? rule.multiplier;
    if (rate == null) {
      return 'Rate unavailable';
    }
    final formatted = rate.truncateToDouble() == rate
        ? rate.toStringAsFixed(0)
        : rate.toStringAsFixed(2);
    return '₹$formatted/hour';
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

String _dayLabel(List<int>? days) {
  if (days == null || days.isEmpty) {
    return 'All days';
  }
  final normalized = days.toSet();
  if (normalized.containsAll({1, 2, 3, 4, 5}) && normalized.length == 5) {
    return 'Weekdays';
  }
  if (normalized.containsAll({6, 7}) && normalized.length == 2) {
    return 'Weekends';
  }
  return '${normalized.length} days';
}

String _timeLabel(String? start, String? end) {
  if ((start == null || start.isEmpty) && (end == null || end.isEmpty)) {
    return 'All hours';
  }
  return '${start ?? '--'}-${end ?? '--'}';
}
