import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import '../errors/app_exception.dart';
import '../auth/token_storage.dart';

class ApiClient {
  ApiClient({
    required this.baseUrl,
    this.getAccessToken,
    this.onRefreshToken,
    this.onLogout,
  });

  final String baseUrl;

  /// Returns the current in-memory access token (nullable).
  final String? Function()? getAccessToken;

  /// Called when a 401 is received — attempts silent token refresh.
  /// Returns the new access token on success, or null on failure.
  final Future<String?> Function()? onRefreshToken;

  /// Called when refresh fails — app should navigate to login.
  final Future<void> Function()? onLogout;

  // ─── Logging ───────────────────────────────────────────────────────

  void _logRequest(String method, String endpoint) {
    debugPrint('→ $method $endpoint');
  }

  void _logResponse(String endpoint, int statusCode, String body) {
    debugPrint('← $endpoint [$statusCode] ${_truncate(body, 200)}');
  }

  void _logParseError(String endpoint, Object error) {
    debugPrint('✗ $endpoint PARSE_ERROR: $error');
  }

  String _truncate(String s, int max) {
    return s.length > max ? '${s.substring(0, max)}…' : s;
  }

  // ─── Auth Headers ──────────────────────────────────────────────────

  Map<String, String> _buildHeaders({bool withAuth = true}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (withAuth) {
      final token = getAccessToken?.call();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ─── HTTP Methods ──────────────────────────────────────────────────

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    _logRequest('GET', endpoint);

    try {
      final response = await http.get(uri, headers: _buildHeaders());
      _logResponse(endpoint, response.statusCode, response.body);
      return await _handleResponse(
        endpoint,
        response,
        () => http.get(uri, headers: _buildHeaders()),
      );
    } on http.ClientException catch (e) {
      debugPrint('✗ $endpoint CLIENT_ERROR: $e');
      throw NetworkException('Cannot reach server');
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    _logRequest('POST', endpoint);
    if (body != null) debugPrint('  body: $body');

    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await http.post(
        uri,
        headers: _buildHeaders(),
        body: encodedBody,
      );
      _logResponse(endpoint, response.statusCode, response.body);
      return await _handleResponse(
        endpoint,
        response,
        () => http.post(uri, headers: _buildHeaders(), body: encodedBody),
      );
    } on http.ClientException catch (e) {
      debugPrint('✗ $endpoint CLIENT_ERROR: $e');
      throw NetworkException('Cannot reach server');
    }
  }

  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    _logRequest('PATCH', endpoint);

    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await http.patch(
        uri,
        headers: _buildHeaders(),
        body: encodedBody,
      );
      _logResponse(endpoint, response.statusCode, response.body);
      return await _handleResponse(
        endpoint,
        response,
        () => http.patch(uri, headers: _buildHeaders(), body: encodedBody),
      );
    } on http.ClientException catch (e) {
      debugPrint('✗ $endpoint CLIENT_ERROR: $e');
      throw NetworkException('Cannot reach server');
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    _logRequest('DELETE', endpoint);

    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await http.delete(
        uri,
        headers: _buildHeaders(),
        body: encodedBody,
      );
      _logResponse(endpoint, response.statusCode, response.body);
      return await _handleResponse(
        endpoint,
        response,
        () => http.delete(uri, headers: _buildHeaders(), body: encodedBody),
      );
    } on http.ClientException catch (e) {
      debugPrint('✗ $endpoint CLIENT_ERROR: $e');
      throw NetworkException('Cannot reach server');
    }
  }

  // ─── Admin Convenience Methods ─────────────────────────────────────

  /// Admin login via email + password.
  Future<Map<String, dynamic>> adminLogin({
    required String email,
    required String password,
  }) async {
    return (await post(
          ApiConstants.authAdminLogin,
          body: {'email': email, 'password': password},
        ))
        as Map<String, dynamic>;
  }

  /// Get current admin profile (validates admin token).
  Future<Map<String, dynamic>> getAdminProfile() async {
    return (await get(ApiConstants.authAdminMe)) as Map<String, dynamic>;
  }

  /// Admin logout — invalidates tokens server-side.
  Future<void> adminLogout({
    String? refreshToken,
    bool allDevices = false,
  }) async {
    await post(
      ApiConstants.authAdminLogout,
      body: {
        if (refreshToken != null) 'refreshToken': refreshToken,
        if (allDevices) 'all': true,
      },
    );
  }

  // ─── Response Handling ─────────────────────────────────────────────

  Future<dynamic> _handleResponse(
    String endpoint,
    http.Response response,
    Future<http.Response> Function() retry,
  ) async {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode == 401) {
      // Attempt silent refresh once
      if (onRefreshToken != null) {
        final newToken = await onRefreshToken!();
        if (newToken != null) {
          // Retry original request with updated headers (getAccessToken now returns new token)
          final retried = await retry();
          _logResponse('$endpoint [retry]', retried.statusCode, retried.body);
          if (retried.statusCode == 401) {
            await onLogout?.call();
            throw const UnauthorizedException('Session expired');
          }
          return _parseSuccess(endpoint, retried);
        }
      }
      await onLogout?.call();
      throw const UnauthorizedException('Session expired');
    }

    if (statusCode >= 400 && statusCode < 500) {
      // Try to extract server error message
      String errorMessage = 'Request failed';
      try {
        final parsed = jsonDecode(body) as Map<String, dynamic>;
        errorMessage =
            (parsed['message'] as String?) ??
            (parsed['error'] as String?) ??
            _truncate(body, 300);
      } catch (_) {
        errorMessage = _truncate(body, 300);
      }
      throw ValidationException(errorMessage);
    }

    if (statusCode >= 500) {
      throw ApiException(
        statusCode: statusCode,
        message: 'Server error: ${_truncate(body, 300)}',
      );
    }

    return _parseSuccess(endpoint, response);
  }

  dynamic _parseSuccess(String endpoint, http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      _logParseError(endpoint, e);
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Failed to parse server response',
      );
    }
  }
}

/// Global ApiClient provider — wired with token access + refresh logic.
/// The circular dependency (ApiClient needs AuthRepository, AuthRepository
/// needs ApiClient) is broken by passing closures that read Riverpod state
/// lazily at call-time rather than at construction time.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiConstants.baseUrl,
    getAccessToken: () => ref.read(accessTokenProvider),
    onRefreshToken: () async {
      // Lazy read to avoid circular dependency at construction
      final tokenStorage = ref.read(tokenStorageProvider);
      final storedToken = await tokenStorage.getRefreshToken();
      if (storedToken == null) return null;

      try {
        // Direct HTTP call — bypass ApiClient to avoid re-triggering 401 loop
        final uri = Uri.parse(
          '${ApiConstants.devBaseUrl}${ApiConstants.authRefresh}',
        );
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': storedToken}),
        );
        if (response.statusCode == 200) {
          final raw = jsonDecode(response.body) as Map<String, dynamic>;
          // Server wraps under { data: { accessToken, refreshToken? } }
          final payload = (raw['data'] is Map<String, dynamic>)
              ? raw['data'] as Map<String, dynamic>
              : raw;

          final newAccessToken = payload['accessToken'] as String?;
          final newRefreshToken = payload['refreshToken'] as String?;

          if (newAccessToken != null) {
            ref.read(accessTokenProvider.notifier).state = newAccessToken;
          }
          if (newRefreshToken != null) {
            await tokenStorage.saveRefreshToken(newRefreshToken);
          }
          debugPrint('↻ Token refreshed successfully');
          return newAccessToken;
        }
        debugPrint('↻ Token refresh failed: ${response.statusCode}');
        return null;
      } catch (e) {
        debugPrint('↻ Token refresh error: $e');
        return null;
      }
    },
    onLogout: () async {
      ref.read(accessTokenProvider.notifier).state = null;
      await ref.read(tokenStorageProvider).clearAll();
    },
  );
});
