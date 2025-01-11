import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error is AppError) {
      return error.message;
    }
    return error.toString();
  }

  static AppError handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    if (error is FirebaseAuthException) {
      return _handleFirebaseError(error);
    }
    return AppError(error.toString(), ErrorType.unknown);
  }

  static AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError('Connection timeout', ErrorType.network);
      default:
        return AppError(error.message ?? 'Network error', ErrorType.network);
    }
  }

  static AppError _handleFirebaseError(FirebaseAuthException error) {
    return AppError(error.message ?? 'Authentication error', ErrorType.authentication);
  }
}

class AppError {
  final String message;
  final ErrorType type;

  AppError(this.message, this.type);
}

enum ErrorType {
  network,
  authentication,
  server,
  unknown,
} 