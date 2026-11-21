import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halal_lens/app.dart';
import 'package:halal_lens/features/authentication/data/auth_repository.dart';
import 'package:halal_lens/features/authentication/domain/auth_user.dart';

class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository();

  static const user = AuthUser(
    id: 'test-user',
    fullName: 'Amina Example',
    email: 'amina@example.com',
    preferredLanguage: 'en',
    isActive: true,
  );

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async => user;

  @override
  Future<AuthUser> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async => user;

  @override
  Future<AuthUser?> restoreSession() async => null;

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('home route displays foundation links', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const HalalLensApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('HalalLens'), findsOneWidget);
    expect(find.text('Scan a barcode'), findsOneWidget);
    expect(find.text('Analysis'), findsOneWidget);
    expect(find.text('Log in or sign up'), findsOneWidget);
  });

  testWidgets('sign-up, profile, logout, and login flow works', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const HalalLensApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log in or sign up'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New to HalalLens? Sign up'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('auth-full-name')),
      'Amina Example',
    );
    await tester.enterText(
      find.byKey(const Key('auth-email')),
      'amina@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('auth-password')),
      'a-secure-password-123',
    );
    await tester.ensureVisible(find.byKey(const Key('auth-submit')));
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Amina Example'), findsOneWidget);
    expect(find.text('amina@example.com'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Log in or sign up'), findsOneWidget);

    await tester.tap(find.text('Log in or sign up'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('auth-email')),
      'amina@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('auth-password')),
      'a-secure-password-123',
    );
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Amina Example'), findsOneWidget);
  });
}
