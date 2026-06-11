import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_systems.dart';
import '../data/repositories/admin_bookings_repository.dart';

class AdminBookingDetailNotifier
    extends FamilyAsyncNotifier<BookingModel, String> {
  @override
  Future<BookingModel> build(String arg) {
    return ref.read(adminBookingsRepositoryProvider).fetchBookingDetail(arg);
  }

  Future<void> refresh() async {
    final bookingId = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(adminBookingsRepositoryProvider)
          .fetchBookingDetail(bookingId),
    );
  }
}

final adminBookingDetailNotifierProvider =
    AsyncNotifierProvider.family<
      AdminBookingDetailNotifier,
      BookingModel,
      String
    >(AdminBookingDetailNotifier.new);
