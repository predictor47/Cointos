import 'package:dio/dio.dart';
import 'package:your_app_name/core/utils/error_handler.dart';
import 'error_interceptor.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl;

  ApiService({required this.baseUrl}) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      if (parser != null) {
        return parser(response.data);
      }
      return response.data as T;
    } catch (e) {
      throw _handleError(e);
    }
  }

  AppError _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return AppError('Connection timeout', ErrorType.network);
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
        case DioExceptionType.cancel:
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return AppError(error.message ?? 'Network error', ErrorType.network);
      }
    }
    return AppError('Unknown error', ErrorType.unknown);
  }
} 