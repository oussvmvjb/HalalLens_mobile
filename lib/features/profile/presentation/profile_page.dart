import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../authentication/application/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(authControllerProvider);
    final user = session.valueOrNull;

    if (session.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 64,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(height: 20),
                Text(
                  session.hasError
                      ? l10n.profileSessionError
                      : l10n.profileLoginPrompt,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.go('/authentication'),
                  child: Text(l10n.profileLoginAction),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                      l10n.profileTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: AppTheme.lightGreen,
                              child: Text(
                                user.fullName.trim().isEmpty
                                    ? '?'
                                    : user.fullName
                                        .trim()
                                        .substring(0, 1)
                                        .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: AppTheme.darkGreen),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.fullName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.email_outlined),
                            title: Text(l10n.email),
                            subtitle: Text(user.email),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: const Icon(Icons.language),
                            title: Text(l10n.preferredLanguage),
                            subtitle: Text(
                              user.preferredLanguage.toLowerCase() == 'ar'
                                  ? l10n.languageArabic
                                  : user.preferredLanguage.toLowerCase() == 'fr'
                                  ? l10n.languageFrench
                                  : user.preferredLanguage.toLowerCase() == 'en'
                                  ? l10n.languageEnglish
                                  : user.preferredLanguage.toLowerCase() ==
                                      'zh_cn'
                                  ? l10n.languageChinese
                                  : user.preferredLanguage.toUpperCase(),
                            ),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: Icon(
                              user.isActive
                                  ? Icons.verified_user_outlined
                                  : Icons.block,
                            ),
                            title: Text(l10n.accountStatus),
                            subtitle: Text(
                              user.isActive ? l10n.active : l10n.inactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          await ref
                              .read(authControllerProvider.notifier)
                              .signOut();
                          if (context.mounted) context.go('/');
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.requestFailed)),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(l10n.logOut),
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
              ),
            ),
          ],
        );
      },
    );
  }
}
