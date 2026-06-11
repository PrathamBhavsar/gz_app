import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/domain_global.dart';
import '../../auth/data/repositories/auth_repository.dart';

class ProfileNotifier extends AsyncNotifier<UserModel> {
  @override
  Future<UserModel> build() async {
    return ref.read(authRepositoryProvider).fetchCurrentUser();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, UserModel>(ProfileNotifier.new);
