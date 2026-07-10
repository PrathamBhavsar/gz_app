import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_activity_repository.dart';
import 'admin_operations_models.dart';

/// Store-wide activity feed powering the Session Management screen
/// (All / Current / Incoming / Past tabs), latest first.
class AdminSessionsNotifier extends AsyncNotifier<AdminSessionsData> {
  @override
  Future<AdminSessionsData> build() => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AdminSessionsData> _load() async {
    final repo = ref.read(adminActivityRepositoryProvider);
    final items = await repo.fetchFeed(scope: 'store');
    return AdminSessionsData(items: items, loadedAt: DateTime.now());
  }
}

final adminSessionsNotifierProvider =
    AsyncNotifierProvider<AdminSessionsNotifier, AdminSessionsData>(
      AdminSessionsNotifier.new,
    );
