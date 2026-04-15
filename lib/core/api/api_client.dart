import 'dart:convert';
import 'dart:io';
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
    return ApiException(statusCode: statusCode, message: 'Server error: $responseBody');
  }
}
