import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_campaigns_repository.dart';
import 'admin_campaigns_notifier.dart';
import 'admin_command_state.dart';

class AdminCampaignCommandNotifier extends Notifier<AdminCommandState> {
  @override
  AdminCommandState build() => const AdminCommandInitial();

  Future<void> create(Map<String, dynamic> body) async {
    state = const AdminCommandLoading();
    try {
      await ref.read(adminCampaignsRepositoryProvider).createCampaign(body);
      ref.invalidate(adminCampaignsNotifierProvider);
      state = const AdminCommandSuccess('Campaign created');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> update(String id, Map<String, dynamic> body) async {
    state = const AdminCommandLoading();
    try {
      await ref
          .read(adminCampaignsRepositoryProvider)
          .updateCampaign(id, body);
      ref.invalidate(adminCampaignsNotifierProvider);
      state = const AdminCommandSuccess('Campaign updated');
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> pause(String id) async {
    state = const AdminCommandLoading();
    try {
      final msg = await ref
          .read(adminCampaignsRepositoryProvider)
          .pauseCampaign(id);
      ref.invalidate(adminCampaignsNotifierProvider);
      state = AdminCommandSuccess(msg);
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  Future<void> resume(String id) async {
    state = const AdminCommandLoading();
    try {
      final msg = await ref
          .read(adminCampaignsRepositoryProvider)
          .resumeCampaign(id);
      ref.invalidate(adminCampaignsNotifierProvider);
      state = AdminCommandSuccess(msg);
    } catch (error) {
      state = AdminCommandError(adminCommandMessage(error));
    }
  }

  void reset() => state = const AdminCommandInitial();
}

final adminCampaignCommandNotifierProvider =
    NotifierProvider<AdminCampaignCommandNotifier, AdminCommandState>(
      AdminCampaignCommandNotifier.new,
    );
