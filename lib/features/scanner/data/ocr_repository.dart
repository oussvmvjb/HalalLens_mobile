import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/network/api_client.dart';
import '../domain/ocr_text_result.dart';

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return ApiOcrRepository(ref.watch(apiClientProvider));
});

const defaultOcrLanguages = ['en', 'fr', 'ar'];
const ocrConnectTimeout = Duration(seconds: 15);
const ocrSendTimeout = Duration(minutes: 2);
const ocrReceiveTimeout = Duration(seconds: 660);

enum OcrRequestStage { uploading, preparingOcr, processingOcr }

abstract interface class OcrRepository {
  Future<OcrTextResult> extractText(
    XFile image, {
    List<String> languages = defaultOcrLanguages,
    ValueChanged<OcrRequestStage>? onStageChanged,
  });
}

class ApiOcrRepository implements OcrRepository {
  const ApiOcrRepository(this._dio);

  final Dio _dio;

  @override
  Future<OcrTextResult> extractText(
    XFile image, {
    List<String> languages = defaultOcrLanguages,
    ValueChanged<OcrRequestStage>? onStageChanged,
  }) async {
    onStageChanged?.call(OcrRequestStage.uploading);
    final imageBytes = await image.readAsBytes();
    if (imageBytes.isEmpty) {
      throw const FormatException('The selected image is empty.');
    }
    onStageChanged?.call(OcrRequestStage.preparingOcr);

    final requestUrl =
        '${_dio.options.baseUrl.replaceFirst(RegExp(r'/+$'), '')}/scan/extract-text';
    if (kDebugMode) {
      debugPrint(
        '[OCR] POST $requestUrl (multipart field: image, '
        '${imageBytes.length} bytes; languages: $languages)',
      );
    }

    try {
      final formData =
          FormData()
            ..files.add(
              MapEntry(
                'image',
                MultipartFile.fromBytes(imageBytes, filename: image.name),
              ),
            );
      for (final language in languages) {
        formData.fields.add(MapEntry('languages', language));
      }

      onStageChanged?.call(OcrRequestStage.processingOcr);
      final response = await _dio.post<Map<String, dynamic>>(
        '/scan/extract-text',
        data: formData,
        options: Options(
          connectTimeout: ocrConnectTimeout,
          sendTimeout: ocrSendTimeout,
          receiveTimeout: ocrReceiveTimeout,
        ),
      );
      if (kDebugMode) {
        debugPrint(
          '[OCR] HTTP ${response.statusCode} from '
          '${response.requestOptions.uri}',
        );
        debugPrint('[OCR] Response body: ${response.data}');
      }
      final data = response.data;
      if (data == null) {
        throw const FormatException('OCR response body is empty.');
      }
      return OcrTextResult.fromJson(data);
    } on DioException catch (error) {
      if (kDebugMode) {
        debugPrint(
          '[OCR] Request failed: ${error.type} ${error.message}; '
          'URL: ${error.requestOptions.uri}; '
          'status: ${error.response?.statusCode}; '
          'body: ${error.response?.data}',
        );
      }
      throw ApiException.fromDio(error);
    }
  }
}
