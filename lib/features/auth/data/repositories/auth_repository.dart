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

/// Profile fields the provider gave us, used to prefill the signup screen.
class OAuthPrefill {
  const OAuthPrefill({this.email, this.name, this.avatarUrl});

  final String? email;
  final String? name;
  final String? avatarUrl;

  factory OAuthPrefill.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const OAuthPrefill();
    return OAuthPrefill(
      email: json['email']?.toString(),
      name: json['name']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}

/// Outcome of phase 1 (`/auth/oauth/:provider/verify`).
sealed class OAuthVerifyResult {
  const OAuthVerifyResult();
}

/// Identity already maps to an account — we have a full session.
class OAuthExistingUser extends OAuthVerifyResult {
  const OAuthExistingUser(this.session);
  final AuthTokenResponse session;
}

/// No account yet — ask the user, then complete signup with [signupToken].
class OAuthNewUser extends OAuthVerifyResult {
  const OAuthNewUser({
    required this.provider,
    required this.signupToken,
    required this.prefill,
  });
  final String provider;
  final String signupToken;
  final OAuthPrefill prefill;
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

  /// Phase 1 — verify a provider identity. Google sends [idToken]; Discord
  /// sends [code] + [redirectUri]. Returns either an existing-user session or a
  /// new-user signup token (no account is created on the new-user path).
  Future<OAuthVerifyResult> oauthVerify({
    required String provider,
    String? idToken,
    String? accessToken,
    String? code,
    String? redirectUri,
  }) async {
    await _net.assertConnection();
    final body = <String, dynamic>{
      if (idToken != null && idToken.isNotEmpty) 'idToken': idToken,
      if (accessToken != null && accessToken.isNotEmpty)
        'accessToken': accessToken,
      if (code != null && code.isNotEmpty) 'code': code,
      if (redirectUri != null && redirectUri.isNotEmpty)
        'redirectUri': redirectUri,
    };

    final raw =
        await _api.post(ApiConstants.authOAuthVerify(provider), body: body)
            as Map<String, dynamic>;
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : const <String, dynamic>{};

    if (data['isNewUser'] == true) {
      final signupToken = data['signupToken']?.toString();
      if (signupToken == null || signupToken.isEmpty) {
        throw const ApiException(
          statusCode: 500,
          message: 'Missing signup token in OAuth verify response',
        );
      }
      return OAuthNewUser(
        provider: provider,
        signupToken: signupToken,
        prefill: OAuthPrefill.fromJson(
          data['prefill'] as Map<String, dynamic>?,
        ),
      );
    }

    return OAuthExistingUser(AuthTokenResponse.fromJson(raw));
  }

  /// Phase 2 — complete a social signup after the user confirms.
  Future<AuthTokenResponse> oauthCompleteSignup({
    required String signupToken,
    required String name,
    String? phone,
  }) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authOAuthSignup,
      body: {
        'signupToken': signupToken,
        'name': name,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
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

  Future<UserModel> updateProfile({String? name}) async {
    await _net.assertConnection();
    final raw = await _api.patch(
      ApiConstants.authMe,
      body: {if (name != null && name.isNotEmpty) 'name': name},
    );
    final data = (raw as Map<String, dynamic>)['data'];
    final payload = data is Map<String, dynamic> ? data['user'] : null;
    if (payload is! Map<String, dynamic>) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing updated user profile in auth response',
      );
    }
    return UserModel.fromJson(payload);
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

  Future<UserModel> verifyPhoneChange({
    required String newPhone,
    required String otp,
  }) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authPhoneChangeVerify,
      body: {'phone': newPhone, 'code': otp},
    );
    final data = (raw as Map<String, dynamic>)['data'];
    final payload = data is Map<String, dynamic> ? data['user'] : null;
    if (payload is! Map<String, dynamic>) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing updated user profile in phone change response',
      );
    }
    return UserModel.fromJson(payload);
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
