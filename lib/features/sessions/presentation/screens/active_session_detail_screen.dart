import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/active_session_detail_mobile_layout.dart';

class ActiveSessionDetailScreen extends StatelessWidget {
  final String id;
  const ActiveSessionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ActiveSessionDetailMobileLayout(id: id),
    );
  }
}
