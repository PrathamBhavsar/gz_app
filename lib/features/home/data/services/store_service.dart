import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_global.dart';

class StoreService {
  final ApiClient _apiClient;

  StoreService(this._apiClient);

  Future<PaginatedStoresResponse> getStores({String? query}) async {
    // TODO: Implement GET /stores using _apiClient
    await Future.delayed(const Duration(milliseconds: 600));

    final mockStores = [
      StoreModel(
        id: '1',
        name: 'Nexus Gaming Center',
        slug: 'nexus-gaming',
        address: '123 Gamer Street',
        city: 'Metropolis',
        isActive: true,
        settings: {'rating': 4.8, 'systemCount': 40, 'openNow': true},
      ),
      StoreModel(
        id: '2',
        name: 'Pixel Lounge',
        slug: 'pixel-lounge',
        address: '456 Retro Avenue',
        city: 'Metropolis',
        isActive: true,
        settings: {'rating': 4.5, 'systemCount': 25, 'openNow': true},
      ),
    ];

    if (query != null && query.isNotEmpty) {
      final filtered = mockStores
          .where((s) => s.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return PaginatedStoresResponse(data: filtered);
    }

    return PaginatedStoresResponse(data: mockStores);
  }

  Future<StoreResponse> getStore(String slug) async {
    // TODO: Implement GET /stores/:slug using _apiClient
    await Future.delayed(const Duration(milliseconds: 300));
    return StoreResponse(
      data: StoreModel(
        id: '1',
        name: 'Nexus Gaming Center',
        slug: slug,
        address: '123 Gamer Street',
        city: 'Metropolis',
        isActive: true,
        settings: {'rating': 4.8, 'systemCount': 40, 'openNow': true},
      ),
    );
  }

  Future<PaginatedCampaignsResponse> getActiveCampaigns(String storeId) async {
    // TODO: Implement GET /stores/:storeId/campaigns/active using _apiClient
    await Future.delayed(const Duration(milliseconds: 400));
    return const PaginatedCampaignsResponse(data: []);
  }
}

final storeServiceProvider = Provider<StoreService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StoreService(apiClient);
});
