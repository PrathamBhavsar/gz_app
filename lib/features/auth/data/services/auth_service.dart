import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses.dart';

class AuthService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthService(this._apiClient, this._tokenStorage);

  // ─── Login with Email ──────────────────────────────────────────────
  Future<AuthTokenResponse> loginWithEmail(
    String email,
    String password,
  ) async {
    final data = await _apiClient.post(
      ApiConstants.authLoginEmail,
      body: {'email': email, 'password': password},
    );
    return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Login with OTP (request OTP) ─────────────────────────────────
  Future<void> loginWithOtp(String phone) async {
    await _apiClient.post(ApiConstants.authLoginOtp, body: {'phone': phone});
  }

  // ─── Verify OTP ───────────────────────────────────────────────────
  Future<AuthTokenResponse> verifyOtp(String phone, String code) async {
    final data = await _apiClient.post(
      ApiConstants.authVerifyOtp,
      body: {'phone': phone, 'code': code},
    );
    return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Get current user (requires Bearer token via ApiClient) ───────
  Future<UserResponse> getMe() async {
    final data = await _apiClient.get(ApiConstants.authMe);
    return UserResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Request password reset email ─────────────────────────────────
  Future<void> requestPasswordReset(String email) async {
    await _apiClient.post(
      ApiConstants.authPasswordResetRequest,
      body: {'email': email},
    );
  }

  // ─── Confirm password reset ───────────────────────────────────────
  Future<void> resetPassword(String token, String newPassword) async {
    await _apiClient.post(
      ApiConstants.authPasswordResetConfirm,
      body: {'token': token, 'newPassword': newPassword},
    );
  }

  // ─── Logout ───────────────────────────────────────────────────────
  Future<void> logout() async {
    await _apiClient.post(ApiConstants.authLogout);
    await _tokenStorage.clearAll();
  }

  // ─── Register ─────────────────────────────────────────────────────
  Future<UserResponse> register({
    required String name,
    String? phone,
    String? email,
    String? password,
  }) async {
    final body = <String, dynamic>{'name': name};
    if (phone != null) body['phone'] = phone;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;

    final data = await _apiClient.post(ApiConstants.authRegister, body: body);
    return UserResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Refresh access token ─────────────────────────────────────────
  Future<AuthTokenResponse> refreshToken(String refreshToken) async {
    final data = await _apiClient.post(
      ApiConstants.authRefresh,
      body: {'refreshToken': refreshToken},
    );
    return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Update profile (name, email) ────────────────────────────────
  Future<UserResponse> updateMe({String? name, String? email}) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;

    final data = await _apiClient.patch(ApiConstants.authMe, body: body);
    return UserResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Register device for push notifications ──────────────────────
  Future<void> registerDevice({
    required String fcmToken,
    required String platform,
  }) async {
    await _apiClient.patch(
      ApiConstants.authMeDevice,
      body: {'fcmToken': fcmToken, 'platform': platform},
    );
  }

  // ─── Request phone number change ─────────────────────────────────
  Future<void> requestPhoneChange(String newPhone) async {
    await _apiClient.post(
      ApiConstants.authPhoneChange,
      body: {'newPhone': newPhone},
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthService(apiClient, tokenStorage);
});
