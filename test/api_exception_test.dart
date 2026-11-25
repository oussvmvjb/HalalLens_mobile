import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halal_lens/core/errors/api_exception.dart';

void main() {
  for (final (statusCode, retryable) in <(int, bool)>[
    (400, false),
    (413, false),
    (415, false),
    (422, false),
    (429, true),
    (500, true),
    (503, true),
    (504, true),
  ]) {
    test(
      'maps HTTP $statusCode retryability without exposing server details',
      () {
        final requestOptions = RequestOptions(path: '/scan/extract-text');
        final exception = ApiException.fromDio(
          DioException(
            requestOptions: requestOptions,
            response: Response<Map<String, dynamic>>(
              requestOptions: requestOptions,
              statusCode: statusCode,
              data: {
                'success': false,
                'error_code': 'TEST_ERROR',
                'message': 'internal path and traceback',
                'retryable': retryable,
              },
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        expect(exception.statusCode, statusCode);
        expect(exception.errorCode, 'TEST_ERROR');
        expect(exception.failureKind, ApiFailureKind.httpResponse);
        expect(exception.retryable, retryable);
        expect(exception.message, isNot(contains('internal path')));
      },
    );
  }

  test('marks connection interruptions retryable', () {
    final exception = ApiException.fromDio(
      DioException(
        requestOptions: RequestOptions(path: '/scan/extract-text'),
        type: DioExceptionType.connectionError,
      ),
    );

    expect(exception.retryable, isTrue);
    expect(exception.statusCode, isNull);
    expect(exception.failureKind, ApiFailureKind.connection);
  });

  test('classifies DNS failures without exposing the hostname', () {
    const hostname = 'private.example.test';
    final exception = ApiException.fromDio(
      DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.connectionError,
        error: const SocketException("Failed host lookup: '$hostname'"),
      ),
    );

    expect(exception.failureKind, ApiFailureKind.dns);
    expect(exception.retryable, isTrue);
    expect(exception.message, contains('resolve'));
    expect(exception.message, isNot(contains(hostname)));
  });

  test('classifies TLS failures and does not mark them retryable', () {
    final exception = ApiException.fromDio(
      DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.connectionError,
        error: HandshakeException('certificate details must not be surfaced'),
      ),
    );

    expect(exception.failureKind, ApiFailureKind.ssl);
    expect(exception.retryable, isFalse);
    expect(exception.message, contains('secure connection'));
    expect(exception.message, isNot(contains('certificate details')));
  });

  test('provides a cold-start-friendly message for connection timeouts', () {
    final exception = ApiException.fromDio(
      DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.connectionTimeout,
      ),
    );

    expect(exception.failureKind, ApiFailureKind.connectionTimeout);
    expect(exception.retryable, isTrue);
    expect(exception.message, contains('may be starting'));
  });
}
