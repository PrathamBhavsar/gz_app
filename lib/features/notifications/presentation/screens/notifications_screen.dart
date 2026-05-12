import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/notifications_mobile_layout.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const NotificationsMobileLayout(),
    );
  }
}
