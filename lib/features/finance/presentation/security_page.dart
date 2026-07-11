import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../auth/infrastructure/firebase_auth_service.dart';
import '../application/finance_controller.dart';

class SecurityPage extends ConsumerStatefulWidget {
  const SecurityPage({super.key});

  @override
  ConsumerState<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends ConsumerState<SecurityPage> {
  bool _sending = false;

  Future<void> _resetPassword() async {
    final auth = ref.read(firebaseAuthServiceProvider);
    final email = auth.currentUser?.email;
    if (email == null || email.isEmpty) return;
    setState(() => _sending = true);
    try {
      await auth.sendPasswordReset(email);
      if (mounted) {
        showSuccessMessage(context, 'Enviamos as instruções para $email.');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível enviar o e-mail agora.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _signOut() async {
    ref.read(financeControllerProvider.notifier).resetWorkspaceSelection();
    await ref.read(firebaseAuthServiceProvider).signOut();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    final providers =
        user?.providerData
            .map((item) => item.providerId)
            .where((item) => item != 'firebase')
            .toSet()
            .join(', ') ??
        '';
    return Scaffold(
      appBar: const BrandAppBar(title: 'Segurança', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Proteja sua conta',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Revise seus métodos de acesso e ações de segurança.',
                ),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      _SecurityItem(
                        icon: Icons.mark_email_read_outlined,
                        title: 'E-mail',
                        subtitle: user?.emailVerified == true
                            ? 'Verificado e protegido'
                            : 'Verificação pendente',
                        trailing: StatusPill(
                          label: user?.emailVerified == true
                              ? 'Verificado'
                              : 'Pendente',
                          color: user?.emailVerified == true
                              ? AppColors.secondary
                              : Colors.orange.shade800,
                        ),
                      ),
                      const Divider(height: 1),
                      _SecurityItem(
                        icon: Icons.key_rounded,
                        title: 'Método de entrada',
                        subtitle: providers.isEmpty
                            ? 'E-mail e senha'
                            : providers,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _sending ? null : _resetPassword,
                  icon: const Icon(Icons.lock_reset_rounded),
                  label: Text(_sending ? 'Enviando...' : 'Redefinir senha'),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDAD6),
                    foregroundColor: const Color(0xFF93000A),
                  ),
                  onPressed: _signOut,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sair de todos os dados locais'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecurityItem extends StatelessWidget {
  const _SecurityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surfaceContainer,
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
