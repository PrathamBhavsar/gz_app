import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/features/home/presentation/providers/home_notifier.dart';
import 'package:gz_app/features/home/presentation/widgets/home_mobile_layout.dart';
import 'package:gz_app/models/domain_global.dart';

class _HomeNotifierForTest extends HomeNotifier {
  @override
  AsyncValue<HomeData> build() {
    return const AsyncData(
      HomeData(
        stores: [
          StoreModel(
            id: 'store-1',
            name: 'Arena Prime',
            slug: 'arena-prime',
            city: 'Bengaluru',
            isActive: true,
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('home store cards fit within the mobile feed viewport', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 667));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeNotifierProvider.overrideWith(_HomeNotifierForTest.new),
        ],
        child: const MaterialApp(home: Scaffold(body: HomeMobileLayout())),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
