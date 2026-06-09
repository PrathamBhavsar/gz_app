import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/core/api/api_client.dart';
import 'package:gz_app/core/auth/token_storage.dart';
import 'package:gz_app/core/network/connectivity_service.dart';
import 'package:gz_app/core/network/network_checker.dart';
import 'package:gz_app/features/sessions/application/activity_hub_notifier.dart';
import 'package:gz_app/features/sessions/data/repositories/billing_repository.dart';
import 'package:gz_app/features/sessions/data/repositories/bookings_repository.dart';
import 'package:gz_app/features/sessions/data/repositories/sessions_repository.dart';
import 'package:gz_app/models/api_responses.dart';
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

class _FakeSessionsRepository extends SessionsRepository {
  _FakeSessionsRepository(this.sessions, Ref ref)
      : super(_DummyApiClient(), NetworkChecker(_FakeConnectivityService()), ref);

  final List<SessionModel> sessions;

  @override
  Future<List<SessionModel>> fetchMySessions() async => sessions;
}

class _FakeBookingsRepository extends BookingsRepository {
  _FakeBookingsRepository(this.bookings, Ref ref)
      : super(_DummyApiClient(), NetworkChecker(_FakeConnectivityService()), ref);

  final List<BookingModel> bookings;

  @override
  Future<List<BookingModel>> fetchMyBookings() async => bookings;
}

class _FakeBillingRepository extends BillingRepository {
  _FakeBillingRepository(this.rows, Ref ref)
      : super(_DummyApiClient(), NetworkChecker(_FakeConnectivityService()), ref);

  final List<BillingRow> rows;

  @override
  Future<List<BillingRow>> fetchBillingHistory({int page = 1, int limit = 50}) async => rows;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hub splits active upcoming and past records', () async {
    final now = DateTime.now();
    final container = ProviderContainer(
      overrides: [
        sessionsRepositoryProvider.overrideWith(
          (ref) => _FakeSessionsRepository([
            SessionModel(
              id: 'sess-live',
              status: SessionStatus.inProgress,
              startedAt: now.subtract(const Duration(minutes: 30)),
              durationMinutes: 120,
              metadata: const {'systemName': 'PC Station 03'},
            ),
            SessionModel(
              id: 'sess-old',
              status: SessionStatus.completed,
              startedAt: now.subtract(const Duration(days: 1, hours: 2)),
              endedAt: now.subtract(const Duration(days: 1)),
              metadata: const {'systemName': 'PS5 Console'},
            ),
          ], ref),
        ),
        bookingsRepositoryProvider.overrideWith(
          (ref) => _FakeBookingsRepository([
            BookingModel(
              id: 'book-1',
              status: BookingStatus.pending,
              isPaid: false,
              scheduledStart: now.add(const Duration(hours: 2)),
              scheduledEnd: now.add(const Duration(hours: 4)),
              metadata: const {'systemName': 'Xbox Series X'},
            ),
          ], ref),
        ),
        billingRepositoryProvider.overrideWith(
          (ref) => _FakeBillingRepository([
            BillingRow(
              id: 'bill-1',
              storeId: 'store-1',
              sessionId: 'sess-old',
              storeName: 'GameZone Koramangala',
              systemName: 'PS5 Console',
              date: now.subtract(const Duration(days: 1)),
              durationMinutes: 120,
              amount: 240,
              status: 'paid',
            ),
          ], ref),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.read(activeStoreIdProvider.notifier).state = 'store-1';

    final state = await container.read(activityHubNotifierProvider.future);

    expect(state.activeSession?.sessionId, 'sess-live');
    expect(state.activeSession?.elapsedProgress, greaterThan(0));
    expect(state.upcoming, hasLength(1));
    expect(state.upcoming.first.status.name, 'unpaid');
    expect(state.past, hasLength(1));
    expect(state.past.first.store, 'GameZone Koramangala');
  });
}
