import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/api_exception.dart';
import '../application/auth_controller.dart';

class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends ConsumerState<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final controller = ref.read(authControllerProvider.notifier);
      if (_isSignUp) {
        await controller.signUp(
          fullName: _fullNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await controller.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
      if (mounted) context.go('/profile');
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = _readableError(error));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _readableError(Object error) {
    if (error is ApiException) return error.message;
    if (error is DioException && error.error is ApiException) {
      return (error.error! as ApiException).message;
    }
    return 'Could not reach the server. Check your connection and try again.';
  }

  @override
  Widget build(BuildContext context) {
    final title = _isSignUp ? 'Create your account' : 'Welcome back';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              children: [
                Text(
                  _isSignUp ? 'Sign up for HalalLens' : 'Log in to HalalLens',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  _isSignUp
                      ? 'Create an account to save your profile and scans.'
                      : 'Log in to view your account profile.',
                ),
                const SizedBox(height: 24),
                if (_isSignUp) ...[
                  TextFormField(
                    key: const Key('auth-full-name'),
                    controller: _fullNameController,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.name],
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Enter your name'
                                : null,
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  key: const Key('auth-email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
                        ? null
                        : 'Enter a valid email address';
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('auth-password'),
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  autofillHints: [
                    _isSignUp
                        ? AutofillHints.newPassword
                        : AutofillHints.password,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Password',
                    helperText:
                        _isSignUp ? 'Use at least 12 characters.' : null,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip:
                          _obscurePassword ? 'Show password' : 'Hide password',
                      onPressed:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final password = value ?? '';
                    if (password.isEmpty) return 'Enter your password';
                    if (_isSignUp && password.length < 12) {
                      return 'Password must be at least 12 characters';
                    }
                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    key: const Key('auth-error'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('auth-submit'),
                  onPressed: _isSubmitting ? null : _submit,
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(_isSignUp ? 'Create account' : 'Log in'),
                ),
                TextButton(
                  onPressed:
                      _isSubmitting
                          ? null
                          : () => setState(() {
                            _isSignUp = !_isSignUp;
                            _errorMessage = null;
                          }),
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Log in'
                        : 'New to HalalLens? Sign up',
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
