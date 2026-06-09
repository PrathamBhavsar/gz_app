import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/session_runtime_providers.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<BookingCommandState>(
      bookingCommandNotifierProvider(widget.id),
      (previous, next) {
        if (next is BookingCommandSuccess && next != previous) {
          showSuccessSnackbar(context, next.message);
          ref.read(bookingCommandNotifierProvider(widget.id).notifier).reset();
        } else if (next is BookingCommandError && next != previous) {
          showErrorSnackbar(context, next.error);
          ref.read(bookingCommandNotifierProvider(widget.id).notifier).reset();
        }
      },
    );

    final booking = ref.watch(bookingDetailStateNotifierProvider(widget.id));
    final commandState = ref.watch(bookingCommandNotifierProvider(widget.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Check in'),
      body: SafeArea(
        top: false,
        child: booking.when(
          loading: () => const GzLoadingView(message: 'Loading booking...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref
                .read(bookingDetailStateNotifierProvider(widget.id).notifier)
                .refresh(),
          ),
          data: (bookingData) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowSubtle,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusCard),
                    child: CustomPaint(
                      painter: _QrPatternPainter(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  bookingData.status == SessionUiStatus.checkedIn
                      ? 'You are already checked in'
                      : 'Show this to staff',
                  style: AppTypography.bodyR.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusCard),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '${bookingData.system}  ·  ${bookingData.time}  ·  ${bookingData.duration}',
                          style: AppTypography.bodyR,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GzButton(
                  label: bookingData.status == SessionUiStatus.checkedIn
                      ? 'Checked in'
                      : 'Scan to check in',
                  loading: commandState is BookingCommandLoading,
                  onPressed: bookingData.status == SessionUiStatus.checkedIn
                      ? null
                      : () => ref
                          .read(bookingCommandNotifierProvider(widget.id).notifier)
                          .checkIn(),
                ),
                const SizedBox(height: 12),
                GzButton(
                  label: 'Manual check in',
                  variant: GzButtonVariant.ghost,
                  loading: commandState is BookingCommandLoading,
                  onPressed: bookingData.status == SessionUiStatus.checkedIn
                      ? null
                      : () => ref
                          .read(bookingCommandNotifierProvider(widget.id).notifier)
                          .checkIn(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QrPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.textPrimary;
    const cols = 10;
    const rows = 10;
    const pattern = [
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 0],
      [1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 1, 0],
      [0, 1, 0, 1, 0, 1, 1, 0, 1, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 0, 1],
    ];
    const padding = 16.0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (pattern[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              padding + c * (size.width - padding * 2) / cols,
              padding + r * (size.height - padding * 2) / rows,
              (size.width - padding * 2) / cols - 2,
              (size.height - padding * 2) / rows - 2,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_QrPatternPainter old) => false;
}
