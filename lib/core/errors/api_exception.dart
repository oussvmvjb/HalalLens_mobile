import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseBody = error.response?.data;
    final detail = responseBody is Map<String, dynamic> ? responseBody['detail'] : null;
    return ApiException(
      message: detail is String && detail.isNotEmpty
          ? detail
          : switch (error.type) {
              DioExceptionType.connectionTimeout ||
              DioExceptionType.receiveTimeout ||
              DioExceptionType.sendTimeout =>
                'The server took too long to respond.',
              DioExceptionType.connectionError => 'Could not connect to the server.',
              _ => 'The request could not be completed.',
            },
      statusCode: statusCode,
    );
  }

  @override
  String toString() => message;
}
