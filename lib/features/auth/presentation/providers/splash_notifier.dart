import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/splash_repository.dart';
import '../../../admin/presentation/providers/admin_auth_provider.dart';
import '../../../admin/presentation/providers/admin_auth_state.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

// ─── Sealed state ──────────────────────────────────────────────────────────

sealed class SplashState {
  const SplashState();
}

class SplashChecking extends SplashState {
  const SplashChecking();
}

class SplashToHome extends SplashState {
  const SplashToHome();
}

class SplashToAdmin extends SplashState {
  const SplashToAdmin();
}

class SplashToAuth extends SplashState {
  const SplashToAuth();
}

class SplashToOnboarding extends SplashState {
  const SplashToOnboarding();
}

// ─── Notifier ──────────────────────────────────────────────────────────────

class SplashNotifier extends Notifier<SplashState> {
  @override
  SplashState build() {
    _resolve();
    return const SplashChecking();
  }

  Future<void> _resolve() async {
    final splashRepo = ref.read(splashRepositoryProvider);
    final tokenStorage = ref.read(tokenStorageProvider);

    final refreshToken = await splashRepo.getRefreshToken();

    if (refreshToken == null) {
      final seen = await splashRepo.getHasSeenOnboarding();
      state = seen ? const SplashToAuth() : const SplashToOnboarding();
      return;
    }

    // Has stored credentials — validate. ApiClient handles 401 → refresh → retry.
    await ref.read(authNotifierProvider.notifier).checkAuthStatus();
    final authState = ref.read(authNotifierProvider);

    if (authState is AuthAuthenticated) {
      final userType = await splashRepo.getUserType();
      if (userType == 'admin') {
        await ref.read(adminAuthNotifierProvider.notifier).checkAdminStatus();
        final adminState = ref.read(adminAuthNotifierProvider);
        state = adminState is AdminAuthAuthenticated
            ? const SplashToAdmin()
            : const SplashToAuth();
      } else {
        state = const SplashToHome();
      }
      return;
    }

    if (authState is AuthError) {
      final err = authState.error;
      if (err is NetworkException) {
        // Offline — trust stored tokens
        final userType = await splashRepo.getUserType();
        state = userType == 'admin' ? const SplashToAdmin() : const SplashToHome();
        return;
      }
    }

    // Auth validation failed — clear tokens
    await tokenStorage.clearAll();
    final seen = await splashRepo.getHasSeenOnboarding();
    state = seen ? const SplashToAuth() : const SplashToOnboarding();
  }
}

final splashNotifierProvider = NotifierProvider<SplashNotifier, SplashState>(
  () => SplashNotifier(),
);
