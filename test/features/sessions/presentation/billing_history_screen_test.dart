import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/core/theme/app_theme.dart';
import 'package:gz_app/features/sessions/application/billing_notifier.dart';
import 'package:gz_app/features/sessions/presentation/screens/billing_history_screen.dart';
import 'package:gz_app/models/api_responses.dart';
import 'package:gz_app/shared/widgets/gz_loading_view.dart';
import 'package:gz_app/shared/widgets/page_error_display.dart';

class _LoadingBillingNotifier extends BillingNotifier {
  @override
  Future<List<BillingRow>> build() async {
    return Completer<List<BillingRow>>().future;
  }
}

class _DataBillingNotifier extends BillingNotifier {
  _DataBillingNotifier(this.result);

  final List<BillingRow> result;

  @override
  Future<List<BillingRow>> build() async => result;
}

Widget _wrap(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.light,
      home: const BillingHistoryScreen(),
    ),
  );
}

void main() {
  testWidgets('shows loading state', (tester) async {
    await tester.pumpWidget(
      _wrap([
        billingNotifierProvider.overrideWith(() => _LoadingBillingNotifier()),
      ]),
    );

    expect(find.byType(GzLoadingView), findsOneWidget);
  });

  testWidgets('shows empty state for no billing rows', (tester) async {
    await tester.pumpWidget(
      _wrap([
        billingNotifierProvider.overrideWith(() => _DataBillingNotifier(const [])),
      ]),
    );
    await tester.pump();

    expect(find.byType(PageErrorDisplay), findsOneWidget);
    expect(find.text('No billing records'), findsOneWidget);
  });

  testWidgets('renders billing data rows', (tester) async {
    await tester.pumpWidget(
      _wrap([
        billingNotifierProvider.overrideWith(
          () => _DataBillingNotifier([
            BillingRow(
              id: 'bill-1',
              storeId: 'store-1',
              storeName: 'GameZone Koramangala',
              systemName: 'PC Station 03',
              date: DateTime(2026, 6, 10),
              durationMinutes: 120,
              amount: 160,
              method: 'cash',
              status: 'paid',
            ),
          ]),
        ),
      ]),
    );
    await tester.pump();

    expect(find.text('GameZone Koramangala'), findsOneWidget);
    expect(find.text('₹160'), findsOneWidget);
    expect(find.text('Paid'), findsAtLeastNWidgets(1));
  });
}
