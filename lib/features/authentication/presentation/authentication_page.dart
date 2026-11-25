import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/auth_controller.dart';
import 'auth_ui_components.dart';

class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends ConsumerState<AuthenticationPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSignUp = false;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    if (apiError?.failureKind == ApiFailureKind.connectionTimeout ||
        apiError?.failureKind == ApiFailureKind.receiveTimeout ||
        apiError?.failureKind == ApiFailureKind.sendTimeout ||
        apiError?.statusCode == 408 ||
        apiError?.statusCode == 504) {
      return l10n.requestTimeout;
    }
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
      body: AuthBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding =
                  constraints.maxWidth < 600 ? 20.0 : 32.0;
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (constraints.maxHeight - 32).clamp(
                      0,
                      double.infinity,
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                              tooltip: l10n.authBackHome,
                              onPressed: () => context.go('/'),
                              icon: const Icon(Icons.home_outlined),
                            ),
                          ),
                          Text(
                            l10n.appName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFF183B2D),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 18),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.025),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildAuthForm(l10n, title),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAuthForm(AppLocalizations l10n, String title) {
    return Form(
      key: _formKey,
      child: Column(
        key: ValueKey(_isSignUp),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.mainText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSignUp ? l10n.authSignupDescription : l10n.authLoginDescription,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryText),
          ),
          const SizedBox(height: 26),
          if (_isSignUp) ...[
            TextFormField(
              key: const Key('auth-full-name'),
              controller: _fullNameController,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              decoration: InputDecoration(
                labelText: l10n.fullName,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator:
                  (value) =>
                      value == null || value.trim().isEmpty
                          ? l10n.enterName
                          : null,
            ),
            const SizedBox(height: 14),
          ],
          TextFormField(
            key: const Key('auth-email'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            decoration: InputDecoration(
              labelText: l10n.email,
              prefixIcon: const Icon(Icons.mail_outline_rounded),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
                  ? null
                  : l10n.enterValidEmail;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            key: const Key('auth-password'),
            controller: _passwordController,
            obscureText: _obscurePassword,
            autofillHints: [
              _isSignUp ? AutofillHints.newPassword : AutofillHints.password,
            ],
            decoration: InputDecoration(
              labelText: l10n.password,
              helperText: _isSignUp ? l10n.passwordHelper : null,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip:
                    _obscurePassword ? l10n.showPassword : l10n.hidePassword,
                onPressed:
                    () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (value) {
              final password = value ?? '';
              if (password.isEmpty) return l10n.enterPassword;
              if (_isSignUp && password.length < 12) {
                return l10n.passwordTooShort;
              }
              return null;
            },
          ),
          if (_isSignUp) ...[
            const SizedBox(height: 14),
            TextFormField(
              key: const Key('auth-confirm-password'),
              controller: _confirmPasswordController,
              obscureText: _obscurePassword,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: l10n.confirmPassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip:
                      _obscurePassword ? l10n.showPassword : l10n.hidePassword,
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator:
                  (value) =>
                      value == _passwordController.text
                          ? null
                          : l10n.passwordsDoNotMatch,
            ),
          ] else
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                key: const Key('auth-forgot-password'),
                onPressed: _showPasswordRecoveryMessage,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(l10n.forgotPassword),
              ),
            ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              key: const Key('auth-error'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 18),
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
                    : Text(_isSignUp ? l10n.createAccount : l10n.login),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed:
                _isSubmitting
                    ? null
                    : () => setState(() {
                      _isSignUp = !_isSignUp;
                      _formKey = GlobalKey<FormState>();
                      _errorMessage = null;
                    }),
            child: Text(
              _isSignUp ? l10n.alreadyHaveAccount : l10n.newToHalalLens,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordRecoveryMessage() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.passwordRecoveryUnavailable)));
  }
}
