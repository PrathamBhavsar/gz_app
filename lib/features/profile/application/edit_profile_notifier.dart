import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/domain_global.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/data/repositories/auth_repository.dart';
import 'profile_notifier.dart';

sealed class EditProfileState {
  const EditProfileState();
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileLoading extends EditProfileState {
  const EditProfileLoading();
}

class EditProfileSuccess extends EditProfileState {
  const EditProfileSuccess(this.user);

  final UserModel user;
}

class EditProfileError extends EditProfileState {
  const EditProfileError(this.error);

  final Object error;
}

class EditProfileNotifier extends Notifier<EditProfileState> {
  @override
  EditProfileState build() => const EditProfileInitial();

  Future<void> submit({required String name}) async {
    state = const EditProfileLoading();

    try {
      final user = await ref
          .read(authRepositoryProvider)
          .updateProfile(name: name);
      ref.read(authNotifierProvider.notifier).setCurrentUser(user);
      ref.invalidate(profileNotifierProvider);
      state = EditProfileSuccess(user);
    } catch (error) {
      state = EditProfileError(error);
    }
  }

  void reset() {
    state = const EditProfileInitial();
  }
}

final editProfileNotifierProvider =
    NotifierProvider<EditProfileNotifier, EditProfileState>(
      EditProfileNotifier.new,
    );
