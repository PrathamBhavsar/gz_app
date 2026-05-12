import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/active_session_mobile_layout.dart';

class ActiveSessionScreen extends StatelessWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const ActiveSessionMobileLayout(),
    );
  }
}
