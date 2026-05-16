import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../features/booking/data/repositories/booking_repository.dart';
import '../../../../models/domain_systems.dart';

class BookingDetailNotifier
    extends FamilyNotifier<AsyncValue<BookingModel>, String> {
  @override
  AsyncValue<BookingModel> build(String id) {
    _fetch(id);
    return const AsyncLoading();
  }

  Future<void> _fetch(String id) async {
    state = const AsyncLoading();
    try {
      final storeId = ref.read(activeStoreIdProvider) ?? '';
      final repo = ref.read(bookingRepositoryProvider);
      final response = await repo.fetchBooking(storeId, id);
      if (response.data != null) {
        state = AsyncData(response.data!);
      } else {
        state = AsyncError(Exception('Booking not found'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh(String id) => _fetch(id);
}

final bookingDetailNotifierProvider = NotifierProviderFamily<
    BookingDetailNotifier,
    AsyncValue<BookingModel>,
    String>(BookingDetailNotifier.new);
