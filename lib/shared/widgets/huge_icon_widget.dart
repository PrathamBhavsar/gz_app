import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class HugeIconWidget extends StatelessWidget {
  const HugeIconWidget({
    Key? key,
    required this.icon,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  final String icon;
  final double size;
  final Color? color;

  // Hugeicons doesn't support direct string matching out-of-the-box dynamically 
  // without a map, so we map standard names required by AppPageError to actual HugeIcons.
  IconData _getIconData(String name) {
    switch (name) {
      case 'wifi_off':
        return HugeIcons.strokeRoundedWifiDisconnected01;
      case 'cloud_error':
        return HugeIcons.strokeRoundedCloudCross;
      case 'lock':
        return HugeIcons.strokeRoundedLockPassword;
      case 'alert_circle':
      default:
        return HugeIcons.strokeRoundedAlert01;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HugeIcon(
      icon: _getIconData(icon),
      color: color ?? Theme.of(context).iconTheme.color ?? Colors.white,
      size: size,
    );
  }
}
