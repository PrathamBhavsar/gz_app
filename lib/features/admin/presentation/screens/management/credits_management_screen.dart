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

/// Credits Management — Screen 55.
/// Player search, balance card, transaction history, manual adjustment.
class CreditsManagementScreen extends ConsumerStatefulWidget {
  const CreditsManagementScreen({super.key});

  @override
  ConsumerState<CreditsManagementScreen> createState() =>
      _CreditsManagementScreenState();
}

class _CreditsManagementScreenState
    extends ConsumerState<CreditsManagementScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedUserId;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(creditsProvider);
    final role = ref.watch(adminRoleProvider);
    final canAdjust = role == 'super_admin' || role == 'admin';

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
        title: Text('Credits', style: AppTypography.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // Search bar
            TextField(
              controller: _searchCtrl,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search by phone, email, or name',
                hintStyle: AppTypography.caption,
                prefixIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                // Use search value as userId placeholder (real app would search)
                setState(() => _selectedUserId = value.trim().isEmpty ? null : value.trim());
                if (_selectedUserId != null) {
                  ref.read(creditsProvider.notifier).load(userId: _selectedUserId!);
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_selectedUserId != null) _buildContent(state, canAdjust),
            if (_selectedUserId == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Text('Search for a player to view credits',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                ),
              ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ManagementState<Map<String, dynamic>> state, bool canAdjust) {
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
      final balance = state.data['balance'] as Map<String, dynamic>?;
      final transactions = state.data['transactions'] as List<dynamic>?;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance card
          _buildBalanceCard(balance, canAdjust),
          const SizedBox(height: AppSpacing.lg),
          // Transaction history
          Text('Transaction History', style: AppTypography.headingSmall),
          const SizedBox(height: AppSpacing.md),
          if (transactions == null || transactions.isEmpty)
            Text('No transactions',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary))
          else
            ...transactions
                .map((t) => _buildTransactionRow(t as Map<String, dynamic>)),
        ],
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
            Text('Player not found or failed to load',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(Map<String, dynamic>? balance, bool canAdjust) {
    final current = balance?['current_balance']?.toString() ?? '0';
    final available = balance?['available_balance']?.toString() ?? '0';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current Balance', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.xs),
          Text('₹$current', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Available: ₹$available',
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          if (canAdjust) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showAdjustSheet(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.rose,
                  side: const BorderSide(color: AppColors.rose),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                  ),
                ),
                child: Text('Adjust Balance', style: AppTypography.button),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionRow(Map<String, dynamic> tx) {
    final type = tx['transaction_type']?.toString() ?? '--';
    final amount = tx['amount']?.toString() ?? '0';
    final desc = tx['description']?.toString() ?? type;
    final isPositive = (double.tryParse(amount) ?? 0) > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(desc, style: AppTypography.bodySmall),
          ),
          Text(
            '${isPositive ? '+' : ''}₹$amount',
            style: AppTypography.bodySmall.copyWith(
              color: isPositive ? const Color(0xFF4CAF50) : AppColors.rose,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAdjustSheet(BuildContext context) {
    final amountCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
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
            Text('Adjust Credits', style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            Text('Use negative values to deduct. This action is logged.',
                style: AppTypography.caption),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: amountCtrl,
              style: AppTypography.bodyMedium,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount (±)',
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
                labelText: 'Reason',
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
                  if (amount == null || _selectedUserId == null) return;
                  Navigator.pop(context);
                  await ref.read(creditsProvider.notifier).adjustCredits(
                        userId: _selectedUserId!,
                        amount: amount,
                        reason: reasonCtrl.text.trim().isEmpty
                            ? null
                            : reasonCtrl.text.trim(),
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
                child: Text('Apply', style: AppTypography.button),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
