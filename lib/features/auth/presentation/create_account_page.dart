import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../finance/application/finance_controller.dart';
import '../infrastructure/firebase_auth_service.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _isLoading = false;
  String? _errorMessage;
  int _errorShakeTrigger = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aceite os termos para continuar.')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(firebaseAuthServiceProvider)
          .signUp(
            displayName: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
      ref
          .read(financeControllerProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
          );
      if (!mounted) return;
      showSuccessMessage(
        context,
        'Conta criada. Enviamos a verificação para seu e-mail.',
      );
      final redirect = GoRouterState.of(
        context,
      ).uri.queryParameters['redirect'];
      final suffix = redirect == null
          ? ''
          : '?redirect=${Uri.encodeComponent(redirect)}';
      context.go('/verify-email$suffix');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(title: 'Criar conta', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: ShakeOnError(
              trigger: _errorShakeTrigger,
              child: Form(
                key: _formKey,
                child: StaggeredColumn(
                  step: const Duration(milliseconds: 70),
                  spacing: 16,
                  children: [
                    const Center(child: BrandMark(size: 54)),
                    Text(
                      'Comece a organizar a vida financeira de vocês',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Text(
                      'Crie seu acesso. Você poderá convidar outras pessoas depois.',
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (value) => (value?.trim().length ?? 0) >= 3
                          ? null
                          : 'Informe seu nome.',
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: (value) => value != null && value.contains('@')
                          ? null
                          : 'Informe um e-mail válido.',
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        helperText: 'Use pelo menos 8 caracteres.',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
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
                      validator: (value) => (value?.length ?? 0) >= 8
                          ? null
                          : 'Use pelo menos 8 caracteres.',
                    ),
                    _PasswordStrength(password: _passwordController.text),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmation,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _isLoading ? null : _submit(),
                      decoration: InputDecoration(
                        labelText: 'Confirme sua senha',
                        prefixIcon: const Icon(Icons.lock_reset_rounded),
                        suffixIcon: IconButton(
                          tooltip: _obscureConfirmation
                              ? 'Mostrar confirmação'
                              : 'Ocultar confirmação',
                          onPressed: () => setState(
                            () => _obscureConfirmation = !_obscureConfirmation,
                          ),
                          icon: Icon(
                            _obscureConfirmation
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Confirme sua senha.';
                        }
                        if (value != _passwordController.text) {
                          return 'As senhas não são iguais.';
                        }
                        return null;
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _acceptedTerms,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'Li e aceito os Termos de Uso e a Política de Privacidade.',
                      ),
                      onChanged: (value) =>
                          setState(() => _acceptedTerms = value ?? false),
                    ),
                    FilledButton(
                      onPressed: _isLoading ? null : _submit,
                      child: Text(
                        _isLoading ? 'Criando conta...' : 'Criar minha conta',
                      ),
                    ),
                    const Card(
                      color: AppColors.surfaceLow,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Enviaremos um link para verificar seu e-mail.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      child: _errorMessage == null
                          ? const SizedBox.shrink()
                          : Semantics(
                              key: ValueKey(_errorMessage),
                              liveRegion: true,
                              child: Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('Já tem uma conta?'),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Entrar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final score = _score(password);
    final (label, color) = switch (score) {
      0 || 1 => ('Fraca', AppColors.error),
      2 => ('Média', const Color(0xFF9A6700)),
      _ => ('Forte', AppColors.secondary),
    };
    return Semantics(
      label: 'Força da senha: $label',
      child: Row(
        children: [
          for (var index = 0; index < 3; index++) ...[
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 6,
                decoration: BoxDecoration(
                  color: index < score ? color : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            if (index < 2) const SizedBox(width: 8),
          ],
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  int _score(String value) {
    if (value.isEmpty) return 0;
    var score = value.length >= 8 ? 1 : 0;
    if (RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[a-z]').hasMatch(value)) {
      score++;
    }
    if (RegExp(r'[0-9]|[^A-Za-z0-9]').hasMatch(value)) score++;
    return score.clamp(1, 3);
  }
}
