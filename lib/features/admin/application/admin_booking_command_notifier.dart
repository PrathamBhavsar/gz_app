import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_bookings_repository.dart';
import 'admin_command_state.dart';

class AdminBookingCommandNotifier
    extends FamilyNotifier<AdminCommandState, String> {
  @override
  AdminCommandState build(String arg) => const AdminCommandInitial();

  Future<void> checkIn() async =>
      _run(() => ref.read(adminBookingsRepositoryProvider).checkInBooking(arg));

  Future<void> cancel({String? reason}) async => _run(
    () => ref
        .read(adminBookingsRepositoryProvider)
        .cancelBooking(arg, reason: reason),
  );

  Future<void> _run(Future<String> Function() action) async {
    state = const AdminCommandLoading();
    try {
      final message = await action();
      state = AdminCommandSuccess(message);
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
      rethrow;
    }
  }
}

final adminBookingCommandNotifierProvider =
    NotifierProvider.family<
      AdminBookingCommandNotifier,
      AdminCommandState,
      String
    >(AdminBookingCommandNotifier.new);
