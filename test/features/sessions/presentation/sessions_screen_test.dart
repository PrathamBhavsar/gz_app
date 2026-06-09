import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/core/theme/app_theme.dart';
import 'package:gz_app/features/notifications/presentation/providers/notification_feed_notifier.dart';
import 'package:gz_app/features/sessions/application/activity_hub_notifier.dart';
import 'package:gz_app/features/sessions/application/session_ui_models.dart';
import 'package:gz_app/features/sessions/presentation/screens/sessions_screen.dart';
import 'package:gz_app/shared/widgets/gz_loading_view.dart';
import 'package:gz_app/shared/widgets/page_error_display.dart';

class _LoadingHubNotifier extends ActivityHubNotifier {
  @override
  Future<SessionsHubState> build() async {
    return Completer<SessionsHubState>().future;
  }
}

class _DataHubNotifier extends ActivityHubNotifier {
  _DataHubNotifier(this.result);

  final SessionsHubState result;

  @override
  Future<SessionsHubState> build() async => result;
}

Widget _wrap(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.light,
      home: const SessionsScreen(),
    ),
  );
}

void main() {
  testWidgets('shows loading state', (tester) async {
    await tester.pumpWidget(
      _wrap([
        unreadNotificationCountProvider.overrideWithValue(0),
        activityHubNotifierProvider.overrideWith(() => _LoadingHubNotifier()),
      ]),
    );

    expect(find.byType(GzLoadingView), findsOneWidget);
  });

  testWidgets('shows empty state when no session data exists', (tester) async {
    await tester.pumpWidget(
      _wrap([
        unreadNotificationCountProvider.overrideWithValue(0),
        activityHubNotifierProvider.overrideWith(
          () => _DataHubNotifier(
            const SessionsHubState(
              activeSession: null,
              upcoming: [],
              past: [],
            ),
          ),
        ),
      ]),
    );
    await tester.pump();

    expect(find.byType(PageErrorDisplay), findsOneWidget);
    expect(find.text('No sessions yet'), findsOneWidget);
  });

  testWidgets('renders active upcoming and past data', (tester) async {
    await tester.pumpWidget(
      _wrap([
        unreadNotificationCountProvider.overrideWithValue(0),
        activityHubNotifierProvider.overrideWith(
          () => _DataHubNotifier(
            const SessionsHubState(
              activeSession: SessionHubActiveState(
                sessionId: 'sess-1',
                systemName: 'PC Station 03',
                remainingLabel: '01:22:38 remaining',
                elapsedProgress: 0.5,
              ),
              upcoming: [
                UpcomingBookingState(
                  id: 'book-1',
                  system: 'PS5 Console',
                  date: 'Wed 10 Jun',
                  time: '6:00 PM - 8:00 PM',
                  status: SessionUiStatus.unpaid,
                ),
              ],
              past: [
                PastSessionState(
                  id: 'sess-2',
                  store: 'GameZone Koramangala',
                  system: 'PC Station 03',
                  date: 'Tue 9 Jun',
                  duration: '2h 00m',
                  amount: '₹160',
                ),
              ],
            ),
          ),
        ),
      ]),
    );
    await tester.pump();

    expect(find.text('PC Station 03 · Live'), findsOneWidget);
    expect(find.text('PS5 Console'), findsOneWidget);
    expect(find.text('GameZone Koramangala'), findsOneWidget);
  });
}
