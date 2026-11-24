import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
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
        setState(
          () =>
              _errorMessage = _readableError(
                error,
                AppLocalizations.of(context)!,
              ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _readableError(Object error, AppLocalizations l10n) {
    final apiError =
        error is ApiException
            ? error
            : error is DioException && error.error is ApiException
            ? error.error as ApiException
            : null;
    return switch (apiError?.statusCode) {
      401 => l10n.invalidCredentials,
      409 => l10n.emailAlreadyRegistered,
      422 => l10n.invalidRequest,
      null => l10n.networkError,
      _ => l10n.requestFailed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _isSignUp ? l10n.authSignupTitle : l10n.authLoginTitle;
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
              Expanded(
                child: Text(
                  l10n.appName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.mainText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.authBackHome,
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_outlined),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 32.0;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(
                          constraints.maxWidth < 400 ? 20 : 28,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isSignUp
                                    ? l10n.authSignupDescription
                                    : l10n.authLoginDescription,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppTheme.secondaryText),
                              ),
                              const SizedBox(height: 24),
                              if (_isSignUp) ...[
                                TextFormField(
                                  key: const Key('auth-full-name'),
                                  controller: _fullNameController,
                                  textCapitalization: TextCapitalization.words,
                                  autofillHints: const [AutofillHints.name],
                                  decoration: InputDecoration(
                                    labelText: l10n.fullName,
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.trim().isEmpty
                                              ? l10n.enterName
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
                                decoration: InputDecoration(
                                  labelText: l10n.email,
                                ),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  return RegExp(
                                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                      ).hasMatch(email)
                                      ? null
                                      : l10n.enterValidEmail;
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
                                  labelText: l10n.password,
                                  helperText:
                                      _isSignUp ? l10n.passwordHelper : null,
                                  suffixIcon: IconButton(
                                    tooltip:
                                        _obscurePassword
                                            ? l10n.showPassword
                                            : l10n.hidePassword,
                                    onPressed:
                                        () => setState(
                                          () =>
                                              _obscurePassword =
                                                  !_obscurePassword,
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
                                  if (password.isEmpty) {
                                    return l10n.enterPassword;
                                  }
                                  if (_isSignUp && password.length < 12) {
                                    return l10n.passwordTooShort;
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
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : Text(
                                          _isSignUp
                                              ? l10n.createAccount
                                              : l10n.login,
                                        ),
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
                                      ? l10n.alreadyHaveAccount
                                      : l10n.newToHalalLens,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
