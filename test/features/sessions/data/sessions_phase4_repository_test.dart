import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/core/api/api_client.dart';
import 'package:gz_app/core/api/api_constants.dart';
import 'package:gz_app/core/auth/token_storage.dart';
import 'package:gz_app/core/errors/app_exception.dart';
import 'package:gz_app/core/network/connectivity_service.dart';
import 'package:gz_app/core/network/network_checker.dart';
import 'package:gz_app/features/sessions/data/repositories/bookings_repository.dart';
import 'package:gz_app/features/sessions/data/repositories/sessions_repository.dart';
import 'package:gz_app/models/enums.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient(this.responses) : super(baseUrl: 'http://example.test');

  final Map<String, dynamic> responses;
  final List<String> requestedGetPaths = <String>[];
  final List<Map<String, dynamic>> requestedPosts = <Map<String, dynamic>>[];

  @override
  Future<dynamic> get(String endpoint) async {
    requestedGetPaths.add(endpoint);
    return responses[endpoint] ?? <String, dynamic>{};
  }

  @override
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    requestedPosts.add({
      'endpoint': endpoint,
      'body': body,
    });
    return responses[endpoint] ?? <String, dynamic>{};
  }
}

class _FakeConnectivityService extends ConnectivityService {
  _FakeConnectivityService(this._connected);

  final bool _connected;

  @override
  Future<bool> checkNow() async => _connected;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 4 repositories', () {
    test('sessions repository requires active store id', () async {
      final api = _FakeApiClient(<String, dynamic>{});
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(api),
          networkCheckerProvider.overrideWithValue(
            NetworkChecker(_FakeConnectivityService(true)),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(sessionsRepositoryProvider);

      await expectLater(
        () => repo.fetchMySessions(),
        throwsA(isA<ValidationException>()),
      );
    });

    test('bookings repository interpolates pay endpoint and body', () async {
      final api = _FakeApiClient({
        '/stores/store-1/bookings/book-1/pay': {
          'data': {
            'id': 'payment-1',
            'store_id': 'store-1',
            'billing_id': 'bill-1',
            'user_id': 'user-1',
            'amount': 160,
            'method': 'cash',
            'status': 'paid',
          },
        },
      });
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(api),
          networkCheckerProvider.overrideWithValue(
            NetworkChecker(_FakeConnectivityService(true)),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.read(activeStoreIdProvider.notifier).state = 'store-1';

      final repo = container.read(bookingsRepositoryProvider);
      final payment = await repo.payBooking(
        bookingId: 'book-1',
        paymentMethod: PaymentMethod.cash,
        idempotencyKey: 'idem-1',
      );

      expect(payment.id, 'payment-1');
      expect(
        api.requestedPosts.single['endpoint'],
        '/stores/store-1/bookings/book-1/pay',
      );
      expect(
        api.requestedPosts.single['body'],
        {'paymentMethod': 'cash', 'idempotencyKey': 'idem-1'},
      );
    });

    test('sessions repository interpolates logs endpoint', () async {
      final logsPath =
          ApiConstants.sessionLogs.replaceAll('{storeId}', 'store-1').replaceAll('{id}', 'sess-1');
      final api = _FakeApiClient({
        logsPath: {
          'data': [
            {
              'id': 'log-1',
              'store_id': 'store-1',
              'session_id': 'sess-1',
              'event_type': 'session.started',
            },
          ],
        },
      });
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(api),
          networkCheckerProvider.overrideWithValue(
            NetworkChecker(_FakeConnectivityService(true)),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.read(activeStoreIdProvider.notifier).state = 'store-1';

      final repo = container.read(sessionsRepositoryProvider);
      final logs = await repo.fetchSessionLogs('sess-1');

      expect(logs, hasLength(1));
      expect(api.requestedGetPaths.single, logsPath);
    });
  });
}
