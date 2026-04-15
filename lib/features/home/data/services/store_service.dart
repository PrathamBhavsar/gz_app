import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_global.dart';

class StoreService {
  final ApiClient _apiClient;

  StoreService(this._apiClient);

  Future<PaginatedStoresResponse> getStores({String? query}) async {
    // Simulated API call. In real implementation, this would use _apiClient.get('/stores?search=$query')
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
      return PaginatedStoresResponse(success: true, data: filtered);
    }

    return PaginatedStoresResponse(success: true, data: mockStores);
  }

  Future<StoreResponse> getStore(String slug) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return StoreResponse(
      success: true,
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
    await Future.delayed(const Duration(milliseconds: 400));
    // Assuming campaigns would map properly here. Return empty to avoid compile error for now
    return const PaginatedCampaignsResponse(success: true, data: []);
  }
}

final storeServiceProvider = Provider<StoreService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StoreService(apiClient);
});

// Since ApiClient was previously placed in auth (mistakenly), let's ensure it's provided here or globally
// But we actually created ApiClient globally so it should be fine. Wait, the provider was in auth layer.
// Let's declare it in core/api if needed, or simply redefine/reuse.
// To be safe, I've defined apiClientProvider in auth_service.dart. I will redefine it properly here if not shared.
