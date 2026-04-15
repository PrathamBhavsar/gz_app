import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import 'store_service.dart';
import '../../../../models/api_responses.dart';
import '../../../auth/data/services/auth_service.dart'; // import the global provider

class StoreRepository {
  final StoreService _storeService;
  final NetworkChecker _networkChecker;

  StoreRepository(this._storeService, this._networkChecker);

  Future<PaginatedStoresResponse> fetchStores({String? search}) async {
    await _networkChecker.assertConnection();
    return await _storeService.getStores(query: search);
  }

  Future<StoreResponse> fetchStoreDetails(String slug) async {
    await _networkChecker.assertConnection();
    return await _storeService.getStore(slug);
  }

  Future<PaginatedCampaignsResponse> fetchActiveCampaigns(String storeId) async {
    await _networkChecker.assertConnection();
    return await _storeService.getActiveCampaigns(storeId);
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  // reusing the apiClientProvider from auth for now
  final apiClient = ref.watch(apiClientProvider);
  final storeService = StoreService(apiClient);
  final networkChecker = ref.watch(networkCheckerProvider);
  return StoreRepository(storeService, networkChecker);
});
