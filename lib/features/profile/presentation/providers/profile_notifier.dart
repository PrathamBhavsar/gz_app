import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/data/repositories/auth_repository.dart';
import '../../../../models/domain_global.dart';

class ProfileNotifier extends Notifier<AsyncValue<UserModel>> {
  @override
  AsyncValue<UserModel> build() {
    _fetch();
    return const AsyncLoading();
  }

  Future<void> _fetch() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final res = await repo.getUserProfile();
      if (res.data == null) throw Exception('No user data');
      state = AsyncData(res.data!);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _fetch();
}

final profileNotifierProvider =
    NotifierProvider<ProfileNotifier, AsyncValue<UserModel>>(
  ProfileNotifier.new,
);
