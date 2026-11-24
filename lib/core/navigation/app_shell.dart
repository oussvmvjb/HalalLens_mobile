import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/application/auth_controller.dart';
import '../../l10n/generated/app_localizations.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.child, required this.location, super.key});

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authControllerProvider).valueOrNull;
    final destination = user == null ? '/authentication' : '/profile';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        titleSpacing: 16,
        title: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              const Icon(Icons.eco_outlined, size: 25),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.appName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF183B2D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: user == null ? l10n.login : l10n.profile,
                onPressed: () => context.go(destination),
                icon:
                    user == null
                        ? const Icon(Icons.account_circle_outlined)
                        : CircleAvatar(
                          radius: 15,
                          backgroundColor: const Color(0xFFD9F2E5),
                          child: Text(
                            user.fullName.trim().isEmpty
                                ? '?'
                                : user.fullName.trim().substring(0, 1),
                            style: const TextStyle(
                              color: Color(0xFF16845B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
      body: child,
      bottomNavigationBar: _AppBottomNavigationBar(location: location),
    );
  }
}

class _AppBottomNavigationBar extends StatelessWidget {
  const _AppBottomNavigationBar({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final destinations = <_Destination>[
      _Destination('/', l10n.navHome, Icons.home_outlined, Icons.home_rounded),
      _Destination(
        '/scanner',
        l10n.navScanner,
        Icons.qr_code_scanner_outlined,
        Icons.qr_code_scanner_rounded,
      ),
      _Destination(
        '/analysis',
        l10n.navAnalysis,
        Icons.fact_check_outlined,
        Icons.fact_check_rounded,
      ),
      _Destination(
        '/history',
        l10n.navHistory,
        Icons.history_outlined,
        Icons.history_rounded,
      ),
      _Destination(
        '/settings',
        l10n.navSettings,
        Icons.settings_outlined,
        Icons.settings_rounded,
      ),
    ];
    final orderedDestinations =
        isRtl ? destinations.reversed.toList() : destinations;

    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16845B).withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  for (final destination in orderedDestinations)
                    Expanded(
                      child: _NavigationButton(
                        destination: destination,
                        selected: _selectedPath(location) == destination.path,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _selectedPath(String path) {
    if (path == '/scanner' || path == '/barcode' || path == '/product') {
      return '/scanner';
    }
    if (path == '/analysis') return '/analysis';
    if (path == '/history') return '/history';
    if (path == '/settings') return '/settings';
    return '/';
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({required this.destination, required this.selected});

  final _Destination destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Tooltip(
        message: destination.label,
        child: InkWell(
          onTap: () => context.go(destination.path),
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 52,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFD9F2E5) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                selected ? destination.activeIcon : destination.icon,
                color:
                    selected
                        ? const Color(0xFF16845B)
                        : const Color(0xFF789387),
                size: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.path, this.label, this.icon, this.activeIcon);

  final String path;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
