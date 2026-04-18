import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_management_provider.dart';
import '../../providers/admin_auth_provider.dart';

/// Billing & Payments — Screen 53.
/// Ledger view with status filters, override panel (super_admin), refund.
class BillingPaymentsScreen extends ConsumerStatefulWidget {
  const BillingPaymentsScreen({super.key});

  @override
  ConsumerState<BillingPaymentsScreen> createState() =>
      _BillingPaymentsScreenState();
}

class _BillingPaymentsScreenState
    extends ConsumerState<BillingPaymentsScreen> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(billingProvider.notifier).load(status: _statusFilter));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(billingProvider);
    final role = ref.watch(adminRoleProvider);
    final isSuperAdmin = role == 'super_admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminPricing),
        ),
        title: Text('Billing', style: AppTypography.headingSmall),
      ),
      body: RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () =>
            ref.read(billingProvider.notifier).load(status: _statusFilter),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              _buildStatusChips(),
              const SizedBox(height: AppSpacing.lg),
              _buildContent(state, isSuperAdmin),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChips() {
    final options = [null, 'unpaid', 'paid', 'overridden'];
    final labels = ['All', 'Unpaid', 'Paid', 'Overridden'];
    return Row(
      children: List.generate(options.length, (i) {
        final isActive = _statusFilter == options[i];
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: GestureDetector(
            onTap: () {
              setState(() => _statusFilter = options[i]);
              ref.read(billingProvider.notifier).load(status: _statusFilter);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isActive ? AppColors.rose : AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
              child: Text(
                labels[i],
                style: AppTypography.bodySmall.copyWith(
                  color:
                      isActive ? AppColors.background : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContent(
      ManagementState<List<dynamic>> state, bool isSuperAdmin) {
    if (state is ManagementLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }

    if (state is ManagementError) {
      return _buildError(state.error);
    }

    if (state is ManagementLoaded) {
      final entries = state.data;
      if (entries.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text('No billing records',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ),
        );
      }
      return Column(
        children: entries
            .map((e) => _buildLedgerCard(e as Map<String, dynamic>, isSuperAdmin))
            .toList(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load billing records',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => ref
                  .read(billingProvider.notifier)
                  .load(status: _statusFilter),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Retry', style: AppTypography.button),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerCard(Map<String, dynamic> entry, bool isSuperAdmin) {
    final id = entry['id']?.toString() ?? '--';
    final netAmount = entry['net_amount']?.toString() ?? '0';
    final status = entry['status'] ?? entry['billing_reason'] ?? '--';
    final createdAt = entry['created_at']?.toString() ?? '';
    final userId = entry['user_id']?.toString() ?? '';

    final statusColor = switch (status.toString().toLowerCase()) {
      'paid' => const Color(0xFF4CAF50),
      'unpaid' => AppColors.rose,
      'overridden' => AppColors.gold,
      _ => AppColors.textSecondary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bill #${id.substring(0, id.length > 8 ? 8 : id.length)}',
                        style: AppTypography.bodyMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '₹$netAmount · $userId',
                      style: AppTypography.caption,
                    ),
                    if (createdAt.isNotEmpty)
                      Text(_formatDate(createdAt), style: AppTypography.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                ),
                child: Text(
                  status.toString().toUpperCase(),
                  style: AppTypography.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (isSuperAdmin)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _showOverrideSheet(context, id),
                    child: Text('Override',
                        style:
                            AppTypography.bodySmall.copyWith(color: AppColors.rose)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showOverrideSheet(BuildContext context, String billingId) {
    final reasonCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manual Override', style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            Text('This action is being logged under your name.',
                style: AppTypography.caption),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: amountCtrl,
              style: AppTypography.bodyMedium,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'New Amount',
                labelStyle: AppTypography.caption,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: reasonCtrl,
              style: AppTypography.bodyMedium,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Reason for Override (required)',
                labelStyle: AppTypography.caption,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(amountCtrl.text);
                  if (amount == null || reasonCtrl.text.trim().isEmpty) return;
                  Navigator.pop(context);
                  await ref.read(billingProvider.notifier).overrideBilling(
                    billingId: billingId,
                    reason: reasonCtrl.text.trim(),
                    amount: amount,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rose,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                  ),
                ),
                child: Text('Apply Override', style: AppTypography.button),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
