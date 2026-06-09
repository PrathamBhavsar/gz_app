import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gz_app/core/api/api_client.dart';
import 'package:gz_app/core/network/connectivity_service.dart';
import 'package:gz_app/core/network/network_checker.dart';
import 'package:gz_app/features/sessions/application/payment_notifier.dart';
import 'package:gz_app/features/sessions/data/repositories/bookings_repository.dart';
import 'package:gz_app/models/domain_billing.dart';
import 'package:gz_app/models/enums.dart';

class _DummyApiClient extends ApiClient {
  _DummyApiClient() : super(baseUrl: 'http://example.test');
}

class _FakeConnectivityService extends ConnectivityService {
  _FakeConnectivityService();

  @override
  Future<bool> checkNow() async => true;
}

class _FakeBookingsRepository extends BookingsRepository {
  _FakeBookingsRepository(this.payment, Ref ref)
      : super(
          _DummyApiClient(),
          NetworkChecker(_FakeConnectivityService()),
          ref,
        );

  final PaymentModel payment;

  @override
  Future<PaymentModel> payBooking({
    required String bookingId,
    required PaymentMethod paymentMethod,
    required String idempotencyKey,
  }) async {
    return payment;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('payment notifier transitions to success after submit', () async {
    final container = ProviderContainer(
      overrides: [
        bookingsRepositoryProvider.overrideWith(
          (ref) => _FakeBookingsRepository(
            const PaymentModel(
              id: 'payment-1',
              amount: 160,
              method: PaymentMethod.cash,
              status: PaymentStatus.completed,
            ),
            ref,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(
      paymentNotifierProvider('book-1').notifier,
    );

    await notifier.submit(PaymentMethod.cash);

    final state = container.read(paymentNotifierProvider('book-1'));
    expect(state, isA<PaymentSuccess>());
    expect((state as PaymentSuccess).payment.id, 'payment-1');
  });
}
