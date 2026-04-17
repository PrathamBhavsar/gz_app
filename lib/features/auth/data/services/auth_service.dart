import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
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
      '/auth/login/email',
      body: {'email': email, 'password': password},
    );
    return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Login with OTP (request OTP) ─────────────────────────────────
  Future<void> loginWithOtp(String phone) async {
    await _apiClient.post('/auth/login/otp', body: {'phone': phone});
  }

  // ─── Verify OTP ───────────────────────────────────────────────────
  Future<AuthTokenResponse> verifyOtp(String phone, String code) async {
    final data = await _apiClient.post(
      '/auth/verify/otp',
      body: {'phone': phone, 'code': code},
    );
    return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Get current user (requires Bearer token via ApiClient) ───────
  Future<UserResponse> getMe() async {
    final data = await _apiClient.get('/auth/me');
    return UserResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Request password reset email ─────────────────────────────────
  Future<void> requestPasswordReset(String email) async {
    await _apiClient.post(
      '/auth/password/reset/request',
      body: {'email': email},
    );
  }

  // ─── Confirm password reset ───────────────────────────────────────
  Future<void> resetPassword(String token, String newPassword) async {
    await _apiClient.post(
      '/auth/password/reset/confirm',
      body: {'token': token, 'newPassword': newPassword},
    );
  }

  // ─── Logout ───────────────────────────────────────────────────────
  Future<void> logout() async {
    await _apiClient.post('/auth/logout');
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

    final data = await _apiClient.post('/auth/register', body: body);
    return UserResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Refresh access token ─────────────────────────────────────────
  Future<AuthTokenResponse> refreshToken(String refreshToken) async {
    final data = await _apiClient.post(
      '/auth/refresh',
      body: {'refreshToken': refreshToken},
    );
    return AuthTokenResponse.fromJson(data as Map<String, dynamic>);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthService(apiClient, tokenStorage);
});
