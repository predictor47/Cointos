class AppError implements Exception {
  final String message;
  final ErrorType type;

  AppError(this.message, this.type);
}

enum ErrorType {
  network,
  authentication,
  server,
  validation,
  unknown
}

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error is AppError) {
      return error.message;
    }
    // Handle other error types
    return 'An unexpected error occurred';
  }
} 