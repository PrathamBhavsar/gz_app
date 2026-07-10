import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_dashboard_notifier.dart';
import '../../../application/admin_walk_in_notifier.dart';

class WalkInBookingScreen extends ConsumerStatefulWidget {
  const WalkInBookingScreen({super.key});

  @override
  ConsumerState<WalkInBookingScreen> createState() =>
      _WalkInBookingScreenState();
}

class _WalkInBookingScreenState extends ConsumerState<WalkInBookingScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<int> _durations = const [30, 60, 90, 120];

  String? _selectedSystemId;
  int _selectedDuration = 60;
  bool _payUpfront = false;
  PaymentMethod _paymentMethod = PaymentMethod.cash;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AdminWalkInState>(adminWalkInNotifierProvider, (_, next) {
      if (next is AdminWalkInSuccess) {
        showSuccessSnackbar(context, 'Walk-in session started');
        ref.read(adminWalkInNotifierProvider.notifier).reset();
        final target = next.response.systemId;
        if (target != null && target.isNotEmpty) {
          context.go(
            '${AppRoutes.adminSessions}?systemId=${Uri.encodeComponent(target)}',
          );
        } else {
          context.go(AppRoutes.adminDashboard);
        }
      } else if (next is AdminWalkInError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    final dashboard = ref.watch(adminDashboardNotifierProvider);
    final submitState = ref.watch(adminWalkInNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Walk-in Booking'),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.rule)),
          ),
          child: GzButton(
            label: 'Start Session Now',
            loading: submitState is AdminWalkInLoading,
            onPressed: _selectedSystemId == null
                ? null
                : () => ref
                      .read(adminWalkInNotifierProvider.notifier)
                      .submit(
                        systemId: _selectedSystemId!,
                        durationMinutes: _selectedDuration,
                        userName: _nameController.text.trim().isEmpty
                            ? null
                            : _nameController.text.trim(),
                        phone: _phoneController.text.trim().isEmpty
                            ? null
                            : _phoneController.text.trim(),
                        paymentMethod: _payUpfront ? _paymentMethod : null,
                      ),
          ),
        ),
      ),
      body: dashboard.when(
        loading: () =>
            const GzLoadingView(message: 'Loading available systems'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminDashboardNotifierProvider.notifier).refresh(),
        ),
        data: (data) {
          final systems = data.liveSystems
              .where((item) => item.status == 'available')
              .toList();
          if (systems.isEmpty) {
            return const PageErrorDisplay(error: AppPageError.empty);
          }

          _selectedSystemId ??= systems.first.systemId;

          return SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const _StepIndicator(),
                const SizedBox(height: 20),
                GzCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer details', style: AppTypography.h3),
                      const SizedBox(height: 12),
                      _InputField(
                        controller: _nameController,
                        hintText: 'Walk-in customer name',
                      ),
                      const SizedBox(height: 10),
                      _InputField(
                        controller: _phoneController,
                        hintText: 'Phone number',
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GzCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Available systems', style: AppTypography.h3),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: systems.map((system) {
                          final selected = system.systemId == _selectedSystemId;
                          return GzChip(
                            label: system.name ?? system.systemId ?? 'System',
                            keyPrefix: system.platform?.toUpperCase(),
                            active: selected,
                            onTap: () => setState(
                              () => _selectedSystemId = system.systemId,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GzCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Duration', style: AppTypography.h3),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _durations.map((value) {
                          return GzChip(
                            label:
                                '${value ~/ 60 > 0 ? '${value ~/ 60}h' : ''}${value % 60 == 0 ? '' : ' ${value % 60}m'}'
                                    .trim(),
                            active: value == _selectedDuration,
                            onTap: () =>
                                setState(() => _selectedDuration = value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GzCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile.adaptive(
                        value: _payUpfront,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pay upfront', style: AppTypography.h3),
                        subtitle: const Text(
                          'If enabled, a payment method is required.',
                          style: AppTypography.small,
                        ),
                        onChanged: (value) =>
                            setState(() => _payUpfront = value),
                      ),
                      if (_payUpfront) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: PaymentMethod.values
                              .where(
                                (method) =>
                                    method != PaymentMethod.wallet &&
                                    method != PaymentMethod.credits,
                              )
                              .map((method) {
                                return GzChip(
                                  label: method.name.toUpperCase(),
                                  active: method == _paymentMethod,
                                  onTap: () =>
                                      setState(() => _paymentMethod = method),
                                );
                              })
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    const labels = ['User', 'System', 'Payment'];
    return Row(
      children: List.generate(labels.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 18),
              color: AppColors.rule,
            ),
          );
        }
        final step = index ~/ 2;
        return SizedBox(
          width: 60,
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${step + 1}',
                  style: AppTypography.small.copyWith(
                    color: AppColors.surface,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(labels[step], style: AppTypography.small),
            ],
          ),
        );
      }),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.pillBg,
        hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
