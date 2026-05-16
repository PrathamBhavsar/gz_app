import 'package:flutter/material.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/domain_loyalty.dart';
import '../widgets/campaign_detail_mobile_layout.dart';

class CampaignDetailScreen extends StatelessWidget {
  const CampaignDetailScreen({super.key, required this.id, this.campaign});

  final String id;
  final CampaignModel? campaign;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => CampaignDetailMobileLayout(id: id, campaign: campaign),
          DeviceType.tablet  => CampaignDetailMobileLayout(id: id, campaign: campaign),
          DeviceType.desktop => CampaignDetailMobileLayout(id: id, campaign: campaign),
        },
      ),
    );
  }
}
