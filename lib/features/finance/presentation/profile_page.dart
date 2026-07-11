import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../auth/infrastructure/firebase_auth_service.dart';
import '../application/finance_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : finance.userName;
    final email = user?.email ?? finance.email;
    final initial = name.trim().isEmpty ? '?' : name.trim().characters.first;

    return Scaffold(
      appBar: BrandAppBar(
        title: 'Meu perfil',
        showBack: true,
        actions: [
          IconButton(
            tooltip: 'Editar nome',
            onPressed: () => _editName(context, ref, name),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            child: StaggeredColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.surfaceContainer,
                    foregroundImage: user?.photoURL == null
                        ? null
                        : NetworkImage(user!.photoURL!),
                    child: user?.photoURL == null
                        ? Text(
                            initial.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(email, textAlign: TextAlign.center),
                const SizedBox(height: 28),
                const SectionHeading(title: 'Dados da conta'),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      _ProfileRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Nome',
                        value: name,
                      ),
                      const Divider(height: 1),
                      _ProfileRow(
                        icon: Icons.mail_outline_rounded,
                        label: 'E-mail',
                        value: email,
                      ),
                      const Divider(height: 1),
                      _ProfileRow(
                        icon: Icons.verified_user_outlined,
                        label: 'Verificação',
                        value: user?.emailVerified == true
                            ? 'E-mail verificado'
                            : 'Verificação pendente',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Card(
                  color: AppColors.surfaceLow,
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Para alterar nome ou e-mail, use o provedor com que você criou sua conta.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nome'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Nome completo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.length < 3) return;
    try {
      await ref
          .read(firebaseAuthServiceProvider)
          .updateProfile(displayName: name);
      ref
          .read(financeControllerProvider.notifier)
          .updateProfile(
            name: name,
            email: ref.read(financeControllerProvider).email,
          );
      if (context.mounted) showSuccessMessage(context, 'Perfil atualizado.');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível atualizar o perfil.')),
        );
      }
    }
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
