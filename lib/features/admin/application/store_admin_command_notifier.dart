import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/enums.dart';
import '../data/repositories/store_admins_repository.dart';
import 'admin_command_state.dart';
import 'store_admins_notifier.dart';

class StoreAdminCommandNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> createAdmin({
    required String name,
    required String email,
    required AdminRole role,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(storeAdminsRepositoryProvider).createAdmin(
        name: name,
        email: email,
        role: role.name,
      );
      ref.invalidate(storeAdminsNotifierProvider);
      state = const AdminCommandSuccess('Staff member invited');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> updateAdmin({
    required String id,
    required AdminRole role,
    String? name,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(storeAdminsRepositoryProvider).updateAdmin(
        id: id,
        role: role.name,
        name: name,
      );
      ref.invalidate(storeAdminsNotifierProvider);
      state = const AdminCommandSuccess('Staff role updated');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> deactivateAdmin(String id) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(storeAdminsRepositoryProvider).deactivateAdmin(id);
      ref.invalidate(storeAdminsNotifierProvider);
      state = const AdminCommandSuccess('Staff access removed');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() {
    state = const AdminCommandInitial();
  }
}

final storeAdminCommandNotifierProvider =
    NotifierProvider<StoreAdminCommandNotifier, AdminCommandState>(
      StoreAdminCommandNotifier.new,
    );
