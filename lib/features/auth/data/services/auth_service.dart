import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<UserResponse> getMe() async {
    // Simulated API Call
    return const UserResponse(
      success: true,
      data: null, // Replace later with actual UserModel when decoded
    );
  }

  Future<void> loginWithOtp(String phone) async {
    // Simulated API Call
  }

  Future<UserResponse> verifyOtp(String phone, String code) async {
    // Simulated API Call (Assuming this returns auth tokens + user)
    return const UserResponse(
      success: true,
      data: null, 
    );
  }

  Future<void> requestPasswordReset(String email) async {
    // Simulated API Call
  }

  Future<void> resetPassword(String token, String newPassword) async {
    // Simulated API Call
  }
}

// Global provider for ApiClient (Placeholder for now)
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'http://192.168.1.4:3000/v1');
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient);
});