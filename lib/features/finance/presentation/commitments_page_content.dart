import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

enum _CommitmentFilter { all, invoices, loans }

enum _CommitmentKind { invoice, loan }

class CommitmentsPage extends ConsumerStatefulWidget {
  const CommitmentsPage({super.key});

  @override
  ConsumerState<CommitmentsPage> createState() => _CommitmentsPageState();
}

class _CommitmentsPageState extends ConsumerState<CommitmentsPage> {
  _CommitmentFilter _filter = _CommitmentFilter.all;

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final commitments = _buildCommitments(finance);
    final visible = commitments.where(_matchesFilter).toList();
    final grouped = _groupByMonth(visible);
    final today = DateUtils.dateOnly(DateTime.now());
    final total = visible.fold(
      const Money.zero(),
      (sum, item) => sum + item.amount,
    );
    final overdueCount = visible
        .where((item) => DateUtils.dateOnly(item.dueDate).isBefore(today))
        .length;

    return Scaffold(
      appBar: const BrandAppBar(title: 'Compromissos', showBack: true),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(financeControllerProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
            children: [
              Text(
                'Tudo que ainda precisa de atenção',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Acompanhe faturas e parcelas de empréstimos em ordem de vencimento.',
              ),
              const SizedBox(height: 24),
              _SummaryCard(
                total: total,
                count: visible.length,
                overdueCount: overdueCount,
              ),
              const SizedBox(height: 20),
              _Filters(
                selected: _filter,
                onSelected: (value) => setState(() => _filter = value),
              ),
              const SizedBox(height: 24),
              if (visible.isEmpty)
                const _EmptyState()
              else
                for (final group in grouped.entries) ...[
                  _MonthHeader(month: group.key, count: group.value.length),
                  const SizedBox(height: 10),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: group.value.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, index) =>
                          _CommitmentTile(item: group.value[index]),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
            ],
          ),
        ),
      ),
    );
  }

  bool _matchesFilter(_CommitmentItem item) => switch (_filter) {
    _CommitmentFilter.all => true,
    _CommitmentFilter.invoices => item.kind == _CommitmentKind.invoice,
    _CommitmentFilter.loans => item.kind == _CommitmentKind.loan,
  };
}

List<_CommitmentItem> _buildCommitments(FinanceState finance) {
  final items = <_CommitmentItem>[];

  for (final invoice in finance.invoices) {
    if (invoice.pending.cents <= 0 ||
        invoice.status == InvoiceStatus.cancelled) {
      continue;
    }
    final reference = toBeginningOfSentenceCase(
          DateFormat('MMMM yyyy', 'pt_BR').format(invoice.referenceMonth),
        ) ??
        '';
    items.add(
      _CommitmentItem(
        kind: _CommitmentKind.invoice,
        title: invoice.cardName,
        subtitle: 'Fatura de $reference',
        dueDate: invoice.dueDate,
        amount: invoice.pending,
        route: '/invoice/${invoice.id}',
      ),
    );
  }

  final loansById = {for (final loan in finance.loans) loan.id: loan};
  for (final installment in finance.loanInstallments) {
    final loan = loansById[installment.loanId];
    final ignored = installment.status == LoanInstallmentStatus.cancelled ||
        installment.status == LoanInstallmentStatus.paid;
    if (loan == null || installment.pending.cents <= 0 || ignored) continue;

    items.add(
      _CommitmentItem(
        kind: _CommitmentKind.loan,
        title: loan.description,
        subtitle:
            '${loan.lender} • Parcela ${installment.number}/${loan.installmentCount}',
        dueDate: installment.dueDate,
        amount: installment.pending,
        route: '/loans/${loan.id}',
      ),
    );
  }

  items.sort((a, b) {
    final byDate = a.dueDate.compareTo(b.dueDate);
    return byDate != 0 ? byDate : a.title.compareTo(b.title);
  });
  return items;
}

Map<DateTime, List<_CommitmentItem>> _groupByMonth(
  List<_CommitmentItem> items,
) {
  final result = <DateTime, List<_CommitmentItem>>{};
  for (final item in items) {
    final month = DateTime(item.dueDate.year, item.dueDate.month);
    result.putIfAbsent(month, () => []).add(item);
  }
  return result;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.count,
    required this.overdueCount,
  });

  final Money total;
  final int count;
  final int overdueCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryContainer, Color(0xFF3D37A9)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL PENDENTE',
            style: TextStyle(
              color: Color(0xFFDAD7FF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 7),
          FittedBox(
            alignment: Alignment.centerLeft,
            child: Text(
              total.format(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryPill(
                icon: Icons.event_available_rounded,
                label: '$count ${count == 1 ? 'compromisso' : 'compromissos'}',
              ),
              if (overdueCount > 0)
                _SummaryPill(
                  icon: Icons.warning_amber_rounded,
                  label:
                      '$overdueCount ${overdueCount == 1 ? 'atrasado' : 'atrasados'}',
                  warning: true,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.icon,
    required this.label,
    this.warning = false,
  });

  final IconData icon;
  final String label;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final color = warning ? const Color(0xFFFFD6D3) : const Color(0xFFDAD7FF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.selected, required this.onSelected});

  final _CommitmentFilter selected;
  final ValueChanged<_CommitmentFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in const [
            (_CommitmentFilter.all, 'Todos'),
            (_CommitmentFilter.invoices, 'Faturas'),
            (_CommitmentFilter.loans, 'Empréstimos'),
          ]) ...[
            ChoiceChip(
              label: Text(entry.$2),
              selected: selected == entry.$1,
              showCheckmark: false,
              avatar: selected == entry.$1
                  ? const Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: AppColors.primary,
                    )
                  : null,
              onSelected: (_) => onSelected(entry.$1),
            ),
            if (entry.$1 != _CommitmentFilter.loans) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.month, required this.count});

  final DateTime month;
  final int count;

  @override
  Widget build(BuildContext context) {
    final label = toBeginningOfSentenceCase(
          DateFormat('MMMM yyyy', 'pt_BR').format(month),
        ) ??
        '';
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        Text(
          '$count',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CommitmentTile extends StatelessWidget {
  const _CommitmentTile({required this.item});

  final _CommitmentItem item;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final dueDate = DateUtils.dateOnly(item.dueDate);
    final overdue = dueDate.isBefore(today);
    final status = switch (dueDate.difference(today).inDays) {
      0 => 'Vence hoje',
      1 => 'Vence amanhã',
      _ when overdue =>
        'Atrasado desde ${DateFormat("d 'de' MMM", 'pt_BR').format(item.dueDate)}',
      _ => 'Vence em ${DateFormat("d 'de' MMM", 'pt_BR').format(item.dueDate)}',
    };
    final color = overdue ? AppColors.error : AppColors.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      onTap: () => context.push(item.route),
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: .1),
        child: Icon(
          item.kind == _CommitmentKind.invoice
              ? Icons.receipt_long_rounded
              : Icons.account_balance_rounded,
          color: color,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.amount.format(),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text('${item.subtitle}\n$status'),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 42,
            color: AppColors.primary,
          ),
          SizedBox(height: 14),
          Text(
            'Nenhum compromisso pendente',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'Quando houver uma fatura ou parcela em aberto, ela aparecerá aqui.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

final class _CommitmentItem {
  const _CommitmentItem({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.amount,
    required this.route,
  });

  final _CommitmentKind kind;
  final String title;
  final String subtitle;
  final DateTime dueDate;
  final Money amount;
  final String route;
}
