import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DisputeStatus { open, review, resolved, withdrawn }

class DisputeDetailState {
  const DisputeDetailState({
    this.status = DisputeStatus.review,
    this.confirmOpen = false,
    this.withdrawnBannerVisible = false,
  });

  final DisputeStatus status;
  final bool confirmOpen;
  final bool withdrawnBannerVisible;

  DisputeDetailState copyWith({
    DisputeStatus? status,
    bool? confirmOpen,
    bool? withdrawnBannerVisible,
  }) {
    return DisputeDetailState(
      status:                 status                 ?? this.status,
      confirmOpen:            confirmOpen            ?? this.confirmOpen,
      withdrawnBannerVisible: withdrawnBannerVisible ?? this.withdrawnBannerVisible,
    );
  }
}

class DisputeDetailNotifier extends Notifier<DisputeDetailState> {
  @override
  DisputeDetailState build() => const DisputeDetailState();

  void setStatus(DisputeStatus s) => state = state.copyWith(status: s);
  void openConfirm()  => state = state.copyWith(confirmOpen: true);
  void closeConfirm() => state = state.copyWith(confirmOpen: false);

  void withdraw() {
    state = state.copyWith(
      confirmOpen: false,
      status: DisputeStatus.withdrawn,
      withdrawnBannerVisible: true,
    );
    Future.delayed(const Duration(milliseconds: 2200), () {
      state = state.copyWith(withdrawnBannerVisible: false);
    });
  }
}

final disputeDetailProvider =
    NotifierProvider<DisputeDetailNotifier, DisputeDetailState>(
  () => DisputeDetailNotifier(),
);
