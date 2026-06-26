import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../notifications/application/notifications_notifier.dart';
import '../../../notifications/presentation/screens/notification_center_sheet.dart';
import '../../application/activity_hub_notifier.dart';
import '../../application/session_ui_models.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../shared/widgets/gz_live_dot.dart';
import '../../../../shared/widgets/gz_tag.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  int _filterIndex = 0;
  final _filters = ['All', 'Upcoming', 'Active', 'Past'];

  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final hubState = ref.watch(activityHubNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: hubState.when(
          loading: () => const GzLoadingView(message: 'Loading sessions...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () =>
                ref.read(activityHubNotifierProvider.notifier).refresh(),
          ),
          data: (data) {
            if (data.activeSession == null &&
                data.upcoming.isEmpty &&
                data.past.isEmpty) {
              return PageErrorDisplay(
                error: const AppPageError(
                  title: 'No sessions yet',
                  message: 'Your bookings and sessions will appear here.',
                  icon: 'inbox',
                  kind: AppPageErrorKind.empty,
                ),
                onRetry: () =>
                    ref.read(activityHubNotifierProvider.notifier).refresh(),
              );
            }

            final filter = _filters[_filterIndex];
            final visibleUpcoming = switch (filter) {
              'Upcoming' || 'All' => data.upcoming,
              _ => const <UpcomingBookingState>[],
            };
            final visiblePast = switch (filter) {
              'Past' || 'All' => data.past,
              _ => const <PastSessionState>[],
            };
            final showActive =
                (switch (filter) {
                  'Active' || 'All' => true,
                  _ => false,
                }) &&
                data.activeSession != null;
            final filterEmpty =
                !showActive &&
                visibleUpcoming.isEmpty &&
                visiblePast.isEmpty;

            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(activityHubNotifierProvider.notifier).refresh(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Sessions',
                                  style: AppTypography.h1,
                                ),
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  GzIconBtn(
                                    tooltip: 'Notifications',
                                    onTap: () =>
                                        showNotificationCenter(context),
                                    child: const HugeIcon(
                                      icon:
                                          HugeIcons.strokeRoundedNotification03,
                                      color: AppColors.textPrimary,
                                      size: 22,
                                    ),
                                  ),
                                  if (unreadCount > 0)
                                    const Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GzLiveDot(
                                        size: 6,
                                        color: AppColors.err,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 36,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _filters.length,
                              separatorBuilder: (_, index) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, i) => GzChip(
                                label: _filters[i],
                                active: _filterIndex == i,
                                onTap: () => setState(() => _filterIndex = i),
                              ),
                            ),
                          ),
                          if (showActive) ...[
                            const SizedBox(height: 20),
                            _ActiveSessionBanner(
                              activeSession: data.activeSession!,
                            ),
                          ],
                          if (visibleUpcoming.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text('Upcoming', style: AppTypography.h2),
                            const SizedBox(height: 12),
                            for (final booking in visibleUpcoming) ...[
                              _UpcomingItem(
                                system: booking.system,
                                date: booking.date,
                                time: booking.time,
                                tag: GzTag(
                                  kind: _tagKindForStatus(booking.status),
                                  label: _labelForStatus(booking.status),
                                ),
                                actionLabel:
                                    booking.status == SessionUiStatus.unpaid
                                    ? 'Pay'
                                    : 'Check in',
                                onAction: () =>
                                    booking.status == SessionUiStatus.unpaid
                                    ? context.push(
                                        AppRoutes.paymentSheetPath(booking.id),
                                      )
                                    : context.push(
                                        AppRoutes.checkInPath(booking.id),
                                      ),
                              ),
                              if (booking != visibleUpcoming.last)
                                const SizedBox(height: 10),
                            ],
                          ],
                          if (visiblePast.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text('Past sessions', style: AppTypography.h2),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (filterEmpty && filter != 'All')
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _TabEmptyState(filter: filter),
                    )
                  else
                    SliverList(
                      delegate: SliverChildListDelegate([
                        for (final session in visiblePast)
                          _PastSessionRow(
                            store: session.store,
                            system: session.system,
                            date: session.date,
                            duration: session.duration,
                            amount: session.amount,
                            onTap: () => context.push(
                              AppRoutes.sessionHistoryDetailPath(session.id),
                            ),
                          ),
                        const SizedBox(height: 24),
                      ]),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActiveSessionBanner extends StatelessWidget {
  const _ActiveSessionBanner({required this.activeSession});

  final SessionHubActiveState activeSession;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.activeSessionDetailPath(activeSession.sessionId),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceTint,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        child: Row(
          children: [
            const GzLiveDot(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${activeSession.systemName} · Live',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activeSession.remainingLabel,
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  'View',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: AppColors.textPrimary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TabEmptyState extends StatelessWidget {
  const _TabEmptyState({required this.filter});

  final String filter;

  List<List<dynamic>> get _icon => switch (filter) {
    'Active' => HugeIcons.strokeRoundedGameController01,
    'Upcoming' => HugeIcons.strokeRoundedCalendar02,
    'Past' => HugeIcons.strokeRoundedTime04,
    _ => HugeIcons.strokeRoundedInbox,
  };

  String get _title => switch (filter) {
    'Active' => 'No active sessions',
    'Upcoming' => 'No upcoming bookings',
    'Past' => 'No session history',
    _ => 'Nothing here',
  };

  String get _subtitle => switch (filter) {
    'Active' => 'Start a session at your favourite store to see it here.',
    'Upcoming' => 'Book a session and it will appear here.',
    'Past' => 'Your completed sessions will show up here.',
    _ => 'Switch to a different tab to see your sessions.',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: HugeIcon(
              icon: _icon,
              color: AppColors.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(_title, style: AppTypography.h2, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(
            _subtitle,
            style: AppTypography.bodyR.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

GzTagKind _tagKindForStatus(SessionUiStatus status) => switch (status) {
  SessionUiStatus.confirmed => GzTagKind.ok,
  SessionUiStatus.unpaid => GzTagKind.warn,
  SessionUiStatus.checkedIn => GzTagKind.info,
  SessionUiStatus.active => GzTagKind.ok,
  SessionUiStatus.completed => GzTagKind.info,
};

String _labelForStatus(SessionUiStatus status) => switch (status) {
  SessionUiStatus.confirmed => 'Confirmed',
  SessionUiStatus.unpaid => 'Unpaid',
  SessionUiStatus.checkedIn => 'Checked in',
  SessionUiStatus.active => 'Active',
  SessionUiStatus.completed => 'Completed',
};

class _UpcomingItem extends StatelessWidget {
  const _UpcomingItem({
    required this.system,
    required this.date,
    required this.time,
    required this.tag,
    required this.actionLabel,
    required this.onAction,
  });

  final String system;
  final String date;
  final String time;
  final Widget tag;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(system, style: AppTypography.h3),
                    const SizedBox(height: 3),
                    Text(
                      '$date · $time',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              tag,
            ],
          ),
          const SizedBox(height: 12),
          GzButton(
            label: actionLabel,
            small: true,
            variant: GzButtonVariant.ghost,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}

class _PastSessionRow extends StatelessWidget {
  const _PastSessionRow({
    required this.store,
    required this.system,
    required this.date,
    required this.duration,
    required this.amount,
    required this.onTap,
  });

  final String store;
  final String system;
  final String date;
  final String duration;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store, style: AppTypography.h3),
                  const SizedBox(height: 3),
                  Text(
                    '$system · $date',
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  duration,
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
