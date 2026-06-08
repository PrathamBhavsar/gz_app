import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';

sealed class OtpState {
  const OtpState();
}

class OtpInitial extends OtpState {
  const OtpInitial();
}

class OtpLoading extends OtpState {
  const OtpLoading();
}

class OtpSuccess extends OtpState {
  const OtpSuccess();
}

class OtpError extends OtpState {
  const OtpError(this.error);

  final Object error;
}

class OtpNotifier extends Notifier<OtpState> {
  @override
  OtpState build() => const OtpInitial();

  Future<void> verify({
    required String code,
    String? phone,
    String? email,
  }) async {
    state = const OtpLoading();

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .verifyOtp(code: code, phone: phone, email: email);
      await ref.read(authNotifierProvider.notifier).setAuthenticated(session);
      state = const OtpSuccess();
    } catch (error) {
      state = OtpError(error);
    }
  }

  Future<void> resend({required String phone}) async {
    try {
      await ref.read(authRepositoryProvider).requestOtpLogin(phone: phone);
    } catch (error) {
      state = OtpError(error);
    }
  }

  void reset() {
    state = const OtpInitial();
  }
}

final otpNotifierProvider = NotifierProvider<OtpNotifier, OtpState>(
  OtpNotifier.new,
);
