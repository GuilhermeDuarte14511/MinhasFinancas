import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../infrastructure/firebase_auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  int _errorShakeTrigger = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = await ref
          .read(firebaseAuthServiceProvider)
          .signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (!mounted) return;
      showSuccessMessage(
        context,
        'Bem-vindo, ${user.displayName ?? 'de volta'}!',
      );
      _continueAfterLogin(user.emailVerified);
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = friendlyAuthError(error);
          _errorShakeTrigger++;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = await ref
          .read(firebaseAuthServiceProvider)
          .signInWithGoogle();
      if (mounted) {
        _continueAfterLogin(user.emailVerified);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = friendlyAuthError(error);
          _errorShakeTrigger++;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _continueAfterLogin(bool emailVerified) {
    final redirect = GoRouterState.of(context).uri.queryParameters['redirect'];
    if (emailVerified) {
      context.go(redirect?.startsWith('/') == true ? redirect! : '/gate');
      return;
    }
    final suffix = redirect == null
        ? ''
        : '?redirect=${Uri.encodeComponent(redirect)}';
    context.go('/verify-email$suffix');
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      setState(
        () => _errorMessage = 'Informe seu e-mail antes de recuperar a senha.',
      );
      return;
    }
    try {
      await ref.read(firebaseAuthServiceProvider).sendPasswordReset(email);
      if (mounted) {
        showSuccessMessage(context, 'Enviamos as instruções para $email.');
      }
    } catch (error) {
      if (mounted) setState(() => _errorMessage = friendlyAuthError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 520,
            padding: const EdgeInsets.fromLTRB(24, 54, 24, 32),
            child: StaggeredColumn(
              initialDelay: const Duration(milliseconds: 40),
              step: const Duration(milliseconds: 90),
              spacing: 24,
              children: [
                Column(
                  children: [
                    const BrandMark(),
                    const SizedBox(height: 20),
                    Text(
                      'Nossa Grana',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sua vida financeira, organizada em um só lugar.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                ShakeOnError(
                  trigger: _errorShakeTrigger,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: StaggeredColumn(
                          step: const Duration(milliseconds: 55),
                          children: [
                            TextFormField(
                              key: const Key('login-email'),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                hintText: 'exemplo@email.com',
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                              ),
                              validator: (value) =>
                                  value != null && value.contains('@')
                                  ? null
                                  : 'Informe um e-mail válido.',
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              key: const Key('login-password'),
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword
                                      ? 'Mostrar senha'
                                      : 'Ocultar senha',
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) => (value?.length ?? 0) >= 6
                                  ? null
                                  : 'A senha deve ter pelo menos 6 caracteres.',
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _isLoading ? null : _resetPassword,
                                child: const Text('Esqueci minha senha'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FilledButton(
                              key: const Key('login-submit'),
                              onPressed: _isLoading ? null : _submit,
                              child: Text(
                                _isLoading ? 'Entrando...' : 'Entrar',
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('ou'),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton.icon(
                              onPressed: _isLoading ? null : _signInWithGoogle,
                              icon: const Icon(
                                Icons.g_mobiledata_rounded,
                                size: 28,
                              ),
                              label: const Text('Entrar com Google'),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: _errorMessage == null
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Semantics(
                                        key: ValueKey(_errorMessage),
                                        liveRegion: true,
                                        child: Text(
                                          _errorMessage!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Ainda não tem uma conta?'),
                    TextButton(
                      onPressed: () {
                        final redirect = GoRouterState.of(
                          context,
                        ).uri.queryParameters['redirect'];
                        final suffix = redirect == null
                            ? ''
                            : '?redirect=${Uri.encodeComponent(redirect)}';
                        context.go('/create-account$suffix');
                      },
                      child: const Text('Criar conta'),
                    ),
                  ],
                ),
                Text(
                  'Acesso protegido pelo Firebase Authentication',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
