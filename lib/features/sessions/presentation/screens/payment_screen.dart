import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

enum _PaymentMethod { cash, upi, card }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.id});
  final String id;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PaymentMethod _selected = _PaymentMethod.cash;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Complete payment'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusCard),
              ),
              child: Column(
                children: [
                  Text(
                    '₹160',
                    style: AppTypography.h1.copyWith(
                      fontSize: 40,
                      fontFamily: 'GeistMono',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Due by 11:00 PM tonight',
                    style: AppTypography.small
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Payment method', style: AppTypography.h2),
            const SizedBox(height: 12),
            _PaymentMethodTile(
              icon: HugeIcons.strokeRoundedMoney02,
              label: 'Cash',
              selected: _selected == _PaymentMethod.cash,
              onTap: () => setState(() => _selected = _PaymentMethod.cash),
            ),
            const SizedBox(height: 10),
            _PaymentMethodTile(
              icon: HugeIcons.strokeRoundedSmartPhone01,
              label: 'UPI',
              selected: _selected == _PaymentMethod.upi,
              onTap: () => setState(() => _selected = _PaymentMethod.upi),
              expandChild: _selected == _PaymentMethod.upi
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter UPI ID',
                          hintStyle: AppTypography.bodyR
                              .copyWith(color: AppColors.textMuted),
                          filled: true,
                          fillColor: AppColors.pillBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            _PaymentMethodTile(
              icon: HugeIcons.strokeRoundedCreditCard,
              label: 'Card',
              selected: _selected == _PaymentMethod.card,
              onTap: () => setState(() => _selected = _PaymentMethod.card),
              expandChild: _selected == _PaymentMethod.card
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Card number',
                              hintStyle: AppTypography.bodyR
                                  .copyWith(color: AppColors.textMuted),
                              filled: true,
                              fillColor: AppColors.pillBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'MM / YY',
                                    hintStyle: AppTypography.bodyR
                                        .copyWith(color: AppColors.textMuted),
                                    filled: true,
                                    fillColor: AppColors.pillBg,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'CVV',
                                    hintStyle: AppTypography.bodyR
                                        .copyWith(color: AppColors.textMuted),
                                    filled: true,
                                    fillColor: AppColors.pillBg,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 28),
            GzButton(label: 'Pay ₹160', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.expandChild,
  });

  final List<List<dynamic>> icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? expandChild;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          border: Border.all(
            color: selected ? AppColors.textPrimary : AppColors.rule,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                HugeIcon(icon: icon, color: AppColors.textSecondary, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: AppTypography.h3)),
                if (selected)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 13),
                  )
                else
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.rule, width: 2),
                    ),
                  ),
              ],
            ),
            ?expandChild,
          ],
        ),
      ),
    );
  }
}
