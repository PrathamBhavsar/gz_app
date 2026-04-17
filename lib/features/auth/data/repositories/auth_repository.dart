import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../core/auth/token_storage.dart';
import '../services/auth_service.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_global.dart';

class AuthRepository {
  final AuthService _authService;
  final NetworkChecker _networkChecker;
  final TokenStorage _tokenStorage;

  AuthRepository(this._authService, this._networkChecker, this._tokenStorage);

  // ─── Persist tokens from a successful login/verify response ───────
  Future<UserModel> _handleAuthToken(AuthTokenResponse response) async {
    if (response.refreshToken != null) {
      await _tokenStorage.saveRefreshToken(response.refreshToken!);
    }
    if (response.user?.id != null) {
      await _tokenStorage.saveUserId(response.user!.id!);
    }
    if (response.user == null) {
      throw Exception('Authentication succeeded but no user data returned');
    }
    return response.user!;
  }

  // ─── Login with email + password ──────────────────────────────────
  Future<UserModel> loginWithEmail(String email, String password) async {
    await _networkChecker.assertConnection();
    final response = await _authService.loginWithEmail(email, password);
    return _handleAuthToken(response);
  }

  // ─── Get user profile ─────────────────────────────────────────────
  Future<UserResponse> getUserProfile() async {
    await _networkChecker.assertConnection();
    return await _authService.getMe();
  }

  // ─── OTP login flow ───────────────────────────────────────────────
  Future<void> requestOtpLogin(String phone) async {
    await _networkChecker.assertConnection();
    await _authService.loginWithOtp(phone);
  }

  Future<UserModel> verifyPhoneOtp(String phone, String code) async {
    await _networkChecker.assertConnection();
    final response = await _authService.verifyOtp(phone, code);
    return _handleAuthToken(response);
  }

  // ─── Password reset ───────────────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    await _networkChecker.assertConnection();
    await _authService.requestPasswordReset(email);
  }

  Future<void> confirmPasswordReset(String token, String newPassword) async {
    await _networkChecker.assertConnection();
    await _authService.resetPassword(token, newPassword);
  }

  // ─── Register ─────────────────────────────────────────────────────
  Future<UserResponse> register({
    required String name,
    String? phone,
    String? email,
    String? password,
  }) async {
    await _networkChecker.assertConnection();
    return await _authService.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
  }

  // ─── Logout ───────────────────────────────────────────────────────
  Future<void> logout() async {
    // Best-effort — even if API call fails, clear local tokens
    try {
      await _authService.logout();
    } catch (_) {
      await _tokenStorage.clearAll();
    }
  }

  // ─── Silent token refresh ─────────────────────────────────────────
  Future<String?> refreshAccessToken() async {
    final storedRefreshToken = await _tokenStorage.getRefreshToken();
    if (storedRefreshToken == null) return null;

    final response = await _authService.refreshToken(storedRefreshToken);
    if (response.refreshToken != null) {
      await _tokenStorage.saveRefreshToken(response.refreshToken!);
    }
    return response.accessToken;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final networkChecker = ref.watch(networkCheckerProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRepository(authService, networkChecker, tokenStorage);
});
