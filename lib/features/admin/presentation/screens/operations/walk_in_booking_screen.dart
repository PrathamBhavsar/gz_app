import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_operations_provider.dart';
import '../../../data/services/admin_operations_service.dart';
import '../../providers/admin_auth_provider.dart';

final _walkInStepProvider = StateProvider.autoDispose<int>((ref) => 0);
final _walkInShowNewUserProvider = StateProvider.autoDispose<bool>((ref) => false);
final _walkInSelectedSystemIdProvider = StateProvider.autoDispose<String?>((ref) => null);
final _walkInSelectedSystemNameProvider = StateProvider.autoDispose<String?>((ref) => null);
final _walkInDurationProvider = StateProvider.autoDispose<double>((ref) => 60);
final _walkInPlatformFilterProvider = StateProvider.autoDispose<String>((ref) => 'All');
final _walkInPayUpfrontProvider = StateProvider.autoDispose<bool>((ref) => true);
final _walkInPaymentMethodProvider = StateProvider.autoDispose<String?>((ref) => null);
final _walkInSystemsProvider =
    StateProvider.autoDispose<List<Map<String, dynamic>>>((ref) => []);

String _formatDuration(int minutes) {
  if (minutes < 60) return '${minutes}m';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m > 0 ? '${h}h ${m}m' : '${h}h';
}

/// Walk-in Booking — Screen 44.
/// Rapidly create a session for a customer at the counter.
class WalkInBookingScreen extends ConsumerStatefulWidget {
  const WalkInBookingScreen({super.key});

  @override
  ConsumerState<WalkInBookingScreen> createState() =>
      _WalkInBookingScreenState();
}

class _WalkInBookingScreenState extends ConsumerState<WalkInBookingScreen> {
  final _searchController = TextEditingController();
  final _newNameController = TextEditingController();
  final _newPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadAvailableSystems());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _newNameController.dispose();
    _newPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableSystems() async {
    try {
      final storeId = ref.read(adminStoreIdProvider);
      if (storeId == null) return;
      final data = await ref
          .read(adminOperationsServiceProvider)
          .getAvailableSystems(storeId);
      if (data is List && mounted) {
        ref.read(_walkInSystemsProvider.notifier).state =
            data.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final walkInState = ref.watch(walkInProvider);
    final currentStep = ref.watch(_walkInStepProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.go(AppRoutes.adminDashboard),
        ),
        title: Text('Walk-in Booking', style: AppTypography.headingSmall),
      ),
      body: Column(
        children: [
          _WalkInStepIndicator(currentStep: currentStep),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: switch (currentStep) {
                0 => _UserStep(
                    searchCtrl: _searchController,
                    nameCtrl: _newNameController,
                    phoneCtrl: _newPhoneController,
                  ),
                1 => const _SystemStep(),
                2 => const _PaymentStep(),
                _ => const SizedBox.shrink(),
              },
            ),
          ),
          _WalkInBottomAction(
            walkInState: walkInState,
            onNext: _handleNext,
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    final currentStep = ref.read(_walkInStepProvider);
    if (currentStep < 2) {
      ref.read(_walkInStepProvider.notifier).state = currentStep + 1;
    } else {
      _submitWalkIn();
    }
  }

  Future<void> _submitWalkIn() async {
    const userId = 'guest';
    final systemId = ref.read(_walkInSelectedSystemIdProvider);
    if (systemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a system'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final durationMinutes = ref.read(_walkInDurationProvider);
    final payUpfront = ref.read(_walkInPayUpfrontProvider);
    final paymentMethod = ref.read(_walkInPaymentMethodProvider);

    ref.read(walkInProvider.notifier).createWalkIn(
      userId: userId,
      systemId: systemId,
      durationMinutes: durationMinutes.round(),
      paymentMethod: payUpfront ? paymentMethod : null,
    );
  }
}

// ─── Step Indicator ──────────────────────────────────────────────────────────

class _WalkInStepIndicator extends StatelessWidget {
  const _WalkInStepIndicator({required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _StepDot(step: 0, label: 'User', isActive: currentStep >= 0),
          Expanded(child: Container(height: 2, color: AppColors.border)),
          _StepDot(step: 1, label: 'System', isActive: currentStep >= 1),
          Expanded(child: Container(height: 2, color: AppColors.border)),
          _StepDot(step: 2, label: 'Payment', isActive: currentStep >= 2),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.step,
    required this.label,
    required this.isActive,
  });
  final int step;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? AppColors.rose : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.rose : AppColors.border,
            ),
          ),
          child: Center(
            child: isActive
                ? const HugeIcon(
                    icon: HugeIcons.strokeRoundedTick01,
                    color: AppColors.background,
                    size: 16,
                  )
                : Text(
                    '${step + 1}',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── Step 1: User ────────────────────────────────────────────────────────────

class _UserStep extends ConsumerWidget {
  const _UserStep({
    required this.searchCtrl,
    required this.nameCtrl,
    required this.phoneCtrl,
  });
  final TextEditingController searchCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;

  static InputDecoration _decor(String hint, {bool isLabel = false}) =>
      InputDecoration(
        hintText: isLabel ? null : hint,
        labelText: isLabel ? hint : null,
        labelStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        hintStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showNewUserForm = ref.watch(_walkInShowNewUserProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Find or create a player', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: searchCtrl,
          style: AppTypography.bodyLarge,
          decoration: _decor('Phone or email').copyWith(
            prefixIcon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (!showNewUserForm)
          TextButton.icon(
            onPressed: () =>
                ref.read(_walkInShowNewUserProvider.notifier).state = true,
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedUserCircle,
              color: AppColors.rose,
              size: 20,
            ),
            label: Text(
              'New User',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.rose),
            ),
          ),
        if (showNewUserForm) ...[
          const SizedBox(height: AppSpacing.md),
          Text('New Player', style: AppTypography.headingSmall),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: nameCtrl,
            style: AppTypography.bodyLarge,
            decoration: _decor('Name', isLabel: true),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            style: AppTypography.bodyLarge,
            decoration: _decor('Phone', isLabel: true),
          ),
        ],
      ],
    );
  }
}

// ─── Step 2: System & Duration ───────────────────────────────────────────────

class _SystemStep extends ConsumerWidget {
  const _SystemStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformFilter = ref.watch(_walkInPlatformFilterProvider);
    final availableSystems = ref.watch(_walkInSystemsProvider);
    final selectedSystemId = ref.watch(_walkInSelectedSystemIdProvider);
    final durationMinutes = ref.watch(_walkInDurationProvider);

    final filteredSystems = platformFilter == 'All'
        ? availableSystems
        : availableSystems
            .where((s) =>
                (s['platform'] as String?)?.toLowerCase() ==
                platformFilter.toLowerCase())
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select system & duration', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (ctx, i) {
              final filters = ['All', 'PC', 'Console', 'VR'];
              final isSelected = filters[i] == platformFilter;
              return GestureDetector(
                onTap: () => ref
                    .read(_walkInPlatformFilterProvider.notifier)
                    .state = filters[i],
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.rose : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusSm),
                    border: Border.all(
                      color: isSelected ? AppColors.rose : AppColors.border,
                    ),
                  ),
                  child: Text(
                    filters[i],
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (filteredSystems.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'No available systems',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 2.0,
            ),
            itemCount: filteredSystems.length,
            itemBuilder: (ctx, i) {
              final system = filteredSystems[i];
              final sysId = system['systemId']?.toString();
              final sysName = system['name']?.toString() ?? 'System';
              final isSelected = sysId == selectedSystemId;
              return GestureDetector(
                onTap: () {
                  ref.read(_walkInSelectedSystemIdProvider.notifier).state =
                      sysId;
                  ref.read(_walkInSelectedSystemNameProvider.notifier).state =
                      sysName;
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.rose.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                    border: Border.all(
                      color: isSelected ? AppColors.rose : AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sysName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.rose
                              : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (system['platform'] != null)
                        Text(
                          system['platform'].toString(),
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: AppSpacing.lg),
        Text('Duration', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _DurationPreset(label: '30m', minutes: 30, selected: durationMinutes),
            _DurationPreset(label: '1h', minutes: 60, selected: durationMinutes),
            _DurationPreset(label: '2h', minutes: 120, selected: durationMinutes),
            _DurationPreset(label: '4h', minutes: 240, selected: durationMinutes),
            _DurationPreset(label: '8h', minutes: 480, selected: durationMinutes),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Text(
              '15m',
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
            Expanded(
              child: Slider(
                value: durationMinutes,
                min: 15,
                max: 480,
                divisions: 31,
                activeColor: AppColors.rose,
                inactiveColor: AppColors.secondary,
                label: _formatDuration(durationMinutes.round()),
                onChanged: (v) =>
                    ref.read(_walkInDurationProvider.notifier).state = v,
              ),
            ),
            Text(
              '8h',
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        Center(
          child: Text(
            _formatDuration(durationMinutes.round()),
            style: AppTypography.headingSmall.copyWith(color: AppColors.rose),
          ),
        ),
      ],
    );
  }
}

class _DurationPreset extends ConsumerWidget {
  const _DurationPreset({
    required this.label,
    required this.minutes,
    required this.selected,
  });
  final String label;
  final int minutes;
  final double selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = selected.round() == minutes;
    return GestureDetector(
      onTap: () =>
          ref.read(_walkInDurationProvider.notifier).state = minutes.toDouble(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(
            color: isSelected ? AppColors.rose : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Step 3: Payment ─────────────────────────────────────────────────────────

class _PaymentStep extends ConsumerWidget {
  const _PaymentStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payUpfront = ref.watch(_walkInPayUpfrontProvider);
    final paymentMethod = ref.watch(_walkInPaymentMethodProvider);
    final selectedSystemName = ref.watch(_walkInSelectedSystemNameProvider);
    final durationMinutes = ref.watch(_walkInDurationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment method', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(_walkInPayUpfrontProvider.notifier).state = true,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: payUpfront
                        ? AppColors.rose.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                    border: Border.all(
                      color: payUpfront ? AppColors.rose : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Pay Upfront',
                      style: AppTypography.bodyMedium.copyWith(
                        color: payUpfront
                            ? AppColors.rose
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(_walkInPayUpfrontProvider.notifier).state = false;
                  ref.read(_walkInPaymentMethodProvider.notifier).state = null;
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: !payUpfront
                        ? AppColors.rose.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                    border: Border.all(
                      color: !payUpfront ? AppColors.rose : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Pay at End',
                      style: AppTypography.bodyMedium.copyWith(
                        color: !payUpfront
                            ? AppColors.rose
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (payUpfront) ...[
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _PaymentChip(
                label: 'Cash',
                method: 'cash',
                selected: paymentMethod,
              ),
              _PaymentChip(
                label: 'UPI',
                method: 'upi',
                selected: paymentMethod,
              ),
              _PaymentChip(
                label: 'Card',
                method: 'card',
                selected: paymentMethod,
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          ),
          child: Column(
            children: [
              _SummaryRow(label: 'System', value: selectedSystemName ?? '--'),
              _SummaryRow(
                label: 'Duration',
                value: _formatDuration(durationMinutes.round()),
              ),
              _SummaryRow(
                label: 'Payment',
                value: payUpfront
                    ? (paymentMethod?.toUpperCase() ?? 'Select')
                    : 'At end',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentChip extends ConsumerWidget {
  const _PaymentChip({
    required this.label,
    required this.method,
    required this.selected,
  });
  final String label;
  final String method;
  final String? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = selected == method;
    return GestureDetector(
      onTap: () =>
          ref.read(_walkInPaymentMethodProvider.notifier).state = method,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          border: Border.all(
            color: isSelected ? AppColors.rose : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

// ─── Bottom Action ───────────────────────────────────────────────────────────

class _WalkInBottomAction extends ConsumerWidget {
  const _WalkInBottomAction({
    required this.walkInState,
    required this.onNext,
  });
  final WalkInState walkInState;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = walkInState is WalkInLoading;
    final currentStep = ref.watch(_walkInStepProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref
                      .read(_walkInStepProvider.notifier)
                      .state = currentStep - 1,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadius),
                    ),
                  ),
                  child: Text('Back', style: AppTypography.button),
                ),
              ),
            if (currentStep > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isLoading ? null : onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rose,
                  foregroundColor: AppColors.background,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                    : Text(
                        currentStep < 2 ? 'Continue' : 'Start Session',
                        style: AppTypography.button
                            .copyWith(color: AppColors.background),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
