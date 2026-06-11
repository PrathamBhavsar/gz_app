import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/store_config_repository.dart';
import 'admin_command_state.dart';
import 'store_config_notifier.dart';

class StoreConfigCommandNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> save({
    required int bookingWindowMinutes,
    required int paymentWindowMinutes,
    required int noShowGraceMinutes,
    required int maxBookingDurationMinutes,
    required String operatingHoursStart,
    required String operatingHoursEnd,
    required bool allowWalkIns,
    required bool autoStartSessionOnCheckIn,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(storeConfigRepositoryProvider).updateConfig(
        bookingWindowMinutes: bookingWindowMinutes,
        paymentWindowMinutes: paymentWindowMinutes,
        noShowGraceMinutes: noShowGraceMinutes,
        maxBookingDurationMinutes: maxBookingDurationMinutes,
        operatingHoursStart: operatingHoursStart,
        operatingHoursEnd: operatingHoursEnd,
        allowWalkIns: allowWalkIns,
        autoStartSessionOnCheckIn: autoStartSessionOnCheckIn,
      );
      ref.invalidate(storeConfigNotifierProvider);
      state = const AdminCommandSuccess('Store config saved');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() {
    state = const AdminCommandInitial();
  }
}

final storeConfigCommandNotifierProvider =
    NotifierProvider<StoreConfigCommandNotifier, AdminCommandState>(
      StoreConfigCommandNotifier.new,
    );
