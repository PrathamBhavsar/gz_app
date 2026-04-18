import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_operations_provider.dart';
import '../../../../../../models/domain_admin.dart';

/// Walk-in Booking — Screen 44.
/// Rapidly create a session for a customer at the counter.
class WalkInBookingScreen extends ConsumerStatefulWidget {
  const WalkInBookingScreen({super.key});

  @override
  ConsumerState<WalkInBookingScreen> createState() =>
      _WalkInBookingScreenState();
}

class _WalkInBookingScreenState extends ConsumerState<WalkInBookingScreen> {
  int _currentStep = 0;

  // Step 1: User
  final _searchController = TextEditingController();
  String? _selectedUserId;
  String? _selectedUserName;
  final _newNameController = TextEditingController();
  final _newPhoneController = TextEditingController();
  bool _showNewUserForm = false;

  // Step 2: System & Duration
  String? _selectedSystemId;
  String? _selectedSystemName;
  double _durationMinutes = 60;
  String _platformFilter = 'All';

  // Step 3: Payment
  bool _payUpfront = true;
  String? _paymentMethod;

  // Available systems cache
  List<Map<String, dynamic>> _availableSystems = [];

  @override
  void dispose() {
    _searchController.dispose();
    _newNameController.dispose();
    _newPhoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadAvailableSystems());
  }

  Future<void> _loadAvailableSystems() async {
    try {
      final storeId = ref.read(adminStoreIdProvider);
      if (storeId == null) return;
      final data = await ref
          .read(adminOperationsServiceProvider)
          .getAvailableSystems(storeId);
      if (data is List && mounted) {
        setState(() {
          _availableSystems =
              data.cast<Map<String, dynamic>>();
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final walkInState = ref.watch(walkInProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminDashboard),
        ),
        title: Text('Walk-in Booking', style: AppTypography.headingSmall),
      ),
      body: Column(
        children: [
          // Step indicator
          _buildStepIndicator(),
          const SizedBox(height: AppSpacing.md),
          // Step content
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: switch (_currentStep) {
                0 => _buildUserStep(),
                1 => _buildSystemStep(),
                2 => _buildPaymentStep(),
                _ => const SizedBox.shrink(),
              },
            ),
          ),
          // Bottom action
          _buildBottomAction(walkInState),
        ],
      ),
    );
  }

  // ─── Step Indicator ─────────────────────────────────────────────────

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildStepDot(0, 'User'),
          Expanded(child: Container(height: 2, color: AppColors.border)),
          _buildStepDot(1, 'System'),
          Expanded(child: Container(height: 2, color: AppColors.border)),
          _buildStepDot(2, 'Payment'),
        ],
      ),
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = _currentStep >= step;
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
                ? const Icon(Icons.check, color: AppColors.background, size: 16)
                : Text(
                    '${step + 1}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
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

  // ─── Step 1: User ───────────────────────────────────────────────────

  Widget _buildUserStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Find or create a player',
            style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.lg),
        // Search field
        TextField(
          controller: _searchController,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Phone or email',
            hintStyle: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
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
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppSpacing.borderRadius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppSpacing.borderRadius),
              borderSide:
                  const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // New user button
        if (!_showNewUserForm)
          TextButton.icon(
            onPressed: () =>
                setState(() => _showNewUserForm = true),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedUserCircle,
              color: AppColors.rose,
              size: 20,
            ),
            label: Text(
              'New User',
              style:
                  AppTypography.bodyMedium.copyWith(color: AppColors.rose),
            ),
          ),
        if (_showNewUserForm) ...[
          const SizedBox(height: AppSpacing.md),
          Text('New Player', style: AppTypography.headingSmall),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _newNameController,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadius),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadius),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadius),
                borderSide:
                    const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _newPhoneController,
            keyboardType: TextInputType.phone,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Phone',
              labelStyle: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadius),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadius),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadius),
                borderSide:
                    const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ─── Step 2: System & Duration ──────────────────────────────────────

  Widget _buildSystemStep() {
    final filteredSystems = _platformFilter == 'All'
        ? _availableSystems
        : _availableSystems
            .where((s) =>
                (s['platform'] as String?)?.toLowerCase() ==
                _platformFilter.toLowerCase())
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select system & duration',
            style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.lg),
        // Platform filters
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (ctx, i) {
              final filters = ['All', 'PC', 'Console', 'VR'];
              final isSelected = filters[i] == _platformFilter;
              return GestureDetector(
                onTap: () =>
                    setState(() => _platformFilter = filters[i]),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.rose : AppColors.surface,
                    borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusSm),
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
        // System grid
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
              final isSelected = sysId == _selectedSystemId;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedSystemId = sysId;
                  _selectedSystemName = sysName;
                }),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.rose.withOpacity(0.15)
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
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: AppSpacing.lg),
        // Duration presets
        Text('Duration', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _buildDurationPreset('30m', 30),
            _buildDurationPreset('1h', 60),
            _buildDurationPreset('2h', 120),
            _buildDurationPreset('4h', 240),
            _buildDurationPreset('8h', 480),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Duration slider
        Row(
          children: [
            Text('15m',
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary)),
            Expanded(
              child: Slider(
                value: _durationMinutes,
                min: 15,
                max: 480,
                divisions: 31,
                activeColor: AppColors.rose,
                inactiveColor: AppColors.secondary,
                label: _formatDuration(_durationMinutes.round()),
                onChanged: (v) =>
                    setState(() => _durationMinutes = v),
              ),
            ),
            Text('8h',
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
        Center(
          child: Text(
            _formatDuration(_durationMinutes.round()),
            style: AppTypography.headingSmall
                .copyWith(color: AppColors.rose),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationPreset(String label, int minutes) {
    final isSelected = _durationMinutes.round() == minutes;
    return GestureDetector(
      onTap: () => setState(() => _durationMinutes = minutes.toDouble()),
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
            color: isSelected
                ? AppColors.background
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ─── Step 3: Payment ────────────────────────────────────────────────

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment method', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.lg),
        // Pay toggle
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _payUpfront = true),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _payUpfront
                        ? AppColors.rose.withOpacity(0.15)
                        : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                    border: Border.all(
                      color: _payUpfront ? AppColors.rose : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Pay Upfront',
                      style: AppTypography.bodyMedium.copyWith(
                        color: _payUpfront
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
                onTap: () => setState(() {
                  _payUpfront = false;
                  _paymentMethod = null;
                }),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: !_payUpfront
                        ? AppColors.rose.withOpacity(0.15)
                        : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadius),
                    border: Border.all(
                      color:
                          !_payUpfront ? AppColors.rose : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Pay at End',
                      style: AppTypography.bodyMedium.copyWith(
                        color: !_payUpfront
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
        if (_payUpfront) ...[
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildPaymentChip('Cash', 'cash'),
              _buildPaymentChip('UPI', 'upi'),
              _buildPaymentChip('Card', 'card'),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        // Summary
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          ),
          child: Column(
            children: [
              _buildSummaryRow('System', _selectedSystemName ?? '--'),
              _buildSummaryRow(
                'Duration',
                _formatDuration(_durationMinutes.round()),
              ),
              _buildSummaryRow(
                'Payment',
                _payUpfront ? (_paymentMethod?.toUpperCase() ?? 'Select') : 'At end',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentChip(String label, String method) {
    final isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
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
            color: isSelected
                ? AppColors.background
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  // ─── Bottom Action ──────────────────────────────────────────────────

  Widget _buildBottomAction(WalkInState walkInState) {
    final isLoading = walkInState is WalkInLoading;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
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
            if (_currentStep > 0)
              const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleNext,
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
                        _currentStep < 2 ? 'Continue' : 'Start Session',
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

  void _handleNext() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _submitWalkIn();
    }
  }

  Future<void> _submitWalkIn() async {
    // For demo: use "guest" user if none selected
    final userId = _selectedUserId ?? 'guest';
    final systemId = _selectedSystemId;
    if (systemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a system'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ref.read(walkInProvider.notifier).createWalkIn(
      userId: userId,
      systemId: systemId,
      durationMinutes: _durationMinutes.round(),
      paymentMethod: _payUpfront ? _paymentMethod : null,
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }
}
