import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/features/sessions/presentation/providers/activity_hub_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('activityHubProvider can be read before async fetch completes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(() => container.read(activityHubProvider), returnsNormally);
  });
}
