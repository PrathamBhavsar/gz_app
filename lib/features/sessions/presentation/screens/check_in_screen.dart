import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/check_in_mobile_layout.dart';

class CheckInScreen extends StatelessWidget {
  final String id;
  const CheckInScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CheckInMobileLayout(id: id),
    );
  }
}
