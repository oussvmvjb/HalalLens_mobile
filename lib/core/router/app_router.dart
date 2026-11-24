import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_shell.dart';
import '../../features/analysis/presentation/analysis_page.dart';
import '../../features/authentication/presentation/authentication_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/product/presentation/product_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/scanner/presentation/scanner_page.dart';
import '../../features/scanner/presentation/barcode_scanner_page.dart';
import '../../features/settings/presentation/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/authentication',
        builder: (context, state) => const AuthenticationPage(),
      ),
      ShellRoute(
        builder:
            (context, state, child) =>
                AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/scanner',
            builder: (context, state) => const ScannerPage(),
          ),
          GoRoute(
            path: '/barcode',
            builder: (context, state) => const BarcodeScannerPage(),
          ),
          GoRoute(
            path: '/product',
            builder: (context, state) => const ProductPage(),
          ),
          GoRoute(
            path: '/analysis',
            builder: (context, state) => const AnalysisPage(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
