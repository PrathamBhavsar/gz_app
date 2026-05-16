import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';

class SplashRepository {
  final TokenStorage _tokenStorage;

  SplashRepository(this._tokenStorage);

  Future<String?> getRefreshToken() => _tokenStorage.getRefreshToken();

  Future<bool> getHasSeenOnboarding() => _tokenStorage.getHasSeenOnboarding();

  Future<String?> getUserType() => _tokenStorage.getUserType();
}

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  return SplashRepository(ref.watch(tokenStorageProvider));
});
