import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/enums.dart';
import '../../data/repositories/wallet_repository.dart';

class CampaignsState {
  final AsyncValue<List<CampaignModel>> data;
  final CampaignType? selectedFilter;

  const CampaignsState({
    this.data = const AsyncLoading(),
    this.selectedFilter,
  });

  CampaignsState copyWith({
    AsyncValue<List<CampaignModel>>? data,
    Object? selectedFilter = _sentinel,
  }) => CampaignsState(
    data: data ?? this.data,
    selectedFilter: selectedFilter == _sentinel ? this.selectedFilter : selectedFilter as CampaignType?,
  );

  List<CampaignModel> get filtered {
    final all = data.asData?.value ?? [];
    if (selectedFilter == null) return all;
    return all.where((c) => c.campaignType == selectedFilter).toList();
  }

  static const Object _sentinel = Object();
}

class CampaignsNotifier extends Notifier<CampaignsState> {
  @override
  CampaignsState build() {
    final storeId = ref.watch(activeStoreIdProvider);
    if (storeId != null) {
      Future.microtask(() => _fetch(storeId));
    }
    return const CampaignsState();
  }

  Future<void> _fetch(String storeId) async {
    state = state.copyWith(data: const AsyncLoading());
    try {
      final campaigns = await ref.read(walletRepositoryProvider).fetchCampaigns(storeId);
      state = state.copyWith(data: AsyncData(campaigns));
    } catch (e, st) {
      state = state.copyWith(data: AsyncError(e, st));
    }
  }

  void setFilter(CampaignType? filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  Future<void> refresh() async {
    final storeId = ref.read(activeStoreIdProvider);
    if (storeId == null) return;
    await _fetch(storeId);
  }
}

final campaignsNotifierProvider =
    NotifierProvider<CampaignsNotifier, CampaignsState>(
  () => CampaignsNotifier(),
);
