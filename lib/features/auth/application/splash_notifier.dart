import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../core/navigation/routes.dart';
import 'admin_auth_notifier.dart';
import 'auth_notifier.dart';

class SplashNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() => _resolve();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_resolve);
  }

  Future<String> _resolve() async {
    final storage = ref.read(tokenStorageProvider);
    final hasSeenOnboarding = await storage.getHasSeenOnboarding();

    if (!hasSeenOnboarding) {
      return AppRoutes.onboarding;
    }

    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return AppRoutes.authLanding;
    }

    final userType = await storage.getUserType();
    if (userType == 'admin') {
      final isAuthed = await ref
          .read(adminAuthNotifierProvider.notifier)
          .bootstrap();
      return isAuthed ? AppRoutes.adminDashboard : AppRoutes.adminLogin;
    }

    final isAuthed = await ref.read(authNotifierProvider.notifier).bootstrap();
    return isAuthed ? AppRoutes.home : AppRoutes.authLanding;
  }
}

final splashNotifierProvider = AsyncNotifierProvider<SplashNotifier, String>(
  SplashNotifier.new,
);
