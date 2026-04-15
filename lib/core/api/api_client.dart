import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/app_exception.dart';

class ApiClient {
  ApiClient({required this.baseUrl});

  final String baseUrl;

  // Real implementation will use HTTP or Dio plugin.
  // This serves as the placeholder for the refactored layer.

  Future<dynamic> get(String endpoint) async {
    // Placeholder HTTP GET format intercepting API & Network logic.
    throw UnimplementedError('HTTP client not integrated yet.');
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    // Placeholder HTTP POST
    throw UnimplementedError('HTTP client not integrated yet.');
  }

  /// Maps typical HTTP status ranges to Typed app exceptions.
  Exception _handleError(int statusCode, String responseBody) {
    if (statusCode == 401) {
      return const UnauthorizedException('Session expired');
    }
    if (statusCode >= 400 && statusCode < 500) {
      return ValidationException('Validation failed: $responseBody');
    }
    return ApiException(
      statusCode: statusCode,
      message: 'Server error: $responseBody',
    );
  }
}

/// Global ApiClient provider — shared across all services
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'http://192.168.1.4:3000/v1');
});
