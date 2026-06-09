import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/bookings_repository.dart';
import 'session_ui_models.dart';

class BookingDetailNotifier extends FamilyAsyncNotifier<BookingDetailState, String> {
  @override
  Future<BookingDetailState> build(String arg) => _load(arg);

  Future<void> refresh() async {
    final id = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(id));
  }

  Future<BookingDetailState> _load(String bookingId) async {
    final booking = await ref.read(bookingsRepositoryProvider).fetchBookingDetail(bookingId);
    return mapBookingDetail(booking);
  }

  void handleBookingCheckedIn(Map<String, dynamic> payload) {
    final bookingId =
        payload['bookingId']?.toString() ??
        payload['id']?.toString() ??
        payload['referenceId']?.toString();
    if (bookingId == null || bookingId != arg || state.valueOrNull == null) {
      return;
    }
    final current = state.value!;
    state = AsyncData(
      current.copyWith(
        status: SessionUiStatus.checkedIn,
        paymentStatus: 'Checked in',
        primaryActionLabel: 'Checked in',
      ),
    );
  }
}

final bookingDetailNotifierProvider = AsyncNotifierProvider.family<
    BookingDetailNotifier,
    BookingDetailState,
    String>(BookingDetailNotifier.new);

sealed class BookingCommandState {
  const BookingCommandState();
}

class BookingCommandInitial extends BookingCommandState {
  const BookingCommandInitial();
}

class BookingCommandLoading extends BookingCommandState {
  const BookingCommandLoading();
}

class BookingCommandSuccess extends BookingCommandState {
  const BookingCommandSuccess(this.message);

  final String message;
}

class BookingCommandError extends BookingCommandState {
  const BookingCommandError(this.error);

  final Object error;
}

class BookingCommandNotifier extends FamilyNotifier<BookingCommandState, String> {
  @override
  BookingCommandState build(String arg) => const BookingCommandInitial();

  Future<void> checkIn() async {
    state = const BookingCommandLoading();
    try {
      await ref.read(bookingsRepositoryProvider).checkInBooking(arg);
      await ref.read(bookingDetailNotifierProvider(arg).notifier).refresh();
      state = const BookingCommandSuccess('Checked in successfully');
    } catch (error) {
      state = BookingCommandError(error);
    }
  }

  Future<void> cancel() async {
    state = const BookingCommandLoading();
    try {
      await ref.read(bookingsRepositoryProvider).cancelBooking(arg);
      await ref.read(bookingDetailNotifierProvider(arg).notifier).refresh();
      state = const BookingCommandSuccess('Booking cancelled');
    } catch (error) {
      state = BookingCommandError(error);
    }
  }

  void reset() {
    state = const BookingCommandInitial();
  }
}

final bookingCommandNotifierProvider = NotifierProvider.family<
    BookingCommandNotifier,
    BookingCommandState,
    String>(BookingCommandNotifier.new);
