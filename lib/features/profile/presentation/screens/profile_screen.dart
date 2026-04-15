import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(child: Text('Profile Management Coming Soon', style: AppTypography.headingMedium)),
    );
  }
}
