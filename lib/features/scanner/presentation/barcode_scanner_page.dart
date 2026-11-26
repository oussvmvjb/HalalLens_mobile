import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../product/data/product_translation_repository.dart';
import '../../product/domain/product_details_language.dart';
import '../../product/domain/product_details_translation.dart';
import '../data/barcode_repository.dart';
import '../domain/barcode_lookup_result.dart';

class BarcodeScannerPage extends ConsumerStatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  ConsumerState<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends ConsumerState<BarcodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.itf,
      BarcodeFormat.qrCode,
    ],
  );

  final TextEditingController _barcodeController = TextEditingController();
  BarcodeLookupResult? _result;
  String? _lastSubmittedBarcode;
  String? _errorMessage;
  String? _errorCode;
  bool _isLoading = false;
  bool _errorRetryable = false;
  ProductDetailsLanguage _selectedLanguage = ProductDetailsLanguage.english;
  ProductDetailsLanguage? _translationLoadingLanguage;
  ProductDetailsLanguage? _translationErrorLanguage;
  final Map<ProductDetailsLanguage, ProductDetailsTranslation> _translations =
      {};
  final Map<ProductDetailsLanguage, Future<ProductDetailsTranslation>>
  _translationRequests = {};

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isLoading || _result != null || _errorMessage != null) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value != null && value.isNotEmpty) {
        await _lookup(value);
        return;
      }
    }
  }

  Future<void> _lookup(String barcode) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _lastSubmittedBarcode = barcode;
      _errorMessage = null;
      _errorCode = null;
      _errorRetryable = false;
      _translations.clear();
      _translationRequests.clear();
      _translationLoadingLanguage = null;
      _translationErrorLanguage = null;
    });

    try {
      if (_controller.value.isRunning) {
        await _controller.stop();
      }
      final result = await ref.read(barcodeRepositoryProvider).lookup(barcode);
      if (mounted) {
        setState(() => _result = result);
        unawaited(_ensureTranslation(result, _selectedLanguage));
      }
    } on ApiException catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = _errorMessageFor(error, l10n);
          _errorCode = error.errorCode;
          _errorRetryable = error.retryable;
        });
      }
    } on FormatException {
      if (mounted) {
        setState(
          () =>
              _errorMessage =
                  AppLocalizations.of(context)!.barcodeResponseInvalid,
        );
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[Barcode] Lookup failed: $error\n$stackTrace');
      }
      if (mounted) {
        setState(
          () =>
              _errorMessage = AppLocalizations.of(context)!.barcodeLookupFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _errorMessageFor(ApiException error, AppLocalizations l10n) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.statusCode == 504) {
      return l10n.requestTimeout;
    }
    if (error.type == DioExceptionType.connectionError ||
        error.statusCode == null) {
      return l10n.networkError;
    }
    return switch (error.statusCode) {
      404 => l10n.barcodeNotFound,
      422 => l10n.barcodeInvalid,
      429 => l10n.requestFailed,
      500 || 502 || 503 => l10n.barcodeLookupFailed,
      _ => l10n.barcodeLookupFailed,
    };
  }

  Future<void> _retry() async {
    final barcode = _lastSubmittedBarcode;
    if (barcode != null) await _lookup(barcode);
  }

  Future<void> _submitManualBarcode() async {
    final value = _barcodeController.text.trim();
    if (value.isEmpty || _isLoading) return;
    FocusScope.of(context).unfocus();
    await _lookup(value);
  }

  Future<void> _scanAnother() async {
    _barcodeController.clear();
    setState(() {
      _result = null;
      _lastSubmittedBarcode = null;
      _errorMessage = null;
      _errorCode = null;
      _errorRetryable = false;
      _translations.clear();
      _translationRequests.clear();
      _translationLoadingLanguage = null;
      _translationErrorLanguage = null;
    });
    await _controller.start();
  }

  Future<void> _selectProductLanguage(ProductDetailsLanguage language) async {
    if (_selectedLanguage == language) return;
    setState(() {
      _selectedLanguage = language;
      _translationErrorLanguage = null;
    });
    final result = _result;
    if (result != null) await _ensureTranslation(result, language);
  }

  Future<void> _ensureTranslation(
    BarcodeLookupResult result,
    ProductDetailsLanguage language,
  ) async {
    if (_translations.containsKey(language)) return;

    var request = _translationRequests[language];
    if (request == null) {
      setState(() {
        _translationLoadingLanguage = language;
        _translationErrorLanguage = null;
      });
      final product = result.product;
      request = ref
          .read(productTranslationRepositoryProvider)
          .translate(
            ProductDetailsText(
              productName: product.name,
              brand: product.brand,
              ingredients: product.ingredients,
              categories: product.categories,
              originDescription: product.originDescription,
              labels: product.labels,
              certificationIssuers: result.certifications
                  .map((certification) => certification.issuer)
                  .toList(growable: false),
              analysisExplanation: result.analysis.explanation,
            ),
            language.code,
          );
      _translationRequests[language] = request;
    } else if (_translationLoadingLanguage != language) {
      setState(() => _translationLoadingLanguage = language);
    }

    try {
      final translation = await request;
      if (!mounted || !identical(_result, result)) return;
      setState(() {
        _translations[language] = translation;
        if (_translationLoadingLanguage == language) {
          _translationLoadingLanguage = null;
        }
        _translationErrorLanguage = null;
      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[Translation] Product details translation failed: $error\n$stackTrace',
        );
      }
      if (mounted && identical(_result, result)) {
        setState(() {
          if (_translationLoadingLanguage == language) {
            _translationLoadingLanguage = null;
          }
          _translationErrorLanguage = language;
        });
      }
    } finally {
      if (identical(_translationRequests[language], request)) {
        _translationRequests.remove(language);
      }
      if (mounted &&
          identical(_result, result) &&
          _translationLoadingLanguage == language) {
        setState(() => _translationLoadingLanguage = null);
      }
    }
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    unawaited(_controller.dispose());
    super.dispose();
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
                      l10n.barcodeScannerTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.barcodeScannerHelp,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_result == null && _errorMessage == null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: constraints.maxWidth < 600 ? 320 : 420,
                          child: MobileScanner(
                            controller: _controller,
                            onDetect: _onDetect,
                            errorBuilder:
                                (context, error, child) =>
                                    _cameraError(context, error, l10n),
                            placeholderBuilder:
                                (context, child) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            overlayBuilder:
                                (context, constraints) => Center(
                                  child: Container(
                                    width: constraints.maxWidth * 0.78,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _manualBarcodeCard(l10n),
                    ],
                    if (_isLoading)
                      _StatusCard(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 12),
                            Text(l10n.barcodeLookupLoading),
                          ],
                        ),
                      ),
                    if (_errorMessage case final message?)
                      _errorCard(message, l10n),
                    if (_result case final result?) _productCard(result, l10n),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _manualBarcodeCard(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('manual-barcode-input'),
                controller: _barcodeController,
                enabled: !_isLoading,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.search,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (_) => _submitManualBarcode(),
                decoration: InputDecoration(
                  hintText: l10n.barcodeLabel,
                  prefixIcon: const Icon(Icons.qr_code_2_rounded),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              key: const Key('manual-barcode-submit'),
              onPressed: _isLoading ? null : _submitManualBarcode,
              icon: const Icon(Icons.search_rounded),
              label: Text(l10n.scanBarcode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cameraError(
    BuildContext context,
    MobileScannerException error,
    AppLocalizations l10n,
  ) {
    final message = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied => l10n.cameraPermissionDenied,
      MobileScannerErrorCode.unsupported => l10n.barcodeCameraUnsupported,
      _ => l10n.cameraUnavailableTryAgain,
    };
    return ColoredBox(
      color: AppTheme.secondaryBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_outlined, size: 40),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _controller.start,
                child: Text(l10n.cameraTryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorCard(String message, AppLocalizations l10n) {
    final showRetry = _errorRetryable || _errorCode == 'PRODUCT_NOT_FOUND';
    return _StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (showRetry)
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _retry,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retryLookup),
                ),
              FilledButton.icon(
                onPressed: _scanAnother,
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(l10n.scanAnotherProduct),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/scanner'),
                icon: const Icon(Icons.document_scanner_outlined),
                label: Text(l10n.scanIngredientsLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productCard(BarcodeLookupResult result, AppLocalizations l10n) {
    final product = result.product;
    final language = _selectedLanguage;
    final copy = language.copy;
    final translated = _translations[language]?.details;
    final ingredients = translated?.ingredients ?? product.ingredients;
    final categories = translated?.categories ?? product.categories;
    final labels = translated?.labels ?? product.labels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _productLanguageSelector(language),
        if (_translationErrorLanguage == language)
          _StatusCard(
            child: Directionality(
              textDirection:
                  language.isRightToLeft
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(copy.translationUnavailable)),
                ],
              ),
            ),
          ),
        Directionality(
          textDirection:
              language.isRightToLeft ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatusCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProductImage(url: product.imageUrl),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translated?.productName ??
                                product.name ??
                                copy.productInformationUnavailable,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if ((translated?.brand ?? product.brand)
                              case final brand?)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('${copy.brand}: $brand'),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SelectableText(
                              '${copy.barcode}: ${product.barcode}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _StatusCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${copy.analysis}: ${language.analysisStatus(result.analysis.status)}'
                      '${result.analysis.verdict != null ? ' (${result.analysis.verdict})' : ''}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translated?.analysisExplanation ??
                          result.analysis.explanation,
                    ),
                    if (result.analysis.analyzedAt != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Last analyzed: ${result.analysis.analyzedAt!.toLocal()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                    if (result.analysis.warnings.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      for (final warning in result.analysis.warnings)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '• $warning',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ),
                    ],
                    if (result.analysis.ingredientsAnalysis.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      for (final item in result.analysis.ingredientsAnalysis)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.originalText} — ${item.status.toUpperCase()}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (item.reason.isNotEmpty)
                                Text(
                                  item.reason,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              if (item.sources.isNotEmpty)
                                Text(
                                  'Evidence: ${item.sources.join(', ')}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.secondaryText,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              _infoCard(
                title: copy.ingredients,
                content:
                    ingredients.isEmpty
                        ? Text(copy.noIngredients)
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (
                              var index = 0;
                              index < ingredients.length;
                              index++
                            )
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: Text(
                                  '${index + 1}. ${ingredients[index]}',
                                ),
                              ),
                          ],
                        ),
              ),
              if (categories.isNotEmpty)
                _infoCard(
                  title: copy.categories,
                  content: Text(categories.join(', ')),
                ),
              if (product.countryOfOrigin != null ||
                  product.originDescription != null)
                _infoCard(
                  title: copy.origin,
                  content: Text(
                    translated?.originDescription ??
                        product.originDescription ??
                        product.countryOfOrigin!,
                  ),
                ),
              if (labels.isNotEmpty)
                _infoCard(title: copy.labels, content: Text(labels.join(', '))),
              if (product.nutriments.isNotEmpty)
                _infoCard(
                  title: copy.nutrition,
                  content: Text(
                    product.nutriments.entries
                        .map(
                          (entry) =>
                              '${language.nutrientLabel(entry.key)}: ${entry.value}',
                        )
                        .join('\n'),
                  ),
                ),
              _infoCard(
                title: copy.certifications,
                content:
                    result.certifications.isEmpty
                        ? Text(copy.noCertifications)
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (
                              var index = 0;
                              index < result.certifications.length;
                              index++
                            )
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${index < (translated?.certificationIssuers.length ?? 0) ? translated!.certificationIssuers[index] : result.certifications[index].issuer}'
                                  ' — ${language.verificationStatus(result.certifications[index].verificationStatus)}'
                                  '${result.certifications[index].certificateNumber == null ? '' : '\n${result.certifications[index].certificateNumber}'}',
                                ),
                              ),
                          ],
                        ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _scanAnother,
          icon: const Icon(Icons.qr_code_scanner),
          label: Text(l10n.scanAnotherProduct),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go('/scanner'),
          icon: const Icon(Icons.document_scanner_outlined),
          label: Text(l10n.scanIngredientsLabel),
        ),
      ],
    );
  }

  Widget _productLanguageSelector(ProductDetailsLanguage language) {
    final isTranslating = _translationLoadingLanguage == language;
    return _StatusCard(
      child: Directionality(
        textDirection:
            language.isRightToLeft ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          children: [
            const Icon(Icons.translate),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.copy.languageLabel),
                  DropdownButton<ProductDetailsLanguage>(
                    value: language,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: [
                      for (final option in ProductDetailsLanguage.values)
                        DropdownMenuItem(
                          value: option,
                          child: Text(option.label),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        unawaited(_selectProductLanguage(value));
                      }
                    },
                  ),
                  if (isTranslating) ...[
                    LinearProgressIndicator(
                      minHeight: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      language.copy.translating,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required Widget content}) {
    return _StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 14),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 88,
        height: 88,
        child:
            url == null
                ? const ColoredBox(
                  color: AppTheme.secondaryBackground,
                  child: Icon(Icons.inventory_2_outlined, size: 34),
                )
                : Image.network(
                  url!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const ColoredBox(
                        color: AppTheme.secondaryBackground,
                        child: Icon(Icons.inventory_2_outlined, size: 34),
                      ),
                ),
      ),
    );
  }
}
