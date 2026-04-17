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

/// The kind of page-level error being displayed.
enum AppPageErrorKind {
  /// Backend returned an error, or parsing failed.
  serverError,

  /// No internet — actual ping to API server failed.
  noInternet,

  /// API succeeded but returned an empty list.
  empty,
}

/// Converts any exception into a displayable error for [PageErrorDisplay].
class AppPageError {
  const AppPageError({
    required this.title,
    required this.message,
    required this.icon,
    this.kind = AppPageErrorKind.serverError,
  });

  final String title;
  final String message;
  final String icon; // HugeIcon key / asset name
  final AppPageErrorKind kind;

  /// Pre-built error for no-internet state.
  static const noInternet = AppPageError(
    title: 'No Internet',
    message: 'Check your connection and tap Retry.',
    icon: 'wifi_off',
    kind: AppPageErrorKind.noInternet,
  );

  /// Pre-built error for empty-list state.
  static const empty = AppPageError(
    title: 'Nothing here yet',
    message: 'There are no items to show right now.',
    icon: 'inbox',
    kind: AppPageErrorKind.empty,
  );

  /// Map any exception to a friendly UI error.
  factory AppPageError.from(Object error) {
    if (error is NetworkException) {
      return const AppPageError(
        title: 'No Internet',
        message: 'Check your connection and tap Retry.',
        icon: 'wifi_off',
        kind: AppPageErrorKind.noInternet,
      );
    }
    if (error is ApiException) {
      return AppPageError(
        title: 'Something went wrong',
        message: error.message.isNotEmpty
            ? error.message
            : 'The server returned an error. Please try again.',
        icon: 'cloud_error',
        kind: AppPageErrorKind.serverError,
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
