import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/network/api_client.dart';

final localeProvider = AsyncNotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends AsyncNotifier<Locale> {
  late TokenStorage _storage;

  @override
  Future<Locale> build() async {
    _storage = ref.watch(tokenStorageProvider);
    final savedLocale = await _storage.read(key: StorageKeys.appLocale);
    return _localeFor(savedLocale);
  }

  Future<void> setLanguage(String languageCode) async {
    if (!const {'en', 'fr', 'ar', 'zh_CN'}.contains(languageCode)) {
      throw ArgumentError.value(languageCode, 'languageCode');
    }

    final previous = state.valueOrNull ?? const Locale('en');
    final selected = _localeFor(languageCode);
    state = AsyncData(selected);
    try {
      await _storage.write(key: StorageKeys.appLocale, value: languageCode);
    } catch (error, stackTrace) {
      state = AsyncData(previous);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Locale _localeFor(String? languageCode) {
    return switch (languageCode) {
      'fr' => const Locale('fr'),
      'ar' => const Locale('ar'),
      'zh_CN' => const Locale('zh', 'CN'),
      _ => const Locale('en'),
    };
  }
}
