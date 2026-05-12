import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityHubState {
  const ActivityHubState({
    this.tab = 'upcoming',
    this.expandedHistId,
    this.showPaySheet = false,
  });

  final String tab;          // 'upcoming' | 'active' | 'history'
  final String? expandedHistId;
  final bool showPaySheet;

  ActivityHubState copyWith({
    String? tab,
    Object? expandedHistId = _s,
    bool? showPaySheet,
  }) {
    return ActivityHubState(
      tab:            tab            ?? this.tab,
      expandedHistId: expandedHistId == _s ? this.expandedHistId : expandedHistId as String?,
      showPaySheet:   showPaySheet   ?? this.showPaySheet,
    );
  }

  static const Object _s = Object();
}

class ActivityHubNotifier extends Notifier<ActivityHubState> {
  @override
  ActivityHubState build() => const ActivityHubState();

  void setTab(String t) => state = state.copyWith(tab: t, showPaySheet: false);
  void toggleHist(String id) {
    final next = state.expandedHistId == id ? null : id;
    state = state.copyWith(expandedHistId: next);
  }
  void showPay()  => state = state.copyWith(showPaySheet: true);
  void closePay() => state = state.copyWith(showPaySheet: false);
}

final activityHubProvider =
    NotifierProvider<ActivityHubNotifier, ActivityHubState>(
  () => ActivityHubNotifier(),
);
