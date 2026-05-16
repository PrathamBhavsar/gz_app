import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Shows a slim error banner when the device is offline.
/// Returns [SizedBox.shrink] when connected or connectivity is unknown.
class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnectedAsync = ref.watch(connectivityStreamProvider);
    final isOffline = isConnectedAsync.valueOrNull == false;
    if (!isOffline) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      color: AppColors.errBg,
      child: Row(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedWifiOff01,
            color: AppColors.err,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'No internet connection',
            style: AppTypography.small.copyWith(color: AppColors.err),
          ),
        ],
      ),
    );
  }
}
