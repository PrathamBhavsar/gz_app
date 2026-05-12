import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/dispute_detail_mobile_layout.dart';

class DisputeDetailScreen extends StatelessWidget {
  const DisputeDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DisputeDetailMobileLayout(id: id),
    );
  }
}
