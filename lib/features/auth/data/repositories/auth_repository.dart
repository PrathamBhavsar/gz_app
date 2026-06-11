import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_global.dart';

class RegisterResult {
  const RegisterResult({
    required this.message,
    this.email,
    this.phone,
    this.requiresEmailVerification = false,
  });

  final String message;
  final String? email;
  final String? phone;
  final bool requiresEmailVerification;

  factory RegisterResult.fromJson(
    Map<String, dynamic> json, {
    String? fallbackEmail,
    String? fallbackPhone,
  }) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : null;

    final payloadUser = data?['user'] is Map<String, dynamic>
        ? data!['user'] as Map<String, dynamic>
        : data;
    final email =
        payloadUser?['email']?.toString() ??
        data?['email']?.toString() ??
        fallbackEmail;
    final phone =
        payloadUser?['phone']?.toString() ??
        data?['phone']?.toString() ??
        fallbackPhone;
    final requiresEmailVerification =
        (data?['requiresEmailVerification'] ??
                data?['requires_email_verification']) ==
            true ||
        (email != null && email.isNotEmpty);

    return RegisterResult(
      message: (json['message'] ?? 'Registration successful').toString(),
      email: email,
      phone: phone,
      requiresEmailVerification: requiresEmailVerification,
    );
  }
}

class AuthRepository {
  AuthRepository(this._api, this._net, this._storage, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;
  final Ref _ref;

  Future<AuthTokenResponse> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authLoginEmail,
      body: {'email': email, 'password': password},
    );
    return AuthTokenResponse.fromJson(raw as Map<String, dynamic>);
  }

  Future<RegisterResult> register({
    required String name,
    String? phone,
    String? email,
    String? password,
  }) async {
    await _net.assertConnection();

    final body = <String, dynamic>{
      'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (password != null && password.isNotEmpty) 'password': password,
    };

    final raw = await _api.post(ApiConstants.authRegister, body: body);
    return RegisterResult.fromJson(
      raw as Map<String, dynamic>,
      fallbackEmail: email,
      fallbackPhone: phone,
    );
  }

  Future<void> requestOtpLogin({required String phone}) async {
    await _net.assertConnection();
    await _api.post(ApiConstants.authLoginOtp, body: {'phone': phone});
  }

  Future<AuthTokenResponse> verifyOtp({
    required String code,
    String? phone,
    String? email,
  }) async {
    await _net.assertConnection();
    final body = <String, dynamic>{
      'code': code,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
    };

    final raw = await _api.post(ApiConstants.authVerifyOtp, body: body);
    return AuthTokenResponse.fromJson(raw as Map<String, dynamic>);
  }

  Future<String> requestPasswordReset({required String email}) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authPasswordResetRequest,
      body: {'email': email},
    );
    return (raw as Map<String, dynamic>)['message']?.toString() ??
        'Reset link sent.';
  }

  Future<String> confirmPasswordReset({
    required String token,
    required String password,
  }) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authPasswordResetConfirm,
      body: {'token': token, 'newPassword': password},
    );
    return (raw as Map<String, dynamic>)['message']?.toString() ??
        'Password updated.';
  }

  Future<AuthTokenResponse> exchangeOAuthCode({
    required String provider,
    required String code,
    String? state,
    String? redirectUri,
  }) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authLoginOAuth(provider),
      body: {
        'code': code,
        if (state != null && state.isNotEmpty) 'state': state,
        if (redirectUri != null && redirectUri.isNotEmpty)
          'redirectUri': redirectUri,
      },
    );
    return AuthTokenResponse.fromJson(raw as Map<String, dynamic>);
  }

  Future<String> verifyEmailToken(String token) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authVerifyEmail,
      body: {'token': token},
    );
    return (raw as Map<String, dynamic>)['message']?.toString() ??
        'Email verified successfully.';
  }

  Future<UserModel> fetchCurrentUser() async {
    await _net.assertConnection();
    final raw = await _api.get(ApiConstants.authMe);
    final response = UserResponse.fromJson(raw as Map<String, dynamic>);
    final user = response.data;
    if (user == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing user profile in auth response',
      );
    }
    return user;
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    await _net.assertConnection();
    await _api.patch(
      ApiConstants.authMe,
      body: {
        if (name != null && name.isNotEmpty) 'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
    );
  }

  Future<String> requestPhoneChange({required String newPhone}) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authPhoneChange,
      body: {'newPhone': newPhone},
    );
    return (raw as Map<String, dynamic>)['message']?.toString() ??
        'OTP sent to your new phone number.';
  }

  Future<String> verifyPhoneChange({
    required String newPhone,
    required String otp,
  }) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authPhoneChangeVerify,
      body: {'phone': newPhone, 'code': otp},
    );
    return (raw as Map<String, dynamic>)['message']?.toString() ??
        'Phone number updated.';
  }

  Future<void> registerDeviceToken(String token) async {
    await _net.assertConnection();
    await _api.patch(
      ApiConstants.authMeDevice,
      body: {'fcmToken': token, 'platform': 'android'},
    );
  }

  Future<UserModel> persistSession(AuthTokenResponse session) async {
    _ref.read(accessTokenProvider.notifier).state = session.accessToken;

    if (session.refreshToken != null && session.refreshToken!.isNotEmpty) {
      await _storage.saveRefreshToken(session.refreshToken!);
    }

    await _storage.saveUserType('player');

    final user = session.user ?? await fetchCurrentUser();
    if (user.id != null && user.id!.isNotEmpty) {
      await _storage.saveUserId(user.id!);
    }

    return user;
  }

  Future<void> logout() async {
    Object? pendingError;
    StackTrace? pendingStack;
    final refreshToken = await _storage.getRefreshToken();

    try {
      await _net.assertConnection();
      await _api.post(
        ApiConstants.authLogout,
        body: {
          if (refreshToken != null && refreshToken.isNotEmpty)
            'refreshToken': refreshToken,
        },
      );
    } catch (error, stackTrace) {
      pendingError = error;
      pendingStack = stackTrace;
    } finally {
      await clearLocalSession();
    }

    if (pendingError != null && pendingStack != null) {
      Error.throwWithStackTrace(pendingError, pendingStack);
    }
  }

  Future<void> clearLocalSession() async {
    _ref.read(accessTokenProvider.notifier).state = null;
    await _storage.clearAll();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
    ref,
  );
});
