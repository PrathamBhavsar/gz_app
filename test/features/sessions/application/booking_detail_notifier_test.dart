import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gz_app/core/api/api_client.dart';
import 'package:gz_app/core/network/connectivity_service.dart';
import 'package:gz_app/core/network/network_checker.dart';
import 'package:gz_app/features/sessions/application/booking_detail_notifier.dart';
import 'package:gz_app/features/sessions/application/session_ui_models.dart';
import 'package:gz_app/features/sessions/data/repositories/bookings_repository.dart';
import 'package:gz_app/models/domain_systems.dart';
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
  _FakeBookingsRepository(this.booking, Ref ref)
      : super(
          _DummyApiClient(),
          NetworkChecker(_FakeConnectivityService()),
          ref,
        );

  final BookingModel booking;

  @override
  Future<BookingModel> fetchBookingDetail(String bookingId) async => booking;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('booking detail maps unpaid booking to pay action', () async {
    final booking = BookingModel(
      id: 'book-1',
      status: BookingStatus.pending,
      isPaid: false,
      systemId: 'sys-1',
      scheduledStart: DateTime(2026, 6, 10, 18),
      scheduledEnd: DateTime(2026, 6, 10, 20),
      amount: 220,
      metadata: const {
        'systemName': 'PS5 Console',
        'seatName': 'Bay 2',
        'storeName': 'GameZone Koramangala',
      },
    );

    final container = ProviderContainer(
      overrides: [
        bookingsRepositoryProvider.overrideWith(
          (ref) => _FakeBookingsRepository(booking, ref),
        ),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(
      bookingDetailNotifierProvider('book-1').future,
    );

    expect(state.status, SessionUiStatus.unpaid);
    expect(state.paymentStatus, 'Unpaid');
    expect(state.primaryActionLabel, 'Pay now');
    expect(state.system, 'PS5 Console');
  });
}
