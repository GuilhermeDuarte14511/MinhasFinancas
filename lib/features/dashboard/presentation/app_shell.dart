import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../finance/application/finance_controller.dart';
import '../../finance/presentation/agenda_page.dart';
import '../../finance/presentation/cards_page.dart';
import '../../finance/presentation/loans_page.dart';
import '../../finance/presentation/more_page.dart';
import '../../onboarding/presentation/entry_gate_page.dart';
import 'dashboard_page.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.section, super.key});

  final String section;

  int get _currentIndex => switch (section) {
    'cards' => 1,
    'loans' => 3,
    'agenda' => 4,
    'more' => 5,
    _ => 0,
  };

  Widget get _page => switch (section) {
    'cards' => const CardsPage(),
    'loans' => const LoansPage(embedded: true),
    'agenda' => const AgendaPage(),
    'more' => const MorePage(),
    _ => const DashboardPage(),
  };

  void _showSpaceMenu(
    BuildContext context,
    WidgetRef ref,
    FinanceState finance,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .82,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Espaço financeiro',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                for (final space in finance.availableSpaces)
                  Card(
                    color: space.id == finance.spaceId
                        ? AppColors.surfaceLow
                        : Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(
                          space.colorValue,
                        ).withValues(alpha: .14),
                        child: Icon(
                          Icons.home_work_rounded,
                          color: Color(space.colorValue),
                        ),
                      ),
                      title: Text(
                        space.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        space.id == finance.spaceId
                            ? 'Espaço ativo'
                            : 'Tocar para selecionar',
                      ),
                      trailing: space.id == finance.spaceId
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.secondary,
                            )
                          : null,
                      onTap: space.id == finance.spaceId
                          ? null
                          : () async {
                              Navigator.pop(sheetContext);
                              await ref
                                  .read(financeControllerProvider.notifier)
                                  .selectWorkspace(space.id);
                            },
                    ),
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.push('/members');
                  },
                  icon: const Icon(Icons.group_outlined),
                  label: const Text('Gerenciar membros'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.go('/welcome');
                  },
                  icon: const Icon(Icons.add_home_outlined),
                  label: const Text('Criar ou entrar em outro espaço'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateMenu(BuildContext context, FinanceState finance) {
    final canEdit = finance.canEdit;
    final canCreatePurchase = canEdit && finance.cards.isNotEmpty;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .82,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'O que você quer adicionar?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'Registre o que entrou, o que saiu ou um compromisso financeiro.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                _CreateOption(
                  icon: Icons.south_west_rounded,
                  title: 'Entrada de dinheiro',
                  subtitle: canEdit
                      ? 'Salário, 13º, férias, bônus ou reembolso'
                      : 'Seu acesso é somente leitura',
                  enabled: canEdit,
                  color: AppColors.secondary,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push('/new-income');
                  },
                ),
                _CreateOption(
                  icon: Icons.north_east_rounded,
                  title: 'Saída de dinheiro',
                  subtitle: !canEdit
                      ? 'Seu acesso é somente leitura'
                      : finance.categories.isEmpty
                      ? 'Cadastre uma categoria para continuar'
                      : 'Conta, boleto, Pix, dinheiro ou débito',
                  enabled: canEdit && finance.categories.isNotEmpty,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push('/new-expense');
                  },
                ),
                _CreateOption(
                  icon: Icons.credit_card_outlined,
                  title: 'Compra no cartão',
                  subtitle: canCreatePurchase
                      ? 'Registre uma compra à vista ou parcelada'
                      : !canEdit
                      ? 'Seu acesso é somente leitura'
                      : 'Cadastre um cartão antes de registrar compras',
                  enabled: canCreatePurchase,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push('/new-purchase');
                  },
                ),
                _CreateOption(
                  icon: Icons.add_card_rounded,
                  title: 'Novo cartão',
                  subtitle: canEdit
                      ? 'Adicione limite, fechamento e vencimento'
                      : 'Seu acesso é somente leitura',
                  enabled: canEdit,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push('/new-card');
                  },
                ),
                _CreateOption(
                  icon: Icons.account_balance_outlined,
                  title: 'Novo empréstimo',
                  subtitle: canEdit
                      ? 'Cadastre um contrato e suas parcelas'
                      : 'Seu acesso é somente leitura',
                  enabled: canEdit,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push('/new-loan');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    if (!finance.hasFinancialSpace) return const EntryGatePage();
    final displayName = finance.userName.trim().isEmpty
        ? 'usuário'
        : finance.userName.trim();
    final compactNavigation = MediaQuery.sizeOf(context).width < 420;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 20,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceContainer,
              child: Text(
                displayName.characters.first.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Olá, $displayName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showSpaceMenu(context, ref, finance),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              finance.spaceName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notificações',
            onPressed: () => context.push('/notifications'),
            icon: Badge(
              isLabelVisible: finance.notificationsEnabled,
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          const SizedBox(width: 10),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: AnimatedPageSwitcher(child: _page),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        height: 76,
        labelBehavior: compactNavigation
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          if (index == 2) {
            _showCreateMenu(context, finance);
            return;
          }
          context.go(switch (index) {
            1 => '/app/cards',
            3 => '/app/loans',
            4 => '/app/agenda',
            5 => '/app/more',
            _ => '/app/home',
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined),
            selectedIcon: Icon(Icons.credit_card_rounded),
            label: 'Cartões',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded, size: 32),
            selectedIcon: Icon(Icons.add_circle_rounded, size: 32),
            label: 'Novo',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_outlined),
            selectedIcon: Icon(Icons.account_balance_rounded),
            label: 'Empréstimos',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_rounded),
            selectedIcon: Icon(Icons.more_horiz_rounded),
            label: 'Mais',
          ),
        ],
      ),
    );
  }
}

class _CreateOption extends StatelessWidget {
  const _CreateOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final foreground = enabled ? color : AppColors.textMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: enabled ? Colors.transparent : AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          minTileHeight: 72,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabled: enabled,
          onTap: enabled ? onTap : null,
          leading: CircleAvatar(
            backgroundColor: foreground.withValues(alpha: .12),
            child: Icon(icon, color: foreground),
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: enabled
              ? const Icon(Icons.chevron_right_rounded)
              : const Icon(Icons.lock_outline_rounded, size: 20),
        ),
      ),
    );
  }
}
