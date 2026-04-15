import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Sessions')),
      body: Center(child: Text('Sessions Tracking Coming Soon', style: AppTypography.headingMedium)),
    );
  }
}
