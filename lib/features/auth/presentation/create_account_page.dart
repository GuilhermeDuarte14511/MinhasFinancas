import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  bool _acceptedTerms = false;
  bool _isLoading = false;
  String? _errorMessage;
  int _errorShakeTrigger = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                  children: [
                    Text(
                      'Comece a organizar a vida financeira de vocês',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Text(
                      'Crie seu acesso. Você poderá convidar outras pessoas depois.',
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
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        helperText: 'Use pelo menos 8 caracteres.',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      validator: (value) => (value?.length ?? 0) >= 8
                          ? null
                          : 'Use pelo menos 8 caracteres.',
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
