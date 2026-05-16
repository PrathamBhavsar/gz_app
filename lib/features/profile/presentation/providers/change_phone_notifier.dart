import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/data/repositories/auth_repository.dart';
import '../../../../core/errors/app_exception.dart';

sealed class ChangePhoneState { const ChangePhoneState(); }
class ChangePhoneInitial extends ChangePhoneState { const ChangePhoneInitial(); }
class ChangePhoneLoading extends ChangePhoneState { const ChangePhoneLoading(); }
class ChangePhoneOtpSent extends ChangePhoneState {
  final String phone;
  const ChangePhoneOtpSent(this.phone);
}
class ChangePhoneSuccess extends ChangePhoneState { const ChangePhoneSuccess(); }
class ChangePhoneError extends ChangePhoneState {
  final String message;
  const ChangePhoneError(this.message);
}

class ChangePhoneNotifier extends Notifier<ChangePhoneState> {
  @override
  ChangePhoneState build() => const ChangePhoneInitial();

  Future<void> sendOtp(String newPhone) async {
    state = const ChangePhoneLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.requestPhoneChange(newPhone);
      state = ChangePhoneOtpSent(newPhone);
    } on ValidationException catch (e) {
      state = ChangePhoneError(e.message);
    } catch (e) {
      state = ChangePhoneError(e.toString());
    }
  }

  Future<void> verifyOtp(String otp) async {
    final current = state;
    if (current is! ChangePhoneOtpSent) return;
    await ref.read(authRepositoryProvider).verifyPhoneChange(current.phone, otp);
  }

  void markSuccess() => state = const ChangePhoneSuccess();
  void reset() => state = const ChangePhoneInitial();
}

final changePhoneProvider =
    NotifierProvider<ChangePhoneNotifier, ChangePhoneState>(
  ChangePhoneNotifier.new,
);
