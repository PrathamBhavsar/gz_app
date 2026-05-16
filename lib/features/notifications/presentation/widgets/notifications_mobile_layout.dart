import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_center_sheet.dart';

// Thin wrapper — reuses the NotificationCenterContent from the modal sheet.
// Shown via AppRoutes.notifications as a full screen (not modal).
class NotificationsMobileLayout extends ConsumerWidget {
  const NotificationsMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const NotificationCenterContent();
  }
}
