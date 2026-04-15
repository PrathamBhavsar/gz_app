import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_builder.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/main_mobile_layout.dart';
import 'widgets/main_tablet_layout.dart';

class MainPage extends ConsumerWidget {
  final Widget child;
  const MainPage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => MainMobileLayout(child: child),
          DeviceType.tablet => MainTabletLayout(child: child),
          DeviceType.desktop => MainTabletLayout(child: child),
        },
      ),
    );
  }
}
