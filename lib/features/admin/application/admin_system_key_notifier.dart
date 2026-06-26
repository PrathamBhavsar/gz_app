import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_systems.dart';
import '../data/repositories/systems_admin_repository.dart';
import 'admin_system_detail_notifier.dart';

sealed class AdminSystemKeyState {
  const AdminSystemKeyState();
}

class AdminSystemKeyInitial extends AdminSystemKeyState {
  const AdminSystemKeyInitial();
}

class AdminSystemKeyLoading extends AdminSystemKeyState {
  const AdminSystemKeyLoading();
}

class AdminSystemKeySuccess extends AdminSystemKeyState {
  const AdminSystemKeySuccess(this.result);

  final SystemApiKeyModel result;
}

class AdminSystemKeyError extends AdminSystemKeyState {
  const AdminSystemKeyError(this.error);

  final Object error;
}

class AdminSystemKeyNotifier
    extends FamilyNotifier<AdminSystemKeyState, String> {
  @override
  AdminSystemKeyState build(String arg) => const AdminSystemKeyInitial();

  Future<void> regenerate() async {
    state = const AdminSystemKeyLoading();
    try {
      final result = await ref
          .read(systemsAdminRepositoryProvider)
          .regenerateKey(arg);
      ref.invalidate(adminSystemDetailNotifierProvider(arg));
      state = AdminSystemKeySuccess(result);
    } catch (error) {
      state = AdminSystemKeyError(error);
    }
  }

  void reset() {
    state = const AdminSystemKeyInitial();
  }
}

final adminSystemKeyNotifierProvider =
    NotifierProvider.family<
      AdminSystemKeyNotifier,
      AdminSystemKeyState,
      String
    >(AdminSystemKeyNotifier.new);
