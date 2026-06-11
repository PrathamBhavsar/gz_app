import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_admin.dart';
import '../../../../models/enums.dart';
import '../data/repositories/admin_bookings_repository.dart';

sealed class AdminWalkInState {
  const AdminWalkInState();
}

class AdminWalkInInitial extends AdminWalkInState {
  const AdminWalkInInitial();
}

class AdminWalkInLoading extends AdminWalkInState {
  const AdminWalkInLoading();
}

class AdminWalkInSuccess extends AdminWalkInState {
  const AdminWalkInSuccess(this.response);

  final WalkInBookingResponse response;
}

class AdminWalkInError extends AdminWalkInState {
  const AdminWalkInError(this.message);

  final String message;
}

class AdminWalkInNotifier extends Notifier<AdminWalkInState> {
  @override
  AdminWalkInState build() => const AdminWalkInInitial();

  Future<void> submit({
    required String systemId,
    required int durationMinutes,
    String? userId,
    String? userName,
    String? phone,
    PaymentMethod? paymentMethod,
  }) async {
    state = const AdminWalkInLoading();
    try {
      final result = await ref
          .read(adminBookingsRepositoryProvider)
          .createWalkInBooking(
            systemId: systemId,
            durationMinutes: durationMinutes,
            userId: userId,
            userName: userName,
            phone: phone,
            paymentMethod: paymentMethod,
          );
      state = AdminWalkInSuccess(result);
    } catch (error) {
      state = AdminWalkInError(AppPageError.from(error).message);
      rethrow;
    }
  }

  void reset() {
    state = const AdminWalkInInitial();
  }
}

final adminWalkInNotifierProvider =
    NotifierProvider<AdminWalkInNotifier, AdminWalkInState>(
      AdminWalkInNotifier.new,
    );
