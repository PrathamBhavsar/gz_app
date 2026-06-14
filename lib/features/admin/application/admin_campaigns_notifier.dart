import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_campaigns_repository.dart';
import '../data/repositories/system_types_repository.dart';
import 'admin_management_models.dart';

class AdminCampaignsNotifier extends AsyncNotifier<AdminCampaignData> {
  String _selectedFilter = 'All';

  @override
  Future<AdminCampaignData> build() => _load();

  Future<void> selectFilter(String value) async {
    _selectedFilter = value;
    final current = state.valueOrNull;
    if (current == null) {
      await refresh();
      return;
    }
    state = AsyncData(
      AdminCampaignData(
        campaigns: current.campaigns,
        systemTypes: current.systemTypes,
        selectedFilter: value,
        loadedAt: current.loadedAt,
      ),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AdminCampaignData> _load() async {
    final campaignsRepo = ref.read(adminCampaignsRepositoryProvider);
    final typesRepo = ref.read(systemTypesRepositoryProvider);
    final campaigns = await campaignsRepo.fetchCampaigns();
    final systemTypes = await typesRepo.fetchSystemTypes();
    return AdminCampaignData(
      campaigns: campaigns,
      systemTypes: systemTypes,
      selectedFilter: _selectedFilter,
      loadedAt: DateTime.now(),
    );
  }
}

final adminCampaignsNotifierProvider =
    AsyncNotifierProvider<AdminCampaignsNotifier, AdminCampaignData>(
      AdminCampaignsNotifier.new,
    );
