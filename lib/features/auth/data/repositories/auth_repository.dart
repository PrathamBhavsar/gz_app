import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import 'auth_service.dart';
import '../../../../models/api_responses.dart';

class AuthRepository {
  final AuthService _authService;
  final NetworkChecker _networkChecker;

  AuthRepository(this._authService, this._networkChecker);

  Future<UserResponse> getUserProfile() async {
    await _networkChecker.assertConnection();
    return await _authService.getMe();
  }

  Future<void> requestOtpLogin(String phone) async {
    await _networkChecker.assertConnection();
    await _authService.loginWithOtp(phone);
  }

  Future<UserResponse> verifyPhoneOtp(String phone, String code) async {
    await _networkChecker.assertConnection();
    return await _authService.verifyOtp(phone, code);
  }
  
  Future<void> sendPasswordReset(String email) async {
    await _networkChecker.assertConnection();
    await _authService.requestPasswordReset(email);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final networkChecker = ref.watch(networkCheckerProvider);
  return AuthRepository(authService, networkChecker);
});
