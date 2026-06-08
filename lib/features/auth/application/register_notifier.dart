import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';

sealed class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess(this.result);

  final RegisterResult result;
}

class RegisterError extends RegisterState {
  const RegisterError(this.error);

  final Object error;
}

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterInitial();

  Future<void> submit({
    required String name,
    String? phone,
    String? email,
    String? password,
  }) async {
    state = const RegisterLoading();

    try {
      final result = await ref
          .read(authRepositoryProvider)
          .register(name: name, phone: phone, email: email, password: password);
      state = RegisterSuccess(result);
    } catch (error) {
      state = RegisterError(error);
    }
  }

  void reset() {
    state = const RegisterInitial();
  }
}

final registerNotifierProvider =
    NotifierProvider<RegisterNotifier, RegisterState>(RegisterNotifier.new);
