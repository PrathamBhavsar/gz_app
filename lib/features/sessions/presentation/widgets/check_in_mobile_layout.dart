import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/booking/data/repositories/booking_repository.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

final _checkInLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final _checkInErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

class CheckInMobileLayout extends ConsumerStatefulWidget {
  final String id;
  const CheckInMobileLayout({super.key, required this.id});

  @override
  ConsumerState<CheckInMobileLayout> createState() =>
      _CheckInMobileLayoutState();
}

class _CheckInMobileLayoutState extends ConsumerState<CheckInMobileLayout> {
  Future<void> _tapCheckIn() async {
    ref.read(_checkInLoadingProvider.notifier).state = true;
    ref.read(_checkInErrorProvider.notifier).state = null;
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final repo = ref.read(bookingRepositoryProvider);
      await repo.checkIn(storeId, widget.id);
      if (mounted) {
        context.go(AppRoutes.sessions);
      }
    } catch (e) {
      if (mounted) {
        ref.read(_checkInLoadingProvider.notifier).state = false;
        ref.read(_checkInErrorProvider.notifier).state = e.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(_checkInLoadingProvider);
    final error = ref.watch(_checkInErrorProvider);
    return SafeArea(
      child: Column(
        children: [
          const GzTopBar(title: 'Check In'),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── QR code placeholder ──
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'QR CODE',
                            style: AppTypography.meta,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            widget.id.length > 12
                                ? widget.id.substring(0, 12)
                                : widget.id,
                            style: AppTypography.small,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'OR',
                      style: AppTypography.meta,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GzButton(
                      label: 'Tap to Check In',
                      loading: loading,
                      onPressed: loading ? null : _tapCheckIn,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (error != null)
                      Text(
                        error,
                        style: AppTypography.small.copyWith(color: AppColors.err),
                        textAlign: TextAlign.center,
                      )
                    else
                      Text(
                        'Check-in window opens 15 minutes before your session',
                        style: AppTypography.small,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
