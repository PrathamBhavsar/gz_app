import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/system_types_repository.dart';
import 'admin_command_state.dart';
import 'admin_systems_notifier.dart';

class AdminSystemTypeCommandNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> createType({
    required String name,
    String? description,
    double? hourlyBaseRate,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(systemTypesRepositoryProvider).createSystemType(
        name: name,
        description: description,
        hourlyBaseRate: hourlyBaseRate,
      );
      ref.invalidate(adminSystemsNotifierProvider);
      state = const AdminCommandSuccess('System type created');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> updateType({
    required String id,
    required String name,
    String? description,
    double? hourlyBaseRate,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(systemTypesRepositoryProvider).updateSystemType(
        id: id,
        name: name,
        description: description,
        hourlyBaseRate: hourlyBaseRate,
      );
      ref.invalidate(adminSystemsNotifierProvider);
      state = const AdminCommandSuccess('System type updated');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> deleteType(String id) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(systemTypesRepositoryProvider).deleteSystemType(id);
      ref.invalidate(adminSystemsNotifierProvider);
      state = const AdminCommandSuccess('System type removed');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() {
    state = const AdminCommandInitial();
  }
}

final adminSystemTypeCommandNotifierProvider =
    NotifierProvider<AdminSystemTypeCommandNotifier, AdminCommandState>(
      AdminSystemTypeCommandNotifier.new,
    );
