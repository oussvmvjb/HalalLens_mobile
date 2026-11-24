import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/application/locale_controller.dart';
import 'l10n/generated/app_localizations.dart';

class HalalLensApp extends ConsumerWidget {
  const HalalLensApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider).valueOrNull ?? const Locale('en');
    return MaterialApp.router(
      title: 'HalalLens',
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light(locale.languageCode),
      routerConfig: router,
    );
  }
}
