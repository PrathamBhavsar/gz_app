import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/store_detail_mobile_layout.dart';
import '../../widgets/store_detail_tablet_layout.dart';
import '../../providers/active_store_notifier.dart';

class StoreDetailScreen extends ConsumerStatefulWidget {
  final String slug;
  
  const StoreDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends ConsumerState<StoreDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeStoreProvider.notifier).fetchAndSetActiveStore(widget.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const StoreDetailMobileLayout(),
          DeviceType.tablet => const StoreDetailTabletLayout(),
          DeviceType.desktop => const StoreDetailTabletLayout(),
        },
      ),
    );
  }
}
