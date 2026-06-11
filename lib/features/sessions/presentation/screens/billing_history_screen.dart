import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../application/billing_notifier.dart';
import '../../application/session_ui_models.dart';
import '../../../../models/api_responses.dart';

class BillingHistoryScreen extends ConsumerStatefulWidget {
  const BillingHistoryScreen({super.key});

  @override
  ConsumerState<BillingHistoryScreen> createState() =>
      _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends ConsumerState<BillingHistoryScreen> {
  int _filterIndex = 0;
  final _filters = ['All', 'Paid', 'Unpaid', 'Overdue'];

  @override
  Widget build(BuildContext context) {
    final billingState = ref.watch(billingNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Billing history'),
      body: SafeArea(
        top: false,
        child: billingState.when(
          loading: () => const GzLoadingView(message: 'Loading billing...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(billingNotifierProvider.notifier).refresh(),
          ),
          data: (rows) {
            if (rows.isEmpty) {
              return PageErrorDisplay(
                error: const AppPageError(
                  title: 'No billing records',
                  message: 'Completed sessions will appear here.',
                  icon: 'inbox',
                  kind: AppPageErrorKind.empty,
                ),
                onRetry: () =>
                    ref.read(billingNotifierProvider.notifier).refresh(),
              );
            }

            final visibleRows = rows
                .where((row) {
                  switch (_filters[_filterIndex]) {
                    case 'Paid':
                      return _statusLabel(row) == 'Paid';
                    case 'Unpaid':
                      return _statusLabel(row) == 'Unpaid';
                    case 'Overdue':
                      return _statusLabel(row) == 'Overdue';
                    default:
                      return true;
                  }
                })
                .toList(growable: false);

            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(billingNotifierProvider.notifier).refresh(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, i) => GzChip(
                          label: _filters[i],
                          active: _filterIndex == i,
                          onTap: () => setState(() => _filterIndex = i),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: visibleRows.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final row = visibleRows[index];
                        return _BillingRow(
                          row: row,
                          store: billingStoreName(row),
                          date: formatReadableDate(row.date),
                          duration: row.durationMinutes == null
                              ? 'Unknown duration'
                              : formatShortDuration(
                                  Duration(minutes: row.durationMinutes!),
                                ),
                          amount: formatCurrency(row.amount),
                          tag: GzTag(
                            kind: _tagKindForBilling(row),
                            label: _statusLabel(row),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

String _statusLabel(BillingRow row) => formatBillingStatus(row.status);

GzTagKind _tagKindForBilling(BillingRow row) {
  switch (_statusLabel(row)) {
    case 'Paid':
      return GzTagKind.ok;
    case 'Overdue':
      return GzTagKind.err;
    default:
      return GzTagKind.warn;
  }
}

class _BillingRow extends StatelessWidget {
  const _BillingRow({
    required this.row,
    required this.store,
    required this.date,
    required this.duration,
    required this.amount,
    required this.tag,
  });

  final BillingRow row;
  final String store;
  final String date;
  final String duration;
  final String amount;
  final Widget tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(store, style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(
                  '$date · $duration',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                tag,
                if (row.id.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () {
                      final location = Uri(
                        path: AppRoutes.disputeCreate,
                        queryParameters: {'billingId': row.id},
                      ).toString();
                      context.push(location);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Raise dispute',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            amount,
            style: AppTypography.num.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
