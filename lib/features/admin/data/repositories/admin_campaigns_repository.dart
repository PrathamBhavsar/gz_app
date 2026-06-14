import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_loyalty.dart';
import 'admin_store_repository_support.dart';

class AdminCampaignsRepository {
  AdminCampaignsRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<List<CampaignModel>> fetchCampaigns() async {
    await _net.assertConnection();
    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.campaignsAdminList),
    );
    final map = adminStoreAsMap(raw, responseName: 'campaigns');
    return adminStoreExtractList(map, dataKeys: const ['campaigns', 'items'])
        .map((e) => CampaignModel.fromJson(adminStoreAsMap(e, responseName: 'campaign')))
        .toList(growable: false);
  }

  Future<List<CampaignRedemptionModel>> fetchRedemptions(String id) async {
    await _net.assertConnection();
    final raw = await _api.get(
      await adminStorePath(_storage, ApiConstants.campaignRedemptions, id: id),
    );
    final map = adminStoreAsMap(raw, responseName: 'campaign redemptions');
    return adminStoreExtractList(
          map,
          dataKeys: const ['redemptions', 'items'],
        )
        .map(
          (e) => CampaignRedemptionModel.fromJson(
            adminStoreAsMap(e, responseName: 'redemption'),
          ),
        )
        .toList(growable: false);
  }

  Future<CampaignModel> createCampaign(Map<String, dynamic> body) async {
    await _net.assertConnection();
    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.campaignsAdminList),
      body: body,
    );
    final map = adminStoreAsMap(raw, responseName: 'create campaign');
    return CampaignResponse.fromJson(map).data ??
        _parseCampaignFromData(map);
  }

  Future<CampaignModel> updateCampaign(
    String id,
    Map<String, dynamic> body,
  ) async {
    await _net.assertConnection();
    final raw = await _api.patch(
      await adminStorePath(_storage, ApiConstants.campaignDetail, id: id),
      body: body,
    );
    final map = adminStoreAsMap(raw, responseName: 'update campaign');
    return CampaignResponse.fromJson(map).data ??
        _parseCampaignFromData(map);
  }

  Future<String> pauseCampaign(String id) async {
    await _net.assertConnection();
    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.campaignPause, id: id),
    );
    final map = adminStoreAsMap(raw, responseName: 'pause campaign');
    return map['message']?.toString() ?? 'Campaign paused';
  }

  Future<String> resumeCampaign(String id) async {
    await _net.assertConnection();
    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.campaignResume, id: id),
    );
    final map = adminStoreAsMap(raw, responseName: 'resume campaign');
    return map['message']?.toString() ?? 'Campaign resumed';
  }

  CampaignModel _parseCampaignFromData(Map<String, dynamic> map) {
    final data = map['data'];
    if (data is Map<String, dynamic>) return CampaignModel.fromJson(data);
    if (data is Map) {
      return CampaignModel.fromJson(
        data.map((k, v) => MapEntry(k.toString(), v)),
      );
    }
    return CampaignModel.fromJson(map);
  }
}

final adminCampaignsRepositoryProvider =
    Provider<AdminCampaignsRepository>((ref) {
  return AdminCampaignsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
