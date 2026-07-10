import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../finance/application/finance_controller.dart';
import '../../finance/presentation/agenda_page.dart';
import '../../finance/presentation/cards_page.dart';
import '../../finance/presentation/more_page.dart';
import 'dashboard_page.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.section, super.key});

  final String section;

  int get _currentIndex => switch (section) {
    'cards' => 1,
    'agenda' => 3,
    'more' => 4,
    _ => 0,
  };

  Widget get _page => switch (section) {
    'cards' => const CardsPage(),
    'agenda' => const AgendaPage(),
    'more' => const MorePage(),
    _ => const DashboardPage(),
  };

  void _showSpaceMenu(BuildContext context, FinanceState finance) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
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
            Card(
              color: AppColors.surfaceLow,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(
                    finance.spaceColorValue,
                  ).withValues(alpha: .14),
                  child: Icon(
                    Icons.home_work_rounded,
                    color: Color(finance.spaceColorValue),
                  ),
                ),
                title: Text(finance.spaceName),
                subtitle: const Text('Espaço ativo'),
                trailing: const Icon(
                  Icons.check_circle,
                  color: AppColors.secondary,
                ),
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
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
                finance.userName.characters.first.toUpperCase(),
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
                    'Olá, ${finance.userName}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showSpaceMenu(context, finance),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              finance.spaceName,
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
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          if (index == 2) {
            context.push(finance.cards.isEmpty ? '/new-card' : '/new-purchase');
            return;
          }
          context.go(switch (index) {
            1 => '/app/cards',
            3 => '/app/agenda',
            4 => '/app/more',
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
