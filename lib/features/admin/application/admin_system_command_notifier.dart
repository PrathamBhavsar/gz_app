import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/enums.dart';
import '../data/repositories/systems_admin_repository.dart';
import 'admin_command_state.dart';
import 'admin_system_detail_notifier.dart';
import 'admin_systems_notifier.dart';

class AdminSystemCommandNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> createSystem({
    required String name,
    required String systemTypeId,
    required int stationNumber,
    required SystemPlatform platform,
    Map<String, dynamic>? specs,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref
          .read(systemsAdminRepositoryProvider)
          .createSystem(
            name: name,
            systemTypeId: systemTypeId,
            stationNumber: stationNumber,
            platform: platform.name,
            specs: specs,
          );
      ref.invalidate(adminSystemsNotifierProvider);
      state = const AdminCommandSuccess('System created');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> updateSystem({
    required String id,
    required String name,
    required String systemTypeId,
    required int stationNumber,
    required SystemPlatform platform,
    required SystemStatus status,
    Map<String, dynamic>? specs,
  }) async {
    state = const AdminCommandLoading();
    try {
      await ref
          .read(systemsAdminRepositoryProvider)
          .updateSystem(
            id: id,
            name: name,
            systemTypeId: systemTypeId,
            stationNumber: stationNumber,
            platform: platform.name,
            status: status.name,
            specs: specs,
          );
      ref.invalidate(adminSystemsNotifierProvider);
      ref.invalidate(adminSystemDetailNotifierProvider(id));
      state = const AdminCommandSuccess('System updated');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> deleteSystem(String id) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(systemsAdminRepositoryProvider).deleteSystem(id);
      ref.invalidate(adminSystemsNotifierProvider);
      ref.invalidate(adminSystemDetailNotifierProvider(id));
      state = const AdminCommandSuccess('System removed');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() {
    state = const AdminCommandInitial();
  }
}

final adminSystemCommandNotifierProvider =
    NotifierProvider<AdminSystemCommandNotifier, AdminCommandState>(
      AdminSystemCommandNotifier.new,
    );
