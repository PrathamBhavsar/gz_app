import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_billing.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_disputes_notifier.dart';
import '../../../../admin/application/admin_management_models.dart';

class DisputeResolutionScreen extends ConsumerWidget {
  const DisputeResolutionScreen({super.key});

  static const _filters = ['All', 'Open', 'In Review', 'Resolved'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Disputes'),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminDisputesNotifierProvider)
            .when(
              loading: () => const GzLoadingView(message: 'Loading disputes'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () =>
                    ref.read(adminDisputesNotifierProvider.notifier).refresh(),
              ),
              data: (data) => _Body(data: data, filters: _filters),
            ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.data, required this.filters});

  final AdminDisputeData data;
  final List<String> filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = data.filtered;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            children: List.generate(filters.length, (i) {
              final f = filters[i];
              return Padding(
                padding: EdgeInsets.only(right: i == filters.length - 1 ? 0 : 8),
                child: GzChip(
                  label: f,
                  active: data.selectedFilter == f,
                  onTap: () => ref
                      .read(adminDisputesNotifierProvider.notifier)
                      .selectFilter(f),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const PageErrorDisplay(error: AppPageError.empty)
              : GzScrollContent(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      children: items
                          .map(
                            (d) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _DisputeCard(dispute: d),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _DisputeCard extends StatelessWidget {
  const _DisputeCard({required this.dispute});

  final BillingDisputeModel dispute;

  @override
  Widget build(BuildContext context) {
    final id = dispute.id ?? '';
    final isActionable = dispute.status == DisputeStatus.open ||
        dispute.status == DisputeStatus.underReview;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.adminDisputeDetailPath(id)),
      child: GzCard(
        padding: 14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dispute.reason ?? 'Dispute',
                    style: AppTypography.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _statusTag(dispute.status),
              ],
            ),
            if (dispute.disputeAmount != null) ...[
              const SizedBox(height: 4),
              Text(
                'Disputed: ₹${dispute.disputeAmount!.toStringAsFixed(2)}',
                style: AppTypography.small,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                if (dispute.createdAt != null)
                  Text(
                    _formatDate(dispute.createdAt!),
                    style: AppTypography.small,
                  ),
                const Spacer(),
                if (isActionable)
                  SizedBox(
                    width: 116,
                    child: GzButton(
                      label: 'Resolve →',
                      variant: GzButtonVariant.ghost,
                      small: true,
                      onPressed: () =>
                          context.push(AppRoutes.adminDisputeDetailPath(id)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GzTag _statusTag(DisputeStatus? status) {
    return switch (status) {
      DisputeStatus.open => const GzTag(kind: GzTagKind.err, label: 'Open'),
      DisputeStatus.underReview =>
        const GzTag(kind: GzTagKind.warn, label: 'In Review'),
      DisputeStatus.resolved =>
        const GzTag(kind: GzTagKind.ok, label: 'Resolved'),
      DisputeStatus.withdrawn =>
        const GzTag(kind: GzTagKind.mute, label: 'Withdrawn'),
      _ => const GzTag(kind: GzTagKind.mute, label: 'Unknown'),
    };
  }

  String _formatDate(DateTime dt) =>
      '${_month(dt.month)} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];
}
