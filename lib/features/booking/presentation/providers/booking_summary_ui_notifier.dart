import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingSummaryUiState {
  const BookingSummaryUiState({
    this.selectedCampaign,
    this.credits = 300,
    this.payMethod = 'upi',
    this.campOpen = true,
    this.credOpen = true,
    this.confirmed = false,
  });

  final String? selectedCampaign; // 'happy' | 'first' | null
  final int credits;               // 0..850
  final String payMethod;          // 'cash' | 'upi' | 'card' | 'credits'
  final bool campOpen;
  final bool credOpen;
  final bool confirmed;

  BookingSummaryUiState copyWith({
    Object? selectedCampaign = _sentinel,
    int? credits,
    String? payMethod,
    bool? campOpen,
    bool? credOpen,
    bool? confirmed,
  }) {
    return BookingSummaryUiState(
      selectedCampaign: selectedCampaign == _sentinel
          ? this.selectedCampaign
          : selectedCampaign as String?,
      credits:   credits   ?? this.credits,
      payMethod: payMethod ?? this.payMethod,
      campOpen:  campOpen  ?? this.campOpen,
      credOpen:  credOpen  ?? this.credOpen,
      confirmed: confirmed ?? this.confirmed,
    );
  }

  static const Object _sentinel = Object();
}

class BookingSummaryUiNotifier extends Notifier<BookingSummaryUiState> {
  @override
  BookingSummaryUiState build() => const BookingSummaryUiState();

  void toggleCampaign(String id) {
    final next = state.selectedCampaign == id ? null : id;
    state = state.copyWith(selectedCampaign: next);
  }

  void setCredits(int v) => state = state.copyWith(credits: v);
  void setPayMethod(String m) => state = state.copyWith(payMethod: m);
  void toggleCampSection() => state = state.copyWith(campOpen: !state.campOpen);
  void toggleCredSection() => state = state.copyWith(credOpen: !state.credOpen);

  void confirm() {
    state = state.copyWith(confirmed: true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      state = state.copyWith(confirmed: false);
    });
  }
}

final bookingSummaryUiProvider =
    NotifierProvider<BookingSummaryUiNotifier, BookingSummaryUiState>(
  () => BookingSummaryUiNotifier(),
);
