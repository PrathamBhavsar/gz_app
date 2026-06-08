import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses_admin.dart';
import '../../../../models/domain_admin.dart';

class AdminAuthRepository {
  AdminAuthRepository(this._api, this._net, this._storage, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;
  final Ref _ref;

  Future<AdminAuthTokenResponse> login({
    required String email,
    required String password,
  }) async {
    await _net.assertConnection();
    final raw = await _api.adminLogin(email: email, password: password);
    final response = AdminLoginResponse.fromJson(raw);
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing admin session in login response',
      );
    }
    return data;
  }

  Future<AdminAuthModel> fetchCurrentAdmin() async {
    await _net.assertConnection();
    final raw = await _api.getAdminProfile();
    final response = AdminProfileResponse.fromJson(raw);
    final admin = response.data;
    if (admin == null) {
      throw const ApiException(
        statusCode: 500,
        message: 'Missing admin profile in auth response',
      );
    }
    return admin;
  }

  Future<String> requestPasswordReset({required String email}) async {
    await _net.assertConnection();
    final raw = await _api.post(
      ApiConstants.authAdminPasswordResetRequest,
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
      ApiConstants.authAdminPasswordResetConfirm,
      body: {'token': token, 'newPassword': password},
    );
    return (raw as Map<String, dynamic>)['message']?.toString() ??
        'Password updated.';
  }

  Future<AdminAuthModel> persistSession(AdminAuthTokenResponse session) async {
    if (session.accessToken == null || session.accessToken!.isEmpty) {
      throw const ValidationException('Missing admin access token');
    }

    _ref.read(accessTokenProvider.notifier).state = session.accessToken;

    if (session.refreshToken != null && session.refreshToken!.isNotEmpty) {
      await _storage.saveRefreshToken(session.refreshToken!);
    }

    await _storage.saveUserType('admin');

    final admin = session.admin ?? await fetchCurrentAdmin();
    if (admin.id != null && admin.id!.isNotEmpty) {
      await _storage.saveUserId(admin.id!);
    }
    if (admin.role != null && admin.role!.isNotEmpty) {
      await _storage.saveAdminRole(admin.role!);
    }
    if (admin.storeId != null && admin.storeId!.isNotEmpty) {
      await _storage.saveAdminStoreId(admin.storeId!);
    }

    return admin;
  }

  Future<void> logout() async {
    Object? pendingError;
    StackTrace? pendingStack;
    final refreshToken = await _storage.getRefreshToken();

    try {
      await _net.assertConnection();
      await _api.adminLogout(refreshToken: refreshToken);
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

final adminAuthRepositoryProvider = Provider<AdminAuthRepository>((ref) {
  return AdminAuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
    ref,
  );
});
