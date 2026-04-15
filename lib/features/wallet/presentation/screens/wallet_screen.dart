import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GZ Wallet')),
      body: Center(child: Text('Wallet Features Coming Soon', style: AppTypography.headingMedium)),
    );
  }
}
