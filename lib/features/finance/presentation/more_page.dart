import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../auth/infrastructure/firebase_auth_service.dart';
import '../application/finance_controller.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final authenticatedUser = ref.read(firebaseAuthServiceProvider).currentUser;
    final displayName = authenticatedUser?.displayName ?? finance.userName;
    final email = authenticatedUser?.email ?? finance.email;
    final items = <_MenuItem>[
      const _MenuItem(
        icon: Icons.query_stats_rounded,
        title: 'Análises e relatórios',
        subtitle: 'Compare períodos, cartões e categorias',
        route: '/analytics',
      ),
      const _MenuItem(
        icon: Icons.savings_outlined,
        title: 'Receitas',
        subtitle: 'Acompanhe entradas previstas e recebidas',
        route: '/incomes',
      ),
      const _MenuItem(
        icon: Icons.payments_outlined,
        title: 'Empréstimos',
        subtitle: 'Simule ou acompanhe seus contratos',
        route: '/loans',
      ),
      const _MenuItem(
        icon: Icons.category_outlined,
        title: 'Categorias',
        subtitle: 'Organize seus gastos e receitas',
        route: '/categories',
      ),
      const _MenuItem(
        icon: Icons.group_outlined,
        title: 'Espaço financeiro e membros',
        subtitle: 'Gerencie quem acessa suas finanças',
        route: '/members',
      ),
      const _MenuItem(
        icon: Icons.alarm_outlined,
        title: 'Lembretes e notificações',
        subtitle: 'Configure seus alertas',
        route: '/notifications',
      ),
      if (kIsWeb)
        const _MenuItem(
          icon: Icons.install_mobile_outlined,
          title: 'Instalar aplicativo',
          subtitle: 'Adicione à tela inicial',
          route: '/install',
        ),
      const _MenuItem(
        icon: Icons.person_outline_rounded,
        title: 'Perfil',
        subtitle: 'Seus dados e identidade no espaço',
        route: '/profile',
      ),
      const _MenuItem(
        icon: Icons.security_outlined,
        title: 'Segurança',
        subtitle: 'Senha, provedores e sessão',
        route: '/security',
      ),
      const _MenuItem(
        icon: Icons.help_outline_rounded,
        title: 'Ajuda',
        subtitle: 'Dúvidas frequentes e suporte',
        route: '/help',
      ),
    ];
    return SingleChildScrollView(
      child: AppContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.surfaceContainer,
                      child: Text(
                        displayName.characters.first,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(email),
                          const SizedBox(height: 7),
                          const StatusPill(label: 'Plano conjunto'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            for (final item in items) ...[
              Card(
                child: InkWell(
                  onTap: () => context.push(item.route),
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.surfaceContainer,
                          child: Icon(item.icon, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                item.subtitle,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFDAD6),
                foregroundColor: const Color(0xFF93000A),
              ),
              onPressed: () async {
                ref
                    .read(financeControllerProvider.notifier)
                    .resetWorkspaceSelection();
                await ref.read(firebaseAuthServiceProvider).signOut();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sair com segurança'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}
