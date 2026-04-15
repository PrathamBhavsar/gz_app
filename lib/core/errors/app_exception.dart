// Typed exceptions for propagation through layers
class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);
  final String message;
}

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message});
  final int statusCode;
  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized']);
  final String message;
}

class ValidationException implements Exception {
  const ValidationException(this.message);
  final String message;
}

/// Converts any exception into a displayable error for [PageErrorDisplay].
class AppPageError {
  const AppPageError({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final String icon; // HugeIcon key / asset name

  /// Map any exception to a friendly UI error.
  factory AppPageError.from(Object error) {
    if (error is NetworkException) {
      return const AppPageError(
        title: 'No Internet',
        message: 'Check your connection and tap Retry.',
        icon: 'wifi_off',
      );
    }
    if (error is ApiException) {
      return AppPageError(
        title: 'Something went wrong',
        message: error.message.isNotEmpty
            ? error.message
            : 'The server returned an error. Please try again.',
        icon: 'cloud_error',
      );
    }
    if (error is UnauthorizedException) {
      return const AppPageError(
        title: 'Session expired',
        message: 'Please log in again.',
        icon: 'lock',
      );
    }
    // Fallback for any untyped error
    return const AppPageError(
      title: 'Unexpected Error',
      message: 'Something went wrong. Please try again.',
      icon: 'alert_circle',
    );
  }
}
