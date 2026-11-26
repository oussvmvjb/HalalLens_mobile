import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/ocr_repository.dart';
import '../domain/ocr_text_result.dart';

enum _OcrLanguageMode {
  englishFrenchArabic,
  english,
  french,
  arabic,
  chineseSimplified,
  chineseEnglish,
}

enum _ScanState {
  idle,
  uploading,
  preparingOcr,
  processingOcr,
  processingSlow,
  success,
  error,
}

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  final _picker = ImagePicker();
  XFile? _image;
  Uint8List? _imageBytes;
  OcrTextResult? _result;
  String? _errorMessage;
  bool _errorRetryable = false;
  bool _isWorking = false;
  _ScanState _scanState = _ScanState.idle;
  Timer? _slowProcessingTimer;
  _OcrLanguageMode _ocrLanguageMode = _OcrLanguageMode.englishFrenchArabic;

  Future<void> _pickImage(ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isWorking = true;
      _errorMessage = null;
      _errorRetryable = false;
      _scanState = _ScanState.idle;
    });
    try {
      final image = await _picker.pickImage(source: source);
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _image = image;
        _imageBytes = bytes;
        _result = null;
        _scanState = _ScanState.idle;
      });
    } on PlatformException {
      if (mounted) setState(() => _errorMessage = l10n.cameraUnavailable);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _extractText() async {
    final image = _image;
    if (image == null || _isWorking) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isWorking = true;
      _errorMessage = null;
      _errorRetryable = false;
      _scanState = _ScanState.uploading;
    });
    try {
      final result = await ref
          .read(ocrRepositoryProvider)
          .extractText(
            image,
            languages: _ocrLanguagesFor(_ocrLanguageMode),
            onStageChanged: _onOcrStageChanged,
          );
      if (mounted) {
        setState(() {
          _result = result;
          _scanState = _ScanState.success;
        });
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = _errorMessageFor(error, l10n);
          _errorRetryable = error.retryable;
          _scanState = _ScanState.error;
        });
      }
    } on FormatException {
      if (mounted) {
        setState(() {
          _errorMessage = l10n.ocrResponseInvalid;
          _scanState = _ScanState.error;
        });
      }
    } on PlatformException {
      if (mounted) {
        setState(() {
          _errorMessage = l10n.invalidImage;
          _scanState = _ScanState.error;
        });
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[OCR] Unexpected client error: $error\n$stackTrace');
      }
      if (mounted) {
        setState(() {
          _errorMessage = l10n.ocrGenericError;
          _scanState = _ScanState.error;
        });
      }
    } finally {
      _slowProcessingTimer?.cancel();
      if (mounted) setState(() => _isWorking = false);
    }
  }

  void _onOcrStageChanged(OcrRequestStage stage) {
    if (!mounted) return;
    final scanState = switch (stage) {
      OcrRequestStage.uploading => _ScanState.uploading,
      OcrRequestStage.preparingOcr => _ScanState.preparingOcr,
      OcrRequestStage.processingOcr => _ScanState.processingOcr,
    };
    setState(() => _scanState = scanState);
    if (stage == OcrRequestStage.processingOcr) {
      _slowProcessingTimer?.cancel();
      _slowProcessingTimer = Timer(const Duration(seconds: 30), () {
        if (mounted && _isWorking && _scanState == _ScanState.processingOcr) {
          setState(() => _scanState = _ScanState.processingSlow);
        }
      });
    }
  }

  List<String> _ocrLanguagesFor(_OcrLanguageMode mode) {
    return switch (mode) {
      _OcrLanguageMode.englishFrenchArabic => const ['en', 'fr', 'ar'],
      _OcrLanguageMode.english => const ['en'],
      _OcrLanguageMode.french => const ['fr'],
      _OcrLanguageMode.arabic => const ['ar'],
      _OcrLanguageMode.chineseSimplified => const ['zh_CN'],
      _OcrLanguageMode.chineseEnglish => const ['zh_CN', 'en'],
    };
  }

  String _ocrLanguageLabel(AppLocalizations l10n, _OcrLanguageMode mode) {
    return switch (mode) {
      _OcrLanguageMode.englishFrenchArabic =>
        l10n.ocrLanguageEnglishFrenchArabic,
      _OcrLanguageMode.english => l10n.ocrLanguageEnglish,
      _OcrLanguageMode.french => l10n.ocrLanguageFrench,
      _OcrLanguageMode.arabic => l10n.ocrLanguageArabic,
      _OcrLanguageMode.chineseSimplified => l10n.ocrLanguageChineseSimplified,
      _OcrLanguageMode.chineseEnglish => l10n.ocrLanguageChineseEnglish,
    };
  }

  String _errorMessageFor(ApiException error, AppLocalizations l10n) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.statusCode == 504) {
      return l10n.ocrTimeoutMessage;
    }
    if (error.type == DioExceptionType.connectionError ||
        error.statusCode == null) {
      return l10n.networkError;
    }
    return switch (error.statusCode) {
      400 => l10n.ocrRequestInvalid,
      413 => l10n.imageTooLarge,
      415 => l10n.unsupportedImage,
      422 => l10n.invalidImage,
      429 => l10n.ocrRateLimited,
      500 => l10n.serverError,
      503 => l10n.ocrUnavailable,
      _ => l10n.ocrGenericError,
    };
  }

  String? _scanStatusMessage(AppLocalizations l10n) {
    return switch (_scanState) {
      _ScanState.uploading => l10n.uploadingOcr,
      _ScanState.preparingOcr => l10n.preparingOcr,
      _ScanState.processingOcr => l10n.processingOcr,
      _ScanState.processingSlow => l10n.processingOcrSlow,
      _ScanState.success => l10n.ocrSuccess,
      _ScanState.idle || _ScanState.error => null,
    };
  }

  Future<void> _copyText(OcrTextResult result) async {
    if (result.fullText.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: result.fullText));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copySuccess)),
    );
  }

  void _rescan() {
    setState(() {
      _result = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 32.0;
        return ListView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            32,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.scannerTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.scannerDescription,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        PopupMenuButton<_OcrLanguageMode>(
                          tooltip: l10n.ocrLanguageLabel,
                          enabled: !_isWorking,
                          onSelected: (mode) {
                            setState(() {
                              _ocrLanguageMode = mode;
                              _result = null;
                            });
                          },
                          itemBuilder:
                              (context) => [
                                for (final mode in _OcrLanguageMode.values)
                                  PopupMenuItem(
                                    value: mode,
                                    child: Text(_ocrLanguageLabel(l10n, mode)),
                                  ),
                              ],
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.border),
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.language_rounded, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    _ocrLanguageLabel(l10n, _ocrLanguageMode),
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_drop_down, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.go('/barcode'),
                          icon: const Icon(Icons.qr_code_scanner, size: 18),
                          label: Text(l10n.scanBarcode),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(48, 40),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_imageBytes == null)
                      _ImagePickerCard(
                        prompt: l10n.selectImagePrompt,
                        takePhotoLabel: l10n.takePhoto,
                        chooseImageLabel: l10n.chooseImage,
                        busy: _isWorking,
                        onTakePhoto: () => _pickImage(ImageSource.camera),
                        onChooseImage: () => _pickImage(ImageSource.gallery),
                      )
                    else ...[
                      _ImagePreview(
                        bytes: _imageBytes!,
                        imageName: _image?.name ?? l10n.imagePreview,
                        label: l10n.imagePreview,
                        changeLabel: l10n.changeImage,
                        scanLabel: l10n.scanImage,
                        scanningLabel: l10n.scanningImage,
                        busy: _isWorking,
                        onChangeImage: () => _pickImage(ImageSource.gallery),
                        onScan: _extractText,
                      ),
                    ],
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _ErrorBanner(
                        message: _errorMessage!,
                        retryLabel: l10n.retryAction,
                        canRetry: _errorRetryable && _image != null,
                        onRetry: _extractText,
                      ),
                    ],
                    if (_scanStatusMessage(l10n) case final statusMessage?) ...[
                      const SizedBox(height: 16),
                      _ScanStatusBanner(
                        message: statusMessage,
                        isWorking: _isWorking,
                      ),
                    ],
                    if (_result case final result?) ...[
                      const SizedBox(height: 20),
                      if (result.halalAssessment != null) ...[
                        _HalalAssessmentCard(assessment: result.halalAssessment!),
                        const SizedBox(height: 16),
                      ],
                      _OcrResultCard(
                        result: result,
                        title: l10n.scanResults,
                        blocksTitle: l10n.recognizedBlocks,
                        ingredientsTitle: l10n.ingredientSuggestions,
                        originalTextLabel: l10n.originalOcrText,
                        suggestedTextLabel: l10n.normalizedSuggestion,
                        normalizationConfidenceLabel:
                            l10n.normalizationConfidenceLabel,
                        reviewRecommendedLabel: l10n.reviewRecommended,
                        warningsTitle: l10n.ocrWarnings,
                        emptyLabel: l10n.noTextDetected,
                        copyLabel: l10n.copyText,
                        confidenceLabel: l10n.confidenceLabel,
                        rescanLabel: l10n.scanAgain,
                        onCopy: () => _copyText(result),
                        onRescan: _rescan,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _slowProcessingTimer?.cancel();
    super.dispose();
  }
}

class _ImagePickerCard extends StatelessWidget {
  const _ImagePickerCard({
    required this.prompt,
    required this.takePhotoLabel,
    required this.chooseImageLabel,
    required this.busy,
    required this.onTakePhoto,
    required this.onChooseImage,
  });

  final String prompt;
  final String takePhotoLabel;
  final String chooseImageLabel;
  final bool busy;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseImage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.secondaryBackground,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.document_scanner_outlined, size: 34),
            ),
            const SizedBox(height: 16),
            Text(prompt, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: busy ? null : onTakePhoto,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(takePhotoLabel),
                ),
                OutlinedButton.icon(
                  onPressed: busy ? null : onChooseImage,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(chooseImageLabel),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    foregroundColor: AppTheme.darkGreen,
                    side: const BorderSide(color: AppTheme.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
            if (busy) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.bytes,
    required this.imageName,
    required this.label,
    required this.changeLabel,
    required this.scanLabel,
    required this.scanningLabel,
    required this.busy,
    required this.onChangeImage,
    required this.onScan,
  });

  final Uint8List bytes;
  final String imageName;
  final String label;
  final String changeLabel;
  final String scanLabel;
  final String scanningLabel;
  final bool busy;
  final VoidCallback onChangeImage;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Semantics(
              image: true,
              label: imageName,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 280,
                  width: double.infinity,
                  color: AppTheme.background,
                  alignment: Alignment.center,
                  child: Image.memory(bytes, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final changeButton = OutlinedButton.icon(
                  onPressed: busy ? null : onChangeImage,
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: Text(changeLabel),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    foregroundColor: AppTheme.darkGreen,
                    side: const BorderSide(color: AppTheme.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
                final scanButton = FilledButton.icon(
                  onPressed: busy ? null : onScan,
                  icon:
                      busy
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.text_snippet_outlined),
                  label: Text(busy ? scanningLabel : scanLabel),
                );
                if (constraints.maxWidth < 480) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      changeButton,
                      const SizedBox(height: 10),
                      scanButton,
                    ],
                  );
                }
                return Row(
                  children: [
                    changeButton,
                    const SizedBox(width: 12),
                    Expanded(child: scanButton),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OcrResultCard extends StatelessWidget {
  const _OcrResultCard({
    required this.result,
    required this.title,
    required this.blocksTitle,
    required this.ingredientsTitle,
    required this.originalTextLabel,
    required this.suggestedTextLabel,
    required this.normalizationConfidenceLabel,
    required this.reviewRecommendedLabel,
    required this.warningsTitle,
    required this.emptyLabel,
    required this.copyLabel,
    required this.confidenceLabel,
    required this.rescanLabel,
    required this.onCopy,
    required this.onRescan,
  });

  final OcrTextResult result;
  final String title;
  final String blocksTitle;
  final String ingredientsTitle;
  final String originalTextLabel;
  final String suggestedTextLabel;
  final String Function(String confidence) normalizationConfidenceLabel;
  final String reviewRecommendedLabel;
  final String warningsTitle;
  final String emptyLabel;
  final String copyLabel;
  final String Function(String confidence) confidenceLabel;
  final String rescanLabel;
  final VoidCallback onCopy;
  final VoidCallback onRescan;

  @override
  Widget build(BuildContext context) {
    final hasText = result.fullText.isNotEmpty;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: SelectableText(
                hasText ? result.fullText : emptyLabel,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: hasText ? AppTheme.mainText : AppTheme.secondaryText,
                ),
              ),
            ),
            if (result.extractedText.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                blocksTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              for (final (index, region) in result.extractedText.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          region.text,
                          key: ValueKey('ocr-region-$index'),
                          textDirection: _textDirectionFor(region.text),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          confidenceLabel(
                            (region.confidence * 100).toStringAsFixed(1),
                          ),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: AppTheme.secondaryText),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
            if (result.ingredients.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                ingredientsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              for (final (index, ingredient) in result.ingredients.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    key: ValueKey('ocr-ingredient-$index'),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '$originalTextLabel: ${ingredient.originalText}',
                          textDirection: _textDirectionFor(
                            ingredient.originalText,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (ingredient.normalizedText != null &&
                            ingredient.normalizedText !=
                                ingredient.originalText) ...[
                          const SizedBox(height: 4),
                          Text(
                            '$suggestedTextLabel: ${ingredient.normalizedText}',
                            textDirection: _textDirectionFor(
                              ingredient.normalizedText!,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          confidenceLabel(
                            (ingredient.confidence * 100).toStringAsFixed(1),
                          ),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: AppTheme.secondaryText),
                        ),
                        if (ingredient.normalizedText != null)
                          Text(
                            normalizationConfidenceLabel(
                              (ingredient.normalizationConfidence * 100)
                                  .toStringAsFixed(1),
                            ),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: AppTheme.secondaryText),
                          ),
                        if (ingredient.needsReview) ...[
                          const SizedBox(height: 4),
                          Text(
                            reviewRecommendedLabel,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: Colors.deepOrange),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
            if (result.warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                warningsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              for (final warning in result.warnings)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(warning),
                ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: hasText ? onCopy : null,
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(copyLabel),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    foregroundColor: AppTheme.darkGreen,
                    side: const BorderSide(color: AppTheme.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onRescan,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(rescanLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextDirection _textDirectionFor(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    required this.retryLabel,
    required this.canRetry,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final bool canRetry;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          if (canRetry) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(retryLabel),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScanStatusBanner extends StatelessWidget {
  const _ScanStatusBanner({required this.message, required this.isWorking});

  final String message;
  final bool isWorking;

  @override
  Widget build(BuildContext context) {
    final success = !isWorking;
    return Semantics(
      liveRegion: true,
      child: Container(
        key: const Key('ocr-status'),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: success ? AppTheme.lightGreen : AppTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (isWorking)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(Icons.check_circle_outline_rounded),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Halal Assessment Card  (Step 8 – color-coded ingredient results)
// ---------------------------------------------------------------------------

class _HalalAssessmentCard extends StatelessWidget {
  const _HalalAssessmentCard({required this.assessment});

  final HalalAssessment assessment;

  Color _statusColor(HalalIngredientStatus status) {
    return switch (status) {
      HalalIngredientStatus.halal => const Color(0xFF2E7D32),
      HalalIngredientStatus.haram => const Color(0xFFC62828),
      HalalIngredientStatus.doubtful => const Color(0xFFE65100),
      HalalIngredientStatus.conditional => const Color(0xFFE65100),
      HalalIngredientStatus.unknown => const Color(0xFF546E7A),
      HalalIngredientStatus.insufficientInformation => const Color(0xFF546E7A),
    };
  }

  Color _statusBackground(HalalIngredientStatus status) {
    return switch (status) {
      HalalIngredientStatus.halal => const Color(0xFFE8F5E9),
      HalalIngredientStatus.haram => const Color(0xFFFFEBEE),
      HalalIngredientStatus.doubtful => const Color(0xFFFFF3E0),
      HalalIngredientStatus.conditional => const Color(0xFFFFF3E0),
      HalalIngredientStatus.unknown => const Color(0xFFECEFF1),
      HalalIngredientStatus.insufficientInformation => const Color(0xFFECEFF1),
    };
  }

  IconData _statusIcon(HalalIngredientStatus status) {
    return switch (status) {
      HalalIngredientStatus.halal => Icons.check_circle_rounded,
      HalalIngredientStatus.haram => Icons.cancel_rounded,
      HalalIngredientStatus.doubtful => Icons.warning_amber_rounded,
      HalalIngredientStatus.conditional => Icons.help_outline_rounded,
      HalalIngredientStatus.unknown => Icons.device_unknown_rounded,
      HalalIngredientStatus.insufficientInformation => Icons.device_unknown_rounded,
    };
  }

  String _statusLabel(HalalIngredientStatus status) {
    return switch (status) {
      HalalIngredientStatus.halal => 'Halal',
      HalalIngredientStatus.haram => 'Haram',
      HalalIngredientStatus.doubtful => 'Doubtful',
      HalalIngredientStatus.conditional => 'Conditional',
      HalalIngredientStatus.unknown => 'Unknown',
      HalalIngredientStatus.insufficientInformation => 'Insufficient Info',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verdictColor = _statusColor(assessment.overallStatus);
    final verdictBg = _statusBackground(assessment.overallStatus);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Overall verdict banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: verdictBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: verdictColor.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(_statusIcon(assessment.overallStatus), color: verdictColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halal Analysis — ${_statusLabel(assessment.overallStatus)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: verdictColor,
                          ),
                        ),
                        if (assessment.confidenceScore != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Confidence: ${(assessment.confidenceScore! * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.labelMedium?.copyWith(color: verdictColor),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Explanation
            if (assessment.explanation.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                assessment.explanation,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ],
            // Warnings
            if (assessment.warnings.isNotEmpty) ...[
              const SizedBox(height: 10),
              for (final warning in assessment.warnings)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Color(0xFFE65100)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          warning,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFE65100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            // Per-ingredient color-coded chips
            if (assessment.ingredientsAnalysis.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                'Ingredients',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final ing in assessment.ingredientsAnalysis)
                    _IngredientChip(
                      name: ing.originalName,
                      status: ing.status,
                      statusColor: _statusColor(ing.status),
                      bgColor: _statusBackground(ing.status),
                      icon: _statusIcon(ing.status),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.bgColor,
    required this.icon,
  });

  final String name;
  final HalalIngredientStatus status;
  final Color statusColor;
  final Color bgColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: statusColor),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
