import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_management_provider.dart';
import '../../providers/admin_permissions.dart';

final _disputeStatusFilterProvider = StateProvider.autoDispose<String?>((ref) => null);
final _selectedResolutionProvider = StateProvider.autoDispose<String>((ref) => 'full_refund');

/// Dispute Resolution — Screen 56.
/// Dispute inbox with status filters, resolution actions.
class DisputeResolutionScreen extends ConsumerStatefulWidget {
  const DisputeResolutionScreen({super.key});

  @override
  ConsumerState<DisputeResolutionScreen> createState() =>
      _DisputeResolutionScreenState();
}

class _DisputeResolutionScreenState
    extends ConsumerState<DisputeResolutionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(disputesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final statusFilter = ref.watch(_disputeStatusFilterProvider);
    final state = ref.watch(disputesProvider);
    final perms = ref.watch(adminPermissionsProvider);
    final canResolve = perms.canResolveDisputes;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminPricing),
        ),
        title: Text('Disputes', style: AppTypography.headingSmall),
      ),
      body: RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () =>
            ref.read(disputesProvider.notifier).load(status: statusFilter),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              _buildStatusChips(statusFilter),
              const SizedBox(height: AppSpacing.lg),
              _buildContent(state, canResolve),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChips(String? statusFilter) {
    final options = [null, 'open', 'in_review', 'resolved'];
    final labels = ['All', 'Open', 'In Review', 'Resolved'];
    return Row(
      children: List.generate(options.length, (i) {
        final isActive = statusFilter == options[i];
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: GestureDetector(
            onTap: () {
              ref.read(_disputeStatusFilterProvider.notifier).state = options[i];
              ref.read(disputesProvider.notifier).load(status: options[i]);
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
      ManagementState<List<dynamic>> state, bool canResolve) {
    if (state is ManagementLoading<List<dynamic>>) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }

    if (state is ManagementError<List<dynamic>>) {
      return _buildError(state.error);
    }

    if (state is ManagementLoaded<List<dynamic>>) {
      final disputes = state.data;
      if (disputes.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text('No disputes found',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ),
        );
      }
      return Column(
        children: disputes
            .map((d) =>
                _buildDisputeCard(d as Map<String, dynamic>, canResolve))
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
            Text('Failed to load disputes',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => ref
                  .read(disputesProvider.notifier)
                  .load(status: ref.read(_disputeStatusFilterProvider)),
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

  Widget _buildDisputeCard(Map<String, dynamic> dispute, bool canResolve) {
    final id = dispute['id']?.toString() ?? '';
    final status = dispute['status']?.toString() ?? 'open';
    final reason = dispute['reason']?.toString() ?? 'No reason provided';
    final amount = dispute['dispute_amount']?.toString() ?? '0';
    final userId = dispute['user_id']?.toString() ?? '--';
    final resolution = dispute['resolution']?.toString();

    final statusColor = switch (status.toLowerCase()) {
      'open' => AppColors.rose,
      'in_review' => AppColors.info,
      'resolved' => AppColors.ok,
      'withdrawn' => AppColors.textSecondary,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dispute #${id.length > 8 ? id.substring(0, 8) : id}',
                        style: AppTypography.bodyMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text('User: $userId · Disputed: ₹$amount',
                        style: AppTypography.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                ),
                child: Text(
                  status.replaceAll('_', ' ').toUpperCase(),
                  style: AppTypography.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(reason, style: AppTypography.caption),
          if (resolution != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
              child: Text('Resolution: $resolution',
                  style: AppTypography.caption),
            ),
          ],
          if (canResolve && status.toLowerCase() == 'open')
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        _showResolveSheet(context, id),
                    child: Text('Resolve',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.rose)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showResolveSheet(BuildContext context, String disputeId) {
    final notesCtrl = TextEditingController();
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
            Text('Resolve Dispute', style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            Text('This action is being logged under your name.',
                style: AppTypography.caption),
            const SizedBox(height: AppSpacing.lg),
            Consumer(
              builder: (context, ref, _) {
                final selectedResolution = ref.watch(_selectedResolutionProvider);
                return Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    _buildResolveChip('Full Refund', 'full_refund', selectedResolution),
                    _buildResolveChip('Partial Refund', 'partial_refund', selectedResolution),
                    _buildResolveChip('Credit Issued', 'credit_issued', selectedResolution),
                    _buildResolveChip('Upheld', 'upheld', selectedResolution),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: notesCtrl,
              style: AppTypography.bodyMedium,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Admin Notes (optional)',
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
                  final resolution = ref.read(_selectedResolutionProvider);
                  context.pop();
                  await ref.read(disputesProvider.notifier).resolveDispute(
                        disputeId: disputeId,
                        resolution: resolution,
                        notes: notesCtrl.text.trim().isEmpty
                            ? null
                            : notesCtrl.text.trim(),
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
                child: Text('Resolve', style: AppTypography.button),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildResolveChip(String label, String value, String selectedResolution) {
    final isActive = selectedResolution == value;
    return GestureDetector(
      onTap: () => ref.read(_selectedResolutionProvider.notifier).state = value,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.rose : AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(
              color: isActive ? AppColors.rose : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color:
                isActive ? AppColors.background : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
