import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/api_exception.dart';
import '../../authentication/application/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider);
    final user = session.valueOrNull;

    if (session.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  session.hasError
                      ? 'Could not check your account. ${_errorMessage(session.error!)}'
                      : 'Log in or sign up to view your profile.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go('/authentication'),
                  child: const Text('Log in or sign up'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Home',
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(
            radius: 36,
            child: Text(
              user.fullName.trim().isEmpty
                  ? '?'
                  : user.fullName.trim().substring(0, 1).toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(user.email),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Preferred language'),
                  subtitle: Text(user.preferredLanguage.toUpperCase()),
                ),
                ListTile(
                  leading: Icon(
                    user.isActive ? Icons.verified_user_outlined : Icons.block,
                  ),
                  title: const Text('Account status'),
                  subtitle: Text(user.isActive ? 'Active' : 'Inactive'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async {
              try {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) context.go('/');
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
                }
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is ApiException) return error.message;
    return 'Could not complete the request. Please try again.';
  }
}
