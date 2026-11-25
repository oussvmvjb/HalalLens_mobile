import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
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
        pageBuilder:
            (context, state) =>
                _animatedPage(state, const AuthenticationPage()),
      ),
      ShellRoute(
        builder:
            (context, state, child) =>
                AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder:
                (context, state) => _animatedPage(state, const HomePage()),
          ),
          GoRoute(
            path: '/scanner',
            pageBuilder:
                (context, state) => _animatedPage(state, const ScannerPage()),
          ),
          GoRoute(
            path: '/barcode',
            pageBuilder:
                (context, state) =>
                    _animatedPage(state, const BarcodeScannerPage()),
          ),
          GoRoute(
            path: '/product',
            pageBuilder:
                (context, state) => _animatedPage(state, const ProductPage()),
          ),
          GoRoute(
            path: '/analysis',
            pageBuilder:
                (context, state) => _animatedPage(state, const AnalysisPage()),
          ),
          GoRoute(
            path: '/history',
            pageBuilder:
                (context, state) => _animatedPage(state, const HistoryPage()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder:
                (context, state) => _animatedPage(state, const ProfilePage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder:
                (context, state) => _animatedPage(state, const SettingsPage()),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

CustomTransitionPage<void> _animatedPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 240),
    reverseTransitionDuration: const Duration(milliseconds: 190),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.025, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}
