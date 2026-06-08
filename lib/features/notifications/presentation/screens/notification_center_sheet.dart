import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'notifications_screen.dart';

Future<void> showNotificationCenter(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const FractionallySizedBox(
        heightFactor: 0.96,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          child: ColoredBox(
            color: AppColors.background,
            child: NotificationsScreen(),
          ),
        ),
      );
    },
  );
}
