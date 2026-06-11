import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_credits_repository.dart';
import 'admin_management_models.dart';

class AdminCreditsNotifier extends AsyncNotifier<AdminCreditsData> {
  String? _selectedUserId;

  @override
  Future<AdminCreditsData> build() async => const AdminCreditsData();

  Future<void> loadUser(String userId) async {
    _selectedUserId = userId.trim();
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadSelectedUser);
  }

  Future<void> refresh() async {
    if (_selectedUserId == null || _selectedUserId!.isEmpty) {
      state = const AsyncData(AdminCreditsData());
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadSelectedUser);
  }

  Future<AdminCreditsData> _loadSelectedUser() async {
    final userId = _selectedUserId;
    if (userId == null || userId.isEmpty) {
      return const AdminCreditsData();
    }
    final payload = await ref
        .read(adminCreditsRepositoryProvider)
        .fetchAccount(userId);
    return AdminCreditsData(
      selectedUserId: userId,
      user: payload.user,
      balance: payload.balance,
      transactions: payload.transactions,
      loadedAt: DateTime.now(),
    );
  }
}

final adminCreditsNotifierProvider =
    AsyncNotifierProvider<AdminCreditsNotifier, AdminCreditsData>(
      AdminCreditsNotifier.new,
    );
