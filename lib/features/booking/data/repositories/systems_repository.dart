import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/systems_service.dart';
import '../../../../models/api_responses.dart';

class SystemsRepository {
  final SystemsService _service;
  final NetworkChecker _networkChecker;

  SystemsRepository(this._service, this._networkChecker);

  Future<SystemsListResponse> fetchAvailableSystems(String storeId) async {
    await _networkChecker.assertConnection();
    return _service.getAvailableSystems(storeId);
  }
}

final systemsRepositoryProvider = Provider<SystemsRepository>((ref) {
  return SystemsRepository(
    ref.watch(systemsServiceProvider),
    ref.watch(networkCheckerProvider),
  );
});
