import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/data/repositories/auth_repository.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_global.dart';

sealed class EditProfileState { const EditProfileState(); }
class EditProfileInitial extends EditProfileState { const EditProfileInitial(); }
class EditProfileLoading extends EditProfileState { const EditProfileLoading(); }
class EditProfileSuccess extends EditProfileState {
  final UserModel user;
  const EditProfileSuccess(this.user);
}
class EditProfileError extends EditProfileState {
  final String message;
  const EditProfileError(this.message);
}

class EditProfileNotifier extends Notifier<EditProfileState> {
  @override
  EditProfileState build() => const EditProfileInitial();

  Future<void> save({String? name, String? email}) async {
    state = const EditProfileLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final res = await repo.updateProfile(name: name, email: email);
      if (res.data == null) throw Exception('No user data returned');
      state = EditProfileSuccess(res.data!);
    } on ValidationException catch (e) {
      state = EditProfileError(e.message);
    } catch (e) {
      state = EditProfileError(e.toString());
    }
  }

  void reset() => state = const EditProfileInitial();
}

final editProfileProvider =
    NotifierProvider<EditProfileNotifier, EditProfileState>(
  EditProfileNotifier.new,
);
