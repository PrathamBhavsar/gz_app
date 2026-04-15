import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<UserResponse> getMe() async {
    // TODO: Implement actual API call using _apiClient
    return const UserResponse(data: null);
  }

  Future<void> loginWithOtp(String phone) async {
    // TODO: Implement POST /auth/login/otp
  }

  Future<UserResponse> verifyOtp(String phone, String code) async {
    // TODO: Implement POST /auth/verify/otp
    return const UserResponse(data: null);
  }

  Future<void> requestPasswordReset(String email) async {
    // TODO: Implement POST /auth/password/reset/request
  }

  Future<void> resetPassword(String token, String newPassword) async {
    // TODO: Implement POST /auth/password/reset/confirm
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient);
});
