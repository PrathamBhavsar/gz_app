import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/create_dispute_mobile_layout.dart';

class CreateDisputeScreen extends StatelessWidget {
  const CreateDisputeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const CreateDisputeMobileLayout(),
    );
  }
}
