import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_button.dart';

class WalkInBookingScreen extends StatelessWidget {
  const WalkInBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Walk-in Booking',
        onBack: () => context.go(AppRoutes.adminDashboard),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.rule)),
          ),
          child: GzButton(label: 'Next: Select System →', onPressed: () {}),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _StepIndicator(),
              SizedBox(height: 20),
              _SearchField(),
              SizedBox(height: 12),
              Center(child: Text('— or —', style: AppTypography.small)),
              SizedBox(height: 12),
              _NewCustomerCard(),
              SizedBox(height: 12),
              _ExistingCustomerCard(),
            ],
          ),
        ),
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
        final active = step == 0;
        return SizedBox(
          width: 60,
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: active ? AppColors.textPrimary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: active
                      ? null
                      : Border.all(color: AppColors.rule, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${step + 1}',
                  style: AppTypography.small.copyWith(
                    color: active ? AppColors.surface : AppColors.textTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[step],
                style: AppTypography.small.copyWith(
                  color: active
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            color: AppColors.textTertiary,
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Search by phone, name, or email…',
              style: AppTypography.bodyR,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewCustomerCard extends StatelessWidget {
  const _NewCustomerCard();

  InputDecoration get _decoration => InputDecoration(
    filled: true,
    fillColor: AppColors.pillBg,
    hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.rule),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New customer', style: AppTypography.h3),
          const SizedBox(height: 12),
          TextField(decoration: _decoration.copyWith(hintText: 'Full name')),
          const SizedBox(height: 10),
          TextField(
            decoration: _decoration.copyWith(hintText: 'Phone number'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class _ExistingCustomerCard extends StatelessWidget {
  const _ExistingCustomerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          GzAvatar(letter: 'R'),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rahul Mehra',
                  style: TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text('+91 98765 43210', style: AppTypography.small),
              ],
            ),
          ),
          HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textTertiary,
            size: 16,
          ),
        ],
      ),
    );
  }
}
