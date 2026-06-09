import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/core/api/api_client.dart';
import 'package:gz_app/core/network/connectivity_service.dart';
import 'package:gz_app/core/network/network_checker.dart';
import 'package:gz_app/features/sessions/application/booking_detail_notifier.dart';
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
  _FakeBookingsRepository(Ref ref)
      : super(_DummyApiClient(), NetworkChecker(_FakeConnectivityService()), ref);

  @override
  Future<BookingModel> fetchBookingDetail(String bookingId) async {
    return BookingModel(
      id: bookingId,
      status: BookingStatus.confirmed,
      isPaid: true,
      scheduledStart: DateTime.now(),
      scheduledEnd: DateTime.now().add(const Duration(hours: 2)),
      metadata: const {
        'systemName': 'PC Station 03',
        'seatName': 'Seat 3',
        'storeName': 'GameZone Koramangala',
      },
    );
  }

  @override
  Future<BookingModel> checkInBooking(String bookingId) async {
    return BookingModel(
      id: bookingId,
      status: BookingStatus.checkedIn,
      isPaid: true,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('booking command notifier reports success after check-in', () async {
    final container = ProviderContainer(
      overrides: [
        bookingsRepositoryProvider.overrideWith((ref) => _FakeBookingsRepository(ref)),
      ],
    );
    addTearDown(container.dispose);

    await container.read(bookingDetailNotifierProvider('book-1').future);
    final notifier = container.read(bookingCommandNotifierProvider('book-1').notifier);
    await notifier.checkIn();

    final state = container.read(bookingCommandNotifierProvider('book-1'));
    expect(state, isA<BookingCommandSuccess>());
    expect((state as BookingCommandSuccess).message, 'Checked in successfully');
  });
}
