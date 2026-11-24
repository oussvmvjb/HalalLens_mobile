import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/authentication/application/auth_controller.dart';
import '../../../l10n/generated/app_localizations.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(authControllerProvider);
    final user = session.valueOrNull;

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
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _WelcomeCard(
                      greeting:
                          user == null
                              ? l10n.homeWelcome
                              : l10n.homeGreeting(user.fullName),
                      subtitle: l10n.homeSubtitle,
                      actionLabel: l10n.homeScanAction,
                      onAction: () => context.go('/scanner'),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.homeRecentScans,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryBackground,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(Icons.history_rounded),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                l10n.homeNoRecentScans,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppTheme.secondaryText),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.homeExplore,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, gridConstraints) {
                        final columnCount =
                            gridConstraints.maxWidth >= 720
                                ? 4
                                : gridConstraints.maxWidth >= 420
                                ? 2
                                : 1;
                        const spacing = 12.0;
                        final itemWidth =
                            (gridConstraints.maxWidth -
                                spacing * (columnCount - 1)) /
                            columnCount;
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            _QuickActionCard(
                              width: itemWidth,
                              icon: Icons.qr_code_scanner_rounded,
                              title: l10n.quickActionScanner,
                              onTap: () => context.go('/scanner'),
                            ),
                            _QuickActionCard(
                              width: itemWidth,
                              icon: Icons.history_rounded,
                              title: l10n.quickActionHistory,
                              onTap: () => context.go('/history'),
                            ),
                            _QuickActionCard(
                              width: itemWidth,
                              icon: Icons.fact_check_rounded,
                              title: l10n.quickActionAnalysis,
                              onTap: () => context.go('/analysis'),
                            ),
                            _QuickActionCard(
                              width: itemWidth,
                              icon: Icons.inventory_2_outlined,
                              title: l10n.quickActionProduct,
                              onTap: () => context.go('/product'),
                            ),
                          ],
                        );
                      },
                    ),
                    if (session.hasError) ...[
                      const SizedBox(height: 20),
                      Text(
                        l10n.homeSessionError,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
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
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.greeting,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final String greeting;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 650;
        final text = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
          ],
        );
        final action = FilledButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.qr_code_scanner_rounded),
          label: Text(actionLabel),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.darkGreen,
          ),
        );

        return Container(
          padding: EdgeInsets.all(compact ? 22 : 32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryGreen, AppTheme.darkGreen],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child:
              compact
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [text, const SizedBox(height: 22), action],
                  )
                  : Row(
                    children: [
                      Expanded(child: text),
                      const SizedBox(width: 24),
                      action,
                    ],
                  ),
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
