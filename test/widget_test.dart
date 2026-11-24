import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:halal_lens/app.dart';
import 'package:halal_lens/core/constants/storage_keys.dart';
import 'package:halal_lens/core/errors/api_exception.dart';
import 'package:halal_lens/core/network/api_client.dart';
import 'package:halal_lens/features/authentication/data/auth_repository.dart';
import 'package:halal_lens/features/authentication/domain/auth_user.dart';
import 'package:halal_lens/features/scanner/data/ocr_repository.dart';
import 'package:halal_lens/features/scanner/domain/ocr_text_result.dart';

class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository();

  static const user = AuthUser(
    id: 'test-user',
    fullName: 'Amina Example',
    email: 'amina@example.com',
    preferredLanguage: 'en',
    isActive: true,
  );

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async => user;

  @override
  Future<AuthUser> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async => user;

  @override
  Future<AuthUser?> restoreSession() async => null;

  @override
  Future<void> signOut() async {}
}

class MemoryTokenStorage implements TokenStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }
}

class FakeImagePickerPlatform extends ImagePickerPlatform {
  FakeImagePickerPlatform(this.imageBytes);

  final List<int> imageBytes;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    return XFile.fromData(
      Uint8List.fromList(imageBytes),
      name: 'label.png',
      mimeType: 'image/png',
    );
  }
}

class FakeOcrRepository implements OcrRepository {
  FakeOcrRepository(this.onExtract);

  final Future<OcrTextResult> Function(
    XFile image,
    List<String> languages,
    ValueChanged<OcrRequestStage>? onStageChanged,
  )
  onExtract;
  int calls = 0;

  @override
  Future<OcrTextResult> extractText(
    XFile image, {
    List<String> languages = defaultOcrLanguages,
    ValueChanged<OcrRequestStage>? onStageChanged,
  }) {
    calls += 1;
    return onExtract(image, languages, onStageChanged);
  }
}

OcrTextResult successfulOcrResult() => OcrTextResult.fromJson({
  'success': true,
  'language': ['en'],
  'full_text': 'AQUA',
  'extracted_text': [
    {'text': 'AQUA', 'confidence': 0.98, 'bounding_box': []},
  ],
  'ingredients': [],
  'warnings': [],
});

Future<void> pumpApp(
  WidgetTester tester,
  MemoryTokenStorage storage, {
  OcrRepository? ocrRepository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(const FakeAuthRepository()),
        tokenStorageProvider.overrideWithValue(storage),
        if (ocrRepository != null)
          ocrRepositoryProvider.overrideWithValue(ocrRepository),
      ],
      child: const HalalLensApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('home exposes scanner, settings, and account actions', (
    tester,
  ) async {
    await pumpApp(tester, MemoryTokenStorage());

    expect(find.text('HalalLens'), findsOneWidget);
    expect(find.text('Fresh choices, made simple.'), findsOneWidget);
    expect(find.byTooltip('Scanner'), findsOneWidget);
    expect(find.byTooltip('Settings'), findsOneWidget);
    expect(find.byTooltip('Log in'), findsOneWidget);
  });

  testWidgets(
    'registration, profile, logout, login, and password toggle work',
    (tester) async {
      await pumpApp(tester, MemoryTokenStorage());

      await tester.tap(find.byTooltip('Log in'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('auth-submit')), findsOneWidget);

      await tester.tap(find.text('New to HalalLens? Sign up'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('auth-full-name')),
        'Amina Example',
      );
      await tester.enterText(
        find.byKey(const Key('auth-email')),
        'amina@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('auth-password')),
        'a-secure-password-123',
      );
      await tester.ensureVisible(find.byKey(const Key('auth-submit')));
      await tester.tap(find.byKey(const Key('auth-submit')));
      await tester.pumpAndSettle();

      expect(find.text('Amina Example'), findsOneWidget);
      expect(find.text('amina@example.com'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Log out'),
        120,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();
      expect(find.text('Fresh choices, made simple.'), findsOneWidget);

      await tester.tap(find.byTooltip('Log in'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('auth-email')),
        'amina@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('auth-password')),
        'a-secure-password-123',
      );
      await tester.tap(find.byKey(const Key('auth-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Amina Example'), findsOneWidget);
    },
  );

  testWidgets('layout fits phone and tablet viewport widths', (tester) async {
    final storage = MemoryTokenStorage();
    for (final width in <double>[320, 360, 375, 390, 414, 768]) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 800);
      await pumpApp(tester, storage);
      expect(tester.takeException(), isNull, reason: 'home at $width px');

      await tester.tap(find.byTooltip('Log in'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'auth at $width px');
      expect(find.byKey(const Key('auth-password')), findsOneWidget);

      await tester.tap(find.byTooltip('Show password'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(
              find.descendant(
                of: find.byKey(const Key('auth-password')),
                matching: find.byType(EditableText),
              ),
            )
            .obscureText,
        isFalse,
      );
      await tester.tap(find.byTooltip('Hide password'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back to home'));
      await tester.pumpAndSettle();
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('language setting persists and switches layout direction', (
    tester,
  ) async {
    final storage = MemoryTokenStorage();
    await pumpApp(tester, storage);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Arabic'));
    await tester.pumpAndSettle();

    expect(find.text('الإعدادات'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('الإعدادات'))),
      TextDirection.rtl,
    );
    expect(storage.values[StorageKeys.appLocale], 'ar');

    await tester.tap(find.text('الإنجليزية'));
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.text('Settings'))),
      TextDirection.ltr,
    );
    expect(storage.values[StorageKeys.appLocale], 'en');

    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();
    expect(find.text('Paramètres'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Paramètres'))),
      TextDirection.ltr,
    );
    expect(storage.values[StorageKeys.appLocale], 'fr');

    await tester.tap(find.text('Chinois simplifié'));
    await tester.pumpAndSettle();
    expect(find.text('设置'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('设置'))),
      TextDirection.ltr,
    );
    expect(storage.values[StorageKeys.appLocale], 'zh_CN');
  });

  testWidgets('scanner exposes Chinese and mixed Chinese-English OCR modes', (
    tester,
  ) async {
    await pumpApp(tester, MemoryTokenStorage());

    await tester.tap(find.byTooltip('Scanner'));
    await tester.pumpAndSettle();
    expect(find.text('English + French + Arabic'), findsOneWidget);

    await tester.tap(find.text('English + French + Arabic'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chinese + English'));
    await tester.pumpAndSettle();
    expect(find.text('Chinese + English'), findsOneWidget);
  });

  testWidgets('scanner keeps waiting on slow OCR and announces success', (
    tester,
  ) async {
    final previousPicker = ImagePickerPlatform.instance;
    ImagePickerPlatform.instance = FakeImagePickerPlatform(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/l1sAAAAASUVORK5CYII=',
      ),
    );
    final result = Completer<OcrTextResult>();
    final repository = FakeOcrRepository((
      image,
      languages,
      onStageChanged,
    ) async {
      onStageChanged?.call(OcrRequestStage.uploading);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      onStageChanged?.call(OcrRequestStage.preparingOcr);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      onStageChanged?.call(OcrRequestStage.processingOcr);
      return result.future;
    });

    try {
      await pumpApp(tester, MemoryTokenStorage(), ocrRepository: repository);
      await tester.tap(find.byTooltip('Scanner'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose an image'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Extract text'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Extract text'));
      await tester.pump();
      expect(find.text('Uploading your product image...'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.text('Preparing the scanner...'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text('Reading the product label...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(repository.calls, 1);
      expect(find.text('Reading text…'), findsOneWidget);

      await tester.pump(const Duration(seconds: 30));
      expect(
        find.text('This is taking a little longer than usual. Please wait...'),
        findsOneWidget,
      );
      expect(repository.calls, 1);

      result.complete(successfulOcrResult());
      await tester.pumpAndSettle();
      expect(find.text('Product text extracted successfully!'), findsOneWidget);
    } finally {
      ImagePickerPlatform.instance = previousPicker;
    }
  });

  testWidgets('retry reuses the selected image after a retryable failure', (
    tester,
  ) async {
    final previousPicker = ImagePickerPlatform.instance;
    ImagePickerPlatform.instance = FakeImagePickerPlatform(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/l1sAAAAASUVORK5CYII=',
      ),
    );
    var attempt = 0;
    final repository = FakeOcrRepository((
      image,
      languages,
      onStageChanged,
    ) async {
      attempt += 1;
      if (attempt == 1) {
        throw const ApiException(
          message: 'A retryable OCR failure.',
          statusCode: 503,
          retryable: true,
        );
      }
      return successfulOcrResult();
    });

    try {
      await pumpApp(tester, MemoryTokenStorage(), ocrRepository: repository);
      await tester.tap(find.byTooltip('Scanner'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose an image'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Extract text'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Extract text'));
      await tester.pumpAndSettle();
      expect(
        find.text('Text recognition is temporarily unavailable.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Change image'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(repository.calls, 2);
      expect(find.text('Product text extracted successfully!'), findsOneWidget);
    } finally {
      ImagePickerPlatform.instance = previousPicker;
    }
  });
}
