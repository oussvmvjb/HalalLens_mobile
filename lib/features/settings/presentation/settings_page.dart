import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/locale_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider).valueOrNull ?? const Locale('en');

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 32.0;
        return ListView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            24,
            horizontalPadding,
            32,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.settingsTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.settingsSubtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.language_rounded),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.languageSettingsTitle,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.languageSettingsDescription,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color: AppTheme.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _LanguageOption(
                              title: l10n.languageEnglish,
                              subtitle: 'English',
                              selected: locale.languageCode == 'en',
                              onTap:
                                  () =>
                                      _selectLanguage(context, ref, 'en', l10n),
                            ),
                            _LanguageOption(
                              title: l10n.languageFrench,
                              subtitle: 'Français',
                              selected: locale.languageCode == 'fr',
                              onTap:
                                  () =>
                                      _selectLanguage(context, ref, 'fr', l10n),
                            ),
                            _LanguageOption(
                              title: l10n.languageArabic,
                              subtitle: 'العربية',
                              selected: locale.languageCode == 'ar',
                              onTap:
                                  () =>
                                      _selectLanguage(context, ref, 'ar', l10n),
                            ),
                            _LanguageOption(
                              title: l10n.languageChinese,
                              subtitle: '简体中文',
                              selected:
                                  locale.languageCode == 'zh' &&
                                  locale.countryCode == 'CN',
                              onTap:
                                  () => _selectLanguage(
                                    context,
                                    ref,
                                    'zh_CN',
                                    l10n,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectLanguage(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
    AppLocalizations l10n,
  ) async {
    try {
      await ref.read(localeProvider.notifier).setLanguage(languageCode);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.languageSaveError)));
      }
    }
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: selected ? AppTheme.darkGreen : AppTheme.secondaryText,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
