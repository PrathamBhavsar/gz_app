import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/api_responses_admin.dart';

class AdminAuthService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AdminAuthService(this._apiClient, this._tokenStorage);

  // ─── Admin Login (email + password) ────────────────────────────────
  Future<AdminLoginResponse> login(String email, String password) async {
    final data = await _apiClient.post(
      ApiConstants.authAdminLogin,
      body: {'email': email, 'password': password},
    );
    return AdminLoginResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Get admin profile (validates token) ───────────────────────────
  Future<AdminProfileResponse> getProfile() async {
    final data = await _apiClient.get(ApiConstants.authAdminMe);
    return AdminProfileResponse.fromJson(data as Map<String, dynamic>);
  }

  // ─── Admin Logout ──────────────────────────────────────────────────
  Future<void> logout({String? refreshToken, bool allDevices = false}) async {
    await _apiClient.post(
      ApiConstants.authAdminLogout,
      body: {
        if (refreshToken != null) 'refreshToken': refreshToken,
        if (allDevices) 'all': true,
      },
    );
    await _tokenStorage.clearAll();
  }

  // ─── Request password reset ────────────────────────────────────────
  Future<void> requestPasswordReset(String email) async {
    await _apiClient.post(
      ApiConstants.authAdminPasswordResetRequest,
      body: {'email': email},
    );
  }

  // ─── Confirm password reset ────────────────────────────────────────
  Future<void> confirmPasswordReset(String token, String newPassword) async {
    await _apiClient.post(
      ApiConstants.authAdminPasswordResetConfirm,
      body: {'token': token, 'newPassword': newPassword},
    );
  }
}

final adminAuthServiceProvider = Provider<AdminAuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AdminAuthService(apiClient, tokenStorage);
});
