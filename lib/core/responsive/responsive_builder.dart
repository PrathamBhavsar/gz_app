import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ResponsiveBuilderWidget extends StatelessWidget {
  const ResponsiveBuilderWidget({super.key, required this.builder});

  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = Breakpoints.getDeviceType(context);
        return builder(context, deviceType);
      },
    );
  }
}

class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.mobile,
    required this.tablet,
    this.desktop,
  });

  final T mobile;
  final T tablet;
  final T? desktop;

  T getValueOf(BuildContext context) {
    final deviceType = Breakpoints.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop ?? tablet;
    }
  }
}
