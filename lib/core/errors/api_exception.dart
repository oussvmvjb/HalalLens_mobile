import 'dart:io';

import 'package:dio/dio.dart';

enum ApiFailureKind {
  dns,
  ssl,
  connection,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  httpResponse,
  other,
}

class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.type,
    this.errorCode,
    this.failureKind = ApiFailureKind.other,
    this.retryable = false,
  });

  final String message;
  final int? statusCode;
  final DioExceptionType? type;
  final String? errorCode;
  final ApiFailureKind failureKind;
  final bool retryable;

  factory ApiException.fromDio(DioException error) {
    if (error.error case final ApiException apiException) {
      return apiException;
    }

    final statusCode = error.response?.statusCode;
    final responseBody = error.response?.data;
    final errorCode = responseBody is Map ? responseBody['error_code'] : null;
    final failureKind = _failureKindFor(error);
    final retryable =
        responseBody is Map && responseBody['retryable'] is bool
            ? responseBody['retryable'] as bool
            : _isRetryable(statusCode, failureKind);
    return ApiException(
      message: _messageFor(failureKind),
      statusCode: statusCode,
      type: error.type,
      errorCode: errorCode is String ? errorCode : null,
      failureKind: failureKind,
      retryable: retryable,
    );
  }

  static ApiFailureKind _failureKindFor(DioException error) {
    if (error.response != null || error.type == DioExceptionType.badResponse) {
      return ApiFailureKind.httpResponse;
    }
    if (error.type == DioExceptionType.badCertificate ||
        error.error is HandshakeException) {
      return ApiFailureKind.ssl;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiFailureKind.connectionTimeout;
      case DioExceptionType.sendTimeout:
        return ApiFailureKind.sendTimeout;
      case DioExceptionType.receiveTimeout:
        return ApiFailureKind.receiveTimeout;
      default:
        break;
    }

    if (error.error is SocketException) {
      final socketError = error.error as SocketException;
      final message =
          '${socketError.message} ${socketError.osError?.message ?? ''}'
              .toLowerCase();
      if (message.contains('failed host lookup') ||
          message.contains('no address associated with hostname') ||
          message.contains('nodename nor servname provided') ||
          message.contains('name or service not known') ||
          message.contains('temporary failure in name resolution')) {
        return ApiFailureKind.dns;
      }
      return ApiFailureKind.connection;
    }
    if (error.type == DioExceptionType.connectionError) {
      return ApiFailureKind.connection;
    }
    return ApiFailureKind.other;
  }

  static String _messageFor(ApiFailureKind failureKind) {
    return switch (failureKind) {
      ApiFailureKind.dns =>
        'Could not resolve the API host. Check your internet connection and try again.',
      ApiFailureKind.ssl =>
        'Could not establish a secure connection to the API. Check your network and try again.',
      ApiFailureKind.connection =>
        'Could not connect to the API. Check your internet connection and try again.',
      ApiFailureKind.connectionTimeout =>
        'The API connection timed out. The service may be starting; please try again.',
      ApiFailureKind.sendTimeout =>
        'Sending the request timed out. Check your connection and try again.',
      ApiFailureKind.receiveTimeout =>
        'The server took too long to respond. It may be starting; please try again.',
      ApiFailureKind.httpResponse ||
      ApiFailureKind.other => 'The request could not be completed.',
    };
  }

  static bool _isRetryable(int? statusCode, ApiFailureKind failureKind) {
    if (statusCode != null) {
      return statusCode == 429 ||
          statusCode == 500 ||
          statusCode == 503 ||
          statusCode == 504;
    }
    return failureKind == ApiFailureKind.dns ||
        failureKind == ApiFailureKind.connection ||
        failureKind == ApiFailureKind.connectionTimeout ||
        failureKind == ApiFailureKind.sendTimeout ||
        failureKind == ApiFailureKind.receiveTimeout;
  }

  @override
  String toString() => message;
}
