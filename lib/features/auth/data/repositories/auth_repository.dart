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

  /// Callback to persist accessToken in Riverpod in-memory state.
  /// This avoids a direct dependency on the Provider container.
  final void Function(String token) _onAccessTokenReceived;

  AuthRepository(
    this._authService,
    this._networkChecker,
    this._tokenStorage,
    this._onAccessTokenReceived,
  );

  // ─── Persist tokens from a successful login/verify response ───────
  Future<UserModel> _handleAuthToken(AuthTokenResponse response) async {
    // 1. Save access token to in-memory Riverpod state (for interceptor)
    _onAccessTokenReceived(response.accessToken);

    // 2. Save refresh token to secure storage (persists across restarts)
    if (response.refreshToken != null) {
      await _tokenStorage.saveRefreshToken(response.refreshToken!);
    }

    // 3. Save userId for WebSocket connections
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
    try {
      await _authService.logout();
    } catch (_) {
      await _tokenStorage.clearAll();
    }
  }

  // ─── Silent token refresh (used by interceptor) ───────────────────
  Future<String?> refreshAccessToken() async {
    final storedRefreshToken = await _tokenStorage.getRefreshToken();
    if (storedRefreshToken == null) return null;

    final response = await _authService.refreshToken(storedRefreshToken);

    // Save new access token in memory
    _onAccessTokenReceived(response.accessToken);

    // Rotate refresh token if a new one was issued
    if (response.refreshToken != null) {
      await _tokenStorage.saveRefreshToken(response.refreshToken!);
    }
    return response.accessToken;
  }

  // ─── Update profile ──────────────────────────────────────────────
  Future<UserResponse> updateProfile({String? name, String? email}) async {
    await _networkChecker.assertConnection();
    return await _authService.updateMe(name: name, email: email);
  }

  // ─── Register device for push ────────────────────────────────────
  Future<void> registerDevice({
    required String fcmToken,
    required String platform,
  }) async {
    await _networkChecker.assertConnection();
    await _authService.registerDevice(fcmToken: fcmToken, platform: platform);
  }

  // ─── Request phone change ────────────────────────────────────────
  Future<void> requestPhoneChange(String newPhone) async {
    await _networkChecker.assertConnection();
    await _authService.requestPhoneChange(newPhone);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final networkChecker = ref.watch(networkCheckerProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  return AuthRepository(
    authService,
    networkChecker,
    tokenStorage,
    // Callback: save accessToken to Riverpod in-memory state
    (token) => ref.read(accessTokenProvider.notifier).state = token,
  );
});
