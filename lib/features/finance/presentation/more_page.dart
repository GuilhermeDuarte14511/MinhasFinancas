import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    final safeName = displayName.trim().isEmpty ? 'Você' : displayName.trim();
    final groups = <_MenuGroup>[
      const _MenuGroup(
        title: 'Planejamento',
        items: [
          _MenuItem(
            icon: Icons.timeline_rounded,
            title: 'Previsão de caixa',
            subtitle: 'Entradas, saídas e saldo futuro',
            route: '/forecast',
          ),
          _MenuItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Contas e saldos',
            subtitle: 'Onde está seu dinheiro',
            route: '/accounts',
          ),
          _MenuItem(
            icon: Icons.donut_small_rounded,
            title: 'Orçamento mensal',
            subtitle: 'Limites por categoria',
            route: '/budgets',
          ),
          _MenuItem(
            icon: Icons.savings_outlined,
            title: 'Receitas',
            subtitle: 'Previstas e recebidas',
            route: '/incomes',
          ),
          _MenuItem(
            icon: Icons.query_stats_rounded,
            title: 'Análises e relatórios',
            subtitle: 'Compare períodos e categorias',
            route: '/analytics',
          ),
        ],
      ),
      const _MenuGroup(
        title: 'Organização financeira',
        items: [
          _MenuItem(
            icon: Icons.payments_outlined,
            title: 'Empréstimos',
            subtitle: 'Contratos e parcelas',
            route: '/loans',
          ),
          _MenuItem(
            icon: Icons.category_outlined,
            title: 'Categorias',
            subtitle: 'Organize gastos e receitas',
            route: '/categories',
          ),
        ],
      ),
      const _MenuGroup(
        title: 'Espaço compartilhado',
        items: [
          _MenuItem(
            icon: Icons.group_outlined,
            title: 'Membros',
            subtitle: 'Pessoas e permissões',
            route: '/members',
          ),
          _MenuItem(
            icon: Icons.alarm_outlined,
            title: 'Lembretes e notificações',
            subtitle: 'Alertas de contas e faturas',
            route: '/notifications',
          ),
        ],
      ),
      _MenuGroup(
        title: 'Conta e aplicativo',
        items: [
          const _MenuItem(
            icon: Icons.person_outline_rounded,
            title: 'Perfil',
            subtitle: 'Seus dados pessoais',
            route: '/profile',
          ),
          const _MenuItem(
            icon: Icons.security_outlined,
            title: 'Segurança',
            subtitle: 'Senha e sessão',
            route: '/security',
          ),
          if (kIsWeb)
            const _MenuItem(
              icon: Icons.install_mobile_outlined,
              title: 'Instalar aplicativo',
              subtitle: 'Adicionar à tela inicial',
              route: '/install',
            ),
          const _MenuItem(
            icon: Icons.help_outline_rounded,
            title: 'Ajuda',
            subtitle: 'Dúvidas frequentes e suporte',
            route: '/help',
          ),
        ],
      ),
    ];

    return SingleChildScrollView(
      child: AppContent(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Mais', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.md),
            AppSurfaceCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              onTap: () => context.push('/profile'),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryFixed,
                    child: Text(
                      safeName.characters.first.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          safeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (email.trim().isNotEmpty)
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: AppSpacing.xxs),
                        const StatusPill(label: 'Plano conjunto'),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final group in groups) ...[
              _MenuSection(group: group),
              const SizedBox(height: AppSpacing.lg),
            ],
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.errorContainer,
                foregroundColor: AppColors.onErrorContainer,
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

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.group});

  final _MenuGroup group;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: AppSpacing.xxs),
        child: Text(
          group.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      AppSurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (final indexed in group.items.indexed) ...[
              _MenuRow(item: indexed.$2),
              if (indexed.$1 < group.items.length - 1)
                const Divider(height: 1, indent: 68),
            ],
          ],
        ),
      ),
    ],
  );
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item});

  final _MenuItem item;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push(item.route),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceContainer,
              child: Icon(item.icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    ),
  );
}

class _MenuGroup {
  const _MenuGroup({required this.title, required this.items});

  final String title;
  final List<_MenuItem> items;
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
