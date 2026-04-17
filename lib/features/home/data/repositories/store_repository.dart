import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/store_service.dart';
import '../../../../models/api_responses.dart';

class StoreRepository {
  final StoreService _storeService;
  final NetworkChecker _networkChecker;

  StoreRepository(this._storeService, this._networkChecker);

  Future<PaginatedStoresResponse> fetchStores({
    String? search,
    String? platform,
    bool? isOpen,
    int? page,
    int? limit,
  }) async {
    await _networkChecker.assertConnection();
    return await _storeService.getStores(
      search: search,
      platform: platform,
      isOpen: isOpen,
      page: page ?? 1,
      limit: limit ?? 20,
    );
  }

  Future<StoreResponse> fetchStoreDetails(String slug) async {
    await _networkChecker.assertConnection();
    return await _storeService.getStore(slug);
  }

  Future<PaginatedCampaignsResponse> fetchActiveCampaigns(
    String storeId,
  ) async {
    await _networkChecker.assertConnection();
    return await _storeService.getActiveCampaigns(storeId);
  }

  Future<SystemsListResponse> fetchAvailableSystems(
    String storeId, {
    String? systemTypeId,
    String? startTime,
    String? endTime,
  }) async {
    await _networkChecker.assertConnection();
    return await _storeService.getAvailableSystems(
      storeId,
      systemTypeId: systemTypeId,
      startTime: startTime,
      endTime: endTime,
    );
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final storeService = ref.watch(storeServiceProvider);
  final networkChecker = ref.watch(networkCheckerProvider);
  return StoreRepository(storeService, networkChecker);
});
