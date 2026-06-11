import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_notifier.dart';
import '../../auth/data/repositories/auth_repository.dart';
import 'profile_notifier.dart';

sealed class ChangePhoneState {
  const ChangePhoneState();
}

class ChangePhoneInitial extends ChangePhoneState {
  const ChangePhoneInitial();
}

class ChangePhoneLoading extends ChangePhoneState {
  const ChangePhoneLoading();
}

class ChangePhoneOtpSent extends ChangePhoneState {
  const ChangePhoneOtpSent({required this.phone, required this.message});

  final String phone;
  final String message;
}

class ChangePhoneSuccess extends ChangePhoneState {
  const ChangePhoneSuccess({required this.phone, required this.message});

  final String phone;
  final String message;
}

class ChangePhoneError extends ChangePhoneState {
  const ChangePhoneError(this.error);

  final Object error;
}

class ChangePhoneNotifier extends Notifier<ChangePhoneState> {
  String? _pendingPhone;

  @override
  ChangePhoneState build() => const ChangePhoneInitial();

  Future<void> submit(String newPhone) async {
    state = const ChangePhoneLoading();

    try {
      final message = await ref
          .read(authRepositoryProvider)
          .requestPhoneChange(newPhone: newPhone);
      _pendingPhone = newPhone;
      state = ChangePhoneOtpSent(phone: newPhone, message: message);
    } catch (error) {
      state = ChangePhoneError(error);
    }
  }

  Future<void> verifyOtp(String otp) async {
    final phone = _pendingPhone;
    if (phone == null || phone.isEmpty) {
      throw StateError('No phone change request is pending.');
    }

    state = const ChangePhoneLoading();

    try {
      final message = await ref
          .read(authRepositoryProvider)
          .verifyPhoneChange(newPhone: phone, otp: otp);
      final user = await ref.read(authRepositoryProvider).fetchCurrentUser();
      ref.read(authNotifierProvider.notifier).setCurrentUser(user);
      ref.invalidate(profileNotifierProvider);
      _pendingPhone = null;
      state = ChangePhoneSuccess(phone: user.phone ?? phone, message: message);
    } catch (error) {
      state = ChangePhoneOtpSent(
        phone: phone,
        message: 'Verify the OTP sent to continue.',
      );
      rethrow;
    }
  }

  Future<void> resendOtp() async {
    final phone = _pendingPhone;
    if (phone == null || phone.isEmpty) {
      throw StateError('No phone change request is pending.');
    }

    try {
      final message = await ref
          .read(authRepositoryProvider)
          .requestPhoneChange(newPhone: phone);
      state = ChangePhoneOtpSent(phone: phone, message: message);
    } catch (error) {
      state = ChangePhoneError(error);
      rethrow;
    }
  }

  void reset() {
    _pendingPhone = null;
    state = const ChangePhoneInitial();
  }
}

final changePhoneNotifierProvider =
    NotifierProvider<ChangePhoneNotifier, ChangePhoneState>(
      ChangePhoneNotifier.new,
    );
