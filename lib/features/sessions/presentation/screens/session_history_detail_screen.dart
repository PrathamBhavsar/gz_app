import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/session_history_detail_mobile_layout.dart';

class SessionHistoryDetailScreen extends StatelessWidget {
  final String id;
  const SessionHistoryDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SessionHistoryDetailMobileLayout(id: id),
    );
  }
}
