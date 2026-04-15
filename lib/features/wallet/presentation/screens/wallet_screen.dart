import 'package:flutter/material.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import 'widgets/wallet_mobile_layout.dart';
import 'widgets/wallet_tablet_layout.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Wallet'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Inside shell
      ),
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const WalletMobileLayout(),
          DeviceType.tablet => const WalletTabletLayout(),
          DeviceType.desktop => const WalletTabletLayout(),
        },
      ),
    );
  }
}
