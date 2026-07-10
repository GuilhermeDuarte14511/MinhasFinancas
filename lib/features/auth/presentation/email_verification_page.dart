import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../infrastructure/firebase_auth_service.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  bool _isChecking = false;
  bool _isSending = false;
  String? _error;

  Future<void> _check() async {
    setState(() {
      _isChecking = true;
      _error = null;
    });
    try {
      final verified = await ref
          .read(firebaseAuthServiceProvider)
          .reloadAndCheckEmailVerification();
      if (!mounted) return;
      if (verified) {
        showSuccessMessage(context, 'E-mail confirmado. Tudo certo!');
        final redirect = GoRouterState.of(
          context,
        ).uri.queryParameters['redirect'];
        context.go(redirect?.startsWith('/') == true ? redirect! : '/gate');
      } else {
        setState(
          () => _error =
              'A confirmação ainda não apareceu. Verifique sua caixa de entrada.',
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = friendlyAuthError(error));
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _isSending = true;
      _error = null;
    });
    try {
      await ref.read(firebaseAuthServiceProvider).sendEmailVerification();
      if (mounted) {
        showSuccessMessage(context, 'Enviamos um novo e-mail de confirmação.');
      }
    } catch (error) {
      if (mounted) setState(() => _error = friendlyAuthError(error));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email =
        ref.read(firebaseAuthServiceProvider).currentUser?.email ?? '';
    return Scaffold(
      appBar: const BrandAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 560,
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
            child: StaggeredColumn(
              step: const Duration(milliseconds: 80),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Color(0xFFE2DFFF),
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'Confirme seu e-mail',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Enviamos um link para $email. Depois de confirmar, volte aqui para continuar.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: _isChecking ? null : _check,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(_isChecking ? 'Verificando...' : 'Já confirmei'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _isSending ? null : _resend,
                  child: Text(_isSending ? 'Reenviando...' : 'Reenviar e-mail'),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _error == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _error!,
                            key: ValueKey(_error),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () async {
                    await ref.read(firebaseAuthServiceProvider).signOut();
                    if (context.mounted) context.go('/login');
                  },
                  child: const Text('Entrar com outra conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
