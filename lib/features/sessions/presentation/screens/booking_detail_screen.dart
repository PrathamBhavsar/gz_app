import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/session_runtime_providers.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  const BookingDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
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
    final commandBusy = commandState is BookingCommandLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Booking'),
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
          data: (bookingData) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GzTag(
                            kind: _bookingTagKind(bookingData.status),
                            label: _bookingTagLabel(bookingData.status),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bookingData.id,
                            style: AppTypography.h3.copyWith(
                              fontFamily: 'GeistMono',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  children: [
                    GzMetaRow(label: 'System', value: bookingData.system),
                    GzMetaRow(label: 'Seat', value: bookingData.seat),
                    GzMetaRow(label: 'Store', value: bookingData.store),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  children: [
                    GzMetaRow(label: 'Date', value: bookingData.date),
                    GzMetaRow(label: 'Time', value: bookingData.time),
                    GzMetaRow(label: 'Duration', value: bookingData.duration),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  children: [
                    GzMetaRow(label: 'Total', value: bookingData.total),
                    GzMetaRow(label: 'Status', value: bookingData.paymentStatus),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GzButton(
                label: bookingData.primaryActionLabel,
                loading: commandBusy,
                onPressed: bookingData.status == SessionUiStatus.checkedIn ||
                        bookingData.isCancelled
                    ? null
                    : () => bookingData.paymentStatus == 'Unpaid'
                        ? context.push(AppRoutes.paymentSheetPath(bookingData.id))
                        : context.push(AppRoutes.checkInPath(bookingData.id)),
              ),
              const SizedBox(height: 12),
              GzButton(
                label: bookingData.isCancelled ? 'Booking cancelled' : 'Cancel booking',
                variant: GzButtonVariant.dangerOutline,
                loading: commandBusy,
                onPressed: bookingData.isCancelled
                    ? null
                    : () => ref
                        .read(bookingCommandNotifierProvider(widget.id).notifier)
                        .cancel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

GzTagKind _bookingTagKind(SessionUiStatus status) => switch (status) {
  SessionUiStatus.confirmed => GzTagKind.ok,
  SessionUiStatus.unpaid => GzTagKind.warn,
  SessionUiStatus.checkedIn => GzTagKind.info,
  SessionUiStatus.active => GzTagKind.ok,
  SessionUiStatus.completed => GzTagKind.info,
};

String _bookingTagLabel(SessionUiStatus status) => switch (status) {
  SessionUiStatus.confirmed => 'Confirmed',
  SessionUiStatus.unpaid => 'Unpaid',
  SessionUiStatus.checkedIn => 'Checked in',
  SessionUiStatus.active => 'Active',
  SessionUiStatus.completed => 'Completed',
};

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: child,
    );
  }
}
