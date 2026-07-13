import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';
import '../domain/financial_planning.dart';
import 'financial_planning_labels.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    FinancialAccount account,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Arquivar conta?'),
        content: Text(
          '${account.name} deixará de aparecer nos saldos. As movimentações permanecerão no histórico.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Arquivar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .archiveAccount(account.id);
      if (context.mounted) showSuccessMessage(context, 'Conta arquivada.');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível arquivar a conta.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final position = finance.financialPosition();
    final accountsById = {for (final item in finance.accounts) item.id: item};
    return Scaffold(
      appBar: BrandAppBar(
        title: 'Contas e saldos',
        showBack: true,
        actions: [
          if (finance.canEdit && finance.accounts.length >= 2)
            IconButton(
              tooltip: 'Transferir entre contas',
              onPressed: () => context.push('/accounts/transfer'),
              icon: const Icon(Icons.swap_horiz_rounded),
            ),
          if (finance.canEdit)
            IconButton(
              tooltip: 'Adicionar conta',
              onPressed: () => context.push('/accounts/new'),
              icon: const Icon(Icons.add_rounded),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AppContent(
            maxWidth: 760,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BalanceSummary(position: position),
                const SizedBox(height: 26),
                SectionHeading(
                  title: 'Suas contas',
                  actionLabel: finance.canEdit ? 'Adicionar' : null,
                  onAction: finance.canEdit
                      ? () => context.push('/accounts/new')
                      : null,
                ),
                const SizedBox(height: 10),
                if (position.accounts.isEmpty)
                  _EmptyAccounts(canEdit: finance.canEdit)
                else
                  for (final item in position.accounts) ...[
                    _AccountCard(
                      position: item,
                      canEdit: finance.canEdit,
                      onArchive: () => _archive(context, ref, item.account),
                    ),
                    const SizedBox(height: 12),
                  ],
                if (finance.accountTransfers.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const SectionHeading(title: 'Transferências recentes'),
                  const SizedBox(height: 8),
                  for (final transfer in finance.accountTransfers.take(5)) ...[
                    _TransferTile(
                      transfer: transfer,
                      fromName:
                          accountsById[transfer.fromAccountId]?.name ??
                          'Conta arquivada',
                      toName:
                          accountsById[transfer.toAccountId]?.name ??
                          'Conta arquivada',
                    ),
                    const Divider(height: 1),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: finance.canEdit && finance.accounts.length >= 2
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/accounts/transfer'),
              icon: const Icon(Icons.swap_horiz_rounded),
              label: const Text('Transferir'),
            )
          : null,
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({required this.position});

  final FinancialPosition position;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF302F69), AppColors.primaryContainer],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SALDO ATUAL',
          style: TextStyle(
            color: Color(0xFFDAD7FF),
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 5),
        FittedBox(
          child: Text(
            position.currentBalance.format(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Icon(
              Icons.auto_graph_rounded,
              color: Color(0xFF99EFE5),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Saldo previsto: ${position.projectedBalance.format()}',
                style: const TextStyle(color: Color(0xFF99EFE5)),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.position,
    required this.canEdit,
    required this.onArchive,
  });

  final AccountPosition position;
  final bool canEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final account = position.account;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final avatar = CircleAvatar(
            radius: 23,
            backgroundColor: Color(account.colorValue).withValues(alpha: .12),
            child: Icon(
              financialAccountTypeIcon(account.type),
              color: Color(account.colorValue),
            ),
          );
          final identity = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                [
                  if (account.institutionName?.isNotEmpty == true)
                    account.institutionName!,
                  financialAccountTypeLabel(account.type),
                ].join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (!account.includeInTotal)
                const Text(
                  'Fora do saldo total',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
            ],
          );
          final menu = canEdit
              ? PopupMenuButton<String>(
                  tooltip: 'Opções da conta',
                  onSelected: (value) {
                    if (value == 'archive') onArchive();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'archive',
                      child: ListTile(
                        leading: Icon(Icons.archive_outlined),
                        title: Text('Arquivar'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink();
          final balances = Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                position.currentBalance.format(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                'Prev. ${position.projectedBalance.format()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
          if (constraints.maxWidth < 420) {
            return Column(
              children: [
                Row(
                  children: [
                    avatar,
                    const SizedBox(width: 12),
                    Expanded(child: identity),
                    menu,
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    const Expanded(child: Text('Saldo atual')),
                    balances,
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              avatar,
              const SizedBox(width: 14),
              Expanded(child: identity),
              const SizedBox(width: 10),
              balances,
              menu,
            ],
          );
        },
      ),
    );
  }
}

class _TransferTile extends StatelessWidget {
  const _TransferTile({
    required this.transfer,
    required this.fromName,
    required this.toName,
  });

  final AccountTransfer transfer;
  final String fromName;
  final String toName;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 4),
    leading: const CircleAvatar(
      backgroundColor: AppColors.surfaceContainer,
      child: Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
    ),
    title: Text(
      '$fromName → $toName',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      DateFormat("d 'de' MMM, y", 'pt_BR').format(transfer.transferredAt),
    ),
    trailing: Text(
      transfer.amount.format(),
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

class _EmptyAccounts extends StatelessWidget {
  const _EmptyAccounts({required this.canEdit});

  final bool canEdit;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: AppColors.surfaceLow,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        const Icon(
          Icons.account_balance_wallet_outlined,
          size: 44,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        Text(
          'Nenhuma conta cadastrada',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        const Text(
          'Adicione onde o dinheiro fica para acompanhar o saldo real e o previsto.',
          textAlign: TextAlign.center,
        ),
        if (canEdit) ...[
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => context.push('/accounts/new'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Adicionar primeira conta'),
          ),
        ],
      ],
    ),
  );
}
