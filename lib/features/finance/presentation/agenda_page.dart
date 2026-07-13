import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/cash_flow.dart';
import '../domain/cash_flow_forecast.dart';
import '../domain/finance_models.dart';
import '../domain/loan_agenda_entry.dart';
import 'cash_flow_action_dialogs.dart';
import 'cash_flow_labels.dart';

enum _AgendaFilter { all, income, expenses, invoices, loans }

enum _AgendaAction { markAsCompleted, delete }

class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends ConsumerState<AgendaPage> {
  late DateTime _selectedMonth;
  _AgendaFilter _filter = _AgendaFilter.all;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
      );
    });
  }

  Future<void> _markAsCompleted(CashFlowEntry entry) async {
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .updateCashFlowStatus(entry.id, CashFlowStatus.confirmed);
      if (mounted) {
        showSuccessMessage(
          context,
          entry.isIncome
              ? 'Entrada marcada como recebida.'
              : 'Despesa marcada como paga.',
        );
      }
    } catch (_) {
      if (mounted) {
        await _showActionError(
          entry.isIncome
              ? 'Não foi possível confirmar a entrada.'
              : 'Não foi possível confirmar a despesa.',
        );
      }
    }
  }

  Future<void> _deleteEntry(CashFlowEntry entry) async {
    var scope = RecurrenceScope.single;
    if (entry.recurrenceSeriesId != null) {
      final selectedScope = await showCashFlowScopePicker(
        context,
        action: CashFlowSeriesAction.delete,
      );
      if (selectedScope == null || !mounted) return;
      scope = selectedScope;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(entry.isIncome ? 'Excluir entrada?' : 'Excluir despesa?'),
        content: Text(
          entry.recurrenceSeriesId == null
              ? '“${entry.description}” será excluído permanentemente e os totais serão atualizados.'
              : '${recurrenceScopeLabel(scope)} de “${entry.description}” será excluído permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir permanentemente'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await ref
          .read(financeControllerProvider.notifier)
          .deleteCashFlowEntry(entry.id, scope);
      if (mounted) showSuccessMessage(context, 'Lançamento excluído.');
    } catch (_) {
      if (mounted) {
        await _showActionError('Não foi possível excluir o lançamento.');
      }
    }
  }

  Future<void> _showActionError(String fallback) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Não foi possível concluir'),
      content: SelectableText(
        ref.read(financeControllerProvider).errorMessage ?? fallback,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendi'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monthEnd = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final forecast = monthEnd.isBefore(today)
        ? null
        : finance.cashFlowForecast(
            referenceDate: today,
            horizonDays: monthEnd.difference(today).inDays,
          );
    final balanceAfterByEvent = {
      if (forecast != null)
        for (final line in forecast.lines) line.event.id: line.balanceAfter,
    };
    final loanEntries = loanAgendaEntriesForMonth(
      loans: finance.loans,
      installments: finance.loanInstallments,
      month: _selectedMonth,
    );
    final items = <_AgendaItem>[
      if (_filter == _AgendaFilter.all || _filter == _AgendaFilter.invoices)
        for (final invoice in finance.invoices)
          if (_isSameMonth(invoice.dueDate, _selectedMonth))
            _AgendaItem.invoice(invoice),
      if (_filter == _AgendaFilter.all || _filter == _AgendaFilter.loans)
        for (final entry in loanEntries) _AgendaItem.loan(entry),
      if (_filter == _AgendaFilter.all ||
          _filter == _AgendaFilter.income ||
          _filter == _AgendaFilter.expenses)
        for (final entry in finance.cashFlowEntries)
          if (entry.status != CashFlowStatus.cancelled &&
              _isSameMonth(entry.occurredAt, _selectedMonth) &&
              (_filter != _AgendaFilter.income || entry.isIncome) &&
              (_filter != _AgendaFilter.expenses || !entry.isIncome))
            _AgendaItem.cashFlow(
              entry,
              relatedCard: _findRelatedCard(entry, finance),
            ),
    ]..sort((a, b) => a.date.compareTo(b.date));
    final monthLabel = toBeginningOfSentenceCase(
      DateFormat('MMMM \'de\' y', 'pt_BR').format(_selectedMonth),
    );

    return RefreshIndicator(
      onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AppContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Agenda', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 5),
              const Text(
                'Entradas, contas, faturas e parcelas em um só lugar.',
              ),
              const SizedBox(height: 24),
              _MonthSelector(
                monthLabel: monthLabel,
                itemCount: items.length,
                onPrevious: () => _changeMonth(-1),
                onNext: () => _changeMonth(1),
              ),
              if (forecast != null) ...[
                const SizedBox(height: 14),
                _AgendaProjectionSummary(
                  forecast: forecast,
                  selectedMonth: _selectedMonth,
                  hasAccounts: finance.accounts.isNotEmpty,
                ),
              ],
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final filter in _AgendaFilter.values) ...[
                      _FilterChip(
                        label: _filterLabel(filter),
                        selected: _filter == filter,
                        onSelected: () => setState(() => _filter = filter),
                      ),
                      if (filter != _AgendaFilter.values.last)
                        const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionHeading(title: 'Lançamentos do mês'),
              const SizedBox(height: 12),
              if (items.isEmpty)
                _EmptyMonth(selectedMonth: _selectedMonth)
              else
                for (final item in items) ...[
                  _AgendaCard(
                    item: item,
                    canEdit: finance.canEdit,
                    balanceAfter: balanceAfterByEvent[item.forecastEventId],
                    onDelete: item.cashFlowEntry == null
                        ? null
                        : () => _deleteEntry(item.cashFlowEntry!),
                    onMarkAsCompleted:
                        item.cashFlowEntry?.status == CashFlowStatus.scheduled
                        ? () => _markAsCompleted(item.cashFlowEntry!)
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.monthLabel,
    required this.itemCount,
    required this.onPrevious,
    required this.onNext,
  });

  final String monthLabel;
  final int itemCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    decoration: BoxDecoration(
      color: AppColors.primaryContainer,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Mês anterior',
          color: Colors.white,
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                monthLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              Text(
                '$itemCount ${itemCount == 1 ? 'lançamento' : 'lançamentos'}',
                style: const TextStyle(color: Color(0xFFDAD7FF)),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Próximo mês',
          color: Colors.white,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    ),
  );
}

class _AgendaProjectionSummary extends StatelessWidget {
  const _AgendaProjectionSummary({
    required this.forecast,
    required this.selectedMonth,
    required this.hasAccounts,
  });

  final CashFlowForecast forecast;
  final DateTime selectedMonth;
  final bool hasAccounts;

  @override
  Widget build(BuildContext context) {
    final monthStart = DateTime(selectedMonth.year, selectedMonth.month);
    final monthEnd = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final monthLines = forecast.lines
        .where((line) => _isSameMonth(line.projectedAt, selectedMonth))
        .toList();
    var income = const Money.zero();
    var expenses = const Money.zero();
    var closing = forecast.openingBalance;
    var balanceAtMonthStart = forecast.openingBalance;
    for (final line in forecast.lines) {
      if (line.projectedAt.isBefore(monthStart)) {
        balanceAtMonthStart = line.balanceAfter;
      }
    }
    var lowest = balanceAtMonthStart;
    var lowestDate = monthStart;
    for (final line in forecast.lines) {
      if (!line.projectedAt.isAfter(monthEnd)) closing = line.balanceAfter;
      if (line.projectedAt.isBefore(monthStart) ||
          line.projectedAt.isAfter(monthEnd)) {
        continue;
      }
      if (line.event.isIncome) {
        income += line.event.amount;
      } else {
        expenses += line.event.amount;
      }
      if (line.balanceAfter.cents < lowest.cents) {
        lowest = line.balanceAfter;
        lowestDate = line.projectedAt;
      }
    }
    final risk = lowest.isNegative;
    return Material(
      color: risk ? const Color(0xFFFFF1F0) : AppColors.surfaceLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => context.push('/forecast'),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: risk
                  ? AppColors.error.withValues(alpha: .3)
                  : AppColors.outline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    risk ? Icons.warning_amber_rounded : Icons.timeline_rounded,
                    color: risk ? AppColors.error : AppColors.primary,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Projeção até o fim do mês',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: _AgendaProjectionMetric(
                      label: 'Ainda entra',
                      value: income,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: _AgendaProjectionMetric(
                      label: 'Ainda sai',
                      value: expenses,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: _AgendaProjectionMetric(
                      label: 'Saldo final',
                      value: closing,
                      color: closing.isNegative
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                !hasAccounts
                    ? 'Cadastre uma conta para usar o saldo real como ponto de partida.'
                    : risk
                    ? 'Atenção: saldo de ${lowest.format()} previsto para ${DateFormat('dd/MM', 'pt_BR').format(lowestDate)}.'
                    : '${monthLines.length} ${monthLines.length == 1 ? 'compromisso pendente' : 'compromissos pendentes'} neste mês.',
                style: TextStyle(
                  color: risk ? AppColors.error : AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: risk ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgendaProjectionMetric extends StatelessWidget {
  const _AgendaProjectionMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final Money value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color, fontSize: 10),
      ),
      const SizedBox(height: 3),
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          value.format(),
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onSelected(),
  );
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({
    required this.item,
    required this.canEdit,
    this.balanceAfter,
    this.onDelete,
    this.onMarkAsCompleted,
  });

  final _AgendaItem item;
  final bool canEdit;
  final Money? balanceAfter;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkAsCompleted;

  @override
  Widget build(BuildContext context) {
    final month = DateFormat.MMM('pt_BR').format(item.date).toUpperCase();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: item.route == null ? null : () => context.push(item.route!),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AgendaDate(
                    day: item.date.day,
                    month: month,
                    backgroundColor: item.backgroundColor,
                    foregroundColor: item.foregroundColor,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (canEdit &&
                      (onDelete != null || onMarkAsCompleted != null))
                    PopupMenuButton<_AgendaAction>(
                      tooltip: 'Ações do lançamento',
                      onSelected: (action) {
                        switch (action) {
                          case _AgendaAction.markAsCompleted:
                            onMarkAsCompleted?.call();
                            break;
                          case _AgendaAction.delete:
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (onMarkAsCompleted != null)
                          PopupMenuItem(
                            value: _AgendaAction.markAsCompleted,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.check_circle_outline_rounded,
                              ),
                              title: Text(
                                item.isIncome
                                    ? 'Marcar como recebida'
                                    : 'Marcar como paga',
                              ),
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: _AgendaAction.delete,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.error,
                              ),
                              title: Text('Excluir lançamento'),
                            ),
                          ),
                      ],
                    )
                  else if (item.route != null)
                    const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPill(label: item.type, color: item.foregroundColor),
                  StatusPill(label: item.status, color: item.statusColor),
                  if (item.relatedCard != null)
                    StatusPill(
                      label: item.relatedCard!,
                      color: AppColors.textMuted,
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    item.isIncome
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    size: 18,
                    color: item.amountColor,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.isIncome ? 'Entrada' : 'Saída',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: item.amountColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        item.amount.format(),
                        style: TextStyle(
                          color: item.amountColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (balanceAfter != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: balanceAfter!.isNegative
                        ? const Color(0xFFFFDAD6)
                        : AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 16,
                        color: balanceAfter!.isNegative
                            ? AppColors.error
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Saldo previsto após este lançamento',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            balanceAfter!.format(),
                            style: TextStyle(
                              color: balanceAfter!.isNegative
                                  ? AppColors.error
                                  : AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AgendaDate extends StatelessWidget {
  const _AgendaDate({
    required this.day,
    required this.month,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final int day;
  final String month;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) => Container(
    width: 52,
    height: 58,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$day',
          style: TextStyle(
            color: foregroundColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(month, style: const TextStyle(fontSize: 11)),
      ],
    ),
  );
}

class _EmptyMonth extends StatelessWidget {
  const _EmptyMonth({required this.selectedMonth});

  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.surfaceLow,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.event_available_rounded,
            size: 40,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 10),
          Text(
            'Nenhum lançamento em ${DateFormat.MMMM('pt_BR').format(selectedMonth)}.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _AgendaItem {
  const _AgendaItem({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.isIncome,
    this.route,
    this.relatedCard,
    this.cashFlowEntry,
    this.forecastEventId,
  });

  factory _AgendaItem.invoice(InvoiceSummary invoice) => _AgendaItem(
    date: invoice.dueDate,
    title: 'Fatura ${invoice.cardName}',
    subtitle:
        'Vence ${DateFormat("d 'de' MMMM", 'pt_BR').format(invoice.dueDate)}',
    type: 'Fatura',
    amount: invoice.pending,
    status: _invoiceStatusLabel(invoice.status, invoice.dueDate),
    statusColor: _invoiceStatusColor(invoice.status, invoice.dueDate),
    route: '/invoice/${invoice.id}',
    relatedCard: invoice.cardName,
    backgroundColor: AppColors.surfaceContainer,
    foregroundColor: AppColors.primary,
    isIncome: false,
    forecastEventId: 'invoice:${invoice.id}',
  );

  factory _AgendaItem.loan(LoanAgendaEntry entry) => _AgendaItem(
    date: entry.installment.dueDate,
    title: entry.loan.description,
    subtitle:
        '${entry.loan.lender} • Parcela ${entry.installment.number}/${entry.loan.installmentCount}',
    type: 'Empréstimo',
    amount: entry.installment.total,
    status: _loanInstallmentStatusLabel(
      entry.installment.status,
      entry.installment.dueDate,
    ),
    statusColor: _loanInstallmentStatusColor(
      entry.installment.status,
      entry.installment.dueDate,
    ),
    route: '/loans/${entry.loan.id}',
    backgroundColor: AppColors.secondaryContainer,
    foregroundColor: AppColors.secondary,
    isIncome: false,
    forecastEventId: 'loan-installment:${entry.installment.id}',
  );

  factory _AgendaItem.cashFlow(CashFlowEntry entry, {String? relatedCard}) =>
      _AgendaItem(
        date: entry.occurredAt,
        title: entry.description,
        subtitle: cashFlowPaymentMethodLabel(entry.paymentMethod),
        type: cashFlowKindLabel(entry.kind),
        amount: entry.amount,
        status: _cashFlowStatusLabel(entry),
        statusColor: _cashFlowStatusColor(entry),
        route: '/cash-flow/${entry.id}',
        relatedCard: relatedCard,
        backgroundColor: entry.isIncome
            ? AppColors.secondaryContainer
            : AppColors.surfaceContainer,
        foregroundColor: entry.isIncome
            ? AppColors.secondary
            : AppColors.primary,
        isIncome: entry.isIncome,
        cashFlowEntry: entry,
        forecastEventId: 'cash-flow:${entry.id}',
      );

  final DateTime date;
  final String title;
  final String subtitle;
  final String type;
  final Money amount;
  final String status;
  final Color statusColor;
  final String? route;
  final String? relatedCard;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isIncome;
  final CashFlowEntry? cashFlowEntry;
  final String? forecastEventId;

  Color get amountColor => isIncome ? AppColors.secondary : AppColors.error;
}

String? _findRelatedCard(CashFlowEntry entry, FinanceState finance) {
  if (entry.paymentMethod != CashFlowPaymentMethod.creditCard &&
      entry.kind != CashFlowKind.cardPurchase) {
    return null;
  }
  final sourceId = entry.sourceEntityId;
  if (sourceId != null) {
    for (final purchase in finance.purchases) {
      if (purchase.id != sourceId) continue;
      for (final card in finance.cards) {
        if (card.id == purchase.cardId) return card.nickname;
      }
    }
  }
  return 'Cartão de crédito';
}

bool _isSameMonth(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month;

String _filterLabel(_AgendaFilter filter) => switch (filter) {
  _AgendaFilter.all => 'Todos',
  _AgendaFilter.income => 'Entradas',
  _AgendaFilter.expenses => 'Despesas',
  _AgendaFilter.invoices => 'Faturas',
  _AgendaFilter.loans => 'Empréstimos',
};

String _invoiceStatusLabel(InvoiceStatus status, [DateTime? dueDate]) {
  if (dueDate != null &&
      dueDate.isBefore(_today()) &&
      (status == InvoiceStatus.open ||
          status == InvoiceStatus.closed ||
          status == InvoiceStatus.partiallyPaid)) {
    return 'Vencida';
  }
  return switch (status) {
    InvoiceStatus.open || InvoiceStatus.closed => 'Pendente',
    InvoiceStatus.partiallyPaid => 'Parcialmente paga',
    InvoiceStatus.paid => 'Paga',
    InvoiceStatus.overdue => 'Vencida',
    InvoiceStatus.cancelled => 'Cancelada',
  };
}

Color _invoiceStatusColor(InvoiceStatus status, DateTime dueDate) {
  if (dueDate.isBefore(_today()) &&
      status != InvoiceStatus.paid &&
      status != InvoiceStatus.cancelled) {
    return AppColors.error;
  }
  return switch (status) {
    InvoiceStatus.paid => AppColors.secondary,
    InvoiceStatus.overdue || InvoiceStatus.cancelled => AppColors.error,
    _ => AppColors.primary,
  };
}

String _loanInstallmentStatusLabel(
  LoanInstallmentStatus status,
  DateTime dueDate,
) {
  if (dueDate.isBefore(_today()) &&
      status != LoanInstallmentStatus.paid &&
      status != LoanInstallmentStatus.cancelled) {
    return 'Vencida';
  }
  return switch (status) {
    LoanInstallmentStatus.planned || LoanInstallmentStatus.open => 'Pendente',
    LoanInstallmentStatus.partiallyPaid => 'Parcialmente paga',
    LoanInstallmentStatus.paid => 'Paga',
    LoanInstallmentStatus.overdue => 'Vencida',
    LoanInstallmentStatus.cancelled => 'Cancelada',
  };
}

Color _loanInstallmentStatusColor(
  LoanInstallmentStatus status,
  DateTime dueDate,
) {
  if (dueDate.isBefore(_today()) &&
      status != LoanInstallmentStatus.paid &&
      status != LoanInstallmentStatus.cancelled) {
    return AppColors.error;
  }
  return switch (status) {
    LoanInstallmentStatus.paid => AppColors.secondary,
    LoanInstallmentStatus.overdue ||
    LoanInstallmentStatus.cancelled => AppColors.error,
    _ => AppColors.primary,
  };
}

String _cashFlowStatusLabel(CashFlowEntry entry) {
  if (entry.status == CashFlowStatus.scheduled &&
      entry.occurredAt.isBefore(_today())) {
    return entry.isIncome ? 'Atrasada' : 'Vencida';
  }
  return switch (entry.status) {
    CashFlowStatus.scheduled => entry.isIncome ? 'Prevista' : 'Pendente',
    CashFlowStatus.confirmed => entry.isIncome ? 'Recebida' : 'Paga',
    CashFlowStatus.cancelled => 'Cancelada',
  };
}

Color _cashFlowStatusColor(CashFlowEntry entry) {
  if (entry.status == CashFlowStatus.scheduled &&
      entry.occurredAt.isBefore(_today())) {
    return AppColors.error;
  }
  return switch (entry.status) {
    CashFlowStatus.scheduled => AppColors.primary,
    CashFlowStatus.confirmed => AppColors.secondary,
    CashFlowStatus.cancelled => AppColors.error,
  };
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
