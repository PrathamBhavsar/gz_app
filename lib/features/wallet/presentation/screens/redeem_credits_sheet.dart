import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';

Future<void> showRedeemCreditsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const RedeemCreditsSheet(),
  );
}

class RedeemCreditsSheet extends StatefulWidget {
  const RedeemCreditsSheet({super.key});

  @override
  State<RedeemCreditsSheet> createState() => _RedeemCreditsSheetState();
}

class _RedeemCreditsSheetState extends State<RedeemCreditsSheet> {
  static const double _maxCredits = 850;

  double _selectedCredits = 300;
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final rupeeValue = _selectedCredits / 10;
    final remaining = _maxCredits - _selectedCredits;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('Redeem credits', style: AppTypography.h1),
                const SizedBox(height: 4),
                Text(
                  '10 credits = ₹1',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: 16),
                const GzCard(
                  variant: CardVariant.tint,
                  child: _BalanceCard(),
                ),
                if (_confirmed) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.okBg,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusLg,
                      ),
                    ),
                    child: Text(
                      'Success! ₹${rupeeValue.toStringAsFixed(2)} has been applied to your wallet.',
                      style: AppTypography.body.copyWith(color: AppColors.ok),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.textPrimary,
                    inactiveTrackColor: AppColors.pillBg,
                    thumbColor: AppColors.textPrimary,
                    overlayColor: AppColors.textPrimary.withValues(alpha: 0.08),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    min: 0,
                    max: _maxCredits,
                    divisions: 17,
                    value: _selectedCredits,
                    onChanged: (value) {
                      setState(() {
                        _selectedCredits = value.roundToDouble();
                        _confirmed = false;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Redeem: ${_selectedCredits.toInt()} credits = ₹${rupeeValue.toStringAsFixed(2)}',
                  style: AppTypography.h3,
                ),
                const SizedBox(height: 4),
                Text(
                  'Remaining: ${remaining.toInt()} credits',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: 18),
                GzButton(
                  label: 'Redeem ${_selectedCredits.toInt()} credits',
                  onPressed: () => setState(() => _confirmed = true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BALANCE', style: AppTypography.meta),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '850', style: AppTypography.heroMd),
              TextSpan(
                text: ' credits available',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
