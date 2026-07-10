import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gz_app/core/api/api_client.dart';
import 'package:gz_app/core/auth/token_storage.dart';
import 'package:gz_app/core/errors/app_exception.dart';
import 'package:gz_app/core/network/connectivity_service.dart';
import 'package:gz_app/core/network/network_checker.dart';
import 'package:gz_app/features/auth/application/admin_auth_notifier.dart';
import 'package:gz_app/features/auth/data/repositories/admin_auth_repository.dart';
import 'package:gz_app/models/domain_admin.dart';

void main() {
  group('AdminAuthNotifier.logout', () {
    test(
      'does not start a second logout while one is already in flight',
      () async {
        final logoutCompleter = Completer<void>();
        late final _FakeAdminAuthRepository repository;
        final container = ProviderContainer(
          overrides: [
            adminAuthRepositoryProvider.overrideWith((ref) {
              repository = _FakeAdminAuthRepository(
                ref: ref,
                logoutCompleter: logoutCompleter,
              );
              return repository;
            }),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(adminAuthNotifierProvider.notifier);
        notifier.state = const AdminAuthAuthenticated(
          AdminAuthModel(id: 'admin-1'),
        );

        final firstLogout = notifier.logout();
        await Future<void>.delayed(Duration.zero);
        await notifier.logout();

        expect(repository.logoutCalls, 1);

        logoutCompleter.complete();
        await firstLogout;

        expect(
          container.read(adminAuthNotifierProvider),
          isA<AdminAuthUnauthenticated>(),
        );
      },
    );

    test('does nothing once the admin is already unauthenticated', () async {
      var repositoryBuilt = false;
      final container = ProviderContainer(
        overrides: [
          adminAuthRepositoryProvider.overrideWith((ref) {
            repositoryBuilt = true;
            return _FakeAdminAuthRepository(ref: ref);
          }),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(adminAuthNotifierProvider.notifier);
      notifier.state = const AdminAuthUnauthenticated();

      await notifier.logout();

      expect(repositoryBuilt, isFalse);
    });
  });

  group('AdminAuthRepository.logout', () {
    test('treats unauthorized logout as already logged out', () async {
      final api = _FakeApiClient(
        logoutError: const UnauthorizedException('Session expired'),
      );
      final storage = _FakeTokenStorage()..refreshToken = 'refresh-1';
      final container = ProviderContainer(
        overrides: [
          _adminAuthRepositoryUnderTest.overrideWith((ref) {
            return AdminAuthRepository(
              api,
              _FakeNetworkChecker(),
              storage,
              ref,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      await container.read(_adminAuthRepositoryUnderTest).logout();

      expect(api.logoutCalls, 1);
      expect(storage.cleared, isTrue);
      expect(container.read(accessTokenProvider), isNull);
    });
  });
}

final _adminAuthRepositoryUnderTest = Provider<AdminAuthRepository>((ref) {
  throw UnimplementedError('override in tests');
});

class _FakeAdminAuthRepository extends AdminAuthRepository {
  _FakeAdminAuthRepository({required Ref ref, this.logoutCompleter})
    : super(
        ApiClient(baseUrl: 'http://localhost'),
        _FakeNetworkChecker(),
        _FakeTokenStorage(),
        ref,
      );

  final Completer<void>? logoutCompleter;
  int logoutCalls = 0;

  @override
  Future<void> logout() async {
    logoutCalls += 1;
    if (logoutCompleter != null) {
      await logoutCompleter!.future;
    }
  }
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient({this.logoutError}) : super(baseUrl: 'http://localhost');

  final Object? logoutError;
  int logoutCalls = 0;

  @override
  Future<void> adminLogout({
    String? refreshToken,
    bool allDevices = false,
  }) async {
    logoutCalls += 1;
    if (logoutError != null) {
      throw logoutError!;
    }
  }
}

class _FakeNetworkChecker extends NetworkChecker {
  _FakeNetworkChecker() : super(_FakeConnectivityService());

  @override
  Future<bool> hasConnection() async => true;

  @override
  Future<void> assertConnection() async {}
}

class _FakeConnectivityService implements ConnectivityService {
  @override
  bool get isConnected => true;

  @override
  Stream<bool> get onConnectivityChanged => const Stream<bool>.empty();

  @override
  Future<bool> checkNow() async => true;

  @override
  void dispose() {}
}

class _FakeTokenStorage extends TokenStorage {
  _FakeTokenStorage() : super(const FlutterSecureStorage());

  String? refreshToken;
  bool cleared = false;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> clearAll() async {
    cleared = true;
    refreshToken = null;
  }
}
