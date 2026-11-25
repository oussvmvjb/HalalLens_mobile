import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:halal_lens/features/scanner/data/ocr_repository.dart';

class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter(this.onRequest, {this.delay = Duration.zero});

  final void Function(RequestOptions options) onRequest;
  final Duration delay;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    onRequest(options);
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    return ResponseBody.fromString(
      jsonEncode({
        'success': true,
        'language': ['zh_CN', 'en'],
        'full_text': '配料表：水，AQUA',
        'extracted_text': [
          {'text': '配料表：水，AQUA', 'confidence': 0.98, 'bounding_box': []},
        ],
        'ingredients': [
          {
            'original_text': '水',
            'normalized_text': '水',
            'confidence': 0.98,
            'normalization_confidence': 1.0,
            'needs_review': false,
          },
        ],
        'warnings': [],
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'uploads image and languages, reports stages, and parses slow responses',
    () async {
      RequestOptions? request;
      final stages = <OcrRequestStage>[];
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api/v1'))
        ..httpClientAdapter = _CapturingAdapter(
          (options) => request = options,
          delay: const Duration(milliseconds: 50),
        );

      final result = await ApiOcrRepository(dio).extractText(
        XFile.fromData(
          Uint8List.fromList([0x89, 0x50, 0x4e, 0x47]),
          path: r'C:\tmp\soap.png',
        ),
        languages: const ['zh_CN', 'en'],
        onStageChanged: stages.add,
      );

      expect(request?.method, 'POST');
      expect(
        request?.uri.toString(),
        'http://localhost:8000/api/v1/scan/extract-text',
      );
      expect(request?.connectTimeout, ocrConnectTimeout);
      expect(request?.sendTimeout, ocrSendTimeout);
      expect(request?.receiveTimeout, ocrReceiveTimeout);
      expect(
        ocrConnectTimeout,
        greaterThanOrEqualTo(const Duration(seconds: 60)),
      );
      expect(ocrSendTimeout, greaterThanOrEqualTo(const Duration(minutes: 2)));
      expect(ocrReceiveTimeout, greaterThan(const Duration(seconds: 600)));
      final formData = request?.data as FormData;
      expect(formData.files.single.key, 'image');
      expect(formData.files.single.value.filename, 'soap.png');
      expect(
        formData.fields
            .where((field) => field.key == 'languages')
            .map((field) => field.value),
        ['zh_CN', 'en'],
      );
      expect(result.language, ['zh_CN', 'en']);
      expect(result.fullText, '配料表：水，AQUA');
      expect(result.ingredients.single.originalText, '水');
      expect(stages, [
        OcrRequestStage.uploading,
        OcrRequestStage.preparingOcr,
        OcrRequestStage.processingOcr,
      ]);

      dio.close(force: true);
    },
  );
}
