import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.type,
    this.errorCode,
    this.retryable = false,
  });

  final String message;
  final int? statusCode;
  final DioExceptionType? type;
  final String? errorCode;
  final bool retryable;

  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseBody = error.response?.data;
    final errorCode = responseBody is Map ? responseBody['error_code'] : null;
    final retryable =
        responseBody is Map && responseBody['retryable'] is bool
            ? responseBody['retryable'] as bool
            : _isRetryable(statusCode, error.type);
    return ApiException(
      message: 'The request could not be completed.',
      statusCode: statusCode,
      type: error.type,
      errorCode: errorCode is String ? errorCode : null,
      retryable: retryable,
    );
  }

  static bool _isRetryable(int? statusCode, DioExceptionType type) {
    if (statusCode != null) {
      return statusCode == 429 ||
          statusCode == 500 ||
          statusCode == 503 ||
          statusCode == 504;
    }
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.connectionError;
  }

  @override
  String toString() => message;
}
