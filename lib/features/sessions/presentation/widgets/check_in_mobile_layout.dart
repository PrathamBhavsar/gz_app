import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/booking/data/repositories/booking_repository.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_top_bar.dart';

class CheckInMobileLayout extends ConsumerStatefulWidget {
  final String id;
  const CheckInMobileLayout({super.key, required this.id});

  @override
  ConsumerState<CheckInMobileLayout> createState() =>
      _CheckInMobileLayoutState();
}

class _CheckInMobileLayoutState extends ConsumerState<CheckInMobileLayout> {
  bool _loading = false;
  String? _error;

  Future<void> _tapCheckIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final repo = ref.read(bookingRepositoryProvider);
      await repo.checkIn(storeId, widget.id);
      if (mounted) {
        context.go(AppRoutes.sessions);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const EmTopBar(title: 'Check In'),
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
                    EmButtonFull(
                      label: 'Tap to Check In',
                      loading: _loading,
                      onPressed: _loading ? null : _tapCheckIn,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (_error != null)
                      Text(
                        _error!,
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
