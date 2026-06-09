import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_loyalty.dart';
import '../data/repositories/booking_repository.dart';
import 'booking_notifier.dart';

class BookingSummaryUiState {
  const BookingSummaryUiState({
    required this.campaigns,
    this.creditBalance,
    this.selectedCampaignId,
    this.creditsToRedeem = 0,
  });

  final List<CampaignModel> campaigns;
  final CreditBalanceModel? creditBalance;
  final String? selectedCampaignId;
  final int creditsToRedeem;

  CampaignModel? get selectedCampaign {
    final selectedId = selectedCampaignId;
    if (selectedId == null) {
      return null;
    }
    for (final campaign in campaigns) {
      if (campaign.id == selectedId) {
        return campaign;
      }
    }
    return null;
  }

  int get maxCreditsRedeemable {
    final available = creditBalance?.availableBalance ?? 0;
    return available.floor();
  }

  BookingSummaryUiState copyWith({
    List<CampaignModel>? campaigns,
    Object? creditBalance = _bookingSummaryUiUnset,
    Object? selectedCampaignId = _bookingSummaryUiUnset,
    int? creditsToRedeem,
  }) {
    return BookingSummaryUiState(
      campaigns: campaigns ?? this.campaigns,
      creditBalance: creditBalance == _bookingSummaryUiUnset
          ? this.creditBalance
          : creditBalance as CreditBalanceModel?,
      selectedCampaignId: selectedCampaignId == _bookingSummaryUiUnset
          ? this.selectedCampaignId
          : selectedCampaignId as String?,
      creditsToRedeem: creditsToRedeem ?? this.creditsToRedeem,
    );
  }
}

const _bookingSummaryUiUnset = Object();

class BookingSummaryUiNotifier extends AsyncNotifier<BookingSummaryUiState> {
  @override
  Future<BookingSummaryUiState> build() async {
    ref.watch(activeStoreIdProvider);
    ref.watch(
      bookingNotifierProvider.select((state) => state.selectedSystemTypeId),
    );
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  void selectCampaign(String? campaignId) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(selectedCampaignId: campaignId));
  }

  void setCreditsToRedeem(int value) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final clamped = value.clamp(0, current.maxCreditsRedeemable);
    state = AsyncData(current.copyWith(creditsToRedeem: clamped));
  }

  Future<BookingSummaryUiState> _load() async {
    final systemTypeId = ref.read(bookingNotifierProvider).selectedSystemTypeId;
    final repository = ref.read(bookingRepositoryProvider);
    final campaignsFuture = repository.fetchActiveCampaigns(
      systemTypeId: systemTypeId,
    );
    final creditBalanceFuture = repository.fetchCreditBalance();

    final campaigns = await campaignsFuture;
    final creditBalance = await creditBalanceFuture;

    return BookingSummaryUiState(
      campaigns: campaigns,
      creditBalance: creditBalance,
    );
  }
}

final bookingSummaryUiNotifierProvider =
    AsyncNotifierProvider<BookingSummaryUiNotifier, BookingSummaryUiState>(
      BookingSummaryUiNotifier.new,
    );
