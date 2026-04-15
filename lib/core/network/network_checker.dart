import 'connectivity_service.dart';
import '../errors/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkChecker {
  const NetworkChecker(this._service);

  final ConnectivityService _service;

  /// Returns true if internet is actually reachable right now.
  Future<bool> hasConnection() => _service.checkNow();

  /// Throws [NetworkException] if offline. Call before any API call.
  Future<void> assertConnection() async {
    final connected = await hasConnection();
    if (!connected) throw const NetworkException();
  }
}

final networkCheckerProvider = Provider<NetworkChecker>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return NetworkChecker(service);
});
