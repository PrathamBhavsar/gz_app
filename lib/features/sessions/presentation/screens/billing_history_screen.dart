import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/billing_history_mobile_layout.dart';

class BillingHistoryScreen extends StatelessWidget {
  const BillingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const BillingHistoryMobileLayout(),
    );
  }
}
